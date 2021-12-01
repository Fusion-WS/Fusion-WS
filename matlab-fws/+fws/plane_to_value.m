function obj = plane_to_value(obj)
% FWS.PLANE_TO_VALUE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 03-Jul-2020 13:28:54
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
plane_to_value(input01,input02,input03,input04)
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



d = size(obj.volume);

map = table(["Axial";"Right sagittal";"Left sagittal";...
             "Right medial sagittal";"Left medial sagittal";...
             "Coronal posterior";"Coronal anterior"],...
            categorical(["a";"rs";"ls";"rsm";"lsm";"cp";"ca"]),...
            [270;360;180;180;360;270;90],...
            [90;360;360;360;360;360;0],...
            'VariableNames',{'plane_name','plane','az','el'});

tmp = map(map.plane == obj.plane,:);
obj.az = tmp.az;
obj.el = tmp.el;
obj.plane_name = tmp.plane_name;

if obj.plane(end)=='m'
    tmp = obj.volume;
    if obj.plane(1)=='r'
        tmp(round(d(1)/2)-2:end,:,:,:) = nan;
        obj.volume = tmp;
    else
        tmp(1:round(d(1)/2)+2,:,:,:) = nan;
        obj.volume = tmp;
    end
end


end

%------------- END OF CODE --------------
