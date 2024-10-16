﻿using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;

namespace ESME.Views.ColorPicker
{
    public class BindOnEnterTextBox : TextBox
    {
        protected override void OnKeyDown(KeyEventArgs e)
        {
            base.OnKeyDown(e);

            if (e.Key == Key.Enter)
            {
                BindingExpression bindingExpression = BindingOperations.GetBindingExpression(this, TextProperty);
                if (bindingExpression != null)
                    bindingExpression.UpdateSource();
            }
        }
    }
}
