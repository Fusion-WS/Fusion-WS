function rv = rotate_vertices(v,varargin)
% FWS.ROTATE_VERTICES: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 09-Aug-2020 09:48:03
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
rotate_vertices(input01,input02,input03,input04)
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

obj = struct('plane',"x",'angle',90,'nd',size(v,2));
obj = fws.defaults(obj, varargin);

RM = {};
for ii=1:numel(obj.plane)
    angle = pi * obj.angle(ii) / 180;
    switch obj.plane(ii)
        case 'x';rm = [1,0,0;0,cos(angle),-sin(angle);0,sin(angle),cos(angle)];
        case 'y';rm = [cos(angle),0,-sin(angle);0,1,0;sin(angle),0,cos(angle)];   
        case 'z';rm = [cos(angle),-sin(angle),0;sin(angle),cos(angle),0;0,0,1];
    end
    RM{ii} =  rm;
end

rv = v;
for ii=1:numel(obj.plane)
    rv = rv * RM{ii};
end
   

end

%------------- END OF CODE --------------
