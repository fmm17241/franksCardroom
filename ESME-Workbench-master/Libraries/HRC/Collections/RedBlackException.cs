using System;

namespace HRC.Collections
{
    ///<summary>
    /// The RedBlackException class distinguishes read black tree exceptions from .NET
    /// exceptions. 
    ///</summary>
    public class RedBlackException : Exception
	{
		public RedBlackException()
        {
    	}
			
		public RedBlackException(string msg) : base(msg) 
        {
		}			
	}
}
