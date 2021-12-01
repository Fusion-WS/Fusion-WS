function [xp,yp] = circle(x,y,r,step)
%% fusion.get.circle - get rrect
%
%    __           _             
%   / _|         (_)            
%  | |_ _   _ ___ _  ___  _ __    
%  |  _| | | / __| |/ _ \| '_ \    :- Functional and Structural 
%  | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
%  |_|  \__,_|___/_|\___/|_| |_|
%
%
%% AUTHOR:  Eyal Soreq
%  EMAIL:  e.soreq14@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 3-June-2020 09:18:27
%
%% INPUTS:
%         x - x and y are the coordinates of the center of the circle
%         y - coordinates of the center of the circle
%         r - r is the radius of the circle
%         step - 0.01 is the angle step, bigger values will draw the circle faster but
%         you might notice imperfections (not very smooth)  
%
%% EXAMPLES:
%{

%}
%
%% DEPENDENCIES:
%
% This file is part of fusion toolbox
% fusion toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% fusion toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with fusion toolbox. If not, see <http://www.gnu.org/licenses/>.
%------------- BEGIN CODE --------------
%
if ~exist('step','var');step = 100;end
ang=linspace(0.5*pi,2.5*pi,step); 
xp=x(:)+r*cos(ang);
yp=y(:)+r*sin(ang);
%------------- END OF CODE --------------