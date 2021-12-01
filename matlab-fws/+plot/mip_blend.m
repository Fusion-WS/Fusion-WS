function im = mip_blend(ax,obj,varargin)
% PLOT.MIP_BLEND: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 06-Aug-2020 13:56:14
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
mip_blend(input01,input02,input03,input04)
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

obj = struct('cortex',obj.cortex,'img',obj.img,'alpha',obj.alpha,...
             'mask',obj.mask,'Ao',obj.Ao,'Sp',obj.Sp,'gf',2);

obj = fws.defaults(obj, varargin);


bkg = [0.90,0.90,0.98];
ax0 = axes('Position',ax.Position);
ax1 = axes('Position',ax.Position);
ax2 = axes('Position',ax.Position);
ax3 = axes('Position',ax.Position);
m = double(obj.mask);
mx = sum(m')>0;my = sum(m)>0;
gf = obj.gf;
img = obj.img(mx,my,:);
alpha = obj.alpha(mx,my);
cortex = obj.cortex(mx,my,:);
Spec = double(obj.Sp(mx,my))./255;
AO = double(obj.Ao(mx,my))./255;
mask = imerode(m,[0 1 0; 1 1 1; 0 1 0]);
imagesc(ax0,cat(3,m(mx,my)*bkg(1),m(mx,my)*bkg(2),m(mx,my)*bkg(3)),'AlphaData',imgaussfilt(mask(mx,my),gf));
imagesc(ax1,img,'AlphaData',alpha);
imagesc(ax2,cortex,'AlphaData',AO.*m(mx,my)*0.5);
linkaxes([ax0,ax1,ax2],'xy');
axis(ax, 'off')
axis(ax0,'off');axis(ax0,'image');
axis(ax1,'off');axis(ax1,'image');
axis(ax2,'off');axis(ax2,'image');
axis(ax3,'off');axis(ax3,'image');
if nargout
    tmp = getframe(ax);
    im = tmp.cdata;
end




%------------- END OF CODE --------------
end