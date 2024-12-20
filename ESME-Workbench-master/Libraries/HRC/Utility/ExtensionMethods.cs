﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Windows.Media;

namespace HRC.Utility
{
    public static class ExtensionMethods
    {
        public static TimeSpan Modulo(this TimeSpan source, TimeSpan modulus)
        {
            var sourceMs = source.TotalMilliseconds;
            var modulusMs = modulus.TotalMilliseconds;
            var modulo = sourceMs - (modulusMs * (int) (sourceMs / modulusMs));
            return new TimeSpan(0, 0, 0, 0, (int) modulo);
        }

        public static double DivideBy(this TimeSpan numerator, TimeSpan denominator) { return numerator.TotalSeconds / denominator.TotalSeconds; }

        public static Color ColorFromHSV(double hue, double saturation, double value)
        {
            var hi = Convert.ToInt32(Math.Floor(hue / 60)) % 6;
            var f = hue / 60 - Math.Floor(hue / 60);

            value = value * 255;
            var v = Convert.ToByte(value);
            var p = Convert.ToByte(value * (1 - saturation));
            var q = Convert.ToByte(value * (1 - f * saturation));
            var t = Convert.ToByte(value * (1 - (1 - f) * saturation));

            switch (hi)
            {
                case 0:
                    return Color.FromArgb(255, v, t, p);
                case 1:
                    return Color.FromArgb(255, q, v, p);
                case 2:
                    return Color.FromArgb(255, p, v, t);
                case 3:
                    return Color.FromArgb(255, p, q, v);
                case 4:
                    return Color.FromArgb(255, t, p, v);
                default:
                    return Color.FromArgb(255, v, p, q);
            }
        }

        public static Color[] CreateHSVPalette(int paletteLength) 
        {
            var result = new Color[paletteLength];
            var angleIncrement = 360.0 / ((double)paletteLength / 3);
            var index = 0;
            var saturation = 100;
            while (true)
            {
                var hueOffset = index * angleIncrement;
                result[index++] = ColorFromHSV(hueOffset, saturation / 100.0, 1.0);
                if (index == paletteLength) break;
                result[index++] = ColorFromHSV(120.0 + hueOffset, saturation / 100.0, 1.0);
                if (index == paletteLength) break;
                result[index++] = ColorFromHSV(240.0 + hueOffset, saturation / 100.0, 1.0);
                if (index == paletteLength) break;
                switch (saturation)
                {
                    case 100:
                        saturation = 90;
                        break;
                    case 90:
                        saturation = 100;
                        break;
                }
            }

            return result;
        }

        public static bool IsValidFilename(this string fileName)
        {
            var charList = new List<char>();
            charList.AddRange(Path.GetInvalidFileNameChars());
            charList.AddRange(Path.GetInvalidPathChars());
            var invalidChars = charList.Distinct().ToList();
            var charsToCheck = fileName.ToCharArray();
            return !(from cur in charsToCheck from invalid in invalidChars where cur == invalid select cur).Any();
        }

        public static IEnumerable<double> AdjacentDifferences(this IList<double> list) { return list.Take(list.Count - 1).Select((s, i) => list[i + 1] - s); }

        public static void Shuffle<T>(this IList<T> list)
        {
            var provider = new RNGCryptoServiceProvider();
            var n = list.Count;
            while (n > 1)
            {
                var box = new byte[1];
                do provider.GetBytes(box);
                while (!(box[0] < n * (Byte.MaxValue / n)));
                var k = (box[0] % n);
                n--;
                var value = list[k];
                list[k] = list[n];
                list[n] = value;
            }
        }
    }

    public struct LumaChromaColor
    {
        // Algorithm taken from http://en.wikipedia.org/wiki/YUV#Conversion_to.2Ffrom_RGB
        const float Wr = 0.299f;
        const float Wb = 0.115f;
        const float Wg = 0.587f;
        const float Umax = 0.436f;
        const float Vmax = 0.615f;

        public static LumaChromaColor FromColor(Color color)
        {
            var y = Wr * color.ScR + Wg * color.ScG + Wb * color.ScB;
            var u = Umax * ((color.ScB - y) / (1.0f - Wb));
            var v = Vmax * ((color.ScR - y) / (1.0f - Wr));
            return new LumaChromaColor(y, u, v);
        }

        public LumaChromaColor(float y, float u, float v)
            : this()
        {
            Y = y;
            U = u;
            V = v;
        }

        public float Y { get; set; }
        public float U { get; set; }
        public float V { get; set; }

        public Color Color
        {
            get
            {
                var scR = Y + V / 0.877f;
                var scG = Y - 0.395f * U - 0.581f * V;
                var scB = Y + U / 0.492f;
                return Color.FromScRgb(1.0f, scR, scG, scB);
            }
        }
    }
}