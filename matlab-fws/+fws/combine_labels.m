function V = combine_labels(v1,v2)
%% ATLAS.MERGE: go over two label volumes that share a grid system and merge them dealing with sttraies using the mode of the neighborhood
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
%  VERSION:  0.0 CREATED: 08-Aug-2017 14:24:47
%
%% INPUTS:
%    v1 -  volume one
%    v2 -  volume two 
%
%
%% OUTPUT:
%     V the merged label volume  
%
%% EXAMPLES:
%{
V = atlas.merge(v1,v2)
%}
%
%% DEPENDENCIES:
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

if any(isnan(v1(:)))
    ix1 = isnan(v1);
    v1(ix1)=0;
end

if any(isnan(v2(:)))
    ix2 = isnan(v2);
    v2(ix2)=0;
end

mv = v1+v2;
mid = unique(mv(mv~=0));% merged id's
cid = [unique(v1(v1~=0));unique(v2(v2~=0))];% concatenated id's
sid = mid(~ismember(mid,cid));% stray id's 
if isempty(sid)
    V = v1;
    V(v2>0)= v2(v2>0)+max(v1(:));
else 
    od=size(mv);
    Pmv = padarray(mv,ones(numel(od),1),nan); % pad image to account for bounderies
    pd = size(Pmv);
    nd = numel(pd);
    d = fws.get_cc_ix(pd,1,'euc');
    V = Pmv;
    for ii=1:numel(sid)
        pidx =find(ismember(Pmv,sid(ii)));
        while ~isempty(pidx)
            ix = pidx(end)+d;
            c=Pmv(unique(ix));
            c = c(ismember(c,cid));
            if ~isempty(c)
                V(pidx(end)) = mode(c);
                pidx(end)=[];
            else
                ix1 = ismember(V(ix),cid);
                if any(ix1);V(pidx(end)) = mode(V(ix(ix1)));pidx(end)=[];
                else; pidx= [pidx(end);pidx(1:end-1)];end
            end
        end
    end
    sd = repmat({':'},nd-1,1);
    for ii=1:nd % crop image back to normal
        V = shiftdim(V,1);
        V = V(2:end-1,sd{:});
    end
end
%------------- END OF CODE --------------
