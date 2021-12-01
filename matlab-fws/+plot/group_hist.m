function group_hist(X,gp,lim,cmap,labels,st,ax,fig,leg,hv)
% PLOT.GROUP_HIST: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 21-Sep-2020 22:38:20
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
group_hist(input01,input02,input03,input04)
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
if ~exist('gp','var');gp = repmat(categorical(1),size(X));end
ng = numel(categories(gp));
if ~exist('labels','var');lg = categories(gp);
else; lg =labels;
end

if ~exist('cmap','var');cmap = jet(ng);end
if ~exist('st','var');st = round(range(X)/10000,5);end
% 
% start by getting the quartiles 
Q = zeros(ng,10);% first,median,third,IQR,lower inner fence, lower outer fence ,upper inner fence ,upper outer fence,lower whiskers,upper whiskers 
for ii=1:numel(lg)
    tmp = X(gp == lg(ii));
    if ~isempty(tmp)
        Q(ii,1:3) = quantile(tmp,[0.25 0.50 0.75]);
        Q(ii,4) = range(Q(ii,1:3));
        Q(ii,5:8) = [Q(ii,1)-Q(ii,4)*1.5,Q(ii,1)-Q(ii,4)*3,Q(ii,3)+Q(ii,4)*1.5,Q(ii,3)+Q(ii,4)*3];
        Q(ii,9:10) = [min(tmp(tmp>=Q(ii,5))),max(tmp(tmp<=Q(ii,7)))];
    end
end


%x = x*100;w=w*100;
if ~exist('ax','var');if ~exist('fig','var');figure();else ;figure(fig);end;end
if ~exist('fc','var');fc=0.02;end
if ~exist('ax','var');ax = axes('position',[0.2,0.2,0.7,0.6]);end
   
for ii=1:numel(lg)
    xt =  fws.winsorize(X(gp == lg(ii)));
    if ~isempty(xt)
        pd = fitdist(xt,'Kernel');
        splt = range(xt)*0.95;
        xi = median(xt)-splt:st:median(xt)+splt;
        f = pdf(pd,xi);
        patch(xi,fws.scale(f,'mn',ii-0.35,'mx',ii+0.35),cmap(ii,:),'FaceAlpha',0.5,'Edgecolor',max(cmap(ii,:)-0.5,0),'parent',ax);
    end
end
ax.YTick = 1:numel(lg);
if ~exist('lim') || isempty('lim');lim = ax.XLim;end
axis(ax,[lim,0.5,numel(lg)+0.5]);
ax.YTickLabel = lg;
grid on
%daspect(ax,[1,1,1])
ax.XTickLabel = num2cell(ax.XTick);  
    
if exist('leg','var');legend(labels);end
end
%------------- END OF CODE --------------
