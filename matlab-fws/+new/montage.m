function im = montage(vol,dim,R,C)
%% new.MONTAGE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 11-Jun-2017 05:16:20
%
%% INPUTS:
%    vol - a 3d volume that we wish to convert from 3d to stacked 2d
%    dim  - the dimension we wish to stack it in 
%    R - number of rows
%    C - number of columns 
%
%
%% OUTPUT:
%
%% EXAMPLES:
%{
im = new.montage(vol,3)
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
ix = true(3,1);ix(dim)=0;
h = find(ix,1,'first');
v = find(ix,1,'last');
P_vol = permute(vol,[h v dim]);
siz = size(P_vol);
squares = size(vol,dim);
if ~exist('C','var');C = [];end
if ~exist('R','var');R = [];end
mn = [isempty(R)&isempty(C),isempty(C)&~isempty(R),isempty(R)&~isempty(C),~isempty(R)&~isempty(C)];
switch find(mn)
    case 1
        R = ceil(sqrt(squares));
        if R*(R-1)>squares;C = R-1;else;C=R;end
    case 2;C = ceil(squares/R);
    case 3;R = ceil(squares/C);
end
im = nan(R*siz(2),C*siz(1));
c = 1;
for ii=1:R
    for jj=1:C
        x = (jj-1)*siz(1);
        y = (ii-1)*siz(2);
        if(c<=squares); im(y+1:y+siz(2),x+1:x+siz(1)) = fliplr(rot90(P_vol(:,:,c)));end
        c = c+1;
    end
end
end
%------------- END OF CODE --------------
