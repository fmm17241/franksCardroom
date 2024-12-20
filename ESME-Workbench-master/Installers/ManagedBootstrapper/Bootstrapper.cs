﻿using System.Diagnostics;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;
using Microsoft.Tools.WindowsInstallerXml.Bootstrapper;

namespace WixBootstrapper
{
    public class Bootstrapper : BootstrapperApplication
    {
        /// <summary>
        /// Gets the global model.
        /// </summary>
        static public Model Model { get; private set; }

        /// <summary>
        /// Gets the global view.
        /// </summary>
        static public RootView View { get; private set; }
        // TODO: We should refactor things so we dont have a global View.

        /// <summary>
        /// Gets the global dispatcher.
        /// </summary>
        static public Dispatcher Dispatcher { get; private set; }

        /// <summary>
        /// Launches the default web browser to the provided URI.
        /// </summary>
        /// <param name="uri">URI to open the web browser.</param>
        public static void LaunchUrl(string uri)
        {
            // Switch the wait cursor since shellexec can take a second or so.
            var cursor = View.Cursor;
            View.Cursor = Cursors.Wait;

            try
            {
                var process = new Process {StartInfo = {FileName = uri, UseShellExecute = true, Verb = "open"}};

                process.Start();
            }
            finally
            {
                View.Cursor = cursor; // back to the original cursor.
            }
        }

        /// <summary>
        /// Thread entry point for WiX Toolset UX.
        /// </summary>
        protected override void Run()
        {
            Engine.Log(LogLevel.Verbose, "Running the ESME Bootstrapper.");
            Model = new Model(this);
            Dispatcher = Dispatcher.CurrentDispatcher;
            var backgroundColorString = Engine.StringVariables["BackgroundColor"];
            var progressBarColorString = Engine.StringVariables["ProgressBarColor"];
            var convertedBackgroundColorObject = ColorConverter.ConvertFromString(backgroundColorString);
            var convertedProgressBarColorObject = ColorConverter.ConvertFromString(progressBarColorString);
            var backgroundColor = (Color)(convertedBackgroundColorObject ?? Colors.LightSeaGreen);
            var progressBarColor = (Color)(convertedProgressBarColorObject ?? Color.FromArgb(0xFF, 0x00, 0x8E, 0x91));
            var viewModel = new RootViewModel
            {
                BundleLongName = Engine.StringVariables["BundleLongName"],
                BundleShortName = Engine.StringVariables["BundleShortName"],
                ProductLongName = Engine.StringVariables["ProductLongName"],
                ProductShortName = Engine.StringVariables["ProductShortName"],
                ProductFullVersion = Engine.StringVariables["ProductFullVersion"],
                ButtonBackgroundBrush = new SolidColorBrush(backgroundColor),
                ProgressBarBrush = new SolidColorBrush(progressBarColor),
            };
            // Populate the view models with the latest data. This is where Detect is called.
            viewModel.Refresh();

            // Create a Window to show UI.
            if (Model.Command.Display == Display.Passive ||
                Model.Command.Display == Display.Full)
            {
                Engine.Log(LogLevel.Verbose, "Creating a UI.");
                View = new RootView(viewModel);
                View.Show();
            }
            Dispatcher.Run();

            Engine.Quit(0);
        }
    }
}
