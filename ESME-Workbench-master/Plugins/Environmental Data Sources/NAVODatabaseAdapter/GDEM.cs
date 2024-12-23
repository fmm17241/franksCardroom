﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using ESME.Environment;
using ESME.Environment.NAVO;
using HRC.Navigation;
using HRC.NetCDF;

namespace NAVODatabaseAdapter
{
    public static class GDEM
    {
        public static string FindSalinityFile(TimePeriod monthIndex, string gdemDirectory)
        {
            var files = Directory.GetFiles(gdemDirectory, GDEMSalinityFileName(monthIndex), SearchOption.AllDirectories);
            if (files.Length > 0) return files[0];
            files = Directory.GetFiles(gdemDirectory, NUWCSalinityFileName(monthIndex), SearchOption.AllDirectories);
            if (files.Length > 0) return files[0];
            throw new FileNotFoundException(string.Format("Could not find requested salinity file, tried {0} and {1}", GDEMSalinityFileName(monthIndex), NUWCSalinityFileName(monthIndex)));
        }

        public static string FindTemperatureFile(TimePeriod monthIndex, string gdemDirectory)
        {
            var files = Directory.GetFiles(gdemDirectory, GDEMTemperatureFileName(monthIndex), SearchOption.AllDirectories);
            if (files.Length > 0) return files[0];
            files = Directory.GetFiles(gdemDirectory, NUWCTemperatureFileName(monthIndex), SearchOption.AllDirectories);
            if (files.Length > 0) return files[0];
            throw new FileNotFoundException(string.Format("Could not find requested temperature file, tried {0} and {1}", GDEMTemperatureFileName(monthIndex), NUWCTemperatureFileName(monthIndex)));
        }

        static string GDEMTemperatureFileName(TimePeriod monthIndex) { return "t" + BaseGDEMFileName(monthIndex); }
        static string GDEMSalinityFileName(TimePeriod monthIndex) { return "s" + BaseGDEMFileName(monthIndex); }
        static string BaseGDEMFileName(TimePeriod monthIndex)
        {
            if ((int)monthIndex < 1 || (int)monthIndex > 12) throw new ArgumentOutOfRangeException("monthIndex", "must be between 1 and 12, inclusive");
            return "gdemv3s" + string.Format("{0:00}", (int)monthIndex) + ".nc";
        }
        static string NUWCTemperatureFileName(TimePeriod monthIndex) { return ShortMonthNames[(int)monthIndex] + "_t.nc"; }
        static string NUWCSalinityFileName(TimePeriod monthIndex) { return ShortMonthNames[(int)monthIndex] + "_s.nc"; }
        static readonly string[] ShortMonthNames = new[] { "noneuary", "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" };

        /// <summary>
        /// Returns true if the directory exists and contains some combination of valid GDEM and/or NUWC file names
        /// </summary>
        /// <param name="gdemDirectory"></param>
        /// <returns></returns>
        public static bool IsDirectoryValid(string gdemDirectory)
        {
            if (!Directory.Exists(gdemDirectory)) return false;
            try
            {
                for (var month = (int)TimePeriod.January; month <= (int)TimePeriod.December; month++)
                {
                    FindTemperatureFile((TimePeriod)month, gdemDirectory);
                    FindSalinityFile((TimePeriod)month, gdemDirectory);
                }
                return true;
            }
            catch (FileFormatException)
            {
                return false;
            }
        }

