﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Media;
using HRC.Navigation;

namespace ESME.NEMO.Overlay
{
    public partial class OverlayFile
    {
        const float YardsToMeters = 0.9144f;

        public static OverlayShape[] Parse(string overlayFileName, out string sourceOverlay, out string expandedRangeKm)
        {
            sourceOverlay = null;
            expandedRangeKm = null;
            var curColor = Colors.Red;
            var shapes = new List<OverlayShape>();
            var locationMode = OverlayLocationMode.LatLong;
            var curState = OverlayParseState.Initialization;
            Geo lastPoint = null;
            var curStyle = LineStyle.Solid;
            var reader = new LineReader();
            var tokenizer = new Tokenizer {CommentIndicators = new[] {"#"}};
            var commentSplit = new[] { "=" };
            reader.FileName = overlayFileName;
            tokenizer.LineReader = reader;

            Token curToken;

            while ((curToken = tokenizer.NextToken()) != null)
            {
                Geo[] curPoints;
                switch (curState)
                {
                    case OverlayParseState.Initialization:
                    switch (((string) curToken.Value).ToLower())
                        {
                            case OverlayKeywords.Comment:
                                var originalComment = reader.Lines[curToken.LineNumber];
                                if (originalComment.StartsWith("# "))
                                {
                                    var step1 = originalComment.Substring(2, originalComment.Length - 2).Trim();
                                    var step2 = step1.Split(commentSplit, StringSplitOptions.RemoveEmptyEntries);
                                    if (step2.Length != 2) break;
                                    switch (step2[0])
                                    {
                                        case "sourceOverlay":
                                            sourceOverlay = step2[1];
                                            break;
                                        case "expandedRangeKm":
                                            expandedRangeKm = step2[1];
                                            break;
                                    }
                                }
                                break;
                            case OverlayKeywords.Move:
                                curPoints = GetPoints(tokenizer, locationMode, null);
                                lastPoint = curPoints.Last();
                                curState = OverlayParseState.ShapeBuild; //Change State to ShapeBuild
                                break;
                            case OverlayKeywords.Absolute:
                            break;
                            case OverlayKeywords.Relative:
                                throw new ApplicationException("Unimplemented position mode: Relative");
                            case OverlayKeywords.DegreesMinutesSeconds:
                                locationMode = OverlayLocationMode.DegreesMinutesSeconds;
                                break;
                            case OverlayKeywords.LatLong:
                                locationMode = OverlayLocationMode.LatLong;
                                break;
                            case OverlayKeywords.XYPair:
                                locationMode = OverlayLocationMode.XYPair;
                                break;
                            case OverlayKeywords.Color:
                                if (tokenizer.Count < 3) throw new ApplicationException("OverlayParser.Parse: Not all color information are found\n");
                                var red = tokenizer.NextToken().Value as float?;
                                var green = tokenizer.NextToken().Value as float?;
                                var blue = tokenizer.NextToken().Value as float?;
                                if ((red == null) || (green == null) || (blue == null)) throw new ApplicationException("OverlayParser: Invalid color definition at line " + curToken.LineNumber);
                                curColor = Color.FromArgb(255, (byte) red, (byte) green, (byte) blue);
                                break;
#if false
                            // DA: Removed all support for color because NUWC decided to throw colors in new and interesting places in overlay files
                            //     Color keywords are completely stripped out by the tokenizer
                            case OverlayKeywords.Red:
                                curColor = Colors.Red;
                                break;
                            case OverlayKeywords.Green:
                                curColor = Colors.Green;
                                break;
                            case OverlayKeywords.Purple:
                                curColor = Colors.Purple;
                                break;
                            case OverlayKeywords.Yellow:
                                curColor = Colors.Yellow;
                                break;
                            case OverlayKeywords.White:
                                curColor = Colors.White;
                                break;
                            case OverlayKeywords.Orange:
                                curColor = Colors.Orange;
                                break;
                            case OverlayKeywords.Blue:
                                curColor = Colors.Blue;
                                break;
                            case OverlayKeywords.Cyan:
                                curColor = Colors.Cyan;
                                break;
#endif
                            case OverlayKeywords.Origin:
                                tokenizer.DiscardToEndOfLine();
                                break;
                            case OverlayKeywords.Solid:
                                curStyle = LineStyle.Solid;
                                break;
                            case OverlayKeywords.Dash:
                                curStyle = LineStyle.Dash;
                                break;
                            case OverlayKeywords.DashDot:
                                curStyle = LineStyle.DashDot;
                                break;
                            case OverlayKeywords.Dot:
                                curStyle = LineStyle.Dot;
                                break;
                            case OverlayKeywords.Point:
                                tokenizer.DiscardNext();
                                break;
                            case OverlayKeywords.Red:
                                curColor = Colors.Red;
                                break;
                            case OverlayKeywords.Green:
                                curColor = Colors.Green;
                                break;
                            case OverlayKeywords.Purple:
                                curColor = Colors.Purple;
                                break;
                            case OverlayKeywords.Yellow:
                                curColor = Colors.Yellow;
                                break;
                            case OverlayKeywords.White:
                                curColor = Colors.White;
                                break;
                            case OverlayKeywords.Orange:
                                curColor = Colors.Orange;
                                break;
                            case OverlayKeywords.Blue:
                                curColor = Colors.Blue;
                                break;
                            case OverlayKeywords.Cyan:
                                curColor = Colors.Cyan;
                                break;
                            default:
                                throw new FormatException("OverlayParser: Unknown token at line " + curToken.LineNumber + ": " + curToken.Value);
                        } //Initialization Switch(curToken)
                        break; //break for the Initialization Case

                    case OverlayParseState.ShapeBuild:
                        float curSize;
                        int curLinenumber;
                        OverlayShape curShape;
                        switch (curToken.Value as string)
                        {
                            case OverlayKeywords.Move:
                                //Submit Shape and Points
                                //continue in ShapeBuild
                                curPoints = GetPoints(tokenizer, locationMode, null);
                                lastPoint = curPoints.Last();
                                break;
                            case OverlayKeywords.Lines:
                                curLinenumber = curToken.LineNumber;
                                if (curLinenumber == tokenizer.Peek().LineNumber) curSize = (float) ((float?) tokenizer.NextToken().Value);
                                else curSize = 2f;
                                curShape = new OverlayLineSegments(GetPoints(tokenizer, locationMode, lastPoint), curColor, curSize, curStyle)
                                           {
                                               LineStyle = curStyle
                                           };
                                shapes.Add(curShape);
                                break;
                            case OverlayKeywords.Point:
                                curLinenumber = curToken.LineNumber;
                                if (curLinenumber == tokenizer.Peek().LineNumber) curSize = (float) ((float?) tokenizer.NextToken().Value);
                                else curSize = 2;
                                curShape = new OverlayPoint(lastPoint, curColor, curSize);
                                shapes.Add(curShape);
                                break;
                            case OverlayKeywords.Circle:
                                //get radius
                                //its the previous point
                                curSize = (float) ((float?) tokenizer.NextToken().Value);
                                curShape = new OverlayCircle(lastPoint, curColor, curStyle, curSize * YardsToMeters)
                                           {
                                               LineStyle = curStyle
                                           };
                                shapes.Add(curShape);
                                //SubmitShape(PositionMode);
                                curState = OverlayParseState.Initialization;
                                break;
                            case OverlayKeywords.Label:
                                //shapes.Add(new OverlayLabel(lastPoint, curColor, tokenizer.NextToken().Value as string));
                                tokenizer.NextToken();
                                break;
                            case OverlayKeywords.Red:
                                curColor = Colors.Red;
                                break;
                            case OverlayKeywords.Green:
                                curColor = Colors.Green;
                                break;
                            case OverlayKeywords.Purple:
                                curColor = Colors.Purple;
                                break;
                            case OverlayKeywords.Yellow:
                                curColor = Colors.Yellow;
                                break;
                            case OverlayKeywords.White:
                                curColor = Colors.White;
                                break;
                            case OverlayKeywords.Orange:
                                curColor = Colors.Orange;
                                break;
                            case OverlayKeywords.Blue:
                                curColor = Colors.Blue;
                                break;
                            case OverlayKeywords.Cyan:
                                curColor = Colors.Cyan;
                                break;
                            case OverlayKeywords.Comment:
                            case OverlayKeywords.Origin:
                                break;
                            case OverlayKeywords.Solid:
                                curStyle = LineStyle.Solid;
                                break;
                            case OverlayKeywords.Dash:
                                curStyle = LineStyle.Dash;
                                break;
                            case OverlayKeywords.DashDot:
                                curStyle = LineStyle.DashDot;
                                break;
                            case OverlayKeywords.Dot:
                                curStyle = LineStyle.Dot;
                                break;
                            case OverlayKeywords.Color:
                                if (tokenizer.Count < 3) throw new ApplicationException("OverlayParser.Parse: Not all color information are found\n");
                                var red = tokenizer.NextToken().Value as float?;
                                var green = tokenizer.NextToken().Value as float?;
                                var blue = tokenizer.NextToken().Value as float?;
                                if ((red == null) || (green == null) || (blue == null)) throw new ApplicationException("OverlayParser: Invalid color definition at line " + curToken.LineNumber);
                                curColor = Color.FromArgb(255, (byte)red, (byte)green, (byte)blue);
                                break;
                            default:
                                throw new FormatException("OverlayParser: Unknown token at line " + curToken.LineNumber + ": " + curToken.Value);
                        } //Switch for shape Build
                        break;
                    default:
                        throw new ApplicationException("OverlayParser.Parse: Unknown state!\n");
                } // switch (curState)
            } // while (curToken != null)
            return shapes.ToArray();
        }

