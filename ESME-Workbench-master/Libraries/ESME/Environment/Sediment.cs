﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using ESME.Model;
using HRC;
using HRC.Navigation;

namespace ESME.Environment
{
    public class Sediment : EnvironmentDataSetBase
    {
        public EnvironmentData<SedimentSample> Samples { get; set; }

        public Sediment()
        {
            Samples = new EnvironmentData<SedimentSample>();
        }

        public static Task<Sediment> LoadAsync(string filename)
        {
            return Task.Run(() => Load(filename));
        }

        public static Sediment Load(string filename)
        {
            //return new Sediment { Samples = XmlSerializer<EnvironmentData<SedimentSample>>.Load(filename, ReferencedTypes) };
            //var formatter = new BinaryFormatter();
            //using (var stream = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read))
            //    return new Sediment { Samples = (EnvironmentData<SedimentSample>)formatter.Deserialize(stream) };
            using (var stream = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read))
            using (var reader = new BinaryReader(stream)) return Deserialize(reader);
        }

        public override void Save(string filename)
        {
            //var serializer = new XmlSerializer<EnvironmentData<SedimentSample>> { Data = Samples };
            //serializer.Save(filename, ReferencedTypes);
            //var formatter = new BinaryFormatter();
            //using (var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None))
            //{
            //    formatter.Serialize(stream, Samples);
            //}
            Serialize(filename);
        }

        public void Serialize(string filename)
        {
            using (var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None))
            using (var writer = new BinaryWriter(stream))
                Serialize(writer);
        }

        public void Serialize(BinaryWriter writer)
        {
            writer.Write(Samples.Count);
            foreach (var item in Samples)
                item.Serialize(writer);
        }

        public static Sediment Deserialize(BinaryReader reader)
        {
            var result = new Sediment();
            var itemCount = reader.ReadInt32();
            for (var i = 0; i < itemCount; i++)
            {
                var curSample = SedimentSample.Deserialize(reader);
                if (curSample != null) result.Samples.Add(curSample);
            }
            return result;
        }
    }

    [Serializable]
    public class SedimentSample : Geo<SedimentSampleBase>, IComparable<SedimentSample>, IComparer<SedimentSample>
    {
        public SedimentSample() { }

        public SedimentSample(Geo location, SedimentSampleBase sample) : base(location.Latitude, location.Longitude, sample) { }
        public SedimentSample(double latitude, double longitude, SedimentSampleBase sample) : base(latitude, longitude, sample) { }

        public static implicit operator SedimentType(SedimentSample sedimentSample)
        {
            return SedimentTypes.Find(sedimentSample.Data.SampleValue);
        }

        public new void Serialize(BinaryWriter writer)
        {
            base.Serialize(writer);
            Data.Serialize(writer);
        }

        public new static SedimentSample Deserialize(BinaryReader reader)
        {
            var location = Geo.Deserialize(reader);
            var sampleBase = SedimentSampleBase.Deserialize(reader);
            return sampleBase.SampleValue == 0 ? null : new SedimentSample(location, sampleBase);
        }
        public int Compare(SedimentSample x, SedimentSample y) { return x.CompareTo(y); }
        public int CompareTo(SedimentSample other)
        {
            var compare = Latitude.CompareTo(other.Latitude);
            return compare != 0 ? compare : Longitude.CompareTo(other.Longitude);
        }
    }

    [Serializable]
    public class SedimentSampleBase : IComparable<SedimentSampleBase>
    {
        public short SampleValue { get; set; }
        public int CompareTo(SedimentSampleBase other)
        {
            return SampleValue.CompareTo(other.SampleValue);
        }

        public void Serialize(BinaryWriter writer)
        {
            writer.Write(SampleValue);
        }

        public static SedimentSampleBase Deserialize(BinaryReader reader)
        {
            return new SedimentSampleBase
            {
                SampleValue = reader.ReadInt16(),
            };
        }
    }
}
