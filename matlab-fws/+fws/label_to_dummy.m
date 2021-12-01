function [D,nc] = label_to_dummy(L)
% FWS.LABEL_TO_DUMMY: Transform an n-dimensional label matrix to a n+1 boolean matrix 
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
%  VERSION:  0.0 CREATED: 30-Jun-2020 18:46:39
%
% INPUTS:
%    L - n-dimensional matrix 
%
%
% OUTPUT:
%    D - (n+1)-dimensional matrix  
%    nc - a vector of unique classes that were dummified 
%
% EXAMPLES:
%{
[D,nc] = label_to_dummy(L)
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


% Get size of matrix 
sz = size(L); 
% Vectorize and transform to double
L = double(L(:));
% Change NaNs to zero and get a sorted class vector 
L((isnan(L))) = 0;
nc = unique(L(L~=0));
nc(nc==0) = [];
% Create a boolean matrix with dimesnionality of sz + 1    
D = false([sz(1),numel(nc)]);
for ii=1:numel(nc)
    D(:,ii) = L == nc(ii);
end
% Reshape the vectorised space back to sz+1    
D = reshape(D,[sz,numel(nc)]);


%------------- END OF CODE --------------
