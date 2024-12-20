﻿using System;
using System.ComponentModel.Composition;
using System.IO;
using System.Xml.Serialization;
using ESME.Environment;
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
    [EnvironmentDataSource(EnvironmentDataType = EnvironmentDataType.Bathymetry,
                           Name = "DBDB-V 5.4 for NAVO",
                           Description = "Digital Bathymetric Data Base - Variable Resolution v5.4 from US Navy/NAVOCEANO")]
    public sealed class DBDB54ForNAVO : EnvironmentalDataSourcePluginBase<Bathymetry>
    {
        const string RequiredDBDBFilename = "dbdbv5_level0c_0.h5";
        const string RequiredDBDBExtractionProgram = "dbv5_command.exe";

        public DBDB54ForNAVO()
        {
            SetPropertiesFromAttributes(GetType());
            DatabaseLocationHelp = "The DBDB-V database file 'dbdbv5_level0c_0.h5'";
            DatabaseControlCaption = "DBDB-V database file";
            DatabaseDialogTitle = "Please locate the DBDB-V database 'dbdbv5_level0c_0.h5'";
            DatabaseFilenameFilter = "HDF5 files (*.h5)|*.h5|All files (*.*)|*.*";

            ExtractorLocationHelp = "The DBDB-V extraction program 'dbv5_command.exe'";
            ExtractorControlCaption = "DBDB-V extraction program";
            ExtractorDialogTitle = "Please locate the DBDB-V extraction program 'dbv5_command.exe'";
            ExtractorFilenameFilter = "Executable files (*.exe)|*.exe|All files (*.*)|*.*";

            ConfigurationControl = new DBDBConfigurationControl { DataContext = this };
            AvailableResolutions = new[] { 2, 1, 0.5f, 0.1f, 0.05f };
            IsTimeVariantData = false;
            AvailableTimePeriods = new[] { TimePeriod.Invalid };

            IsSelectable = true;
            AddValidationRules(
                new ValidationRule<DBDB54ForNAVO>
                {
                    PropertyName = "DatabaseLocation",
                    Description = "File must exist and be named dbdbv5_level0c_0.h5",
                    IsRuleValid = (target, rule) => target.DatabaseLocation != null &&
                                                     File.Exists(target.DatabaseLocation) &&
                                                     Path.GetFileName(DatabaseLocation) == RequiredDBDBFilename,
                },
                new ValidationRule<DBDB54ForNAVO>
                {
                    PropertyName = "ExtractorLocation",
                    Description = "File must exist and be named dbv5_command.exe",
                    IsRuleValid = (target, rule) => target.ExtractorLocation != null &&
                                                     File.Exists(target.ExtractorLocation) &&
                                                     Path.GetFileName(ExtractorLocation) == RequiredDBDBExtractionProgram,
                });
            SelectionControlViewModel = new MultipleSelectionsViewModel<float>
            {
                UnitName = " min",
                AvailableSelections = AvailableResolutions,
            };
            SelectionControl = new MultipleSelectionsView { DataContext = SelectionControlViewModel };
        }

        public override bool IsConfigured { get { return DatabaseLocation != null && File.Exists(DatabaseLocation) && File.Exists(ExtractorLocation); } }

        protected override void Save()
        {
            var serializer = new XmlSerializer<DBDB54ForNAVO> { Data = this };
            serializer.Save(ConfigurationFile, null);
        }

        public override void LoadSettings()
        {
            var settings = XmlSerializer<DBDB54ForNAVO>.LoadExistingFile(ConfigurationFile, null);
            if (settings == null) return;
            DatabaseLocation = settings.DatabaseLocation;
            ExtractorLocation = settings.ExtractorLocation;
        }

        [XmlIgnore] public string DatabaseControlCaption { get; set; }
        [XmlIgnore] public string DatabaseDialogTitle { get; set; }
        [XmlIgnore] public string DatabaseFilenameFilter { get; set; }
        [XmlIgnore] public string DatabaseLocationHelp { get; set; }
        [XmlIgnore] public string ExtractorControlCaption { get; set; }
        [XmlIgnore] public string ExtractorDialogTitle { get; set; }
        [XmlIgnore] public string ExtractorFilenameFilter { get; set; }
        [XmlIgnore] public string ExtractorLocationHelp { get; set; }
        #region public string DatabaseLocation { get; set; }

        public string DatabaseLocation
        {
            get { return _databaseLocation; }
            set
            {
                _databaseLocation = value;
                Save();
            }
        }

        string _databaseLocation;

        #endregion
        #region public string ExtractorLocation { get; set; }

        public string ExtractorLocation
        {
            get { return _extractorLocation; }
            set
            {
                _extractorLocation = value;
                Save();
            }
        }

        string _extractorLocation;

        #endregion

        public override Bathymetry Extract(GeoRect geoRect, float resolution, TimePeriod timePeriod = TimePeriod.Invalid, PercentProgress progress = null)
        {
            CheckResolutionAndTimePeriod(resolution, timePeriod);
            return DBDB.Extract(DatabaseLocation, ExtractorLocation, resolution, geoRect, progress);
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
