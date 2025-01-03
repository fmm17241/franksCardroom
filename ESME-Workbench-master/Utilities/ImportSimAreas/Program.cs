﻿using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Text;
using FileHelpers;
using Devart.Data.SQLite;

namespace ImportSimAreas
{
    class Program
    {
        static void Main(string[] args)
        {
            string sourceFile = null;
            string output = null;
            DbConnection connection = null;
            bool dump = false;
            try
            {
                if (args.Length == 0)
                {
                    Usage("No arguments specified!");
                    return;
                }
                for (var i = 0; i < args.Length; i++)
                {
                    var arg = args[i];
                    switch (arg.ToLower())
                    {
                        case "-sourcefile":
                            sourceFile = args[++i];
                            if (!File.Exists(sourceFile)) Usage("source file does not exist or is an invalid path.");
                            break;
                        case "-output":
                            output = args[++i];
                            break;
                        case "-dump":
                            dump = true;
                            break;
                        default:
                            Usage("Incorrect option specified.");
                            return;
                    }
                }
            }
            catch (Exception ex)
            {
                Usage(ex.Message);
            }

            Devart.Data.SQLite.Entity.Configuration.SQLiteEntityProviderConfig.Instance.Workarounds.IgnoreSchemaName = true;
            connection = new Devart.Data.SQLite.SQLiteConnection(string.Format("Data Source='{0}';FailIfMissing=False", output));
            
            Console.WriteLine("populating database...");
            Import(sourceFile, connection);
            if (dump)
            {
                Console.WriteLine("displaying data names...");
                Dump(connection);
            }
            Console.WriteLine("done.");
        }

        static void Usage(string message)
        {
            Console.WriteLine("ImportSimAreas - import tool for NUWC SimAreas.csv files.");
            Console.WriteLine("     -sourceFile  <sourceFile.csv>    : the path to a valid SimAreas.csv file");
            Console.WriteLine("     -output      <outputFile.sqlite> : the path to the target location of the normalized sqlite database output.");
            Console.WriteLine("     (-dump)                          : if specified, basic database contents will be displayed.");
            if (message != null) Console.WriteLine(message);
        }

        static void Import(string simAreasPath, DbConnection connection)
        {
            var simarea = new SimAreasContext(connection, false, new DropCreateDatabaseAlways<SimAreasContext>());
            var engine = new FileHelperEngine(typeof(SimAreas));
            var entries = (SimAreas[])engine.ReadFile(simAreasPath);

            foreach (var entry in entries)
            {
                var area = (from s in simarea.SimAreas
                            where s.SimAreaName == entry.SimAreaName
                            select s).FirstOrDefault();
                if (area == null)
                {
                    area = new SimArea
                    {
                        SimAreaName = entry.SimAreaName,
                        Latitude = entry.Latitude,
                        Longitude = entry.Longitude,
                        Height = entry.Height,
                        GeoidSeparation = entry.GeoidSeparation,
                        OpsLimitFile = entry.OpsLimitFile,
                        SimLimitFile = entry.SimLimitFile,
                    };
                    simarea.SimAreas.Add(area);
                    simarea.SaveChanges();
                }

            }
        }

        static void Dump(DbConnection connection)
        {
            var simareas = new SimAreasContext(connection, true, new CreateDatabaseIfNotExists<SimAreasContext>());
            foreach (var area in simareas.SimAreas)
            {
                Console.WriteLine("{0} {1} {2}", area.SimAreaName, area.Latitude, area.Longitude);
            }
        }
    }

    [DelimitedRecord(",")]
    [IgnoreFirst(1)]
    public class SimAreas
    {
        public string SimAreaName;
        public float Latitude;
        public float Longitude;
        public float Height;
        public float GeoidSeparation;
        public string OpsLimitFile;
        public string SimLimitFile;
    }

    public class SimArea
    {
        public int SimAreaID { get; set; }
        public string SimAreaName { get; set; }
        public float Latitude { get; set; }
        public float Longitude { get; set; }
        public float Height { get; set; }
        public float GeoidSeparation { get; set; }
        public string OpsLimitFile { get; set; }
        public string SimLimitFile { get; set; }
    }

    public class SimAreasContext : DbContext
    {
        public SimAreasContext(DbConnection connection, bool contextOwnsConnection, IDatabaseInitializer<SimAreasContext> initializer)
            : base(connection, contextOwnsConnection)
        {
            Database.SetInitializer(initializer);
        }

        public DbSet<SimArea> SimAreas { get; set; }
    }
}
