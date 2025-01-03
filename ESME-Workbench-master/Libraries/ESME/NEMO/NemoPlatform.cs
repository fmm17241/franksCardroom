﻿using System;
using System.Collections.Generic;
using System.Globalization;
using System.Xml;
using ESME.Behaviors;

namespace ESME.NEMO
{
    public class NemoPlatform : NemoPSM
    {
        public NemoPlatform(XmlNode platform, string scenarioDirectory, NemoScenario nemoScenario, ref int modeID) : base(platform)
        {
            try
            {
                Sources = new List<NemoSource>();
                Trackdefs = new List<NemoTrackdef>();

                Description = GetString("description");

                Launcher = GetString("launcher");
                Towwer = GetString("towwer");
                RepeatCount = GetInt("repeatCount");

                foreach (XmlNode cur in platform.ChildNodes) if (cur.Name == "trackDef") Trackdefs.Add(new NemoTrackdef(cur, scenarioDirectory));

                foreach (XmlNode cur in platform.ChildNodes) if (cur.Name == "Source") Sources.Add(new NemoSource(cur, Math.Abs(Trackdefs[0].InitialHeight), ref modeID));
                
                if (Trackdefs.Count == 0) throw new FormatException("Platform.trackDef: At least one trackDef is required for each Platform");

                NemoScenario = nemoScenario;
            }
            catch (Exception e)
            {
                throw new PlatformException(string.Format("Error initializing platform {0}", Name), e);
            }
        }

        public void CalculateBehavior()
        {
            BehaviorModel = new BehaviorModel(this);
        }

        public override IEnumerable<KeyValuePair<string, string>> Properties
        {
            get
            {
                foreach (var property in base.Properties) yield return property;
                yield return new KeyValuePair<string, string>("Description", Description);
                yield return new KeyValuePair<string, string>("Launcher", Launcher);
                yield return new KeyValuePair<string, string>("Towwer", Towwer);
                yield return new KeyValuePair<string, string>("Repeat Count", RepeatCount.ToString(CultureInfo.InvariantCulture));
            }
        }

        public string Description { get; private set; }
        public string Launcher { get; private set; }
        public string Towwer { get; private set; }
        public int RepeatCount { get; private set; }
        public List<NemoTrackdef> Trackdefs { get; private set; }
        public List<NemoSource> Sources { get; private set; }
        public BehaviorModel BehaviorModel { get; private set; }

        public NemoScenario NemoScenario { get; private set; }
    }
}