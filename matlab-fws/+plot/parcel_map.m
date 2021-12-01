function lim = parcel_map(varargin)
% PLOT.PARECL_MAP: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 02-Jul-2020 17:43:00
%
% INPUTS:
%    L - labelmp
%    input02 -
%    input03 -
%    input04 -
%
%
% OUTPUT:
%
% EXAMPLES:
%{
parecl_map(input01,input02,input03,input04)
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


% Input handling
obj = struct('label',false,'grid',false,'alpha',0.75,'smooth',3,...
    'colour_map',false,'order',false,'ax',false,...
    'EdgeColor','none','facelighting','gouraud',...
    'SpecularColorReflectance',0.2,'DiffuseStrength',0.8,...
    'SpecularExponent',3,'SpecularStrength',0.4,...
    'dynamiclight',true,'axislabels',true,'lim',false);

obj = fws.defaults(obj, varargin);

if numel(obj.label)==1
    error('Label map not found')
end

if islogical(obj.ax)
    obj.ax=gca;
end

if numel(obj.alpha)==1
    obj.alpha = ones(max(obj.label(:)),1)*obj.alpha;
end

if islogical(obj.colour_map) && ~obj.colour_map
    obj.colour_map=jet(numel(unique(obj.label(obj.label>0))));
end

if  islogical(obj.grid)
    d = arrayfun(@(x) 1:x,size(obj.label),'un',0);
else
    d = obj.grid.mm;
end

xmm = d{1};ymm = d{2};zmm = d{3};
[X,Y,Z]= meshgrid(ymm,xmm,zmm);
if obj.order;ix = obj.order;else;ix=1:max(obj.label(:));end

if size(obj.colour_map,1)==1
    obj.colour_map = ones(numel(ix),3).*obj.colour_map;
end


hold (obj.ax , 'on')
for ii=1:numel(ix)
    tmp = obj.label == ix(ii);
    if obj.smooth>0
        tmp = smooth3(tmp,'gaussian',obj.smooth,3);
    end
    fv = isosurface(X,Y,Z,tmp,.5);
    patch(fv,'FaceColor',obj.colour_map(ii,:),'EdgeColor',obj.EdgeColor,...
        'facealpha',obj.alpha(ii),'facelighting',obj.facelighting,...
        'SpecularColorReflectance',obj.SpecularColorReflectance,...
        'DiffuseStrength',obj.DiffuseStrength,'SpecularExponent',obj.SpecularExponent,...
        'SpecularStrength',obj.SpecularStrength,'Parent', obj.ax);
end


view(obj.ax, 3)
daspect(obj.ax, [1 1 1]);
if ~obj.lim
    lim = [min(ymm) max(ymm) min(xmm) max(xmm) min(zmm) max(zmm)];
else 
    lim = obj.lim;
end
axis(obj.ax, lim);

obj.ax.YDir = 'reverse';
obj.ax.Color = [0.85,0.85,0.85];
if obj.axislabels
    pos = [-110,8,-64;2,65,-64;-110,-76,9;70,8,-64];
    s = [50,50,4;50,4,50];
    lr = fws.bevel_text('string',"L R");
    lr.vertices = fws.rotate_vertices(lr.vertices,'plane',"z",'angle',270);
    patch('parent',obj.ax,'Faces', lr.faces, 'Vertices', lr.vertices.*s(1,:)+pos(1,:),'FaceAlpha',0.5,'EdgeColor','none');
    pa = fws.bevel_text('string',"P A");
    patch('parent',obj.ax,'Faces', pa.faces, 'Vertices', pa.vertices.*s(1,:)+pos(2,:),'FaceAlpha',0.5,'EdgeColor','none');
    is = fws.bevel_text('string',"I S");
    is.vertices = fws.rotate_vertices(is.vertices,'plane',["y","z","x"],'angle',[90,90,180]);
    patch('parent',obj.ax,'Faces', is.faces, 'Vertices', is.vertices.*s(2,:)+pos(3,:),'FaceAlpha',0.5,'EdgeColor','none');    
    rl = fws.bevel_text('string',"R L");
    rl.vertices = fws.rotate_vertices(rl.vertices,'plane',"z",'angle',90);
    patch('parent',obj.ax,'Faces', rl.faces, 'Vertices', rl.vertices.*s(1,:)+pos(4,:),'FaceAlpha',0.5,'EdgeColor','none');
end

axis(obj.ax,'tight')
lim = int8([obj.ax.XLim,obj.ax.YLim,obj.ax.ZLim].*1.05);
grid(obj.ax,'on')


if obj.dynamiclight
    c = camlight(obj.ax,'headlight');
    c.Style = 'infinite';
    h = rotate3d(obj.ax);
    h.Enable = 'on';
    h.ActionPostCallback = @RotationCallback;
end
hold (obj.ax , 'off')
    function RotationCallback(~,~)
        c = camlight(c,'headlight');
    end

end

%------------- END OF CODE --------------
