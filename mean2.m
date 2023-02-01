
function y = mean2(x)
%MEAN2 Compute mean of matrix elements.
%   B = MEAN2(A) computes the mean of the values in A.
%
%   Class Support
%   -------------
%   A is an array of class double or of any integer class. B
%   is a scalar of class double. 
%
%   See also MEAN, STD, STD2.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 5.16 $  $Date: 2001/01/18 15:30:04 $

y = sum(x(:))/prod(size(x));
