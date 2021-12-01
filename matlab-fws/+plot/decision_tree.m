function decision_tree(ax,tree,nw,nh,cmap,lw)
%% PLOT.DECISIONTREE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 20-Apr-2020 17:05:57
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
decisionTree(input01,input02,input03,input04)
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
PI = tree.CutPredictorIndex;
NodeNames = tree.CutVar;
cutpoint = tree.CutPoint;
parentnode = tree.Parent;
fit = tree.NodeMean;
children = tree.Children;
connector_width = fws.scale(tree.NodeSize,'mn',lw(1),'mx',lw(2));
% Get coordinates of nodes
isleaf = PI==0;
isbranch = ~isleaf;
[X,Y] = layouttree(tree,isleaf);
%plot branches 

hold(ax, 'on')

%plot connectors 
for ii=1:length(children)
    idx = find(children(ii,:));
    if ~isempty(idx)
        for k = 1:numel(idx)
            ix = children(ii,idx(k));
            xx = [X(ii); X(ix)];
            yy = [Y(ii)-nh/2; Y(ix)+nh/2];
            [cx,cy] = plot.connector(xx,yy,0.7,3);% x = two points  y =two points and center = defualt is the middle point
            patch([cx(:);nan],[cy(:);nan],'k','linewidth',connector_width(ix),'edgealpha',0.5,'edgecolor',[0.5,0.5,0.5],'parent', ax);
        end
    end
end

for b=find(isbranch)'
    ix = PI(b);
    P = fws.round_rec(X(b)-nw/2,Y(b)-nh/2,nw,nh,0.1);
    patch(P(:,1),P(:,2),cmap(ix,:),'FaceAlpha',1,'parent',ax,'edgecolor','k');
    c =  subsref({'w'; 'k'}, substruct('{}', {1.0*(unique(rgb2gray(cmap(ix,:)))>0.6) + 1}));
    text(X(b),Y(b),NodeNames{b},'parent',ax,'HorizontalAlignment','center','VerticalAlignment','middle','FontUnits','normalized','FontSize',0.07,'Color', c)
end

%plot leaves 
for b=find(isleaf)'
    ix = PI(parentnode(b));
    P = fws.round_rec(X(b),Y(b),nh,nh,0.2,2);
    patch(P(:,1),P(:,2),[0.9,0.9,0.9],'FaceAlpha',1,'parent',ax,'edgecolor','k');
    text(X(b),Y(b),sprintf('%.2f',fit(b)),'parent',ax,'HorizontalAlignment','center','VerticalAlignment','middle','FontUnits','normalized','FontSize',0.07,'Color', 'k')
end



%plot split rule for each branch
for b=find(isbranch)'
    idx = find(children(b,:));
    ix = children(b,idx(1));
    xx = X(b);% we want the split rule to be below 
    yy = quantile([Y(b); Y(ix)],0.575);
    P = fws.round_rec(xx,yy,0.75*nw,nh*0.5,0.1,2);
    patch(P(:,1),P(:,2),[1,1,1],'FaceAlpha',0.8,'parent',ax,'edgecolor','k');
    text(xx,yy,sprintf('> %.2f >=',cutpoint(b)),'parent',ax,'HorizontalAlignment','center','VerticalAlignment','middle','FontUnits','normalized','FontSize',0.05,'Color', 'k')
end
axis(ax,'tight')
axis(ax,'off')
hold(ax, 'off')


end


function [X,Y] = layouttree(tree,isleaf)
%LAYOUTTREE Select x,y coordinates of tree elements.
n = size(tree.Children,1);
X = zeros(n,1);
Y = X;
layoutstyle = 1;

% Plot top node on one level, its children at next level, etc.
for j=1:n
    p = tree.Parent(j);
    if p>0
        Y(j) = Y(p)+1;
    end
end
if layoutstyle==1
    % Layout style 1
    % Place terminal nodes, then put parents above them
    
    % First get preliminary placement, used to position leaf nodes
    for j=1:n
        p = tree.Parent(j);
        if p==0
            X(j) = 0.5;
        else
            dx = 2^-(Y(j)+1);
            if j==tree.Children(p,1)
                X(j) = X(p) - dx;
            else
                X(j) = X(p) + dx;
            end
        end
    end
    
    % Now make leaf nodes equally spaced, preserving their order
    leaves = find(isleaf);
    nleaves = length(leaves);
    [~,b] = sort(X(leaves));
    X(leaves(b)) = (1:nleaves) / (nleaves+1);
    
    % Position parent nodes above and between their children
    for j=max(Y):-1:0
        a = find(~isleaf & Y==j);
        c = tree.Children(a,:);
        X(a) = (X(c(:,1))+X(c(:,2)))/2;
    end
else
    % Layout style 2
    % Spread out the branch nodes, somewhat under their parent nodes
    X(Y==0) = 0.5;
    for j=1:max(Y)
        vis = (Y==j);                  % real nodes at this level
        invis = (Y==(j-1) & isleaf);   % invisible nodes to improve layout
        nvis = sum(vis);
        nboth = nvis + sum(invis);
        x = [X(tree.Parent(vis))+1e-10*(1:nvis)'; X(invis)];
        [xx,xidx] = sort(x);
        xx(xidx) = 1:nboth;
        X(vis) = (xx(1:nvis) / (nboth+1));
    end
end

k = max(Y);
Y = 1 - (Y+0.5)/(k+1);
end
%------------- END OF CODE --------------
