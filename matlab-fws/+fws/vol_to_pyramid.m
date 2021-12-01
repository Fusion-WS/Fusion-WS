function P = vol_to_pyramid(V,G,s,method)
% FWS.RESLICE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 08-Jul-2020 15:11:53
%
% INPUTS:
%    V - Volume 
%    G - Grid object
%    s - Pyramid steps
%
%
% OUTPUT:
%    P - Pyramid cell
%
% EXAMPLES:
%{
reslice(V,G,s)
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
if ~exist('method','var');method='nearest';end
xt = G.mm{2};
yt = G.mm{1};
zt = G.mm{3};
[Xs,Ys,Zs] = meshgrid(xt,yt,zt);
P = {};
for ii=2:s
    xt = xt(1:2:end);
    yt = yt(1:2:end);
    zt = zt(1:2:end);
    [Xt,Yt,Zt] = meshgrid(xt,yt,zt);
    Vt = interp3(Xs,Ys,Zs,V,Xt,Yt,Zt,method);           
    g = G;
    g.mm = {yt,xt,zt};
    g.vx = g.vx*2;
    save.vol(Vt,g,'Filename',sprintf('%s-%i.nii',g.file_name,ii));
    P{ii-1} = {Vt,g};
end


%------------- END OF CODE --------------
