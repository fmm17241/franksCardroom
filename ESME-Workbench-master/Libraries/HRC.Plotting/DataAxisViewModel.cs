using System;
using System.Windows;
using HRC.Aspects;
using HRC.Plotting.AxisLabeling.Layout;
using HRC.Utility;
using HRC.ViewModels;

namespace HRC.Plotting
{
    public class DataAxisViewModel : ViewModelBase
    {
        //[UsedImplicitly] PropertyObserver<DataAxisViewModel> _propertyObserver;
        public DataAxisViewModel()
        {
            DataRange = new RangeCollection();
            Label = "Axis";
            AxisTicks = new ObservableList<DataAxisTick>();
            AxisMarkers = new ObservableList<DataAxisTick>();
            VisibleRange = new Range(1, 2);
        }

        public string Label { get; set; }
        [Initialize(AxisLayoutAlgorithm.ExtendedWilkinson)] public AxisLayoutAlgorithm AxisLayoutAlgorithm { get; set; }
        public ObservableList<DataAxisTick> AxisTicks { get; set; }
        public ObservableList<DataAxisTick> AxisMarkers { get; set; }
        [Initialize(AxisType.Linear)]
        public AxisType AxisType { get; set; }
        public RangeCollection DataRange { get; set; }
        public bool IsInverted { get; set; }
        /// <summary>
        /// Length of a major tick, in pixels at screen resolution
        /// </summary>
        [Initialize(6.0)] public double MajorTickLength { get; set; }
        /// <summary>
        /// Desired number of major ticks per inch.  This is only used as a guideline for the axis 
        /// layout algorithm and the actual result may differ from this value
        /// </summary>
        [Initialize(1.0)] public double MajorTicksPerInch { get; set; }
        /// <summary>
        /// Length of a minor tick, in pixels at screen resolution
        /// </summary>
        [Initialize(3.0)] public double MinorTickLength { get; set; }
        /// <summary>
        /// Desired number of minor ticks per inch.  This is only used as a guideline for the axis 
        /// layout algorithm and the actual result may differ from this value.
        /// This value is only used when AxisType == AxisType.Linear.
        /// When AxisType == AxisType.Logarithmic, minor ticks will always be created at the usual
        /// places (2, 3, 4, 5, 6, 7, 8, and 9), and also at any power of 10 that does not already have
        /// a major tick
        /// </summary>
        [Initialize(4.0)] public double MinorTicksPerInch { get; set; }
        public Func<double, double> PositionToValue { get; set; }
        public Func<double, double> ValueToPosition { get; set; }
        public Range VisibleRange { get; set; }
        public double ActualWidth { get; set; }
        public double ActualHeight { get; set; }

        public Visibility Visibility { get; set; }

        [Initialize(true)] public bool Autorange { get; set; }
        public double MouseDataLocation { get; set; }
    }
}