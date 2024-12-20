﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Serialization;
using ESME.Environment.NAVO;
using ESME.Plugins;
using HRC;
using HRC.Aspects;
using HRC.Collections;
using HRC.Utility;
using HRC.ViewModels;

namespace ESME.Data
{
    [Serializable]
    public class AppSettings : ViewModelBase
    {
        public static readonly List<Type> ReferencedTypes = new List<Type>
        {
            typeof (NAVOConfiguration),
        };

        [UsedImplicitly] PropertyObserver<AppSettings> _propertyObserver;
        public AppSettings()
        {
            _propertyObserver = new PropertyObserver<AppSettings>(this)
                .RegisterHandler(p => p.PluginManagerService,
                                 () =>
                                 {
                                     if (PluginManagerService != null && (object)SelectedTransmissionLossEngine == null) 
                                         SelectedTransmissionLossEngine = ((PluginBase)PluginManagerService[PluginType.TransmissionLossCalculator].Values.First().DefaultPlugin).PluginIdentifier;
                                 });
        }
        static string _appSettingsDirectory;
        
        public static string ApplicationName
        {
            get { return _appName; }
            set
            {
                _appName = value;
                _appSettingsDirectory = Path.Combine(System.Environment.GetFolderPath(System.Environment.SpecialFolder.ApplicationData), _appName);
                if (!Directory.Exists(_appSettingsDirectory)) Directory.CreateDirectory(_appSettingsDirectory);
                AppSettingsFile = Path.Combine(_appSettingsDirectory, "settings.xml");
            }
        }

        static string _appName;

        public static string AppSettingsFile { get; private set; }

        public void Save()
        {
            StaticXmlSerializer.Save(AppSettingsFile, this);
        }

        public static AppSettings Load()
        {
            return (AppSettings)StaticXmlSerializer.Load(AppSettingsFile, typeof(AppSettings));
        }

        public static AppSettings Load(string fileName)
        {
            return (AppSettings)StaticXmlSerializer.Load(fileName, typeof(AppSettings));
        }

        [Initialize]
        public SerializableDictionary<string, string> OpenFileServiceDirectories { get; set; }

        [Initialize]
        public NAVOConfiguration NAVOConfiguration { get; set; }

        [Initialize(true)]
        public bool DisplayContoursOnTransmissionLoss { get; set; }

        [Initialize(120f)]
        public float TransmissionLossContourThreshold { get; set; }

        [Initialize(-1)]
        public int MaxImportThreadCount { get; set; }

        public PluginIdentifier SelectedTransmissionLossEngine { get; set; }
        [XmlIgnore] public IPluginManagerService PluginManagerService { get; set; }

        public string DatabaseDirectory { get; set; }
    }
}