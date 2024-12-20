﻿using System;
using System.ComponentModel.Composition;
using System.Diagnostics;
using System.Windows;
using ESME.Views.PSM;
using HRC;
using HRC.Services;
using HRC.ViewModels;
using MEFedMVVM.ViewModelLocator;

namespace GrahamsWPFTester
{
    [ExportViewModel("MainWindowViewModel")]
    class MainWindowViewModel : ViewModelBase
    {
        readonly IViewAwareStatus _viewAwareStatus;
        readonly IMessageBoxService _messageBox;
        readonly IUIVisualizerService _visualizer;
        readonly IHRCSaveFileService _saveFile;

        [ImportingConstructor]
        public MainWindowViewModel([NotNull] IViewAwareStatus viewAwareStatus,
                                                  IMessageBoxService messageBox,
                                                  IUIVisualizerService visualizer,
                                                  IHRCSaveFileService saveFile)
        {
            _viewAwareStatus = viewAwareStatus;
            _messageBox = messageBox;
            _visualizer = visualizer;
            _saveFile = saveFile;
            _viewAwareStatus.ViewLoaded += () => _visualizer.ShowWindow("PSMBrowserView", new PSMBrowserViewModel(),false,(s, e) => Application.Current.Shutdown());
        }
    }
}
