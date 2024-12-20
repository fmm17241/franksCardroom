﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;
using ESME.NEMO.Overlay;

namespace ESME.NEMO
{
    public class NemoScenario : NemoBase
    {
        public NemoScenario(XmlNode scenario, string nemoDataDirectory) : base(scenario)
        {
            try
            {
                Platforms = new List<NemoPlatform>();
                Animals = new List<NemoAnimals>();

                BuilderVersion = GetString("builderVersion");
                EventName = GetString("eventName");
                CreationTime = GetDateTime("creationTime");
                Description = GetString("description");
                AnalystName = GetString("analystName");
                StartTime = GetDateTime("startTime");
                Duration = GetTimeSpan("duration");
                SimAreaName = GetString("simAreaName");
                TimeFrame = GetString("timeFrame");
                var modeID = 0;
                var scenarioDirectory = Path.Combine(nemoDataDirectory, SimAreaName);

                foreach (var cur in scenario.ChildNodes.Cast<XmlNode>().Where(cur => cur.Name == "Platform")) Platforms.Add(new NemoPlatform(cur, scenarioDirectory, this, ref modeID));
                ModeCount = modeID;

                foreach (var cur in scenario.ChildNodes.Cast<XmlNode>().Where(cur => cur.Name == "animals")) Animals.Add(new NemoAnimals(cur, scenarioDirectory));

                //var simAreaOverlays = Directory.GetFiles(Path.Combine(scenarioDirectory, "Areas"), "*_SIM_AREA.ovr");
                //if ((simAreaOverlays != null) && (simAreaOverlays.Length > 0)) OverlayFile = new OverlayFile(simAreaOverlays[0]);
            }
            catch (Exception e)
            {
                throw new ScenarioException(string.Format("Error initializing scenario"), e);
            }
        }

        public override IEnumerable<KeyValuePair<string, string>> Properties
        {
            get
            {
                yield return new KeyValuePair<string, string>("Range complex", SimAreaName);
                yield return new KeyValuePair<string, string>("Description", Description);
                yield return new KeyValuePair<string, string>("Time frame", TimeFrame);
                yield return new KeyValuePair<string, string>("Start time", StartTime.ToString());
                yield return new KeyValuePair<string, string>("Duration", Duration.ToString());
                yield return new KeyValuePair<string, string>("Created on", CreationTime.ToString());
                yield return new KeyValuePair<string, string>("Created by", AnalystName);
                yield return new KeyValuePair<string, string>("Builder version", BuilderVersion);
            }
        }

        public string BuilderVersion { get; private set; }
        public string EventName { get; private set; }
        public DateTime CreationTime { get; private set; }
        public string Description { get; private set; }
        public string AnalystName { get; private set; }
        public DateTime StartTime { get; private set; }
        public TimeSpan Duration { get; private set; }
        public string SimAreaName { get; private set; }
        public string TimeFrame { get; private set; }
        public List<NemoPlatform> Platforms { get; private set; }
        public List<NemoAnimals> Animals { get; private set; }
        public IEnumerable<NemoMode> DistinctModes
        {
            get
            {
                var results = new List<NemoMode>();
                foreach (var source in Platforms.SelectMany(platform => platform.Sources))
                    results.AddRange(source.Modes);
                return results.Distinct();
            }
        }

        public List<string> DistinctModePSMNames { get { return DistinctModes.Select(mode => mode.PSMName).ToList(); } }

        /// <summary>
        /// A count of the number of unique modes in this scenario, generally used when creating source-receiver level bins
        /// </summary>
        public int ModeCount { get; private set; }

        public OverlayFile OverlayFile { get; private set; }

        public IEnumerable<NemoMode> ActiveModes()
        {
            return from platform in Platforms
                   from source in platform.Sources
                   from mode in source.Modes
                   select mode;
        }
    }
}