﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Text;
using System.Windows;
using ESME.Views.Misc;
using HRC.Services;
using HRC.ViewModels;

namespace ESMEWorkbench.ViewModels.Main
{
    public class AboutViewModel : ViewModelBase, IViewStatusAwareInjectionAware
    {
        public AboutViewModel()
        {
            RegisterMediator();
            WorkbenchModuleBuildInfo = new ModuleBuildInfoViewModel("ESME Workbench", BuildInformation.BuildDateTime, BuildInformation.BuildEngineer, Assembly.GetEntryAssembly().GetName().Version);
            ESMEModuleBuildInfo = new ModuleBuildInfoViewModel("ESME.dll", ESME.BuildInformation.BuildDateTime, ESME.BuildInformation.BuildEngineer);
            HRCModuleBuildInfo = new ModuleBuildInfoViewModel("HRC.dll", HRC.BuildInformation.BuildDateTime, HRC.BuildInformation.BuildEngineer);
            ViewsModuleBuildInfo = new ModuleBuildInfoViewModel("ESME.Views.dll", ESME.Views.BuildInformation.BuildDateTime, ESME.Views.BuildInformation.BuildEngineer);
            var appDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            if (string.IsNullOrEmpty(appDir)) return;
            MapDllVersion = Assembly.LoadFile(Path.Combine(appDir, "WpfDesktopEdition.dll")).GetName().Version.ToString();
            MapCoreVersion = Assembly.LoadFile(Path.Combine(appDir, "MapSuiteCore.dll")).GetName().Version.ToString();
            NetTopologyVersion = Assembly.LoadFile(Path.Combine(appDir, "NetTopologySuite.dll")).GetName().Version.ToString();
            GeoAPIVersion = Assembly.LoadFile(Path.Combine(appDir, "GeoAPI.dll")).GetName().Version.ToString();
        }

        public ModuleBuildInfoViewModel WorkbenchModuleBuildInfo { get; private set; }
        public ModuleBuildInfoViewModel ESMEModuleBuildInfo { get; private set; }
        public ModuleBuildInfoViewModel HRCModuleBuildInfo { get; private set; }
        public ModuleBuildInfoViewModel ViewsModuleBuildInfo { get; private set; }
        public string MapDllVersion { get; private set; }
        public string MapCoreVersion { get; private set; }
        public string NetTopologyVersion { get; private set; }
        public string GeoAPIVersion { get; private set; }
        
        #region OkCommand

        SimpleCommand<object, object> _okCommand;

        public SimpleCommand<object, object> OkCommand
        {
            get { return _okCommand ?? (_okCommand = new SimpleCommand<object, object>(x => CloseActivePopUpCommand.Execute(true))); }
        }

        #endregion

        #region HelpfulBugInfoCommand

        SimpleCommand<object, object> _helpfulBugInfo;

        public SimpleCommand<object, object> HelpfulBugInfoCommand
        {
            get
            {
                return _helpfulBugInfo ?? (_helpfulBugInfo = new SimpleCommand<object, object>(delegate
                                                                                               {
                                                                                                   var infos = new List<ModuleBuildInfoViewModel>
                                                                                                               {
                                                                                                                   WorkbenchModuleBuildInfo,
                                                                                                                   ESMEModuleBuildInfo,
                                                                                                                   HRCModuleBuildInfo,
                                                                                                                   ViewsModuleBuildInfo
                                                                                                               };
                                                                                                   var result = ConcatenatedBuildInfo(infos);
                                                                                                   Clipboard.SetText(result);
                                                                                               }));
            }
        }

        #endregion

        #region ReportBugCommand

        public SimpleCommand<object, object> ReportBugCommand
        {
            get { return _reportBug ?? (_reportBug = new SimpleCommand<object, object>(delegate { Process.Start("http://hrcbugzilla.bu.edu/enter_bug.cgi"); })); }
        }

        SimpleCommand<object, object> _reportBug;

        #endregion

        #region IViewStatusAwareInjectionAware Members

        public void InitialiseViewAwareService(IViewAwareStatus viewAwareStatusService)
        { }

        #endregion

        static string ConcatenatedBuildInfo(IEnumerable<ModuleBuildInfoViewModel> modules)
        {
            var sb = new StringBuilder();
            sb.AppendLine("----- Component Version Info -----");
            foreach (var moduleBuildInfoViewModel in modules)
            {
                sb.AppendLine(moduleBuildInfoViewModel.ModuleName);
                sb.AppendLine(string.Format("  Build Date : {0}", moduleBuildInfoViewModel.BuildDateTime));
                sb.AppendLine(string.Format("     Version : {0}", moduleBuildInfoViewModel.VersionString));
            }
            sb.AppendLine("----- Component Version Info -----");
            sb.AppendLine("");
            return sb.ToString();
        }

        void RegisterMediator()
        {
            try
            {
                Mediator.Instance.Register(this);
            }
            catch (Exception ex)
            {
                Debug.WriteLine("***********\nAboutViewModel: Mediator registration failed: " + ex.Message + "\n***********");
                throw;
            }
        }
    }
}