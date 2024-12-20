﻿using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Threading.Tasks;
using HRC.Navigation;

namespace ESME.Environment
{
    [Serializable]
    public class SoundSpeed : EnvironmentDataSetBase
    {
        public List<SoundSpeedField> SoundSpeedFields { get; set; }

        public SoundSpeed()
        {
            SoundSpeedFields = new List<SoundSpeedField>();
        }

        public override void Save(string filename)
        {
            //var serializer = new XmlSerializer<List<SoundSpeedField>> { Data = SoundSpeedFields };
            //serializer.Save(filename, ReferencedTypes);

            var formatter = new BinaryFormatter();
            using (var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None))
            {
                formatter.Serialize(stream, SoundSpeedFields);
            }
        }

        /// <summary>
        /// Get the data from the specified time period, if available.  If no data are available, NULL is returned.
        /// </summary>
        /// <param name="timePeriod"></param>
        /// <returns></returns>
        public SoundSpeedField this[TimePeriod timePeriod]
        {
            get
            {
                return SoundSpeedFields.Find(t => t.TimePeriod == timePeriod);
            }
        }

        public void Add(SoundSpeed newData)
        {
            foreach (var soundSpeedField in newData.SoundSpeedFields)
            {
                if (this[soundSpeedField.TimePeriod] != null) throw new DataException(string.Format("Unable to add SoundSpeedField for {0}. Data already present.", soundSpeedField.TimePeriod));
                SoundSpeedFields.Add(soundSpeedField);
            }
        }

        public void Add(SoundSpeedField newField)
        {
            if (this[newField.TimePeriod] != null) throw new DataException(string.Format("Unable to add SoundSpeedField for {0}. Data already present.", newField.TimePeriod));
            SoundSpeedFields.Add(newField);
        }

        public static SoundSpeed Load(string filename)
        {
            //var formatter = new BinaryFormatter();
            //using (var stream = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read))
            //{
            //    return new SoundSpeed { SoundSpeedFields = (List<SoundSpeedField>)formatter.Deserialize(stream) };
            //}
            using (var stream = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read))
            using (var reader = new BinaryReader(stream)) return Deserialize(reader);
        }

        public static Task<SoundSpeed> LoadAsync(string filename)
        {
            return Task.Run(() => Load(filename));
        }
#if false
        bool _isExtended;
        readonly object _lockObject = new object();
        public void Extend(Geo<float> deepestPoint)
        {
            lock (_lockObject)
            {
                if (_isExtended) return;
                foreach (var soundSpeedField in SoundSpeedFields) soundSpeedField.ExtendProfiles(deepestPoint);
                _isExtended = true;
            }
        }
#endif

        public static SoundSpeed Average(SoundSpeed monthlySoundSpeeds, List<TimePeriod> timePeriods)
        {
            var result = new SoundSpeed();
            foreach (var timePeriod in timePeriods)
            {
                var months = Globals.AppSettings.NAVOConfiguration.MonthsInTimePeriod(timePeriod);
                var accumulator = new SoundSpeedFieldAverager { TimePeriod = timePeriod };
                foreach (var month in months) accumulator.Add(monthlySoundSpeeds[month]);
                result.SoundSpeedFields.Add(accumulator.Average);
            }
            return result;
        }

        public static SoundSpeedField Average(SoundSpeed monthlySoundSpeeds, TimePeriod timePeriod)
        {
            var months = Globals.AppSettings.NAVOConfiguration.MonthsInTimePeriod(timePeriod).ToList();
            var accumulator = new SoundSpeedFieldAverager { TimePeriod = timePeriod };
            foreach (var month in months) accumulator.Add(monthlySoundSpeeds[month]);
            return accumulator.Average;
        }

        internal static void VerifyThatTimePeriodsMatch(SoundSpeed data1, SoundSpeed data2)
        {
            foreach (var field1 in data1.SoundSpeedFields.Where(field1 => data2[field1.TimePeriod] == null)) throw new DataException(string.Format("SoundSpeeds do not contain the same time periods. Data 1 has time period {0}, data 2 does not", field1.TimePeriod));
            foreach (var field2 in data2.SoundSpeedFields.Where(field2 => data1[field2.TimePeriod] == null)) throw new DataException(string.Format("SoundSpeeds do not contain the same time periods. Data 2 has time period {0}, data 1 does not", field2.TimePeriod));
        }

        public static SoundSpeed Deserialize(BinaryReader reader)
        {
            var result = new SoundSpeed();
            var fieldCount = reader.ReadInt32();
            for (var i = 0; i < fieldCount; i++)
                result.SoundSpeedFields.Add(SoundSpeedField.Deserialize(reader));
            return result;
        }

        public void Serialize(string filename)
        {
            using (var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None))
            using (var writer = new BinaryWriter(stream))
                Serialize(writer);
        }

        public void Serialize(BinaryWriter writer)
        {
            writer.Write(SoundSpeedFields.Count);
            foreach (var item in SoundSpeedFields) item.Serialize(writer);
        }

        #region IExtensibleDataObject
        public virtual ExtensionDataObject ExtensionData { get; set; }
        #endregion
    }
}