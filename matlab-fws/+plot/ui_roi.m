function obj = ui_roi(ax,obj)
% PLOT.UI_ROI: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 18-Aug-2020 16:52:27
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
ui_mip(input01,input02,input03,input04)
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
cla(ax);

%% Colourmaps
obj = new.obj_to_colourmap(obj);

lim = plot.parcel_map('ax',ax,'label', obj.label,'grid', obj.grid,...
 'colour_map', obj.colour_map,'order',obj.table.ROIid);
axis(ax,lim);
ax.FontSize = 20;
ax.Color = fws.hex2rgb("DAE8F2");
% xl = -120:40:80;yl = -80:40:80;zl=-80:40:80;
% xl([1,end]) = lim(1:2);yl([1,end]) = lim(3:4);zl([1,end]) = lim(5:6);
% set(ax, 'XTick', xl, 'YTick', yl, 'ZTick', zl)

grid(ax,'on');
axis(ax,'on');
ax.LineWidth = 1;
ax.GridColor = fws.hex2rgb("181932");
%------------- END OF CODE --------------
