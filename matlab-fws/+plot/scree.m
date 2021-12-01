function [idx,D] = scree(Y,fig,ax,cmap)
%% PLOT.SCREE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 20-Jun-2017 16:35:59
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
scree(input01,input02,input03,input04)
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
n = numel(Y);
xx = linspace(0,1,n)';
yy = fws.scale(Y(:));
xy = [xx,yy];
lv = [linspace(xx(1),xx(end),n);linspace(yy(1),yy(end),n)]';
dtl = sqrt(sum((xy-lv).^2,2));
[D,idx] = max(dtl);


if exist('fig','var')&&~isempty(fig)
    figure(fig)
    if ~exist('ax','var')
        ax = gca;
    end
end

if ~exist('cmap','var')
cmap=[0,0,0];
end
if exist('ax','var')
    y = fws.scale(Y(:));
    ly = linspace(y(1),y(end),n)';
    plot(xx,y,'Marker','.','LineWidth',1,'Color',cmap,'MarkerSize',8,'Parent',ax);hold(ax, 'on')
    plot(xx,ly,'Parent',ax);
    plot(xx,dtl.*range(y),'-b+','LineWidth',0.5,'MarkerSize',2,'Parent',ax);
    idx2 = knnsearch(lv(:,2),xy(idx,2));
    x123 = [xx(idx),xx(idx2),xx(idx)];
    y123 = [ly(idx),ly(idx2),y(idx)];
    plot(x123,y123,'ro','Parent',ax);
    line(x123([1,3]),y123([1,3]),'color','r','Parent',ax);
    line(x123([2,3]),y123([2,3]),'color','r','Parent',ax);
    k = ((y123(2)-y123(1)) * (x123(3)-x123(1)) - (x123(2)-x123(1)) * (y123(3)-y123(1)) / ((y123(2)-y123(1))^2 + (x123(2)-x123(1))^2));    
    x4 = x123(3) - k * (y123(2)-y123(1));
    y4 = y123(3) + k * (x123(2)-x123(1));
    %plot(x4,y4,'ro','Parent',ax);
    %line([x123(3),x4],[y123(3),y4],'color','m','Parent',ax);
    ax.XTick = linspace(xx(1),xx(end),n);
    ax.XTickLabel = '';
    axis(ax,[0,1,0,1.1]);
    grid(ax, 'on')
end

%------------- END OF CODE --------------
