function [P,R] =  group_scatter_fit(ax,x,y,gp,cmap,lim,xl,yl,hst,lg,lgb,tail,ms,fs)
% PLOT.GROUP_SCATTER_FIT: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 22-Sep-2020 04:36:25
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
group_scatter_fit(input01,input02,input03,input04)
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

if ~exist('ms','var');ms=4;end
if ~exist('fs','var');fs=6;end


if ~exist('tail','var');tail='both';end
ng = numel(gp);
leg={};linFit=[];PX=[];PY=[];ln=[];
box = ax.Position;
axis(ax,'off')
if size(x,2)>size(y,2)
    tmp = x;
    x = y;
    y = tmp;
end
P = [];R = [];
for ii=1:ng
    [R(ii),P(ii)] = corr(x,y(:,ii),'type','Pearson','tail' ,tail);
    linFit(ii,:) = polyfit(x, y(:,ii), 1);
    PX(ii,:) = [min(x),max(x)];
    PY(ii,:) = linFit(ii,1)*PX(ii,:)+linFit(ii,2);
end
P = fws.fdr(P,1,0.05);
for ii=1:ng
    Sign =  subsref({'='; '<'}, substruct('{}', {1.0*(P(ii)<1e-3) + 1}));
    leg{ii} = sprintf('%s (r=%0.2f,p%s%0.3f)',char(gp(ii)),R(ii),Sign,P(ii)+0.001);
end


if exist('hst','var')&&~isempty(hst)
   ax = axes('Position',[box(1)+box(3)*0.1,box(2)+box(4)*0.1,box(3)*0.75,box(4)*.75],'FontSize',fs);
   ax_hst = axes('Position',[box(1)+box(3)*0.85,box(2)+box(4)*0.1,box(3)*0.1,box(4)*.75],'FontSize',fs);
   for ii=1:ng
        vt =  fws.winsorize(y(:,ii));
        pd = fitdist(vt,'Kernel');
        vi = linspace(min(vt)*0.9,max(vt)*1.1,100);
        f = pdf(pd,vi);
        patch([0,fws.scale(f),0],[vi(1),vi,vi(end)],cmap(ii,:),'FaceAlpha',0.5,'Edgecolor',max(cmap(ii,:)-0.5,0),'parent',ax_hst);
   end
   axis(ax_hst,'off')
   axis(ax_hst,[xlim(ax_hst),lim(3:4)])
else 
    ax = axes('Position',[box(1)+box(3)*0.1,box(2)+box(4)*0.1,box(3)*0.75,box(4)*.75],'FontSize',fs);
end
% 
% curunits = get(ax, 'Units');
% set(gca, 'Units', 'Points');
% cursize = get(ax, 'Position');
% set(gca, 'Units', curunits);

hold(ax,'on');
for ii=1:ng
    plot(ax,x,y(:,ii), 'ko','MarkerSize',ms,'MarkerFaceColor',cmap(ii,:),'MarkerEdgeColor','none'); % Plot a scatter plot
end
hold(ax,'off');

for ii=1:ng
   ln(ii)= line(ax,PX(ii,:),PY(ii,:),'LineStyle','-','LineWidth',1,'Color',cmap(ii,:).^1.5);
end
grid(ax,'on');
if exist('lgb','var')&&~isempty(lgb)
    [bx,by] = plot.square(lgb(1),lgb(2),lgb(3),lgb(4),'b');
    patch(ax,bx,by,'w','FaceAlpha',0.75,'Edgecolor','k');
end
if exist('lg','var')
    yy = linspace(lg(2),lg(1),numel(leg));
    for r=1:numel(yy)
     text(ax,lg(3)*yy(r).^0,yy(r),leg{r},'FontSize',fs,'VerticalAlignment','middle');
     text(ax,lg(4)*yy(r).^0,yy(r),char(9679),'color',cmap(r,:).^2,'FontSize',fs*1.5,'VerticalAlignment','middle');
    end
end

ax.Color = [0.85,0.85,0.85];
axis(ax,lim)
ax.YLabel.String =yl;
ax.XLabel.String =xl;
%------------- END OF CODE --------------
