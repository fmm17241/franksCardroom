﻿using System;
using System.IO;
using System.Xml.Serialization;
using ThinkGeo.MapSuite.Core;

namespace ESME.Mapping
{
    [Serializable]
    public class ShapefileMapLayer : MapLayerViewModel
    {
        [XmlElement]
        public string ShapefileName
        {
            get { return _shapefileName; }
            set
            {
                if (_shapefileName == value) return;
                _shapefileName = value;

                string projection = null;
                var projectionFile = Path.Combine(Path.GetDirectoryName(_shapefileName), "projection.txt");
                if (File.Exists(projectionFile))
                {
                    using (var sr = new StreamReader(projectionFile)) projection = sr.ReadToEnd();
                }
                var newLayer = new ShapeFileFeatureLayer(_shapefileName);
                if (AreaStyle == null)
                {
                    newLayer.ZoomLevelSet.ZoomLevel01.DefaultAreaStyle = AreaStyles.County1;
                    newLayer.ZoomLevelSet.ZoomLevel01.ApplyUntilZoomLevel = ApplyUntilZoomLevel.Level20;
                }
                else
                {
                    newLayer.ZoomLevelSet.ZoomLevel01.DefaultAreaStyle = AreaStyle;
                    newLayer.ZoomLevelSet.ZoomLevel01.ApplyUntilZoomLevel = ApplyUntilZoomLevel.Level20;
                }
                newLayer.RequireIndex = false;
                if (projection != null)
                    newLayer.FeatureSource.Projection = new ManagedProj4Projection
                    {
                        InternalProjectionParametersString = projection,
                        ExternalProjectionParametersString = ManagedProj4Projection.GetEpsgParametersString(4326),
                    };
                LayerOverlay.Layers.Add(newLayer);
            }
        }
        string _shapefileName;
    }
}