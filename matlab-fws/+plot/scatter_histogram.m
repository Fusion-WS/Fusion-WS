function varargout=scatter_histogram(ax,x,y,gp,cmap,lim,axis_labels,lg,Title,fs)
%% PLOT.SCATTERHIST: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 05-Jan-2020 20:36:27
%
%% INPUTS:
%    lg - [ylim_bottom,ylim_top,x_text,x_marker]
%    input02 - 
%    input03 - 
%    input04 - 
%
%
%% OUTPUT:
%
%% EXAMPLES:
%{
scatterHist(input01,input02,input03,input04)
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
if ~exist('fs','var');fs = ax.FontSize;end
gn = unique(gp);
ng = numel(gn);
st = 0.1;
b = ax.Position;
axis (ax,'off');
ax_pl = axes('Position',[b(1)+b(3)*0.1,b(2)+b(4)*0.1,b(3)*0.75,b(4)*0.75]);
ax_pl.FontSize = fs;
ax_xhist = axes('Position',[b(1)+b(3)*0.1,b(2)+b(4)*0.85,b(3)*0.75,b(4)*0.1]);
ax_yhist = axes('Position',[b(1)+b(3)*0.85,b(2)+b(4)*0.1,b(3)*0.1,b(4)*0.75]);
hold(ax_pl,'on');
hold(ax_xhist,'on');
hold(ax_yhist,'on');
for ii=1:ng
    ix = gp==gn(ii);
    if nnz(ix)
        plot(ax_pl,x(ix),y(ix), 'ko','MarkerSize',2,'MarkerFaceColor',cmap(ii,:),'MarkerEdgeColor','none'); % Plot a scatter plot
        for jj=1:2
            v =  subsref({x(ix);y(ix)}, substruct('{}', {1.0*(jj==1)+1}));
            ax =  subsref({ax_xhist;ax_yhist}, substruct('{}', {1.0*(jj==1)+1}));
            vt =  fws.winsorize(v);
            pd = fitdist(vt,'Kernel');
            splt = range(vt)*0.95;
            vi = median(vt)-splt:st:median(vt)+splt;
            f = pdf(pd,vi);
            switch jj
                case 1;patch(fws.scale(f),vi,cmap(ii,:),'FaceAlpha',0.5,'Edgecolor',max(cmap(ii,:)-0.5,0),'parent',ax);
                case 2;patch(vi,fws.scale(f),cmap(ii,:),'FaceAlpha',0.5,'Edgecolor',max(cmap(ii,:)-0.5,0),'parent',ax);
            end
        end
    end
end
p = [];
ll = {};

for  ii=1:ng
   ix = gp==gn(ii);
   if nnz(ix)
       xx = [mean(x(ix)),max(x(ix))*1.1];
       yy = [mean(y(ix)),max(y(ix))*1.1];
       ll{ii} = sprintf('%s (%.0f%%,%.0f%%)',gn(ii),xx(1),yy(1));
       p(ii) = plot(ax_pl,xx(1),yy(1),'ko','MarkerSize',2,'MarkerFaceColor',cmap(ii,:).^2,'MarkerEdgeColor','k');
   end
end

linkaxes([ax_pl,ax_xhist],'x');
linkaxes([ax_pl,ax_yhist],'y');
if ~isempty(lim)
    axis(ax_pl,[lim,lim])
end

axis(ax_xhist,'off')
axis(ax_yhist,'off')

if exist('lg','var')
   yy = ax_pl.YLim(end)*fliplr(linspace(lg(1),lg(2),numel(ll)));
   for r=1:ng
     text(ax_pl,lg(3)*yy(r).^0,yy(r),ll{r},'FontSize',fs);
     text(ax_pl,lg(4)*yy(r).^0,yy(r),char(9679),'color',cmap(r,:).^2,'FontSize',fs*1.5);
   end
end

if exist('axis_labels','var')
    ax_pl.XLabel.String = axis_labels{1};
    ax_pl.YLabel.String = axis_labels{2};
end
ax_pl.Color = [0.85,0.85,0.85];
grid(ax_pl,'on');
if exist('Tilte','var')
text(ax_pl,lim(1),lim(2),Title,'FontSize',18,'FontWeight','bold');
end
if nargout>0
    varargout{1}= ax_pl;
end
%------------- END OF CODE --------------
