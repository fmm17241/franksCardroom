﻿using System.IO;

namespace ESME.NEMO.Overlay
{
    internal class LineReader
    {
        public LineReader()
        {
            Lines = null;
            LineNumber = 0;
        }

        string _fileName;
        public string FileName
        {
            get { return _fileName; }
            set
            {
                _fileName = value;
                Lines = File.ReadAllLines(_fileName);
            }
        }

        public int LineNumber { get; private set; }

        public string[] Lines { get; private set; }

        public string NextLine
        {
            get
            {
                // Skip over any blank lines encountered
                while ((LineNumber < Lines.Length) && string.IsNullOrEmpty(Lines[LineNumber].Trim()))
                    LineNumber++;
                if (LineNumber >= Lines.Length) return null;
                var result = Lines[LineNumber++].Trim().ToLower();
                return result;
            }
        }
    }
}