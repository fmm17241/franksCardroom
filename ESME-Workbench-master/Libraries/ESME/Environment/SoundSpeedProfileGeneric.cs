﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using HRC.Navigation;

namespace ESME.Environment
{
    public class SoundSpeedProfileAverager : SoundSpeedProfileGeneric<AverageSoundSpeedSample>
    {
        public SoundSpeedProfileAverager() {}

        public SoundSpeedProfileAverager(Geo<List<SoundSpeedSample>> profile) : base(profile)
        {
            if (profile.Data.Count == 0)
                foreach (var datum in profile.Data) Add(new AverageSoundSpeedSample(datum));
            else
                foreach (var datum in profile.Data)
                {
                    var averagerAtDepth = this[datum.Depth];
                    if (averagerAtDepth != null) averagerAtDepth.Add(datum);
                    else Add(new AverageSoundSpeedSample(datum));
                }
        }

        public void Add(Geo<List<SoundSpeedSample>> profile)
        {
            if (profile.Data.Count == 0)
                foreach (var datum in profile.Data) Add(new AverageSoundSpeedSample(datum));
            else
                foreach (var datum in profile.Data)
                {
                    var averagerAtDepth = this[datum.Depth];
                    if (averagerAtDepth != null) averagerAtDepth.Add(datum);
                    else Add(new AverageSoundSpeedSample(datum));
                }
        }

        public SoundSpeedProfile Average 
        {
            get
            {
                var result = new SoundSpeedProfile(this);
                foreach (var datum in Data) result.Add(new SoundSpeedSample(datum.Depth, datum.SoundSpeed));
                return result;
            }
        }
    }

    public class AverageDatum
    {
        public AverageDatum()
        {
            Value = 0;
            Count = 0;
        }

        public AverageDatum(float value)
        {
            Value = value;
            Count = 1;
        }

        public float Value { get; set; }
        public int Count { get; private set; }

        public void Add(float newValue)
        {
            Value += newValue;
            Count++;
        }

        public float Average { get { return Value / Count; } }
    }

    public class SoundSpeedProfile : SoundSpeedProfileGeneric<SoundSpeedSample>, IComparer<SoundSpeedProfile>, IComparable<SoundSpeedProfile>
    {
        public SoundSpeedProfile() { }
        public SoundSpeedProfile(Geo location) : base(location) { }
        public SoundSpeedProfile(Geo<List<SoundSpeedSample>> sourceProfile) : base(sourceProfile) { AddRange(sourceProfile.Data); }

        /// <summary>
        /// Extrapolates the current sound speed profile to the given depth, in one step, using the provided temperature and salinity profile
        /// </summary>
        /// <param name="newMaxDepth"></param>
        public SoundSpeedProfile Extend(float newMaxDepth)
        {
            //if (newMaxDepth < MaxDepth) throw new ApplicationException(string.Format("SoundSpeedProfile.Extend: Given depth {0} is less than current maximum depth {1}", newMaxDepth, MaxDepth));
            if (newMaxDepth < MaxDepth) return new SoundSpeedProfile(this);
            var result = new SoundSpeedProfile(this);
            //System.Diagnostics.Debug.WriteLine("Extrapolating SSP {0} from data depth of {1}m to bathymetry depth of {2}m", this, MaxDepth, newMaxDepth);
            //System.Diagnostics.Debug.WriteLine("  Initial depth vector length: {0}", Depths.Length);
            result.Add(SoundSpeedSample.Extend(Data[Data.Count - 2], Data[Data.Count - 1], newMaxDepth));
            return result;
        }

        /// <summary>
        /// Extends the current sound speed profile to the same depth as a given template, adjusting the copied template values to ensure a
        /// smooth curve in the profile
        /// </summary>
        /// <param name="templateSSP"></param>
        public SoundSpeedProfile Extend(SoundSpeedProfile templateSSP)
        {
            //System.Diagnostics.Debug.WriteLine("Extending SSP {0} to new depth {1}", this, templateSSP.MaxDepth);

            if (templateSSP.MaxDepth <= MaxDepth) throw new InvalidOperationException("Cannot extend a sound speed profile using a template profile that is shorter than the current profile");
            var result = new SoundSpeedProfile((Geo)this);
            if (Data.Count == 0)
            {
                //System.Diagnostics.Debug.WriteLine("  Original SSP is zero length, copying templateSSP.");
                result.AddRange(templateSSP.Data);
            }
            else
            {
                //System.Diagnostics.Debug.WriteLine("  Original SSP depth vector length: {0} ({1}m)", Depths.Length, MaxDepth);
                //if (Data.Count > templateSSP.Data.Count) System.Diagnostics.Debugger.Break();
                var myProfileLength = Data.Count;
                var templateProfileLength = templateSSP.Data.Count;
                var shallowSpeed = Data.Last().SoundSpeed;
                var deepSpeedAtSameDepth = templateSSP.Data[myProfileLength - 1].SoundSpeed;
                //System.Diagnostics.Debug.WriteLine("  Original soundspeed at {0}m: {1}", MaxDepth, shallowSpeed);
                //System.Diagnostics.Debug.WriteLine("  Template soundspeed at {0}m: {1}", MaxDepth, deepSpeedAtSameDepth);

                var ssDiff = deepSpeedAtSameDepth - shallowSpeed;
                //System.Diagnostics.Debug.WriteLine("  Delta    soundspeed at {0}m: {1}", MaxDepth, ssDiff);
                result.AddRange(Data);
                for (var speedIndex = myProfileLength; speedIndex < templateProfileLength; speedIndex++)
                {
                    var newSpeed = templateSSP.Data[speedIndex].SoundSpeed - ssDiff;
                    //System.Diagnostics.Debug.WriteLine("    Template soundspeed at {0}m: Original: {1} Adjusted: {2}", templateSSP.Depths[speedIndex], templateSSP.SoundSpeeds[speedIndex], newSpeed);
                    result.Add(new SoundSpeedSample { Depth = templateSSP.Data[speedIndex].Depth, SoundSpeed = newSpeed });
                }
            }
            //System.Diagnostics.Debug.WriteLine("  New SSP depth vector length: {0}", Depths.Length);
            return result;
        }

