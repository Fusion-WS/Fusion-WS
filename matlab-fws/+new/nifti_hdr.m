function obj = nifti_hdr(V,G,varargin)
% NEW.NIFTI_HDR: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 08-Jul-2020 16:12:29
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
nifti_hdr(input01,input02,input03,input04)
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

G.hdr.Transform.T(eye(size(G.hdr.Transform.T))>0) = [G.vx;1];

obj = struct('Filename',[], 'Filemoddate', datetime, 'Filesize',[],...
             'Description', 'Fusion-Watershed label map', 'ImageSize', size(V),...
             'Datatype', class(V), 'BitsPerPixel',[],'SpaceUnits','Millimeter',...
             'TimeUnits','Second','AdditiveOffset',0,'MultiplicativeScaling',0,...
             'TimeOffset',0,'SliceCode','Unknown','FrequencyDimension',0,...
             'PhaseDimension',0,'SpatialDimension',0,'DisplayIntensityRange',[min(V(:)),max(V(:))],...
             'TransformName','Sform','Transform',G.hdr.Transform,'Qfactor',-1,'raw',[],...
             'Compressed' ,true,'PixelDimensions',abs(G.vx'),'Version', 'NIfTI1');
obj = fws.defaults(obj, varargin);

%------------- END OF CODE --------------
