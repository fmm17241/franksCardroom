﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reactive.Concurrency;
using System.Reactive.Linq;
using System.Reactive.Subjects;
using System.Text;
using System.Threading;
using System.Threading.Tasks.Dataflow;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Threading;
using ESME.Scenarios;
using ESME.TransmissionLoss.Bellhop;
using ESME.Views.Controls;
using HRC;
using HRC.Aspects;
using HRC.Plotting;
using HRC.Utility;
using HRC.ViewModels;
using HRC.WPF;

namespace ESME.Views.TransmissionLossViewer
{
    public class RadialViewModel : ViewModelBase, IDisposable
    {
        public RadialViewModel()
        {
            FullRange = new Range(0, 200);
            StatisticalRange = new Range(75, 125);
            AnimationTargetRange = new Range();
            AnimationTime = TimeSpan.FromSeconds(0);

            AxisSeriesViewModel.DataSeriesCollection.Add(_imageSeriesViewModel);
            AxisSeriesViewModel.DataSeriesCollection.Add(_bottomProfileViewModel);
            AxisSeriesViewModel.XAxis.Label = "Range (m)";
            AxisSeriesViewModel.XAxisTicks = null;
            AxisSeriesViewModel.YAxis.IsInverted = true;
            AxisSeriesViewModel.YAxis.Label = "Depth (m)";
            AxisSeriesViewModel.YAxisTicks = null;
            _fourAxisSeriesObserver = new PropertyObserver<FourAxisSeriesViewModel>(AxisSeriesViewModel)
                .RegisterHandler(a => a.IsMouseOver, UpdateStatusProperties);
            _xAxisPropertyObserver = new PropertyObserver<DataAxisViewModel>(AxisSeriesViewModel.XAxis)
                .RegisterHandler(x => x.MouseDataLocation, UpdateStatusProperties);
            _yAxisPropertyObserver = new PropertyObserver<DataAxisViewModel>(AxisSeriesViewModel.YAxis)
                .RegisterHandler(y => y.MouseDataLocation, UpdateStatusProperties);
            _instanceObservers.Add(Observable.FromEventPattern<PropertyChangedEventArgs>(AxisSeriesViewModel.YAxis, "PropertyChanged")
                                       .ObserveOn(TaskPoolScheduler.Default)
                                       .Where(e => e.EventArgs.PropertyName == "VisibleRange")
                                       .Select(e => AxisSeriesViewModel.YAxis.VisibleRange)
                                       .Throttle(TimeSpan.FromMilliseconds(100))
                                       .Subscribe(visibleRange =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Entering VisibleRangeChanged", DateTime.Now));
                                           //Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Visible range on Y axis changed to {1}", DateTime.Now, visibleRange == null ? "(null)" : visibleRange.ToString()));
                                           if (visibleRange == null)
                                           {
                                               Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving (1) VisibleRangeChanged", DateTime.Now));
                                               return;
                                           }
                                           CalculateBottomProfileGeometry();
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving VisibleRangeChanged", DateTime.Now));
                                       }, e =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: VisibleRangeChanged exception: {1}", DateTime.Now, e.Message));
                                           Debugger.Break();
                                       }));
            _instanceObservers.Add(Observable.FromEventPattern<PropertyChangedEventArgs>(this, "PropertyChanged")
                                       .ObserveOn(TaskPoolScheduler.Default)
                                       .Where(e => e.EventArgs.PropertyName == "AxisRange")
                                       .Select(e => AxisRange)
                                       .DistinctUntilChanged()
                                       .Subscribe(axisRange =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Entering AxisRangeChanged", DateTime.Now));
                                           if (_axisRangeObserver != null)
                                           {
                                               _instanceObservers.Remove(_axisRangeObserver);
                                               _axisRangeObserver.Dispose();
                                           }
                                           if (axisRange == null)
                                           {
                                               Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving (1) AxisRangeChanged", DateTime.Now));
                                               return;
                                           }
                                           _axisRangeObserver = axisRange.ObserveOn(TaskPoolScheduler.Default).Subscribe(r =>
                                           {
                                               if (FullRange == null) FullRange = new Range(axisRange);
                                               else FullRange.Update(axisRange);
                                           });
                                           _instanceObservers.Add(_axisRangeObserver);
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving AxisRangeChanged", DateTime.Now));
                                       }, e =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: AxisRangeChanged exception: {1}", DateTime.Now, e.Message));
                                           Debugger.Break();
                                       }));
            _instanceObservers.Add(Observable.FromEventPattern<PropertyChangedEventArgs>(AxisSeriesViewModel, "PropertyChanged")
                                       .ObserveOn(TaskPoolScheduler.Default)
                                       .Where(e => (e.EventArgs.PropertyName == "ActualWidth" || e.EventArgs.PropertyName == "ActualHeight"))
                                       .Select(e => new { AxisSeriesViewModel.ActualWidth, AxisSeriesViewModel.ActualHeight })
                                       .Sample(TimeSpan.FromMilliseconds(100))
                                       .DistinctUntilChanged()
                                       .Subscribe(e =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Entering ActualHeightWidthChanged", DateTime.Now));
                                           Render();
                                           //CalculateBottomProfileGeometry();
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving ActualHeightWidthChanged", DateTime.Now));
                                       }, e =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: ActualHeightWidthChanged exception: {1}", DateTime.Now, e.Message));
                                           Debugger.Break();
                                       }));
            _instanceObservers.Add(Observable.FromEventPattern<PropertyChangedEventArgs>(this, "PropertyChanged")
                                       .ObserveOn(TaskPoolScheduler.Default)
                                       .Where(e => e.EventArgs.PropertyName == "Radial")
                                       .Subscribe(e =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Entering RadialChanged", DateTime.Now));
                                           _radialObservers.ForEach(o => o.Dispose());
                                           _radialObservers.Clear();
                                           WriteableBitmapVisibility = Visibility.Collapsed;
                                           if (Radial == null || !Radial.IsCalculated)
                                           {
                                               WriteableBitmapVisibility = Visibility.Collapsed;
                                               if (Radial == null) WaitToRenderText = "Please wait...";
                                               else
                                               {
                                                   if (!string.IsNullOrEmpty(Radial.Errors))
                                                   {
                                                       var sb = new StringBuilder();
                                                       sb.AppendLine("This radial was not calculated due to the following error(s):");
                                                       sb.AppendLine(Radial.Errors);
                                                       WaitToRenderText = sb.ToString();
                                                   }
                                                   else WaitToRenderText = "This radial has not yet been calculated";
                                               }
                                               Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving (1) RadialChanged", DateTime.Now));
                                               return;
                                           }
                                           try
                                           {
                                               _shadeFile = ShadeFile.Read(Radial.BasePath + ".shd", (float)Radial.Bearing);
                                               _shadeFile.BottomDepths = Radial.BottomDepths;
                                               _imageSeriesViewModel.Top = Radial.Depths.First();
                                               _imageSeriesViewModel.Left = Radial.Ranges.First();
                                               _imageSeriesViewModel.Bottom = Radial.Depths.Last();
                                               _imageSeriesViewModel.Right = Radial.Ranges.Last();
                                               StatisticalRange.Update(_shadeFile.StatMin, _shadeFile.StatMax);
                                               ColorMapViewModel.Range.Update(StatisticalRange);
                                               AxisSeriesViewModel.XAxis.DataRange.Update(_imageSeriesViewModel.Left, _imageSeriesViewModel.Right);
                                               AxisSeriesViewModel.YAxis.DataRange.Update(_imageSeriesViewModel.Top, _imageSeriesViewModel.Bottom);
                                               _radialObservers.Add(ColorMapViewModel.Range.ObserveOn(TaskPoolScheduler.Default).Sample(TimeSpan.FromMilliseconds(50)).Subscribe(r => Render()));
                                               Render();
                                               CalculateBottomProfileGeometry();
                                           }
                                           catch (Exception ex)
                                           {
                                               WriteableBitmapVisibility = Visibility.Collapsed;
                                               WaitToRenderText = ex.Message;
                                               _shadeFile = null;
                                           }
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving RadialChanged", DateTime.Now));
                                       }, e =>
                                       {
                                           Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: RadialChanged exception: {1}", DateTime.Now, e.Message));
                                           Debugger.Break();
                                       }));
            _instanceObservers.Add(
                ColorMapViewModel.Range.ObserveOn(TaskPoolScheduler.Default).Subscribe(
                    r =>
                    {
                        Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Entering ColorMapViewModel.RangeChanged", DateTime.Now));
                        _dispatcher.InvokeInBackgroundIfRequired(() =>
                        {
                            AxisMarkers.Clear();
                            if (ColorMapViewModel.Range != FullRange)
                            {
                                AxisMarkers.Add(new DataAxisTick(ColorMapViewModel.Range.Min, string.Format("{0:0}", ColorMapViewModel.Range.Min), true, Brushes.White, Brushes.Black, Brushes.Black));
                                AxisMarkers.Add(new DataAxisTick(ColorMapViewModel.Range.Max, string.Format("{0:0}", ColorMapViewModel.Range.Max), true, Brushes.White, Brushes.Black, Brushes.Black));
                            }
                            Debug.WriteLine("{0:HH:mm:ss.fff} ColorMapViewModel.Range changed to {1}",
                                            DateTime.Now,
                                            r);
                        });
                        Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving ColorMapViewModel.RangeChanged", DateTime.Now));
                    }, e =>
                    {
                        Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: ColorMapViewModel.RangeChanged exception: {1}", DateTime.Now, e.Message));
                        Debugger.Break();
                    }));
            _displayQueue
                .ObserveOn(TaskPoolScheduler.Default)
                .Subscribe(result =>
                {
                    Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Entering DisplayQueue", DateTime.Now));
                    _dispatcher.InvokeInBackgroundIfRequired(() =>
                    {
                        var pixelBuffer = result.Item1;
                        var renderRect = result.Item2;
                        var sequenceNumber = result.Item3;
                        //Debug.WriteLine(string.Format("Got completed event for sequence number {0} completed", sequenceNumber));
                        if (sequenceNumber < _displayedSequenceNumber)
                        {
                            Debug.WriteLine("Discarding image buffer: Old image sequence");
                            Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving (1) DisplayQueue", DateTime.Now));
                            return;
                        }
                        if (WriteableBitmap == null || Math.Abs(renderRect.Width - WriteableBitmap.Width) > double.Epsilon || Math.Abs(renderRect.Height - WriteableBitmap.Height) > double.Epsilon) WriteableBitmap = new WriteableBitmap(renderRect.Width, renderRect.Height, 96, 96, PixelFormats.Bgr32, null);
                        _displayedSequenceNumber = sequenceNumber;
                        WriteableBitmap.Lock();
                        WriteableBitmap.WritePixels(renderRect, pixelBuffer, WriteableBitmap.BackBufferStride, 0, 0);
                        WriteableBitmap.AddDirtyRect(renderRect);
                        OnPropertyChanged("WriteableBitmap");
                        WriteableBitmap.Unlock();
                        WriteableBitmapVisibility = Visibility.Visible;
                        _imageSeriesViewModel.ImageSource = WriteableBitmap;
                    });
                    Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: Leaving DisplayQueue", DateTime.Now));
                }, e =>
                {
                    Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} RadialViewModel: DisplayQueue exception: {1}", DateTime.Now, e.Message));
                    Debugger.Break();
                });
        }

        readonly List<IDisposable> _instanceObservers = new List<IDisposable>();
        readonly List<IDisposable> _radialObservers = new List<IDisposable>();
        IDisposable _axisRangeObserver;
        readonly Dispatcher _dispatcher = Dispatcher.CurrentDispatcher;
        public RadialView RadialView { get; set; }
        void Render()
        {
            if (_shadeFile == null || (int)AxisSeriesViewModel.ActualWidth == 0 || (int)AxisSeriesViewModel.ActualHeight == 0)
            {
                Debug.WriteLine(string.Format("Skipping render:{0}{1}",
                    _shadeFile == null ? " No radial" : "",
                    (int)AxisSeriesViewModel.ActualWidth == 0 || (int)AxisSeriesViewModel.ActualHeight == 0 ? " Invalid render size" : ""));
                return;
            }
            var width = (int)Math.Min(_shadeFile.ReceiverRanges.Length, AxisSeriesViewModel.ActualWidth);
            var height = (int)Math.Min(_shadeFile.ReceiverDepths.Length, AxisSeriesViewModel.ActualHeight);
            var renderRect = new Int32Rect(0, 0, width, height);
            Debug.WriteLine(string.Format("{0:HH:mm:ss.fff} Rendering radial {1:0.0}deg at width {2} and height {3}", DateTime.Now, Radial.Bearing, width, height));
            if (Radial != null && _shadeFile != null) _renderQueue.Post(Tuple.Create(_shadeFile, ColorMapViewModel, renderRect, new Range(ColorMapViewModel.Range), _sourceSequenceNumber, _displayQueue));
            else WaitToRenderText = "This radial has not yet been calculated";
            Interlocked.Increment(ref _sourceSequenceNumber);
        }

        readonly Subject<Tuple<int[], Int32Rect, long>> _displayQueue = new Subject<Tuple<int[], Int32Rect, long>>();
        long _sourceSequenceNumber, _displayedSequenceNumber;
        readonly ActionBlock<Tuple<ShadeFile, ColorMapViewModel, Int32Rect, Range, long, Subject<Tuple<int[], Int32Rect, long>>>> _renderQueue = new ActionBlock<Tuple<ShadeFile, ColorMapViewModel, Int32Rect, Range, long, Subject<Tuple<int[], Int32Rect, long>>>>(job =>
        {
            var tlRadial = job.Item1;
            var colorMap = job.Item2;
            var renderRect = job.Item3;
            var range = job.Item4;
            var sequenceNumber = job.Item5;
            var displayQueue = job.Item6;
            //Debug.WriteLine(string.Format("Begin rendering sequence number {0}", sequenceNumber));
            var buffer = tlRadial.RenderToPixelBuffer(v => float.IsInfinity(v) || float.IsNaN(v) ? colorMap.Colors[0] : colorMap.Lookup(v, range), renderRect.Width, renderRect.Height);
            //var buffer = tlRadial.RenderToPixelBuffer(v => float.IsInfinity(v) ? Colors.Gray : colorMap.Lookup(v, range), renderRect.Width, renderRect.Height);
            //Debug.WriteLine(string.Format("Done rendering sequence number {0}", sequenceNumber));
            displayQueue.OnNext(Tuple.Create(buffer, renderRect, sequenceNumber));
        },
        new ExecutionDataflowBlockOptions
        {
            BoundedCapacity = -1,
            MaxDegreeOfParallelism = System.Environment.ProcessorCount
        });

        [UsedImplicitly] PropertyObserver<DataAxisViewModel> _xAxisPropertyObserver;
        [UsedImplicitly] PropertyObserver<DataAxisViewModel> _yAxisPropertyObserver;
        [UsedImplicitly] PropertyObserver<FourAxisSeriesViewModel> _fourAxisSeriesObserver;

        readonly ImageSeriesViewModel _imageSeriesViewModel = new ImageSeriesViewModel();
        readonly LineSeriesViewModel _bottomProfileViewModel = new LineSeriesViewModel();
        ShadeFile _shadeFile;

        [Initialize("Please wait...")]public string WaitToRenderText { get; set; }
        [Initialize] public FourAxisSeriesViewModel AxisSeriesViewModel { get; set; }
        [Initialize] public ColorMapViewModel ColorMapViewModel { get; set; }
        [Initialize] public ObservableList<DataAxisTick> AxisMarkers { get; set; }

        public WriteableBitmap WriteableBitmap { get; set; }
        public Visibility WriteableBitmapVisibility { get; set; }
        public Radial Radial { get; set; }
        public TimeSpan AnimationTime { get; set; }
        public Range FullRange { get; set; }
        public Range StatisticalRange { get; set; }
        public Range AnimationTargetRange { get; set; }
        public Range AxisRange { get; set; }
        void CalculateBottomProfileGeometry()
        {
            var profileData = Radial.BottomProfile.Select(bpp => new Point(bpp.Range * 1000, Math.Max(0.0, bpp.Depth))).ToList();
            var yRange = AxisSeriesViewModel.YAxis.VisibleRange == null || AxisSeriesViewModel.YAxis.VisibleRange.IsEmpty ? AxisSeriesViewModel.YAxis.DataRange : (IRange)AxisSeriesViewModel.YAxis.VisibleRange;
            profileData.Insert(0, new Point(profileData[0].X, yRange.Max));
            profileData.Add(new Point(profileData.Last().X, yRange.Max));
            profileData.Add(new Point(profileData.First().X, profileData.First().Y));
            _bottomProfileViewModel.SeriesData = profileData;
            _bottomProfileViewModel.ItemToPoint = p => (Point)p;
            _bottomProfileViewModel.LineStrokeThickness = 5.0;
            _bottomProfileViewModel.LineFill = Brushes.LightGray;
        }

        public Mode SelectedMode { get; set; }
        public string MouseRange { get; set; }
        public string MouseDepth { get; set; }
        public string MouseTransmissionLossInfo { get; set; }
        public string MouseSPLInfo { get; set; }

        void UpdateStatusProperties()
        {
            if (_mouseTransmissionLossMarker != null) AxisMarkers.Remove(_mouseTransmissionLossMarker);
            if (AxisSeriesViewModel.IsMouseOver && _shadeFile != null)
            {
                MouseRange = string.Format("Range: {0:0.0}m", AxisSeriesViewModel.XAxis.MouseDataLocation);
                MouseDepth = string.Format("Depth: {0:0.0}m", AxisSeriesViewModel.YAxis.MouseDataLocation);
                var px = AxisSeriesViewModel.MouseLocation.X / AxisSeriesViewModel.ActualWidth;
                var py = AxisSeriesViewModel.MouseLocation.Y / AxisSeriesViewModel.ActualHeight;
                var rangeIndex = Math.Max(0, Math.Min((int)(_shadeFile.ReceiverRanges.Length * px), _shadeFile.ReceiverRanges.Length - 1));
                var depthIndex = Math.Max(0, Math.Min((int)(_shadeFile.ReceiverDepths.Length * py), _shadeFile.ReceiverDepths.Length - 1)); MouseTransmissionLossInfo = string.Format("Transmission Loss: {0:0.0}dB", _shadeFile.TransmissionLoss[depthIndex, rangeIndex]);
                if (float.IsInfinity(_shadeFile.TransmissionLoss[depthIndex, rangeIndex]) || float.IsNaN(_shadeFile.TransmissionLoss[depthIndex, rangeIndex]) || double.IsNaN(AxisSeriesViewModel.YAxis.MouseDataLocation) || (Radial.BottomDepths!= null && (AxisSeriesViewModel.YAxis.MouseDataLocation > Radial.BottomDepths[rangeIndex])))
                {
                    MouseTransmissionLossInfo = "Transmission Loss: N/A";
                    MouseSPLInfo = "Sound Pressure: N/A";
                }
                else
                {
                    if (FullRange.Contains(_shadeFile.TransmissionLoss[depthIndex, rangeIndex]))
                    {
                        _mouseTransmissionLossMarker = new DataAxisTick(_shadeFile.TransmissionLoss[depthIndex, rangeIndex],
                                                                        string.Format("{0:0}", _shadeFile.TransmissionLoss[depthIndex, rangeIndex]),
                                                                        true,
                                                                        Brushes.Black,
                                                                        Brushes.LightGray,
                                                                        Brushes.White);
                        AxisMarkers.Add(_mouseTransmissionLossMarker);
                    }
                    MouseTransmissionLossInfo = string.Format("Transmission Loss: {0:0.0}dB", _shadeFile.TransmissionLoss[depthIndex, rangeIndex]);
                    MouseSPLInfo = string.Format("Sound Pressure: {0:0.0}dB", SelectedMode.SourceLevel - _shadeFile.TransmissionLoss[depthIndex, rangeIndex]);
                }
            }
            else
            {
                MouseDepth = "Depth: N/A";
                MouseRange = "Range: N/A";
                MouseTransmissionLossInfo = "Transmission Loss: N/A";
                MouseSPLInfo = "Sound Pressure: N/A";
                if (_mouseTransmissionLossMarker != null) AxisMarkers.Remove(_mouseTransmissionLossMarker);
                _mouseTransmissionLossMarker = null;
            }
        }

        DataAxisTick _mouseTransmissionLossMarker;
        #region File and clipboard-oriented stuff
        #region public string OutputFileName { get; }
        public string OutputFileName
        {
            get
            {
                lock (this)
                    return Radial == null
                               ? null
                               : Path.Combine(Properties.Settings.Default.ExperimentReportDirectory,
                                              string.Format("{0} {1} {2} bearing {3} degrees",
                                                            SelectedMode.ModeName,
                                                            SelectedMode.Source.SourceName,
                                                            SelectedMode.Source.Platform.PlatformName,
                                                            Radial.Bearing));
            }
        }
        #endregion

        public string ToCSV()
        {
            var sb = new StringBuilder();
            sb.AppendLine("Vertical Transmission Loss (dB)");
            sb.Append(",Range (m),");

            foreach (var t in _shadeFile.ReceiverRanges) sb.Append(string.Format(CultureInfo.InvariantCulture,"{0},",t)); //write out the X axis values.
            sb.AppendLine(); // Terminate the line
            sb.AppendLine("Depth (m)");
            // Write the slice data
            for (var i = 0; i < _shadeFile.ReceiverDepths.Length; i++)
            {
                // Write out the Y axis value
                sb.Append(string.Format(CultureInfo.InvariantCulture,"{0},,",_shadeFile.ReceiverDepths[i]));
                for (var j = 0; j < _shadeFile.ReceiverRanges.Length; j++)
                {
                    var tl = _shadeFile.TransmissionLoss[i, j];
                    sb.Append(float.IsInfinity(tl) ? "," : string.Format(CultureInfo.InvariantCulture,"{0},",tl));
                }
                sb.AppendLine();
            }
            return sb.ToString();
        }

        public void SaveAsCSV(string fileName)
        {
            using (var sw = new StreamWriter(fileName))
            {
                sw.Write(ToCSV());
            }
        }

        public BitmapSource ToBitmapSource() { return RadialView.ToBitmapSource(); }
        public void SaveAsImage(string fileName) { RadialView.ToImageFile(fileName); }
        public void CopyTextToClipboard() { Clipboard.SetText(ToCSV()); }
        public void CopyImageToClipboard() { Clipboard.SetImage(RadialView.ToBitmapSource()); }
        #endregion

        public static RadialViewModel DesignTimeData { get; private set; }
        static RadialViewModel()
        {
            var axisRanges = new RangeCollection();
            axisRanges.Add(new Range(0.1, 10));
            DesignTimeData = new RadialViewModel
            {
                AxisSeriesViewModel = new FourAxisSeriesViewModel
                {
                    BottomAxis =
                        {
                            Visibility = Visibility.Visible,
                            Label = "Range (m)",
                        },
                    LeftAxis =
                        {
                            Visibility = Visibility.Visible,
                            Label = "Depth (m)",
                            IsInverted = true,
                        },
                    TopAxis = { Visibility = Visibility.Collapsed },
                    RightAxis = { Visibility = Visibility.Collapsed },
                    XAxisTicks = null,
                    YAxisTicks = null,
                },
                ColorMapViewModel = ColorMapViewModel.DesignTimeData,
                FullRange = new Range(0, 200),
                StatisticalRange = new Range(75, 125),
                AnimationTargetRange = new Range(50, 100),
                AnimationTime = TimeSpan.FromMilliseconds(200),
            };
            DesignTimeData.AxisSeriesViewModel.BottomAxis.DataRange = axisRanges;
            DesignTimeData.AxisSeriesViewModel.LeftAxis.DataRange = axisRanges;
        }

        #region ReverseColorbarCommand
        public SimpleCommand<object, object> ReverseColorbarCommand
        {
            get
            {
                return _reverseColorbar ?? (_reverseColorbar = new SimpleCommand<object, object>(_ =>
                {
                    ColorMapViewModel.Reverse();
                    Render();
                }));
            }
        }

        SimpleCommand<object, object> _reverseColorbar;
        #endregion

        #region ColorBarDoubleClickCommand
        public SimpleCommand<object, EventToCommandArgs> ColorBarDoubleClickCommand { get { return _colorBarDoubleClick ?? (_colorBarDoubleClick = new SimpleCommand<object, EventToCommandArgs>(ColorBarDoubleClickHandler)); } }
        SimpleCommand<object, EventToCommandArgs> _colorBarDoubleClick;

        void ColorBarDoubleClickHandler(EventToCommandArgs args)
        {
            AnimationTime = TimeSpan.FromMilliseconds(200);
            AnimationTargetRange.ForceUpdate(ColorMapViewModel.Range == FullRange ? StatisticalRange : FullRange);
        }
        #endregion
        #region IDisposable implementation
        // Implement IDisposable.
        // Do not make this method virtual.
        // A derived class should not be able to override this method.
        public void Dispose()
        {
            Dispose(true);
            // This object will be cleaned up by the Dispose method.
            // Therefore, you should call GC.SupressFinalize to
            // take this object off the finalization queue
            // and prevent finalization code for this object
            // from executing a second time.
            GC.SuppressFinalize(this);
        }
        bool _disposed;
        
        // Dispose(bool disposing) executes in two distinct scenarios.
        // If disposing equals true, the method has been called directly
        // or indirectly by a user's code. Managed and unmanaged resources
        // can be disposed.
        // If disposing equals false, the method has been called by the
        // runtime from inside the finalizer and you should not reference
        // other objects. Only unmanaged resources can be disposed.
        protected virtual void Dispose(bool disposing)
        {
            // Check to see if Dispose has already been called.
            if (_disposed) return;
            // If disposing equals true, dispose all managed
            // and unmanaged resources.
            if (disposing)
            {
                // Dispose managed resources.
                if (_renderQueue != null) _renderQueue.Complete();
                if (_displayQueue != null) _displayQueue.Dispose();
                if (_instanceObservers != null) _instanceObservers.ForEach(o => o.Dispose());
                if (_radialObservers != null) _radialObservers.ForEach(o => o.Dispose());
            }

            // Call the appropriate methods to clean up
            // unmanaged resources here.
            // If disposing is false,
            // only the following code is executed.

            // Note disposing has been done.
            _disposed = true;
        }
        // Use C# destructor syntax for finalization code.
        // This destructor will run only if the Dispose method
        // does not get called.
        // It gives your base class the opportunity to finalize.
        // Do not provide destructors in types derived from this class.
        ~RadialViewModel()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }
        #endregion
    }
}