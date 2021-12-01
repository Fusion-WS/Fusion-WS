function slice_merge(ax,or,st,x,y,D,cmap,sm,sc)
% PLOT.SLICE_STACK: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 17-Jul-2020 10:40:44
%
% INPUTS:
% or = orientation 1-3
% st = slice coardinates
% x,y = original coardinates vectors
% D = intensity volume
% cmap = colour map
% gh  = figure handle
% sm = smooth factor 1-5 recomended
% sc = scale factor 1-6 recomended
%
%
% OUTPUT:
%
% EXAMPLES:
%{
slice_stack(input01,input02,input03,input04)
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
%
hold (ax,'on')
[X,Y] = meshgrid(x,y);
[Xq,Yq] = meshgrid(round(interp(x,sc),1),round(interp(y,sc),1));
k = size(D,4);
for d = 1:k
    tmp = D(:,:,:,d);

    if k>1
        tmap=cmap{d};
    else
        tmap = cmap;
    end
    mmap{d} = tmap;
    vmx = squeeze(max(tmp,[],or));
    mx = nanmax(vmx(:));
    mn = nanmin(vmx(vmx>0));
    vmx(isnan(vmx))=0;
    vq = imgaussfilt(interp2(X,Y,vmx,Xq,Yq,'linear'),sm);
    vc = [vq(vq>=mn);mx+0.01*mn;mn];
    cc = fws.value_to_cmap(tmap,vc);
    c = nan([numel(vq),3]);
    c(vq(:)>=mn,:) = cc(1:end-2,:);
    % maximum intensity in the right orientation
    Data = imgaussfilt(vq,sm);
    Cdata = reshape(c,[size(vq),3]);
    Alpha = imgaussfilt(1.0*(vq>mn),2*sm);
    switch or
        case 1
            surf(Yq,Xq.^0*mean(st),Xq,Data,'AlphaData',Alpha,'Cdata',Cdata,'FaceAlpha','flat','edgecolor','none','parent',ax);
        case 2
            surf(Xq.^0*mean(st),Yq,Xq,Data,'AlphaData',Alpha,'Cdata',Cdata,'FaceAlpha','flat','edgecolor','none','parent',ax);
        case 3
            surf(Xq,Yq,Xq.^0*mean(st),Data,'AlphaData',Alpha,'Cdata',Cdata,'FaceAlpha','flat','edgecolor','none','parent',ax);
    end
    
    
end
end
%------------- END OF CODE --------------
