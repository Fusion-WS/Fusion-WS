function Output = mip(Y,G,varargin)
%% PLOT.MIP: One line description of what the function or script performs
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
%    Y - 
%    varargin - 
%
%
% OUTPUT:
%    varargout - 
%
% EXAMPLES:
%{
[varargout] = mip(Y,varargin)
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
% Defaults
%{

obj.plane = 'rs';
obj.scale_factor = 3;
obj.smooth_factor = 3;

%}

obj = struct('volume',Y,'grid',G,'plane','rs',...
             'color',hot(100),'smooth_factor',3,'scale_factor',3);
obj = fws.defaults(obj, varargin);
obj = fws.plane_to_value(obj);
obj = fws.load_cortex(obj);
[x,y,z,or,az,el] = fws.get_2d_vectors(obj);
hg = figure('Name','tmp','units','pixels','position',[100 100 600 600],'Visible','off','resize','off');clf;
ax = axes('Position',[0,0,1,1],'Ydir','reverse');
axis off;
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceVertexCData',1-obj.AO,'FaceColor','interp','EdgeColor','none','FaceAlpha',1,'Parent',ax)   ;
view(az,el);
daspect([1 1 1]);
colormap gray;
light;
lim = axis;
tmp = getframe(hg);
Output.cortex = tmp.cdata;
cla(ax)
if size(Y,4)>1
    plot.slice_stack(ax,or,z,x,y,obj.volume,obj.color,obj.smooth_factor,obj.scale_factor)
else 
    plot.slice_merge(ax,or,z,x,y,obj.volume,obj.color,obj.smooth_factor,obj.scale_factor)
end
%
axis(lim);
tmp = getframe(hg);
Output.img = tmp.cdata;
Output.alpha = rgb2gray(tmp.cdata)~=240;
cla(ax)
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceColor','w','EdgeColor','none','FaceAlpha',1,'Parent',ax);
axis(lim);
tmp = getframe(hg);
Output.mask = (rgb2gray(tmp.cdata)~=240).*1;
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceVertexCData',obj.AO,'FaceColor','interp','EdgeColor','none','FaceAlpha',1,'Parent',ax);
axis(lim);
tmp = getframe(hg);
Output.Ao = rgb2gray(tmp.cdata);
cla(ax)
patch('Vertices',obj.vertices,'Faces',obj.faces,'FaceColor','k','EdgeColor','none','FaceAlpha',1,'Parent',ax);
view(az,el);axis 'off';daspect([1 1 1]);axis(lim);colormap gray
axis(lim);
light
tmp = getframe(hg);
Output.Sp = rgb2gray(tmp.cdata);
close(hg)

%------------- END OF CODE --------------

end




