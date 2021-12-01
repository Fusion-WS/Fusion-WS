function cmap = value_to_cmap(map,v)
% FWS.VALUE_TO_CMAP: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 08-Jul-2020 15:44:51
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
value_to_cmap(input01,input02,input03,input04)
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

if size(map,1)==1
    map = [0.5,0.5,0.5;map];
end
n=1000;
cmap = fws.cmap(map,n);
ix = floor(1+ (v(:) - min(v(:))) / (range(v(:))) * (n-1));
if any(isnan(ix))
    c = zeros(numel(ix),3);
    c(isnan(ix),:) = repmat(map(end,:),nnz(isnan(ix)),1);
    c(~isnan(ix)) = cmap(~isnan(ix),:);
else
    c = cmap(ix,:);
end
cmap = c;
end


%------------- END OF CODE --------------
