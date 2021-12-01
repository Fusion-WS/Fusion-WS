function ax= rectangles(ax,rec,labels,cmap,fs)
%% PLOT.RECTANGLES: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 03-Apr-2019 11:42:10
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
rectangles(input01,input02,input03,input04)
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

if ~exist('fs','var');fs=0.1;end
axis (ax,'off');
%ax = axes('Position',[box(1)+box(3)*0.05,box(2),box(3)*0.85,box(4)*0.85]);
%ax = axes('Position',[box(1)+box(3)*0.05,box(2),box(3)*0.85,box(4)*0.85]);
if(nargin < 2)
    labels = [];
end

if(nargin < 3)
    cmap = rand(size(rec,2),3).^0.5;
end

% make a patch for each rectangle

for i = 1:size(rec,2)
    r = rec(:,i);
    xPoints = [r(1), r(1), r(1) + r(3),r(1) + r(3)];
    yPoints = [r(2), r(2)+ r(4), r(2)+ r(4),r(2)];
    patch(xPoints,yPoints,cmap(i,:),'EdgeColor','k','LineWidth',1,'parent',ax);
    if(~isempty(labels))
        c =  subsref({'w'; 'k'}, substruct('{}', {1.0*(unique(rgb2gray(cmap(i,:)))>0.6) + 1}));
        t = text(r(1) + r(3)/2,r(2) + r(4)/2, 1, ' ','Color',c, ...
            'VerticalAlignment','middle','HorizontalAlignment','center',...
            'parent',ax,'Interpreter','none','FontWeight','bold','FontUnits','normalized','FontSize',fs);
        t.String = labels{i};
        axis tight
        axis off
    end
end
    

    
end
%------------- END OF CODE --------------
