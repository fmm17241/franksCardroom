﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Threading.Tasks.Dataflow;
using System.Windows;
using System.Windows.Media;
using System.Windows.Threading;
using ESME.Plugins;
using HRC.Navigation;
using ESME.Environment.NAVO;
using HRC.NetCDF;
using HRC.Utility;
using HRC.ViewModels;
using HRC.WPF;

namespace ESME.Environment
{
    public static class Logger
    {
        public static void Start(string fileName)
        {
            if (_writer != null) _writer.Close();
            _writer = File.AppendText(fileName);
        }

        public static void LogString(string message) { Log(message); }

        static StreamWriter _writer;
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static void Log(string format, params object[] args)
        {
            //Console.WriteLine("{0} {1}", DateTime.Now, string.Format(format, args));
            //if (_writer == null) return;
            //_writer.WriteLine("{0} {1}", DateTime.Now, string.Format(format, args));
            //_writer.Flush();
        }

        public static void Stop()
        {
            if (_writer != null) _writer.Close();
            _writer = null;
        }
    }

    public static class NAVOImporter
    {
        static readonly ActionBlock<ImportJobDescriptor> SoundSpeedWorker;
        static readonly ActionBlock<ImportJobDescriptor> SedimentWorker;
        static readonly ActionBlock<ImportJobDescriptor> WindWorker;
        static readonly ActionBlock<ImportJobDescriptor> BathymetryWorker;
        public static readonly ImportProgressViewModel SoundSpeedProgress;
        public static readonly ImportProgressViewModel SedimentProgress;
        public static readonly ImportProgressViewModel WindProgress;
        public static readonly ImportProgressViewModel BathymetryProgress;

        static void CheckDestinationDirectory(string destinationFilename)
        {
            if (string.IsNullOrEmpty(destinationFilename)) throw new ArgumentNullException("destinationFilename");
            var destinationDirectory = Path.GetDirectoryName(destinationFilename);
            if (string.IsNullOrEmpty(destinationDirectory)) throw new ArgumentException("Destination filename must contain a full path", "destinationFilename");
            if (!Directory.Exists(destinationDirectory)) Directory.CreateDirectory(destinationDirectory);
        }

        static NAVOImporter()
        {
            NcVarShort.Logger = Logger.LogString;
            NetCDFFile.Logger = Logger.LogString;
            //NetCDFReaders.Logger = Logger.LogString;
            Logger.Start(Path.Combine(System.Environment.GetFolderPath(System.Environment.SpecialFolder.MyDocuments), "esme.log"));
            Logger.Log("About to create soundspeed worker");
            if (SoundSpeedWorker == null) SoundSpeedWorker = new ActionBlock<ImportJobDescriptor>(async job =>
            {
                if (Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.SoundSpeed] == null) 
                    throw new InvalidOperationException("Cannot extract sound speed data - no data source is configured");
                SoundSpeedProgress.JobStarting(job);
                CheckDestinationDirectory(job.DestinationFilename);
                var soundSpeed = ((EnvironmentalDataSourcePluginBase<SoundSpeed>)Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.SoundSpeed]).Extract(job.GeoRect, 15, job.TimePeriod);
                soundSpeed.Serialize(job.DestinationFilename);
                job.SampleCount = (uint)soundSpeed[job.TimePeriod].EnvironmentData.Count;
                job.Resolution = 15;
                job.CompletionTask.Start();
                await job.CompletionTask;
                SoundSpeedProgress.JobCompleted(job);
            },
            new ExecutionDataflowBlockOptions
            {
                TaskScheduler = TaskScheduler.Default,
                BoundedCapacity = Globals.AppSettings.MaxImportThreadCount,
                MaxDegreeOfParallelism = Globals.AppSettings.MaxImportThreadCount,
            });
            SoundSpeedProgress = new ImportProgressViewModel("Sound Speed", SoundSpeedWorker);