        public static new SoundSpeedProfile Deserialize(BinaryReader reader)
        {
            var result = new SoundSpeedProfile(Geo.Deserialize(reader));
            var itemCount = reader.ReadInt32();
            //for (var i = 0; i < itemCount; i++) result.Add((T)genericDeserializer.Invoke(null, new object[] { reader }));
            for (var i = 0; i < itemCount; i++) result.Add(SoundSpeedSample.Deserialize(reader));
            return result;
        }

        public int Compare(SoundSpeedProfile x, SoundSpeedProfile y)
        {
            return x.CompareTo(y);
        }

        public int CompareTo(SoundSpeedProfile other)
        {
            var compare = Latitude.CompareTo(other.Latitude);
            return compare != 0 ? compare : Longitude.CompareTo(other.Longitude);
        }
    }

    [Serializable]
    public class SoundSpeedProfileGeneric<T> : Geo<List<T>> where T: SoundSpeedSample, new()
    {
        public SoundSpeedProfileGeneric() {}
        public SoundSpeedProfileGeneric(Geo location) : base(location) { Data = new List<T>(); }

        #region public List<string> Messages { get; set; }

        public List<string> Messages
        {
            get { return _messages; }
            set
            {
                if (_messages == value) return;
                _messages = value;
            }
        }

        [NonSerialized]
        List<string> _messages = new List<string>();

        #endregion

        public T this[float depth] { get { return Data.Single(sample => (sample.Depth - depth) < 0.0001); } }

        public void Add(T soundSpeedSample)
        {
            soundSpeedSample.Calculate(this);
            Data.Add(soundSpeedSample);
            //Data.Sort();
        }

        public void AddRange(IEnumerable<T> sampleRange)
        {
            foreach (var sample in sampleRange) Add(sample);
            //Data.Sort();
        }

        public float MaxDepth { get { return Data.Max(sample => sample.Depth); } }

        public new void Serialize(BinaryWriter writer)
        {
            Data.Sort();
            base.Serialize(writer);
            writer.Write(Data.Count);
            foreach (var item in Data)
                item.Serialize(writer);
        }

    }

    [Serializable]
    public class DepthValuePairs<T> : List<DepthValuePair<T>>
    {
        public DepthValuePair<T> this[float depth] { get { return Find(d => Math.Abs(d.Depth - depth) < 0.0001); } }
        new public DepthValuePair<T> this[int depthIndex] { get { return base[depthIndex]; } }
        public IEnumerable<float> Depths { get { return this.Select(pair => pair.Depth); } }
        public IEnumerable<T> Values { get { return this.Select(pair => pair.Value); } }
        public double MaxDepth { get { return Depths.Last(); } }

        new public void Add(DepthValuePair<T> item)
        {
            base.Add(item);
            Sort();
        }

        new public void AddRange(IEnumerable<DepthValuePair<T>> collection)
        {
            base.AddRange(collection);
            Sort();
        }
    }

    [Serializable]
    public class DepthValuePair<T> : IComparable<DepthValuePair<T>>, IComparer<DepthValuePair<T>>
    {
        public DepthValuePair() { }

        public DepthValuePair(float depth, T value)
        {
            Depth = depth;
            Value = value;
        }

        public float Depth { get; set; }
        public T Value { get; set; }

        public int CompareTo(DepthValuePair<T> other)
        {
            return Depth.CompareTo(other.Depth);
        }

        public int Compare(DepthValuePair<T> x, DepthValuePair<T> y)
        {
            return x.CompareTo(y);
        }

        public static DepthValuePair<T> Deserialize(BinaryReader reader, Func<BinaryReader, T> readFunc)
        {
            return new DepthValuePair<T>(reader.ReadSingle(), readFunc(reader));
        }
    }
}