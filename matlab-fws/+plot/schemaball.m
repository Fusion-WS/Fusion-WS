function varargout = schemaball(ax,adj,varargin)
%% PLOT.SCHEMABALL: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 16-Jul-2018 10:03:03
%
%% INPUTS:
%    ax - axis object 
%    A - Adjceny matrix (symmetric)
%    varargin - paird paramaters
%
%% EXAMPLES:
%{
n = 15;
adj = randn(n);
adj(eye(n)>0) = 0;
adj(abs(adj)<1.5)=0;
fws.sym_adj(adj,'mean')

figure(); plot.schemaball(gca,adj)
%}
%
%% DEPENDENCIES:
%
% This file is part of fusion toolbox
% fusion toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% fusion toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with fusion toolbox. If not, see <http://www.gnu.org/licenses/>.
%------------- BEGIN CODE --------------
%

%% Parse inputs

% Use gca if no axis is supplied
if isempty(ax)
   ax = gca; 
end

if ~ismatrix(adj) || (size(adj, 1) ~= size(adj, 2))
   error('Error: adj input must be a square matrix.')
end

% Number of nodes
nn = size(adj,1);

% Replace NaN's with 0 (maybe on diagonal)
adj(isnan(adj))=0;

% Define object defaults
obj = struct("plot_group_labels",false,"plot_labels",true,"side","bi"...
             ,"groups",{ones(nn,1)},"gap_size",4,"labels",{repmat({''},nn,1)}...
             ,"lim",false,"mode","complete","group_labels",[]...
             ,"link_color",hot(100),"group_color",jet(nn),"group_alpha",1 ...
             ,"link_width",[1,10],"line_width",8,"link_alpha",[0.3,0.8],"width_scale_limit",false...
             ,"font_size",15,"text_shift",1.1 ,'node_line_width',1.5...
             ,"node_scale",'density',"node_size",[0.01,0.1]...
             ,"degree",zeros(nn,1),"density",zeros(nn,1)...
             ,"interpreter",'none',"node_scale_limit",false...
             ,"clim",[round(min(adj(:))) round(max(adj(:)))]...
             ,"colorbar",true);

% Overwrite defaults with user options
obj = fws.defaults(obj,varargin);         
         

%% Sort the data into the groups

% Define index
[index,obj.index] = sort(obj.groups);

% Sort data groups, labels and colours
adj = adj(obj.index, obj.index,:);
obj.groups = obj.groups(obj.index);
obj.labels = obj.labels(obj.index);
obj.group_color = obj.group_color(double(index),:);

% group name and how many groups.
groups = unique(obj.groups);
ng = numel(groups);

%% Select tail(s) of interest
if ~obj.lim
    switch obj.side
        case 'positive';adj(adj<0)=0;obj.lim =[0,1];
        case 'negative';adj(adj>0)=0;obj.lim =[0,1];
        case 'bi';obj.lim =[-1,1];
    end
end

%% Pull node density over the classes (adj 3rd dim)
for ii=1:size(adj,3)
    obj.degree = obj.degree+squeeze(sum(adj(:,:,ii)~=0))'; % degree
    obj.density = obj.density+squeeze(sum(adj(:,:,ii)))';
end

