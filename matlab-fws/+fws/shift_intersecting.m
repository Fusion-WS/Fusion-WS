function xyz = shift_intersecting(xyz,or,r,o)
% FWS.SHIFT_INTERSECTING: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 01-Sep-2020 10:36:27
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
shift_intersecting(input01,input02,input03,input04)
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
ix = true(1,3);
ix(or) = 0;
n = size(xyz,1);
tmp = xyz;
% treat each roi label as a node 
A = zeros(n);
% identify circles that interact  
pc = nchoosek(1:size(xyz,1), 2);


f = @(x1,y1,x2,y2,r1,r2,o) ((x1 - x2)^2 + (y1 - y2)^2)^0.5 <= (r1+r2)*o;
idx = 1;
niter = 1;
while ~isempty(idx)&&niter<200
    A = zeros(n);
    for ii=1:size(pc,1)      
        [x1,y1] = fws.deal(tmp(pc(ii,1),ix));
        [x2,y2] = fws.deal(tmp(pc(ii,2),ix));
        A(pc(ii,1),pc(ii,2)) = f(x1,y1,x2,y2,r,r,o);
    end

idx =  find(sum(A,2));
for jj=idx'
   idx1 = find(A(jj,:));
   p1 = tmp(jj,ix);
   jitter = randn(numel(idx1),nnz(ix));
   pi = tmp(idx1,ix)+sign(jitter).*fws.scale(jitter,'mn',r/2,'mx',r);
   npi = (pi-p1)./sqrt(sum((pi-p1).^2,2)+eps);
   d = fws.euc_dist(p1,pi);
   ps = p1+(2*r*o)*npi;
   tmp(idx1,ix) = ps;
end
niter = niter+1;
end

xyz = tmp;
end



%------------- END OF CODE --------------