        static Geo[] GetPoints(Tokenizer tokenizer, OverlayLocationMode locationMode, Geo lastPoint)
        {
            var resultPoints = new List<Geo>();

            if (lastPoint != null) resultPoints.Add(lastPoint);

            while ((tokenizer.Peek() != null) && (tokenizer.Peek().Value is float))
            {
                Geo curPoint;
                switch (locationMode)
                {
                    case OverlayLocationMode.XYPair:
                        if (tokenizer.Count < 1) throw new ApplicationException("OverlayParser.getInitialPoint: missing information for coordinates\n");

                        curPoint = GetValueInDegrees(tokenizer);
                        resultPoints.Add(curPoint);
                        break;
                    case OverlayLocationMode.LatLong:
                        if (tokenizer.Count < 1) throw new ApplicationException("OverlayParser.getInitialPoint: missing information for coordinates\n");

                        curPoint = GetPoint(tokenizer);
                        resultPoints.Add(curPoint);
                        break;
                    case OverlayLocationMode.DegreesMinutesSeconds:
                        if (tokenizer.Count < 2) throw new ApplicationException("OverlayParser.getInitialPoint: missing information for coordinates\n");

                        curPoint = new Geo(DecodeDegreesMinutesSeconds(tokenizer), DecodeDegreesMinutesSeconds(tokenizer));
                        resultPoints.Add(curPoint);
                        break;
                    default:
                        throw new ApplicationException("OverlayParser.getPoints: Location Mode " + locationMode + " is unknown\n");
                }
            }
            return resultPoints.ToArray();
        }

