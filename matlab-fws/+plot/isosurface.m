function lim = isosurface(ax,L,d,idx,varargin)
% PLOT.ISOSURFACE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 13-Aug-2020 15:10:49
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
isosurface(input01,input02,input03,input04)
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

obj = struct('label',L,'d',{d},'alpha',0.75,'smooth',1,...
    'colour_map',jet(numel(unique(L(:)))),'order',idx,'ax',ax,...
    'EdgeColor','none','facelighting','gouraud',...
    'SpecularColorReflectance',0.2,'DiffuseStrength',0.8,...
    'SpecularExponent',3,'SpecularStrength',0.4);

obj = fws.defaults(obj, varargin);

xmm = d{1};ymm = d{2};zmm = d{3};
[X,Y,Z]= meshgrid(ymm,xmm,zmm);

ix = idx;
hold (ax , 'on')
for ii=1:numel(ix)
    tmp = L == ix(ii);
    if obj.smooth
        tmp = smooth3(tmp,'gaussian',3,obj.smooth);
    end
    fv = isosurface(X,Y,Z,tmp,.5);
    patch(fv,'FaceColor',obj.colour_map(ii,:),'EdgeColor',obj.EdgeColor,...
        'facealpha',obj.alpha,'facelighting',obj.facelighting,...
        'SpecularColorReflectance',obj.SpecularColorReflectance,...
        'DiffuseStrength',obj.DiffuseStrength,'SpecularExponent',obj.SpecularExponent,...
        'SpecularStrength',obj.SpecularStrength,'Parent', obj.ax);
end


view(obj.ax, 3)
daspect(obj.ax, [1 1 1]);
lim = [min(ymm) max(ymm) min(xmm) max(xmm) min(zmm) max(zmm)];
%------------- END OF CODE --------------
