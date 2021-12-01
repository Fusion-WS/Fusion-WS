function [out,lim] = roi(L,G,varargin)
%% PLOT.ROI: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 30-Jun-2020 18:46:39
%
% INPUTS:
%    L -
%    varargin -
%
%
% OUTPUT:
%    varargout -
%
% EXAMPLES:
%{
[varargout] = roi(L,varargin)
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
obj = struct('label',L,'grid',G,'plane','rs','ellipsoid_radius',4,...
    'font_size',0.02,'colour_map',hot(100),'smooth_factor',...
    3,'table',0,'plot_ids',true,'alpha',0.4);

obj = fws.defaults(obj, varargin);
if ~istable(obj.table)
    obj.table = fws.label_to_table('label',L,'grid',G);
end
obj.volume = L;
obj = fws.plane_to_value(obj);
obj = fws.load_cortex(obj);
[x,y,z,or,az,el] = fws.get_2d_vectors(obj);

hg = figure('Name','tmp','units','pixels','position',[100 100 600 600],'Visible','off','resize','off');clf;
ax = axes('Position',[0,0,1,1],'Ydir','reverse');axis off;
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceColor','w','EdgeColor','none','FaceAlpha',1,'Parent',ax);
view(az,el);daspect([1 1 1]);lim = axis;
tmp = getframe(hg);
out.mask = (rgb2gray(tmp.cdata)~=240).*1;
cla(ax);
plot.parcel_map('ax',ax,'label', obj.label,'grid', obj.grid,...
    'colour_map', obj.colour_map,'order',obj.table.ROIid,...
    'dynamiclight',false,'axislabels',false,'lim',lim,'alpha',obj.alpha);
axis(ax,lim);view(ax,az,el);daspect(ax,[1 1 1]);camlight(ax);
ax = axes('Position',[0,0,1,1],'Ydir','reverse');axis off;
try 
    xyz = obj.table.Peak_Magnitude_XYZ;
catch
    xyz = obj.table.Centre_of_mass_XYZ;
end
if obj.plot_ids
    
    hold(ax,'on')
    cs = obj.ellipsoid_radius;
    tmp = fws.shift_intersecting(xyz,or,cs,0.6);
    xyz = fws.shift_intersecting(xyz,or,cs,0.6);
    for ii=1:size(xyz,1)
        [X,Y,Z] = ellipsoid(xyz(ii,2),xyz(ii,1),xyz(ii,3),cs,cs,cs,20);
        surf(ax,X,Y,Z,'FaceLighting','gouraud','facecolor',obj.colour_map(ii,:).^2,'faceAlpha',1,'edgecolor','none');
    end
    hold(ax,'off')
    axis(ax,lim);view(ax,az,el);daspect(ax,[1 1 1]);
    
    fs = obj.font_size;
    
    ax = axes('Position',[0,0,1,1],'Ydir','reverse');axis off;
    
    ids = num2cell(obj.table.ROIid);
    for ii=1:size(xyz,1)
        t = rgb2lab(obj.colour_map(ii,:));
        if t(1)>80;fontc = 'k';else; fontc = 'w';end
        text(ax,xyz(ii,2),xyz(ii,1),xyz(ii,3),ids(ii),'FontUnits','normalized','FontSize',fs,'FontWeight','bold','HorizontalAlignment','center','color',fontc,'VerticalAlignment','middle')
    end
    view(ax,az,el);axis(ax,lim);daspect(ax,[1 1 1]);
end
tmp = getframe(hg);
out.im = tmp.cdata;
out.alpha = rgb2gray(tmp.cdata)~=240;

%% cortex
clf(hg);
ax = axes('Position',[0,0,1,1],'Ydir','reverse');axis off;
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceVertexCData',1-obj.AO,'FaceColor','interp','EdgeColor','none','FaceAlpha',1,'Parent',ax);
axis(ax,lim);view(ax,az,el);daspect(ax,[1 1 1]);camlight(ax);colormap gray;
tmp = getframe(hg);
out.cortex = tmp.cdata;
cla(ax)
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceVertexCData',obj.AO,'FaceColor','interp','EdgeColor','none','FaceAlpha',1,'Parent',ax);
axis(ax,lim);view(ax,az,el);daspect(ax,[1 1 1]);
tmp = getframe(hg);
out.Ao = rgb2gray(tmp.cdata);
cla(ax)
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceColor','k','EdgeColor','none','FaceAlpha',1,'Parent',ax);
axis(ax,lim);view(ax,az,el);daspect(ax,[1 1 1]);
colormap gray
axis(lim);
light
tmp = getframe(hg);
out.Sp = rgb2gray(tmp.cdata);


close(hg)



end


%------------- END OF CODE --------------