        public static SoundSpeedField ReadFile(string gdemDirectory, TimePeriod month, GeoRect region)
        {
            var temperatureFile = NetCDFFile.Open(FindTemperatureFile(month, gdemDirectory));
            var temperatureLatitudes = ((NcVarDouble)temperatureFile.Variables.Single(var => var.Name == "lat")).ToArray();
            var temperatureLongitudes = ((NcVarDouble)temperatureFile.Variables.Single(var => var.Name == "lon")).ToArray();
            var temperatureDepths = ((NcVarDouble)temperatureFile.Variables.Single(var => var.Name == "depth")).ToArray();
            var temperatureData = ((NcVarShort)temperatureFile.Variables.Single(var => var.Name == "water_temp"));
            var temperatureMissingValue = ((NcAttShort)temperatureData.Attributes.Single(att => att.Name == "missing_value"))[0];
            var temperatureScaleFactor = ((NcAttFloat)temperatureData.Attributes.Single(att => att.Name == "scale_factor"))[0];
            var temperatureAddOffset = ((NcAttFloat)temperatureData.Attributes.Single(att => att.Name == "add_offset"))[0];
            temperatureData.Filename = FindTemperatureFile(month, gdemDirectory);

            var salinityFile = NetCDFFile.Open(FindSalinityFile(month, gdemDirectory));
            //var salinityLatitudes = ((NcVarDouble)salinityFile.Variables.Single(var => var.Name == "lat")).ToArray();
            //var salinityLongitudes = ((NcVarDouble)salinityFile.Variables.Single(var => var.Name == "lon")).ToArray();
            //var salinityDepths = ((NcVarDouble)salinityFile.Variables.Single(var => var.Name == "depth")).ToArray();
            var salinityData = ((NcVarShort)salinityFile.Variables.Single(var => var.Name == "salinity"));
            var salinityMissingValue = ((NcAttShort)salinityData.Attributes.Single(att => att.Name == "missing_value"))[0];
            var salinityScaleFactor = ((NcAttFloat)salinityData.Attributes.Single(att => att.Name == "scale_factor"))[0];
            var salinityAddOffset = ((NcAttFloat)salinityData.Attributes.Single(att => att.Name == "add_offset"))[0];
            salinityData.Filename = FindSalinityFile(month, gdemDirectory);

            var north = region.North;
            var south = region.South;
            var east = region.East;
            var west = region.West;

            if (temperatureLongitudes.First() > west) west += 360;
            if (temperatureLongitudes.Last() < west) west -= 360;
            if (temperatureLongitudes.First() > east) east += 360;
            if (temperatureLongitudes.Last() < east) east -= 360;

            var lonMap = new List<AxisMap>();
            var latMap = new List<AxisMap>();
            int i;
            if (east < west)
            {
                for (i = 0; i < temperatureLongitudes.Length; i++) 
                    if ((temperatureLongitudes[i] <= east) || (temperatureLongitudes[i] >= west)) 
                        lonMap.Add(new AxisMap((float)temperatureLongitudes[i], i));
            }
            else
            {
                for (i = 0; i < temperatureLongitudes.Length; i++) 
                    if ((temperatureLongitudes[i] >= west) && (temperatureLongitudes[i] <= east)) 
                        lonMap.Add(new AxisMap((float)temperatureLongitudes[i], i));
            }
            for (i = 0; i < temperatureLatitudes.Length; i++) if (temperatureLatitudes[i] >= south && temperatureLatitudes[i] <= north) latMap.Add(new AxisMap((float)temperatureLatitudes[i], i));
            var selectedLons = lonMap.Select(x => x.Value).ToArray();
            var selectedLats = latMap.Select(y => y.Value).ToArray();

            var latCount = selectedLats.Length;
            var lonCount = selectedLons.Length;

            var newFieldEnvironmentData = new List<SoundSpeedProfile>();

            for (var lonIndex = 0; lonIndex < lonCount; lonIndex++)
            {
                var lon = lonMap[lonIndex].Value;
                var wrappedLon = lon;
                while (wrappedLon > 180) wrappedLon -= 360;
                while (wrappedLon < -180) wrappedLon += 360;

                var lonSourceIndex = lonMap[lonIndex].Index;
                for (var latIndex = 0; latIndex < latCount; latIndex++)
                {
                    var lat = latMap[latIndex].Value;
                    var latSourceIndex = latMap[latIndex].Index;
                    var newProfile = new SoundSpeedProfile(new Geo(lat, wrappedLon));
                    for (var depthIndex = 0; depthIndex < temperatureDepths.Length; depthIndex++)
                    {
                        var temperatureValue = temperatureData[(uint)depthIndex, (uint)latSourceIndex, (uint)lonSourceIndex];
                        var salinityValue = salinityData[(uint)depthIndex, (uint)latSourceIndex, (uint)lonSourceIndex];
                        if ((Math.Abs(temperatureValue - temperatureMissingValue) < 0.0001) || (Math.Abs(salinityValue - salinityMissingValue) < 0.0001)) break;
                        var temperature = (temperatureValue * temperatureScaleFactor) + temperatureAddOffset;
                        var salinity = (salinityValue * salinityScaleFactor) + salinityAddOffset;
                        newProfile.Add(new SoundSpeedSample((float)temperatureDepths[depthIndex], temperature, salinity,
                                                            ChenMilleroLi.SoundSpeed(newProfile, (float)temperatureDepths[depthIndex], temperature, salinity)));
                    }
                    if (newProfile.Data.Count > 0) newFieldEnvironmentData.Add(newProfile);
                }
            }
            var newField = new SoundSpeedField { TimePeriod = month };
            newField.EnvironmentData.AddRange(newFieldEnvironmentData);
            newField.EnvironmentData.Sort();
            newField.EnvironmentData.TrimToNearestPoints(region);
            return newField;
        }

        private class AxisMap
        {
            public float Value { get; private set; }
            public int Index { get; private set; }

            public AxisMap(float value, int index)
            {
                Value = value;
                Index = index;
            }

            public override string ToString() { return string.Format("({0}, {1})", Value, Index); }
        }
    }
}