% Put nodes and their identitfies into in a table 
TT = table((1:nn)',obj.labels,obj.groups,obj.group_color,obj.index,obj.degree,obj.density,'VariableNames',{'id','labels','groups','group_color','index','degree','density'});
switch obj.mode 
    case 'minimal' % if we only want nodes that have links with weights
        if nnz(obj.degree~=0) % if there are any links proceed
            ix1 = find(sum(obj.degree~=0,2)>0);
            TT = TT(ix1,:);
            TT.id = (1:height(TT))';
            ix = sum(obj.degree~=0,2)>0;
            tmp = zeros(nnz(ix),nnz(ix),size(adj,3));
            for ii=1:size(adj,3)
                tmp(:,:,ii) = adj(ix,ix,ii);   
            end
            adj = tmp;
            ng =  numel(unique(TT.groups));
        end
        nn= size(adj,1);
end


% if there are any group gaps add them
if ng > 1
    
    % Gap size between groups
    gap = ceil(nn/(ng*obj.gap_size));

    % Find boundaries between groups 
    ix  = [0,find(diff(double(TT.groups)))',height(TT)];
    T  = cell2table(cell(0,width(TT)), 'VariableNames', TT.Properties.VariableNames);
    
    % add gaps between each group 
    for ii=1:numel(ix)-1
        tmp = table(0,{''},categorical("null"),NaN(1,3),0,TT.degree(1,:).^0-1,TT.degree(1,:).^0-1,'VariableNames',TT.Properties.VariableNames);
        T = [T;repmat(tmp,gap,1);TT(ix(ii)+1:ix(ii+1),:)]; 
    end
    TT = T;

end

% Number of nodes (visble + invisible) on our ball
n = height(TT);

% Coordinates in radians for n equally spaces points
rad = linspace(0.5*pi,2.5*pi,n+1);
X=cos(rad); Y=sin(rad);

% Add to TT table
TT.rad = rad(2:end)';
TT.X = X(2:end)';
TT.Y = Y(2:end)';


%% construct links table

% define each links table
links  = cell2table(cell(0,7), 'VariableNames', {'n1','n2','rad1','rad2','w','class','cmap'});

% For each adjacency (2D) matrix
for ii=1:size(adj,3)  
    
    Al = adj(:,:,ii)~=0;% get links
    Al(tril(true(size(Al)),0)) = 0; %  make sure we are getting them once
    
    Aw = adj(:,:,ii);% get weights
    [ixI,ixJ] = find(Al); % convert index

    for jj=1:numel(ixJ) % Map each weight to a colour and add to links table
        nc = fws.value_to_cmap(obj.link_color,[obj.clim(:); Aw(ixI(jj),ixJ(jj))]);
        tmp  = table(ixI(jj),ixJ(jj),TT.rad(TT.id==ixI(jj)),TT.rad(TT.id==ixJ(jj)),Aw(ixI(jj),ixJ(jj)),ii,nc(end,:),'VariableNames', {'n1','n2','rad1','rad2','w','class','cmap'});
        links = [links;tmp];
    end
    
end

% Scale the link widths and alphas using their weight
if obj.width_scale_limit
    sw = fws.scale([abs(links.w); obj.width_scale_limit(:)],'mn',obj.link_width(1),'mx',obj.link_width(2)); 
    links.width = sw(1:end-numel(obj.width_scale_limit));
else
    links.width = fws.scale(abs(links.w),'mn',obj.link_width(1),'mx',obj.link_width(2)); 
end


links.alpha = fws.scale(abs(links.w),'mn',obj.link_alpha(1),'mx',obj.link_alpha(2));

% Sort table by weight so that largest (abs.) weights drawn last,
links = sortrows(links,'w','ComparisonMethod','abs');


%% Plotting: links
hold on
for jj=1:height(links)
    [x,y] = new.arc(links.rad1(jj),links.rad2(jj));
    patch([x(:);nan],[y(:);nan],'k','linewidth',links.width(jj),'edgealpha',links.alpha(jj),'edgecolor',links.cmap(jj,:),'parent', ax);
end

%% Plotting: group arcs

if ng==1 % Use a complete circle if there is 1 group (aka, no groupings)
    [cx,cy]=new.circle(0,0,1);% get a unit circle
    patch([cx';NaN],[cy';NaN],'k','linewidth',obj.line_width,'edgealpha',obj.group_alpha,'edgecolor','k','parent', ax);
else
    [cx,cy]=new.circle(0,0,1,height(TT)*10);% get a unit circle
    cx = [cx,cx]; cy = [cy,cy];
    
    for ii=1:numel(groups) % Plot an arc and label for each group
        if groups(ii)~='null' % Skip null's to create seperation between groups
            ix = find(TT.groups==groups(ii)); % Index nodes in this group

            if ~isempty(ix)
                patch([cx(ix(1).*10-2:ix(end).*10+2)';nan],[cy(ix(1).*10-2:ix(end).*10+2)';nan],'k','linewidth'...
                ,obj.line_width,'edgealpha',obj.group_alpha,'edgecolor',TT.group_color(ix(1),:),'parent', ax);

                if obj.plot_group_labels
                      t = mean(TT.rad(ix));% Find group middle point
                      xx=cos(t); yy=sin(t); % get middle x,y coordinate
                      r = subsref({struct('rot', t*180/pi,'dir','left'); struct('rot', 180*(t/pi + 1),'dir','right')}, substruct('{}', {(abs(t) > pi/2)+ 1}));
                      text(obj.text_shift*xx,obj.text_shift*yy,strrep(char(obj.group_labels(ii)), ' ', '\newline'),'rotation', r.rot,'fontsize',obj.font_size,'HorizontalAlignment',r.dir,'interpreter',obj.interpreter,'parent', ax)
                end
            end
        end
    end
end


%% Plotting: nodes

% Work out what the node size will represent
switch obj.node_scale
    case 'density'; degree = TT.density;
    case 'degree'; degree = TT.degree;
end

% Scale the node sizes
sw = fws.scale(degree,'mn',obj.node_size(1),'mx',obj.node_size(2));

if obj.node_scale_limit
    sw = fws.scale([degree;obj.node_scale_limit],'mn',obj.node_size(1),'mx',obj.node_size(2));
    sw = sw(1:end-numel(obj.node_scale_limit));
end

% For each node
tmp = find(TT.groups~='null');
[~,tmpIx]=sort(sw(tmp),'descend');
for ii = tmp(tmpIx)'
    % Pull the x,y coordinates for the node
    yy = TT.Y(ii); xx = TT.X(ii); 

    % Plot a node circle on the xx,yy
    [cx,cy]=new.circle(xx,yy,sw(ii));
    patch(cx,cy,'k','FaceAlpha',1,'facecolor',TT.group_color(ii,:).^0.5,'parent', ax,'LineWidth',obj.node_line_width);% plot the nodes 

    % Node text labels
    if obj.plot_labels
        t = atan2(yy,xx);
        r = subsref({struct('rot', t*180/pi,'dir','left'); struct('rot', 180*(t/pi + 1),'dir','right')}, substruct('{}', {(abs(t) > pi/2)+ 1}));
        if TT.degree(ii)
            text(obj.text_shift*xx,obj.text_shift*yy,TT.labels{ii},'FontWeight','bold','Color',TT.group_color(ii,:).^2,'rotation', ...
            r.rot,'fontsize',obj.font_size,'HorizontalAlignment',r.dir,'Interpreter',obj.interpreter,'parent', ax);
        else 
            text(obj.text_shift*xx,obj.text_shift*yy,TT.labels{ii},'rotation',r.rot,'Color',[0.5,0.5,0.5],...
            'fontsize',obj.font_size*0.8,'HorizontalAlignment',r.dir,'Interpreter',obj.interpreter,'parent', ax);
        end
    end
end

%% Tidy up the axes
axis(ax,[-1.25,1.25,-1.25,1.25]);
axis(ax, 'off','square')
hold off


if obj.colorbar
    cax = axes('Position', [ax.Position(3)+(ax.Position(4)*0.4) ax.Position(2)+(ax.Position(4)*0.25) 0.025 ax.Position(4)*0.5],...
               'YAxisLocation','right');
    cix = linspace(obj.clim(2),obj.clim(1),100)';
    imagesc(cax, cix); colormap(cax, obj.link_color)
    set(cax, 'XTick',[],'YAxisLocation','right','LineWidth',1.5,...
        'YTick',[1 50 100],'YTickLabel',[obj.clim(2) median(obj.clim) obj.clim(1)])
end



%% output
for ii=1:nargout
    switch ii
        case 1;varargout{1} = obj;
        case 2;varargout{2} = links;
        case 3;varargout{3} = TT;
        case 4;varargout{4} = adj;
    end
end

end
%------------- END OF CODE --------------