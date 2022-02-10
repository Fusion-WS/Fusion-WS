function obj = obj_to_colourmap(obj)
% NEW.OBJ_TO_COLOURMAP: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 24-Aug-2020 10:56:34
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
obj_to_colourmap(input01,input02,input03,input04)
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
if obj.K.binary
    
    % If binary, we use jet to generate colours for each ROI
    obj.colour_map = jet(obj.nROI);
    
elseif obj.K.two_tailed
    
    % Two tailed maps get a negative (cool) and positive (warm) colourmap
    ROI_negative = obj.table.Peak<0; % Tmp index of the negative clusters.
    obj.colour_map = [fws.value_to_cmap(new.colour_map('map','pos'), obj.table.Peak(~ROI_negative));...
                      fws.value_to_cmap(new.colour_map('map','neg'), abs(obj.table.Peak(ROI_negative)))];
    
elseif obj.K.positive
    
    % One tailed positive map
    obj.colour_map = fws.value_to_cmap(new.colour_map('map','pos'),obj.table.Peak);
    
elseif obj.K.negative
    
    % One tailed negative map
    obj.colour_map = fws.value_to_cmap(new.colour_map('map','neg'),abs(obj.table.Peak));
    
end
end
%------------- END OF CODE --------------
