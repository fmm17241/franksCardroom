
function s = std2(a)
%STD2 Compute standard deviation of matrix elements.
%   B = STD2(A) computes the standard deviation of the values in
%   A.
%
%   Class Support
%   -------------
%   A is an array of class double or of any integer class. B
%   is a scalar of class double.
%
%   See also CORR2, MEAN2, MEAN, STD.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 5.17 $  $Date: 2001/01/18 15:30:39 $

if (~isa(a,'double'))
    a = double(a);
end

s = std(a(:));
