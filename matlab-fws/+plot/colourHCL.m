function ax_cb = colourHCL(ax,data,labels,cmap,fs)
%% PLOT.COLOURHCL: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 04-Jan-2020 21:00:35
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
colourHCL(input01,input02,input03,input04)
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
disp('')
if ~exist('fs','var');fs = 7;end

data = fws.scale(data);% scale data 
pd = pdist(data,'correlation');
ds = squareform(pd);
sim = exp(-ds.^2);
Z_features = linkage(pd,'average');
featuresOrder = optimalleaforder(Z_features,pd);
box = ax.Position;
axis (ax,'off');
ax_ld = axes('Position',[box(1),box(2)+box(4)*0.05,box(3)*0.2,box(4)*0.92]);
ax_heat = axes('Position', [box(1)+box(3)*0.21 box(2)+ box(4)*0.05 box(3)*0.65 box(4)*0.92]);%[left bottom width height]
ax_cb = axes('Position', [box(1)+box(3)*0.92 box(2)+ box(4)*0.05 box(3)*0.05 box(4)*0.92]);%[left bottom width height]
[~,id]  = sort(Z_features(:,3));
Z_features(:,3) = fws.scale(Z_features(:,3),'mn',0.2,'mx',1);% scale for visualization
[h,~,Z_features_order,lcf] = plot.dendrogram(ax_ld,Z_features,0,'orient', 'left', 'colorthreshold',Z_features(id(end-1),3),'Reorder',featuresOrder);
imagesc(ax_heat,sim(featuresOrder,featuresOrder));
ax_ld.YDir = ax_heat.YDir;
axis(ax_ld,[ax_ld.XLim,ax_heat.YLim]);
if ~exist('cmap','var');cmap = turbomap(numel(unique(lcf))-1);end

for ii=1:numel(lcf)
    h(ii).LineWidth = 1;
    if lcf(ii)
        h(ii).Color =cmap(lcf(ii),:);
    end
end
if exist('labels','var')

ax_heat.YTick = '';
nl = size(sim,1);
text(ones(nl,1)*(nl+0.75),1:nl,labels(Z_features_order),'FontSize',fs,'Parent',ax_heat)
line(ax_heat,[0,nl,nl,0,0]+0.5,[0,0,nl,nl,0]+0.5,'LineWidth',0.5,'Color','k');   
axis(ax_heat,[0.5,nl+1.5,0.5,nl+0.5]);

end
% ax_heat.YTickLabel = labels(Z_features_order);
% ax_heat.YAxisLocation = 'right';

axis (ax_ld,'off');
ax_heat.XTick = '';
%colormap(ax_heat,gray);
imagesc(ax_cb,[linspace(min(sim(:)),max(sim(:)),100)]');
colormap(ax_cb,gray);
colormap(ax_heat,gray);
axis(ax_cb,'off')
axis(ax_heat,'off')
line(ax_cb,[0,1,1,0,0]+0.5,[0,0,100,100,0]+0.5,'LineWidth',0.5,'Color','k');   
ax_cb.YDir='normal';
%------------- END OF CODE --------------