            if (SedimentWorker == null) SedimentWorker = new ActionBlock<ImportJobDescriptor>(job =>
            {
                if (Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.Sediment] == null)
                    throw new InvalidOperationException("Cannot extract sediment data - no data source is configured");
                SedimentProgress.JobStarting(job);
                CheckDestinationDirectory(job.DestinationFilename);
                var sediment = ((EnvironmentalDataSourcePluginBase<Sediment>)Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.Sediment]).Extract(job.GeoRect, job.Resolution);
                //var sediment = BST.Extract(job.GeoRect);
                sediment.Save(job.DestinationFilename);
                job.SampleCount = (uint)sediment.Samples.Count;
                job.Resolution = 5;
                job.CompletionTask.Start();
               SedimentProgress.JobCompleted(job);
            },
            new ExecutionDataflowBlockOptions
            {
                TaskScheduler = TaskScheduler.Default,
                BoundedCapacity = -1,
                MaxDegreeOfParallelism = 1,
            });
            SedimentProgress = new ImportProgressViewModel("Sediment", SedimentWorker);

            if (WindWorker == null) WindWorker = new ActionBlock<ImportJobDescriptor>(async job =>
            {
                if (Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.Wind] == null)
                    throw new InvalidOperationException("Cannot extract wind data - no data source is configured");
                WindProgress.JobStarting(job);
                CheckDestinationDirectory(job.DestinationFilename);
                var wind = new Wind();
                foreach (var month in NAVOConfiguration.AllMonths)
                {
                    var monthlyWind = ((EnvironmentalDataSourcePluginBase<Wind>)Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.Wind]).Extract(job.GeoRect, 60, month);
                    wind.TimePeriods.Add(monthlyWind[month]);
                }
                //var wind = await SMGC.ImportAsync(job.GeoRect);
                wind.Save(job.DestinationFilename);
                job.SampleCount = (uint)wind.TimePeriods[0].EnvironmentData.Count;
                job.Resolution = 60;
                job.CompletionTask.Start();
                await job.CompletionTask;
                WindProgress.JobCompleted(job);
            },
            new ExecutionDataflowBlockOptions
            {
                TaskScheduler = TaskScheduler.Default,
                BoundedCapacity = -1,
                MaxDegreeOfParallelism = Globals.AppSettings.MaxImportThreadCount,
            });
            WindProgress = new ImportProgressViewModel("Wind", WindWorker);

            if (BathymetryWorker == null) BathymetryWorker = new ActionBlock<ImportJobDescriptor>(async job =>
            {
                try
                {
                    if (Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.Bathymetry] == null)
                        throw new InvalidOperationException("Cannot extract bathymetry data - no data source is configured");
                    BathymetryProgress.JobStarting(job);
                    CheckDestinationDirectory(job.DestinationFilename);
                    var bathymetry = ((EnvironmentalDataSourcePluginBase<Bathymetry>)Globals.PluginManagerService[PluginType.EnvironmentalDataSource, PluginSubtype.Bathymetry]).Extract(job.GeoRect, job.Resolution);
                    //var bathymetry = DBDB.Extract(job.Resolution, job.GeoRect);
                    bathymetry.Save(job.DestinationFilename);
                    job.SampleCount = (uint)bathymetry.Samples.Count;
                    job.CompletionTask.Start();
                    await job.CompletionTask;
                    var colormap = new DualColormap(Colormap.Summer, Colormap.Jet) { Threshold = 0 };
                    var bathysize = Math.Max(bathymetry.Samples.Longitudes.Count, bathymetry.Samples.Latitudes.Count);
                    var screenSize = Math.Min(SystemParameters.PrimaryScreenWidth, SystemParameters.PrimaryScreenHeight);
                    var displayValues = bathymetry.Samples;
                    if (bathysize > screenSize)
                    {
                        var scaleFactor = screenSize / bathysize;
                        displayValues = EnvironmentData<Geo<float>>.Decimate(bathymetry.Samples,
                                                                                        (int)(bathymetry.Samples.Longitudes.Count * scaleFactor),
                                                                                        (int)(bathymetry.Samples.Latitudes.Count * scaleFactor));
                    }

                    var imageFilename = Path.GetFileNameWithoutExtension(job.DestinationFilename) + ".bmp";
                    var imagePath = Path.GetDirectoryName(job.DestinationFilename);

                    var bitmapData = new float[displayValues.Longitudes.Count, displayValues.Latitudes.Count];
                    for (var latIndex = 0; latIndex < bitmapData.GetLength(1); latIndex++) 
                        for (var lonIndex = 0; lonIndex < bitmapData.GetLength(0); lonIndex++) 
                            bitmapData[lonIndex, latIndex] = displayValues[(uint)lonIndex, (uint)latIndex].Data;

                    var displayData = colormap.ToPixelValues(bitmapData, bathymetry.Minimum.Data, bathymetry.Maximum.Data < 0 ? 
                                      bathymetry.Maximum.Data : 8000, Colors.Black);
                    BitmapWriter.Write(Path.Combine(imagePath, imageFilename), displayData);

                    var sb = new StringBuilder();
                    sb.AppendLine(job.Resolution.ToString(CultureInfo.InvariantCulture));
                    sb.AppendLine("0.0");
                    sb.AppendLine("0.0");
                    sb.AppendLine(job.Resolution.ToString(CultureInfo.InvariantCulture));
                    sb.AppendLine(bathymetry.Samples.GeoRect.West.ToString(CultureInfo.InvariantCulture));
                    sb.AppendLine(bathymetry.Samples.GeoRect.North.ToString(CultureInfo.InvariantCulture));
                    using (var writer = new StreamWriter(Path.Combine(imagePath, Path.GetFileNameWithoutExtension(imageFilename) + ".bpw"), false)) writer.Write(sb.ToString());
                    BathymetryProgress.JobCompleted(job);
                }
                catch (Exception e)
                {
                    Debug.WriteLine("Bathymetry extraction caught exception: {0}", e.Message);
                    throw;
                }
            },
            new ExecutionDataflowBlockOptions
            {
                TaskScheduler = TaskScheduler.Default,
                BoundedCapacity = -1,
                MaxDegreeOfParallelism = Globals.AppSettings.MaxImportThreadCount,
            });
            BathymetryProgress = new ImportProgressViewModel("Bathymetry", BathymetryWorker);
        }

        public static void Import(IEnumerable<ImportJobDescriptor> jobDescriptors)
        {
            foreach (var jobDescriptor in jobDescriptors)
            {
                Import(jobDescriptor);
            }
        }

        public static void Import(ImportJobDescriptor jobDescriptor)
        {
            switch (jobDescriptor.DataType)
            {
                case EnvironmentDataType.Bathymetry:
                    BathymetryProgress.Post(jobDescriptor);
                    break;
#if false
                case EnvironmentDataType.Salinity:
                    SalinityProgress.Post(jobDescriptor);
                    break;
                case EnvironmentDataType.Temperature:
                    //Logger.Log("Temperature job about to post");
                    TemperatureProgress.Post(jobDescriptor);
                    //Logger.Log("Temperature job after post");
                    break;
#endif
                case EnvironmentDataType.SoundSpeed:
                    SoundSpeedProgress.Post(jobDescriptor);
                    break;
                case EnvironmentDataType.Sediment:
                    SedimentProgress.Post(jobDescriptor);
                    break;
                case EnvironmentDataType.Wind:
                    WindProgress.Post(jobDescriptor);
                    break;
            }
        }
    }

    public class ImportJobDescriptor
    {
        public EnvironmentDataType DataType { get; set; }
        public GeoRect GeoRect { get; set; }
        public TimePeriod TimePeriod { get; set; }
        public float Resolution { get; set; }
        public string DestinationFilename { get; set; }
        public uint SampleCount { get; set; }
        //public Action<ImportJobDescriptor> CompletionAction { get; set; }
        public Task<ImportJobDescriptor> CompletionTask { get; set; }
        public Func<Object, ImportJobDescriptor> CompletionFunction { get; set; }
    }

    public class ImportProgressCollection : ReadOnlyObservableCollection<ImportProgressViewModel>
    {
        static readonly ObservableCollection<ImportProgressViewModel> Importers = new ObservableCollection<ImportProgressViewModel>(
            new List<ImportProgressViewModel>
            {
                NAVOImporter.SoundSpeedProgress,
                NAVOImporter.BathymetryProgress,
                NAVOImporter.SedimentProgress,
                NAVOImporter.WindProgress,
            });

        static readonly ImportProgressCollection Instance = new ImportProgressCollection();
        public static ImportProgressCollection Singleton { get { return Instance; } }
        ImportProgressCollection() : base(Importers) { }
    }

    public class ImportProgressViewModel : ViewModelBase
    {
        readonly Dispatcher _dispatcher = Dispatcher.CurrentDispatcher;

        public ImportProgressViewModel(string name, ActionBlock<ImportJobDescriptor> importer = null) 
        {
            Name = name;
            _importer = importer;
            _buffer = new BufferBlock<ImportJobDescriptor>();
            _buffer.LinkTo(_importer);
            AwaitCompletion();
        }

        async void AwaitCompletion()
        {
            try
            {
                await _importer.Completion;
            }
            catch
            {
                _dispatcher.InvokeInBackgroundIfRequired(() =>
                {
                    IsCompleted = _importer.Completion.IsCompleted;
                    IsCanceled = _importer.Completion.IsCanceled;
                    IsFaulted = _importer.Completion.IsFaulted;
                    if (!IsFaulted) return;
                    //Logger.Log("Importer has caught an exception.  Message follows.");
                    System.Media.SystemSounds.Beep.Play();
                    Status = "Error";
                    ToolTip = "";
                    if (_importer.Completion.Exception != null)
                        foreach (var ex in _importer.Completion.Exception.InnerExceptions) 
                            ToolTip += FormatExceptionMessage(ex, 0) + "\r\n";
                    ToolTip = ToolTip.Remove(ToolTip.Length - 2, 2).Trim();
                });

            }
        }

        public string FormatExceptionMessage(Exception exception, int indentLevel)
        {
            return new string(' ', 2 * indentLevel) + ((exception.InnerException == null)
                                                      ? exception.Message
                                                      : exception.Message + "\r\n" + FormatExceptionMessage(exception.InnerException, indentLevel + 1));
        }

        public void Post(ImportJobDescriptor job)
        {
            _dispatcher.InvokeInBackgroundIfRequired(() =>
            {
                Submitted++;
                UpdateStatus();
                _buffer.Post(job);
                IsWorkInProgress = true;
            });
        }

        public void JobStarting(ImportJobDescriptor job)
        {
            _dispatcher.InvokeInBackgroundIfRequired(() =>
            {
                Running++;
                UpdateStatus();
            });
        }

        public void JobCompleted(ImportJobDescriptor job)
        {
            _dispatcher.InvokeInBackgroundIfRequired(() =>
            {
                Running--;
                Completed++;
                UpdateStatus();
            });
            if (Completed != Submitted) return;
            IsWorkInProgress = false;
            Submitted = 0;
            Completed = 0;
        }

        void UpdateStatus()
        {
            if (IsFaulted) return;
            Status = IsWorkInProgress ? string.Format("{0:0}%", ((float)Completed / Submitted) * 100) : "";
            ToolTip = IsWorkInProgress ? string.Format("{0} jobs completed\r\n{1} jobs in queue\r\n{2} jobs running", Completed, Submitted - Completed, Running) : null;
        }

        public string ToolTip { get; set; }

        public string Name { get; private set; }
        public bool IsWorkInProgress { get; private set; }
        public int Submitted { get; private set; }
        public int Completed { get; private set; }
        public int Running { get; private set; }
        public string Status { get; private set; }
        public bool IsCompleted { get; set; }
        public bool IsCanceled { get; set; }
        public bool IsFaulted { get; set; }

        readonly ActionBlock<ImportJobDescriptor> _importer;
        readonly BufferBlock<ImportJobDescriptor> _buffer;
    }
}
