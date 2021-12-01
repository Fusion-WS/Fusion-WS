function [cx,cy] = connector(x,y,c,d)
%% PLOT.CONNECTOR: One line description of what the function or script performs
%
%   __           _             
%  / _|         (_)            
% | |_ _   _ ___ _  ___  _ __    
% |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural 
% | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
% |_|  \__,_|___/_|\___/|_| |_|
%
%
%% AUTHOR:  Eyal Soreq
%  EMAIL:  e.soreq14@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 18-Apr-2020 08:50:32
%
%% INPUTS:
%    input01 - 
%    input02 - 
%    input03 - 
%    input04 - 
%
%
%% OUTPUT:
%
%% EXAMPLES:
%{
connector(input01,input02,input03,input04)
%}
%
%% DEPENDENCIES:
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



% left part starting from (X1,Y1), ending at (S(X2-X1)+X1, Y1)
% 
% mid part starting from (S(X2-X1)+X1, Y1), ending at (S(X2-X1)+X1, Y2)
% 
% right part starting from (S(X2-X1)+X1,Y2), ending at (X2,Y2)
% 
% S(X2-X1)+X1 is, of course, calculated only once.

x1 = x(1);x2 = x(2);
y1 = y(1);y2 = y(2);

if ~exist('c','var');pc = 0.5;else;pc = c;end
if ~exist('d','var');d = 2;end

my = pc*(y2-y1)+y1;
mx1 = 0.25*(x2-x1)+x1;
mx2 = 0.75*(x2-x1)+x1;
hold on
switch d
    case 2;xx = [x1,x1,x2,x2]; yy= [y1,my,my,y2];
    case 3;xx = [x1,x1,x1,x2,x2,x2]; yy= [y1,y1,my,my,y2,y2];
    case 4;xx = [x1,x1,x1,x1,x1,mx1,mx2,x2,x2,x2,x2,x2]; yy= [y1,y1,y1,y1,y1,my,my,y2,y2,y2,y2,y2];
end
    

[cx,cy] = fws.deal(spcrv([xx;yy],d)');


end

%------------- END OF CODE --------------
