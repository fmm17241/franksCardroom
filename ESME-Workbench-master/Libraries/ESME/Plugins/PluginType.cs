namespace ESME.Plugins
{
    public enum PluginType
    {
        Unknown = 0,
        EnvironmentalDataSource = 1,
        TransmissionLossCalculator = 2,
        DataVisualizer = 3,
    }

    public enum PluginSubtype
    {
        Wind = 100,
        SoundSpeed = 101,
        Sediment = 102,
        Bathymetry = 103,
        Bellhop = 200,
        RAMGeo = 201,
        RAMSGeo = 202,
        BellhopArrivals = 203,
    }
}