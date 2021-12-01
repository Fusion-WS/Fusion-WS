function [x,y]= arc(r1,r2,pc)
%% fusion.get.arc - get arc between two
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
if ~exist('pc','var');pc = [0,0];end % assume center is in 0,0
x1 = cos(r1);x2 = cos(r2);
y1 = sin(r1);y2 = sin(r2);
t = linspace(0,1,101);
r =  sqrt((x2-pc(1))^2+(y2-pc(2))^2);
d = sqrt((x2-x1)^2+(y2-y1)^2);% Distance between points
f = @(t,xy1,cxy,xy2) kron((1-t).^2,xy1) + kron(2*(1-t).*t,cxy) +  kron(t.^2,xy2); % define a second order Bernstein polynomial
if r/d>1
    u  = [cos(r1);sin(r1)];
    v  = [cos(r2);sin(r2)];
    x0 = -(u(2)-v(2))/(u(1)*v(2)-u(2)*v(1));
    y0 =  (u(1)-v(1))/(u(1)*v(2)-u(2)*v(1));
    r  = sqrt(x0^2 + y0^2 - 1);
    thetaLim(1) = atan2(u(2)-y0,u(1)-x0);
    thetaLim(2) = atan2(v(2)-y0,v(1)-x0);
    if u(1) >= 0 && v(1) >= 0
        % ensure the arc is within the unit disk
        theta = [linspace(max(thetaLim),pi,50),...
            linspace(-pi,min(thetaLim),50)].';
    else
        theta = linspace(thetaLim(1),thetaLim(2)).';
    end
    x = r*cos(theta)+x0;
    y = r*sin(theta)+y0;
else 
    [x,y] = fws.deal(f(t',[x1,y1],pc,[x2,y2]));
end
%------------- END OF CODE --------------
