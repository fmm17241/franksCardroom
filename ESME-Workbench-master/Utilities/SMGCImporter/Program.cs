﻿using System;
using HRC.Navigation;
using NAVODatabaseAdapter;

namespace SMGCImporter
{
    class Program
    {
        
        static int Main(string[] args)
        {
            string filename = null;
            string location = null;
            try
            {
                if (args.Length == 0)
                {
                    Usage("No arguments specified");
                    return -1;
                }
                for (var argIndex = 0; argIndex < args.Length; argIndex++)
                {
                    var arg = args[argIndex];
                    switch (arg)
                    {
                        case "-inputDirectory":
                            location = args[++argIndex];
                            break;
                        case "-outputFilename":
                            filename = args[++argIndex];
                            break;
                    }
                }
                if (string.IsNullOrEmpty(filename)) Usage("output file name not set!");
                if (string.IsNullOrEmpty(location)) Usage("SMGC databse location not set!");
                var result = SMGC.Import(new GeoRect(90, -90, 180, -180), location);
                foreach (var timePeriod in result.TimePeriods)
                    timePeriod.EnvironmentData.Sort();
                result.Save(filename);
            }  
            catch (Exception ex)
            {
                Usage(ex.Message);
                return -1;
            }
            return 0;
        }

       
        static void Usage(string message) {}
    }
}