function color_bar(ax,Y,label,cmap,nticks,orientation)
% PLOT.COLOR_BAR: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 04-Sep-2020 13:03:19
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
color_bar(input01,input02,input03,input04)
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
% axis(ax,'off');
% ax = axes('Position',ax.Position);
switch orientation
    case 'h'
        imagesc(ax,[0:100]');
        axis(ax,'tight')
        ax.YDir = 'normal';
        ax.YLabel.String = label;
        colormap(ax,cmap);
        ax.YTick = linspace(1,100,nticks);
        ax.YTickLabel = num2cell(round(linspace(min(Y(:))*1.05,max(Y(:))*0.95,nticks),1));
        ax.XTick = [];
    case 'v'
        imagesc(ax,[0:100]);
        axis(ax,'tight')
        ax.XLabel.String = label;
        colormap(ax,cmap);
        ax.XTick = linspace(1,100,nticks);
        ax.XTickLabel = num2cell(round(linspace(min(Y(:))*1.05,max(Y(:))*0.95,nticks),1));
        ax.YTick = [];
end
%------------- END OF CODE --------------