        static Geo GetValueInDegrees(Tokenizer tokenizer)
        {
            //Dave will tell me to do this with Geo Class
            var x = tokenizer.NextToken();
            while (!x.IsNumeric) x = tokenizer.NextToken();
            var y = tokenizer.NextToken();
            if ((x.Value == null) || (y.Value == null)) throw new ApplicationException("OverlayParser.GetValueInDegrees: Values for Latitude or Longitude is not present in Overlay File " + x.LineReader.FileName + " at line " + x.LineNumber);
            return new Geo(0, 0);
        }

        static Geo GetPoint(Tokenizer tokenizer)
        {
            var x = tokenizer.NextToken();
            while (!x.IsNumeric) x = tokenizer.NextToken();
            var y = tokenizer.NextToken();
            if ((x.Value == null) || (y.Value == null)) throw new ApplicationException("OverlayParser.GetPoint: Values for Latitude or Longitude is not present in Overlay File " + x.LineReader.FileName + " at line " + x.LineNumber);
            return new Geo((double)((float?)x.Value), (double)((float?)y.Value));
        }

        static float DecodeDegreesMinutesSeconds(Tokenizer tokenizer)
        {
            var degrees = tokenizer.NextToken();
            while (!degrees.IsNumeric) degrees = tokenizer.NextToken();
            var minutes = tokenizer.NextToken();
            var seconds = tokenizer.NextToken();
            if ((degrees.Value as float? == null) || (minutes.Value as float? == null) || (seconds.Value as float? == null)) throw new ApplicationException("OverlayParser-DMSCoordinate: Values for Latitude or Longitude is not present in overlay file at line " + degrees.LineNumber); //Might change
            return (float) ((degrees.Value as float?) + ((minutes.Value as float?) / 60f) + ((seconds.Value as float?) / 3600f));
        }
    }

//Class End

    internal enum OverlayParseState
    {
        ShapeBuild,
        Initialization
    }

    internal enum OverlayPositionMode
    {
        Absolute,
        Relative
    }

    internal enum OverlayLocationMode
    {
        LatLong,
        XYPair,
        DegreesMinutesSeconds
    }

    internal class OverlayKeywords
    {
        public const string Move = "move";
        public const string Lines = "lines";
        public const string Point = "point";
        public const string Circle = "circle";
        public const string Absolute = "absolute";
        public const string Relative = "relative";
        public const string XYPair = "xyz";
        public const string DegreesMinutesSeconds = "latlong";
        public const string LatLong = "navigation";
        public const string Color = "rgb";
        public const string Red = "red";
        public const string Green = "green";
        public const string Cyan = "cyan";
        public const string Blue = "blue";
        public const string Orange = "orange";
        public const string Purple = "purple";
        public const string Yellow = "yellow";
        public const string White = "white";
        public const string Label = "label";
        public const string Origin = "origin";
        public const string Solid = "solid";
        public const string Dash = "dash";
        public const string Dot = "dot";
        public const string DashDot = "dashdot";
        public const string Comment = "#";
    }
}