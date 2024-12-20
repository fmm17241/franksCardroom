﻿using System.Windows;
using System.Windows.Media.Animation;
using System.Diagnostics;

namespace HRC.Utility
{
	/// <summary>
	/// Contains attached properties to activate Trigger Tracing on the specified Triggers.
	/// This file alone should be dropped into your app.
	/// </summary>
	public static class TriggerTracing
	{
		static TriggerTracing()
		{
			// Initialise WPF Animation tracing and add a TriggerTraceListener
            PresentationTraceSources.Refresh();
            PresentationTraceSources.AnimationSource.Listeners.Clear();
			PresentationTraceSources.AnimationSource.Listeners.Add(new TriggerTraceListener());
			PresentationTraceSources.AnimationSource.Switch.Level = SourceLevels.All;
		}
		
		#region TriggerName attached property

		/// <summary>
		/// Gets the trigger name for the specified trigger. This will be used
		/// to identify the trigger in the debug output.
		/// </summary>
		/// <param name="trigger">The trigger.</param>
		/// <returns></returns>
		public static string GetTriggerName(TriggerBase trigger)
		{
			return (string)trigger.GetValue(TriggerNameProperty);
		}

	    /// <summary>
	    /// Sets the trigger name for the specified trigger. This will be used
	    /// to identify the trigger in the debug output.
	    /// </summary>
	    /// <param name="trigger">The trigger.</param>
	    /// <param name="value"></param>
	    /// <returns></returns>
	    public static void SetTriggerName(TriggerBase trigger, string value)
		{
			trigger.SetCurrentValue(TriggerNameProperty, value);
		}

		public static readonly DependencyProperty TriggerNameProperty =
			DependencyProperty.RegisterAttached(
			"TriggerName",
			typeof(string),
			typeof(TriggerTracing),
			new UIPropertyMetadata(string.Empty));

		#endregion

		#region TraceEnabled attached property

		/// <summary>
		/// Gets a value indication whether trace is enabled for the specified trigger.
		/// </summary>
		/// <param name="trigger">The trigger.</param>
		/// <returns></returns>
		public static bool GetTraceEnabled(TriggerBase trigger)
		{
			return (bool)trigger.GetValue(TraceEnabledProperty);
		}

		/// <summary>
		/// Sets a value specifying whether trace is enabled for the specified trigger
		/// </summary>
		/// <param name="trigger"></param>
		/// <param name="value"></param>
		public static void SetTraceEnabled(TriggerBase trigger, bool value)
		{
			trigger.SetCurrentValue(TraceEnabledProperty, value);
		}

		public static readonly DependencyProperty TraceEnabledProperty =
			DependencyProperty.RegisterAttached(
			"TraceEnabled",
			typeof(bool),
			typeof(TriggerTracing),
			new UIPropertyMetadata(false, OnTraceEnabledChanged));

		private static void OnTraceEnabledChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
		{
			var triggerBase = d as TriggerBase;

			if (triggerBase == null)
				return;

			if (!(e.NewValue is bool))
				return;

			if ((bool)e.NewValue)
			{
				// insert dummy story-boards which can later be traced using WPF animation tracing
				
				var storyboard = new TriggerTraceStoryboard(triggerBase, TriggerTraceStoryboardType.Enter);
				triggerBase.EnterActions.Insert(0, new BeginStoryboard { Storyboard = storyboard });

				storyboard = new TriggerTraceStoryboard(triggerBase, TriggerTraceStoryboardType.Exit);
				triggerBase.ExitActions.Insert(0, new BeginStoryboard { Storyboard = storyboard });
			}
			else
			{
				// remove the dummy storyboards
				
				foreach (var actionCollection in new[] { triggerBase.EnterActions, triggerBase.ExitActions })
				{
					foreach (var triggerAction in actionCollection)
					{
						var bsb = triggerAction as BeginStoryboard;

						if (bsb != null && bsb.Storyboard != null && bsb.Storyboard is TriggerTraceStoryboard)
						{
							actionCollection.Remove(bsb);
							break;
						}
					}
				}
			}
		}

		#endregion

		private enum TriggerTraceStoryboardType
		{
			Enter, Exit
		}

		/// <summary>
		/// A dummy storyboard for tracing purposes
		/// </summary>
		private class TriggerTraceStoryboard : Storyboard
		{
			public TriggerTraceStoryboardType StoryboardType { get; private set; }
			public TriggerBase TriggerBase { get; private set; }

			public TriggerTraceStoryboard(TriggerBase triggerBase, TriggerTraceStoryboardType storyboardType)
			{
				TriggerBase = triggerBase;
				StoryboardType = storyboardType;
			}
		}

		/// <summary>
		/// A custom tracelistener.
		/// </summary>
		private class TriggerTraceListener : TraceListener
		{
			public override void TraceEvent(TraceEventCache eventCache, string source, TraceEventType eventType, int id, string format, params object[] args)
			{
				base.TraceEvent(eventCache, source, eventType, id, format, args);

				if (format.StartsWith("Storyboard has begun;"))
				{
					var storyboard = args[1] as TriggerTraceStoryboard;
					if (storyboard != null)
					{
						// add a breakpoint here to see when your trigger has been
						// entered or exited
						
						// the element being acted upon
						var targetElement = args[5];
						
						// the namescope of the element being acted upon
						//var namescope = (INameScope)args[7];
						
						var triggerBase = storyboard.TriggerBase;
						var triggerName = GetTriggerName(storyboard.TriggerBase);

						Debug.WriteLine(string.Format("Element: {0}, {1}: {2}: {3}",
							targetElement,
							triggerBase.GetType().Name,
							triggerName,
							storyboard.StoryboardType));
					}
				}
			}

			public override void Write(string message)
			{
			}

			public override void WriteLine(string message)
			{
			}
		}
	}

}
