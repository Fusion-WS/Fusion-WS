function [D,W,w]  = get_cc_ix(od,r,dist)
% FWS.GET_CC_IX: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 30-Jun-2020 18:46:38
%
% INPUTS:
%    od - original matrix dimensionality 
%    r - radius
%    dist - the type of distance metric to use 
%
% OUTPUT:
%    ix - 
%
% EXAMPLES:
%{
[ix] = fws.get_cc_ix(dim,r)
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
% get back linear shift for neighbourhood
% od = original matrix size
% pd = paddedd matrix size
% r = neighbourhood radius

if ~exist('dist','var');dist='euc';end

D = [];
if ~(any(ismember(od,1))&& numel(od)==2) % deal with one dimensions
    [D{1:length(od)}]=ndgrid(-r:r);
else 
    D = {ndgrid(-r:r)};
end
d = cellfun(@(x) x+1+r,D,'un',0);
d = sub2ind(od,d{:});
d = d-d((numel(d)+1)/2);
switch dist
    case 'euc';   w = (bwdist(d==0,'euclidean'));
    case 'city';  w = (bwdist(d==0,'cityblock'));
    case 'chess'; w = (bwdist(d==0,'chessboard'));
    case 'qeuc';  w = (bwdist(d==0,'quasi-euclidean'));
    case 'square'; w = r*(d~=0); 
end

D = d(w<=r*sqrt(2));
W = double(1./w(w<=r*sqrt(2)));
W(D==0)=[];
D(D==0)=[];
w = fws.scale(-w);
%------------- END OF CODE --------------
