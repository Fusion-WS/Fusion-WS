function ax = distanceMatrix(ax,dm,labels)
%% PLOT.DISTANCEMATRIX: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 05-Jan-2020 08:35:32
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
distanceMatrix(input01,input02,input03,input04)
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
box = ax.Position;
axis(ax,'off')
ax = axes('Position',[box(1)+box(3)*0.05,box(2)+box(4)*0.05,box(3)*0.9,box(4)*0.92]);
imagesc(ax,dm)

ax.YDir = 'reverse';
ax.YAxisLocation = 'left';
if exist('labels','var')
    nl = numel(labels);
    ax.XTick = [];
    ax.YTick = [];
    text(ones(nl,1)*(nl+0.75),1:nl,labels,'FontUnits','normalized','FontSize',0.05,'Parent',ax)
else 
    nl = size(dm,1);
end
axis(ax,[0.5,nl+.5,0.5,nl+.5]);
line(ax,[0.5,nl+.5,nl+.5,0.5,0.5],[0.5,0.5,nl+.5,nl+.5,0.5],'LineWidth',0.5,'Color','k');   
colormap(ax,gray);
axis(ax,'off')

%------------- END OF CODE --------------
