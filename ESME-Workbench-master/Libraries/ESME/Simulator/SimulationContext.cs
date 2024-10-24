using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using ESME.Locations;
using ESME.Scenarios;

namespace ESME.Simulator
{
    public class SimulationContext : DbContext
    {
        public static SimulationContext OpenOrCreate(string filename)
        {
            var connectionFactory = new SqlCeConnectionFactory("System.Data.SqlServerCe.4.0");
            var connection = connectionFactory.CreateConnection(filename);
            return new SimulationContext(connection, true);
        }

        public SimulationContext(DbConnection connection, bool contextOwnsConnection)
            : base(connection, contextOwnsConnection)
        {
            Configuration.AutoDetectChangesEnabled = false;
            Configuration.ProxyCreationEnabled = true;
            Configuration.LazyLoadingEnabled = true;
            Configuration.ValidateOnSaveEnabled = true;
            System.Data.Entity.Database.SetInitializer(new LocationDatabaseInitializer());
        }

        public DbSet<Location> Locations { get; set; }
        public DbSet<EnvironmentalDataSet> EnvironmentalDataSets { get; set; }
        public DbSet<LogEntry> Log { get; set; }

        public DbSet<Scenario> Scenarios { get; set; }
        public DbSet<Platform> Platforms { get; set; }
        public DbSet<Source> Sources { get; set; }
        public DbSet<Mode> Modes { get; set; }
        public DbSet<Perimeter> Perimeters { get; set; }
        public DbSet<PerimeterCoordinate> PerimeterCoordinates { get; set; }
        public DbSet<ScenarioSpecies> ScenarioSpecies { get; set; }

        public DbSet<Actor> Actors { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            //modelBuilder.Entity<Platform>().HasRequired(p => p.TrackDefinition).WithRequiredPrincipal(t => t.Platform);
            //modelBuilder.Entity<TrackDefinition>().HasRequired(t => t.Platform).WithRequiredDependent(p => p.TrackDefinition);
            //modelBuilder.Entity<TrackDefinition>().HasOptional(p => p.Platform).WithRequired(t => t.TrackDefinition);
            //modelBuilder.Entity<TrackDefinition>().HasRequired(t => t.Platform).WithOptional(p => p.TrackDefinition);
            modelBuilder.Entity<Platform>().HasOptional(p => p.Perimeter).WithMany();
        }

        public class LocationDatabaseInitializer : CreateDatabaseIfNotExists<LocationContext>
        {
            protected override void Seed(LocationContext context)
            {
                //context.Database.ExecuteSqlCommand("");
            }
        }
    }
}