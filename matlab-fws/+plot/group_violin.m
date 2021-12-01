function B = group_violin(X,gp,cmap,ax,w,boxx)
%% PLOT.GPVIOLIN: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 11-Sep-2019 10:34:58
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
gpviolin(input01,input02,input03,input04)
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
d = size(X);
gp = categorical(gp);
if ~exist('gap','var');gap = 0.2;end
if ~exist('cmap','var');cmap = jet(numel(categories(gp)));end
if ~exist('lim','var');lim = [min(X(:))*1.005,max(X(:))*1.005];end
if isempty(ax)
    if ~exist('fig','var');figure(1);else ;figure(fig);end
end
if ~exist('w','var');w = 0.15;end
if ~exist('st','var');st = round(range(X)/10000,5);end
if ~exist('boxx','var');boxx = 1;end

if ~exist('xl','var');xl = 1;end
if ~exist('ax','var')||isempty(ax);ax = gca;end
if ~exist('order','var');order = categories(gp);end

% start by getting the quartiles
% start by getting the quartiles
Quant = @(x) quantile(x,[0 0.25 .50 0.75 1]);
B = table({1},{1},{1},{1},'VariableNames',{'group','quantile','fence','whiskers'});

Q = zeros(numel(order),10);% first,median,third,IQR,lower inner fence, lower outer fence ,upper inner fence ,upper outer fence,lower whiskers,upper whiskers
for ii=1:numel(order)
    tmp = X(gp==order{ii});
    Q(ii,1:3) = quantile(tmp,[0.25 0.50 0.75]);
    Q(ii,4) = range(Q(ii,[1,3]));
    Q(ii,5:8) = [Q(ii,1)-Q(ii,4)*1.5,Q(ii,1)-Q(ii,4)*3,Q(ii,3)+Q(ii,4)*1.5,Q(ii,3)+Q(ii,4)*3];
    Q(ii,9:10) = [min(tmp(tmp>=Q(ii,5))),max(tmp(tmp<=Q(ii,7)))];
    B.group{ii} = order{ii};
    B.quantile{ii} = round(Quant(tmp),2);
    B.fence{ii}  = round(Q(ii,5:8),2);
    B.whiskers{ii} = round(Q(ii,9:10),2);
end



hold(ax,'on');

for c=1:numel(order)
    xt =  fws.winsorize(X(gp==order{c}));
    pd = fitdist(xt,'Kernel');
    splt = range(xt)*0.95;
    xi = median(xt)-splt:st:median(xt)+splt;
    f = pdf(pd,xi);
    xi(f<1e-3)=[];
    f(f<1e-3)=[];
    f = [f,fliplr(-f)];
    f = fws.scale(f,'mn',c-w,'mx',c+w);
    patch(f,[xi,fliplr(xi)],cmap(c,:).^0.5,'FaceAlpha',0.5,'Edgecolor',max(cmap(c,:)-0.5,0),'parent',ax);
    if boxx
        P = fws.round_rec(c-w/2,Q(c,1),w,Q(c,4),0.02); % get curved box patch
        patch(P(:,1),P(:,2),cmap(c,:),'FaceAlpha',0.75,'parent',ax,'edgecolor','none');
        line(P(:,1),P(:,2),'linewidth',0.5,'color','k','parent',ax)
        line([c-w/2,c+w/2],[Q(c,2),Q(c,2)],'linewidth',1,'color','k','parent',ax);
        line([c,c],[Q(c,3),Q(c,10)],'linewidth',1,'color','k','parent',ax);
        line([c-w/4,c+w/4],[Q(c,10),Q(c,10)],'linewidth',1,'color','k','parent',ax);
        line([c,c],[Q(c,1),Q(c,9)],'linewidth',1,'color','k','parent',ax);
        line([c-w/4,c+w/4],[Q(c,9),Q(c,9)],'linewidth',1,'color','k','parent',ax);
    end
    
end
axis(ax,[0.25 numel(order)+0.75 ylim])
ax.XTick = 1:numel(order);
if xl
    ax.XTickLabel = order;
    ax.XTickLabelRotation=-45;
else
    ax.XTickLabel = [];
end




%------------- END OF CODE --------------
