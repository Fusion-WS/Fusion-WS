function radial_scatter(yc,yp,labels,cmap,gmap,ax,pt,fs,cs)
% PLOT.RADIAL_SCATTER: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 22-Sep-2020 04:33:40
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
radial_scatter(input01,input02,input03,input04)
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
label = 1;
disp('');



if ~exist('ax','var')
    figure;
    ax = axes('position',[0.25 0.25 0.5 0.5]);
end

labels = labels(:);
if size(yc,2)==1
    g = grp2idx(yc);
    Y = yc;
else 
    g = grp2idx(yc(:,1)); % ground truth
    Y = yc(:,1);
    gp = grp2idx(yc(:,2)); % predicted class
end
nc = numel(categories(Y));
[~,n] = size(yp);

if ~exist('pt','var');pt = 1;end
if ~exist('cs','var');cs = 0.01;end
if ~exist('cmap','var');cmap = jet(n);end
if ~exist('gmap','var');gmap = parula(nc);end

ang=0.5*pi:2*pi/n:2.5*pi;
X=cos(ang);
Y=sin(ang);
[cx,cy]=new.circle(0,0,1);% get a unit circle
plot(cx,cy,'k-','linewidth',0.5,'parent', ax);hold on
for ii=1:n
    xx = X(ii);yy = Y(ii);
    [cx,cy]=new.circle(xx,yy,cs);% get small circles
    plot(cx,cy,'k','linewidth',1,'parent', ax)
    patch(cx,cy,'k','FaceAlpha',1,'facecolor',cmap(ii,:),'parent', ax);% plot the nodes
    if label
    t = atan2(yy,xx);
    r = subsref({struct('rot', t*180/pi,'dir','left'); struct('rot', 180*(t/pi + 1),'dir','right')}, substruct('{}', {(abs(t) > pi/2)+ 1}));
    text(1.12*xx,1.12*yy,labels{ii},'FontWeight','bold','FontSize',fs,'HorizontalAlignment',r.dir,'interpreter','none','parent', ax,'rotation', r.rot)
    end
end





x = cos(ang(1:end-1))*yp';
y = sin(ang(1:end-1))*yp';

% y = fft(M);                               % Compute DFT of x
% m = abs(y);                               % Magnitude
% p = unwrap(angle(y));                     % Phase
hold on
if pt
    pts = categories(yc);
end

if ~exist('gp','var')
    for ii=1:nc
        ix = g==ii;
        [cx,cy]=new.circle(x(ix)',y(ix)',cs*1.25);% get small circles
        c =  subsref({'w'; 'k'}, substruct('{}', {1.0*(unique(rgb2gray(gmap(ii,:)))>0.45) + 1}));
        patch(cx,cy,'k','FaceAlpha',0.85,'facecolor',gmap(ii,:),'parent', ax,'edgecolor','none');% plot the nodes
        if pt
            text(x(ix) ,y(ix),pts{ii},'parent', ax,'HorizontalAlignment','center','FontWeight','bold','VerticalAlignment','middle','Color',c,'FontSize',fs*0.65);
        end    
    end
else
   ix = (gp == g);
   for ii=1:nc
        ix1 = ((g==ii).*ix)>0;
        if any(ix1)
           [cx,cy]=new.circle(x(ix1),y(ix1),cs*1.25);% get small circles
           patch(cx,cy,'k','FaceAlpha',0.75,'facecolor',gmap(ii,:),'parent', ax);% plot the nodes
        end
   end
   for ii=1:nc
        ix1 = ((g==ii).*~ix)>0;
        if any(ix1)
           [cx,cy]=new.circle(x(ix1),y(ix1),cs*0.75);% get small circles
           patch(cx,cy,'k','FaceAlpha',0.2,'facecolor',gmap(ii,:),'parent', ax);% plot the nodes
        end
    end 
end


axis off;
axis tight;
daspect(ax,[1,1,1])
%------------- END OF CODE --------------
