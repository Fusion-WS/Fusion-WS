function [L,stats] = merge_neighbours(L,Y,CC,obj)
%% FWS.MERGE_NEIGHBORS: Merge small parcels to the nearest neighbour
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
%  VERSION:  0.0 CREATED: 30-Jun-2020 18:46:38
%
% INPUTS:
%    L   - label of volume 
%    Y   - The original volume 
%    obj - Defaults obj   
%
% OUTPUT:
%    L - Merged label 
%    stats - A table of
% EXAMPLES:
%{
[L,stats] = fws.merge_neighbours(L,Y,obj)
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

% For each spatial component
LL = L;
for jj=1:CC.NumObjects
    
    y = -inf(obj.sz); % Create an n-dim void space of neg inf (this avoids adjacent components from being accidentally merged)
    y(CC.PixelIdxList{jj})=Y(CC.PixelIdxList{jj}); % Place the original values of the jjth component into the void (creating a mountain)
    l = zeros(obj.sz);
    l(CC.PixelIdxList{jj})=L(CC.PixelIdxList{jj}); % Place the original values of the jjth component into the void (creating a mountain)
    stats = regionprops3(l,y,{'Volume','MeanIntensity','Centroid','VoxelIdxList'});
    if obj.merge
        merge = obj.merge;
        radius = obj.radius;
        if obj.merge>max(stats.Volume)
            merge = max(stats.Volume);
        end
        
        ix = 1;
        niter = 1000;
        n = 1;
        while ~isempty(ix)
            l = fws.relabel(l);
            stats = regionprops3(l,y,{'Volume','MeanIntensity','Centroid','VoxelIdxList'});
            stats.id = [1:height(stats)]';
            stats = sortrows(stats,{'Volume'});
            if height(stats)==1;break;end
            d2 = fws.get_cc_ix(obj.sz, radius, 'square');
            ix = find(stats.Volume<=merge);
            for ii=ix'
                idx1=stats.VoxelIdxList{ii};
                idx2=idx1'+d2;
                idx2 = idx2(idx2>0&idx2<obj.nvx);
                idx2 = idx2(~ismember(idx2(:),idx1));
                [~,lut1]=fws.label_to_dummy(l(idx2(:)));
                switch numel(lut1)
                    case 0;  keyboard;%radius = radius+1
                    case 1;  l(idx1) = lut1;
                    otherwise
                        idx4 = find(ismember(stats.id,lut1));
                        [~,idx3]=min(fws.euc_dist(stats{ii,[2,4]},stats{idx4,[2,4]}));
                        l(idx1) = lut1(idx3);
                end
            end
            n=n+1;
            if n>niter;break;end
        end
        LL(CC.PixelIdxList{jj}) = l(CC.PixelIdxList{jj})+1e3*jj;
    end
end
L = double(fws.relabel(LL));
stats = regionprops3(L,Y,{'Volume','MeanIntensity'});
%------------- END OF CODE --------------
