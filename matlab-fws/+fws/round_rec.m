function P = round_rec(x,y,w,h,c,method)
% FWS.ROUND_REC: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 21-Sep-2020 22:33:23
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
round_rec(input01,input02,input03,input04)
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
if ~exist('method','var');method=1;end
switch method
    case 1%left bottom
        xx = [x+c*w,x,x,x+c*w,x+w-c*w,x+w,x+w,x+w-c*w,x+c*w,x];
        yy = [y,y+c*h,y+h-c*h,y+h,y+h,y+h-c*h,y+c*h,y,y,y+c*h];
    case 2%center
        x = x-w/2;
        y = y-h/2;
        xx = [x+c*w,x,x,x+c*w,x+w-c*w,x+w,x+w,x+w-c*w,x+c*w,x];
        yy = [y,y+c*h,y+h-c*h,y+h,y+h,y+h-c*h,y+c*h,y,y,y+c*h];   
end

P = spcrv([xx;yy],3)';
end
%------------- END OF CODE --------------
