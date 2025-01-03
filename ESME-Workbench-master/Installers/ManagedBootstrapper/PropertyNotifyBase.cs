﻿//-------------------------------------------------------------------------------------------------
// <copyright file="PropertyNotifyBase.cs" company="Microsoft">
// Copyright (c) Microsoft Corporation. All rights reserved.
//    
//    The use and distribution terms for this software are covered by the
//    Common Public License 1.0 (http://opensource.org/licenses/cpl1.0.php)
//    which can be found in the file CPL.TXT at the root of this distribution.
//    By using this software in any fashion, you are agreeing to be bound by
//    the terms of this license.
//    
//    You must not remove this notice, or any other, from this software.
// </copyright>
// 
// <summary>
// Base class that implements property notifications.
// This code came from the following MSDN article: http://msdn.microsoft.com/en-us/magazine/dd419663.aspx.
// </summary>
//-------------------------------------------------------------------------------------------------

using System;
using System.ComponentModel;
using System.Diagnostics;

namespace WixBootstrapper
{
    /// <summary>
    /// It provides support for property change notifications.
    /// </summary>
    public abstract class PropertyNotifyBase : INotifyPropertyChanged
    {
        /// <summary>
        /// Raised when a property on this object has a new value.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// Warns the developer if this object does not have a public property with the
        /// specified name. This method does not exist in a Release build.
        /// </summary>
        /// <param name="propertyName">Property name to verify.</param>
        [Conditional("DEBUG")]
        [DebuggerStepThrough]
        public void VerifyPropertyName(string propertyName)
        {
            // Verify that the property name matches a real, public, instance property
            // on this object.
            if (null == TypeDescriptor.GetProperties(this)[propertyName])
            {
                Debug.Fail(String.Concat("Invalid property name: ", propertyName));
            }
        }

        /// <summary>
        /// Raises this object's PropertyChanged event.
        /// </summary>
        /// <param name="propertyName">The property that has a new value.</param>
        protected virtual void OnPropertyChanged(string propertyName)
        {
            VerifyPropertyName(propertyName);

            var handler = PropertyChanged;
            if (null == handler) return;
            var e = new PropertyChangedEventArgs(propertyName);
            handler(this, e);
        }
    }
}
