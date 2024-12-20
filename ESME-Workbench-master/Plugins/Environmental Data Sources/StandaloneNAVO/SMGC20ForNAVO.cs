using System;
using System.ComponentModel.Composition;
using System.IO;
using System.Linq;
using System.Xml.Serialization;
using ESME.Environment;
using ESME.Environment.NAVO;
using ESME.Locations;
using ESME.Plugins;
using ESME.Views.Locations;
using HRC.Navigation;
using HRC.Utility;
using HRC.Validation;
using NAVODatabaseAdapter;
using StandaloneNAVOPlugin.Controls;

namespace StandaloneNAVOPlugin
{
    [Serializable]
    [PartCreationPolicy(CreationPolicy.Shared)]
    [EnvironmentDataSource(EnvironmentDataType = EnvironmentDataType.Wind,
                           Name = "SMGC 2.0 for NAVO",
                           Description = "Surface Marine Gridded Climatology Database v2.0 from US Navy/NAVOCEANO")]
    public sealed class SMGC20ForNAVO : EnvironmentalDataSourcePluginBase<Wind>
    {
        public SMGC20ForNAVO()
        {
            SetPropertiesFromAttributes(GetType());
            DataLocationHelp = "The SMGC data directory, which should contain many *.stt files";
            ControlCaption = "SMGC data directory";
            DialogTitle = "Please locate one of the SMGC data files (*.stt)";
            FilenameFilter = "SMGC data files (*.stt)|*.stt|All files (*.*)|*.*";
            ConfigurationControl = new NAVOConfigurationControl { DataContext = this };

            IsTimeVariantData = true;
            AvailableTimePeriods = NAVOConfiguration.AllTimePeriods.ToArray();
            AvailableResolutions = new[] { 60f };

            IsSelectable = true;
            AddValidationRules(new ValidationRule<SMGC20ForNAVO>
            {
                PropertyName = "DataLocation",
                Description = "The directory must exist and contain many files with a .stt extension",
                IsRuleValid = (target, rule) => target.IsConfigured,
            });
            SelectionControlViewModel = new MultipleSelectionsViewModel<float>
            {
                UnitName = " min",
                AvailableSelections = AvailableResolutions,
            };
            SelectionControl = new MultipleSelectionsView { DataContext = SelectionControlViewModel };
        }

        public override bool IsConfigured
        {
            get { return IsDirectoryValid(DataLocation); }
        }

        protected override void Save()
        {
            var serializer = new XmlSerializer<SMGC20ForNAVO> { Data = this };
            serializer.Save(ConfigurationFile, null);
        }

        public override void LoadSettings()
        {
            var settings = XmlSerializer<SMGC20ForNAVO>.LoadExistingFile(ConfigurationFile, null);
            if (settings == null) return;
            DataLocation = settings.DataLocation;
        }

        static bool IsDirectoryValid(string directory)
        {
            if (string.IsNullOrEmpty(directory) || !Directory.Exists(directory)) return false;
            var files = Directory.GetFiles(directory, "*.stt", SearchOption.AllDirectories);
            return files.Length >= 1000;
        }

        [XmlIgnore] public string ControlCaption { get; set; }
        [XmlIgnore] public string DialogTitle { get; set; }
        [XmlIgnore] public string FilenameFilter { get; set; }
        [XmlIgnore] public string DataLocationHelp { get; set; }
        #region public string DataLocation { get; set; }

        public string DataLocation
        {
            get { return _dataLocation; }
            set
            {
                if (_dataLocation == value) return;
                _dataLocation = value;
                if (_dataLocation == null) return;
                if (File.Exists(_dataLocation) || Directory.Exists(_dataLocation))
                {
                    // If the user chose a file, set _dataLocation to the directory that contains the file
                    if ((File.GetAttributes(_dataLocation) & FileAttributes.Directory) != FileAttributes.Directory) _dataLocation = Path.GetDirectoryName(_dataLocation);
                    // If the directory pointed to by _dataLocation is not valid, make _dataLocation point to the parent directory
                    if (!string.IsNullOrEmpty(_dataLocation) && Directory.Exists(_dataLocation)) if (!IsDirectoryValid(_dataLocation)) _dataLocation = Path.GetDirectoryName(_dataLocation);
                    // If the directory still is not valid, set it back to the user's original choice
                    if (!string.IsNullOrEmpty(_dataLocation) && Directory.Exists(_dataLocation)) if (!IsDirectoryValid(_dataLocation)) _dataLocation = value;
                }
                Save();
            }
        }

        string _dataLocation;

        #endregion

        public override Wind Extract(GeoRect geoRect, float resolution, TimePeriod timePeriod = TimePeriod.Invalid, PercentProgress progress = null)
        {
            CheckResolutionAndTimePeriod(resolution, timePeriod);
            var allTimePeriods = SMGC.Import(geoRect, DataLocation);
            var result = new Wind();
            result.TimePeriods.Add(allTimePeriods[timePeriod]);
            return result;
        }

        public override EnvironmentalDataSet SelectedDataSet
        {
            get
            {
                var selectedItem = ((MultipleSelectionsViewModel<float>)SelectionControlViewModel).SelectedItem;
                return new EnvironmentalDataSet { SourcePlugin = PluginIdentifier, Resolution = selectedItem.Value, TimePeriod = TimePeriod.Invalid };
            }
        }
    }
}