function [xp,yp] = square(x,y,w,h,c)
% PLOT.SQUARE: One line description of what the function or script performs
%
%   __           _             
%  / _|         (_)            
% | |_ _   _ ___ _  ___  _ __    
% |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural 
% | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
% |_|  \__,_|___/_|\___/|_| |_|
%
%
% AUTHOR:  Eyal Soreq
%  EMAIL:  e.soreq14@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 29-Jul-2020 14:47:59
%
% INPUTS:
%    input01 - 
%    input02 - 
%    input03 - 
%    input04 - 
%
%
% OUTPUT:
%
% EXAMPLES:
%{
square(input01,input02,input03,input04)
%}
%
% DEPENDENCIES:
%
% This file is part of Fusion Pipeline
% Fusion Pipeline is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% Fusion Pipeline is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with Fusion Pipeline.If not, see <http://www.gnu.org/licenses/>.
%------------- BEGIN CODE --------------
%
%x and y are the coordinates of the center of the square
% w is the width and h is the height
%
%
if ~exist('c','var');c= 'c';end
switch c
    case 'c';x1 = x-w/2;x2=x+w/2;y1 =y-h/2; y2 =y+h/2;
    case 'b';x1 = x;x2=x+w;y1 =y; y2 =y+h;
    case 't';x1 = x;x2=x-w;y1 =y; y2 =y+h;       
end
xp= [ x1 x1 x2 x2 x1] ;
yp= [ y1 y2 y2 y1 y1];
end
%------------- END OF CODE --------------
