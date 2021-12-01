function slice_stack(ax,or,st,x,y,D,cmap,sm,sc)
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
    mx = max(tmp(:));
    mn = min(tmp(:));
    if k>1
        tmap=cmap{d};
    else
        tmap = cmap;
    end
    mmap{d} = tmap;
    vmx = squeeze(max(tmp,[],or));
    vmx(isnan(vmx))=0;
    Vmx = imgaussfilt(interp2(X,Y,vmx,Xq,Yq,'makima'),sm);
    % maximum intensity in the right orientation
    for ii=1:numel(st)
        switch or
            case 1;v = squeeze(tmp(ii,:,:));
            case 2;v = squeeze(tmp(:,ii,:));
            case 3;v = squeeze(tmp(:,:,ii));
        end
        v(isnan(v))=0;
        vq = interp2(X,Y,v,Xq,Yq, 'makima');
        vq = Vmx.*(vq>mn);
        vc = [vq(vq>=mn);mx+0.01*mn;mn];
        cc = fws.value_to_cmap(tmap,vc);
        c = nan([numel(vq),3]);
        c(vq(:)>=mn,:) = cc(1:end-2,:);
        switch or
            case 1
                surf(Yq,Xq.^0*st(ii),Xq,imgaussfilt(vq,sm),'AlphaData',imgaussfilt(vq.^2,sm),'Cdata',reshape(c,[size(vq),3]),'FaceAlpha','flat','edgecolor','none','parent',ax);
            case 2
                surf(Xq.^0*st(ii),Yq,Xq,imgaussfilt(vq,sm),'AlphaData',imgaussfilt(vq.^2,sm),'Cdata',reshape(c,[size(vq),3]),'FaceAlpha','flat','edgecolor','none','parent',ax);
            case 3
                surf(Xq,Yq,Xq.^0*st(ii),imgaussfilt(vq,sm),'AlphaData',imgaussfilt(vq.^2,sm),'Cdata',reshape(c,[size(vq),3]),'FaceAlpha','flat','edgecolor','none','parent',ax);
        end
    end
end
end
%------------- END OF CODE --------------
