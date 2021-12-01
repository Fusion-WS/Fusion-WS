function [MU,STD,LEVELS,tmap,AB,ix2,GROUPS,ab,M] = group_adj(X,gp,n,T,cmap)
% FWS.GROUP_ADJ: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 22-Sep-2020 06:50:39
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
group_adj(input01,input02,input03,input04)
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
ix1 = find(triu(true(n),1));
[I,J]=find(triu(true(n),1));
LUT = zeros(2^16,1,'uint16');
LUT(T.ROIid+1) = T.cid;
A = zeros(n);
B = zeros(n);
A(ix1) = intlut(uint16(I),LUT);
B(ix1) = intlut(uint16(J),LUT);
A = fws.sym_adj(A,'upper');
B = fws.sym_adj(B,'upper');
[~,ix2] = sort(T.cid);
pr = [[1:max(T.cid);1:max(T.cid)]';nchoosek(1:max(T.cid),2)];
GP = categorical(categories(T.cat));
GROUPS= GP(pr(:,1)).*GP(pr(:,2));
ng = numel(GP);
AB = zeros(n);
ab = zeros(ng);
ab(eye(ng)>0)=1;
ab(tril(true(ng),-1)>0)=2;
c = 1;
tmap = zeros(size(pr,1),3);
ix3 = [find(ab==1);find(ab==2)];
for ii=1:size(pr,1)
    tmp = A==pr(ii,1)&B==pr(ii,2)|A==pr(ii,2)&B==pr(ii,1);
    AB = AB+tmp*c;
    c=c+1;
    if diff(pr(ii,:))
        tmp = fws.cmap([cmap(pr(ii,1),:);cmap(pr(ii,2),:)],3);
        tmap(ii,:) = tmp(2,:);
    else
        tmap(ii,:) = cmap(ii,:);
    end
    ab(ix3(ii))=ii;
end
M = repmat(zeros(n),1,1,size(X,1));
for ii=1:size(X,1)
    tmp = zeros(n);
    tmp(ix1) = X(ii,:);
    M(:,:,ii)= fws.sym_adj(tmp,'upper');
end
Mr = reshape(M,[],size(X,1));
ABr = reshape(AB,[],1);
GP = dummyvar(gp);
MU = zeros(max(ABr),size(GP,2));
STD = zeros(max(ABr),size(GP,2));
for ii=1:max(ABr)
    ix = ABr==ii;
    MU(ii,:)=nanmean(Mr(ix,:)*GP./sum(GP));
    STD(ii,:)=nanstd(Mr(ix,:)*GP./sum(GP));
end
LEVELS = categories(gp);

end
%------------- END OF CODE --------------
