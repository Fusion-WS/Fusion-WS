function d = min_max_scale(D,mn,mx)
% FWS.MIN_MAX_SCALE: scale D to a range between mn and mx
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
%  VERSION:  0.0 CREATED: 01-Jul-2020 15:54:44
%
% INPUTS:
%    D - 
%    mn - 
%    mx - 
%
%
% OUTPUT:
%    d - 
%
% EXAMPLES:
%{
[s] = min_max_scale(M,mn,mx)
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
if any(isnan(D))
    ix = isnan(D);
    d = D(~ix);
else
    d = D;
end
if sum(abs(diff(d)))
    mi = min(d);
    ma = max(d);
    r = range([mi;ma]);
    d = bsxfun(@rdivide, bsxfun(@minus,d,mi),r);
    d = d*range([mx,mn])+mn;
end
if exist('ix','var')
   tmp = NaN(length(D),1);
   tmp(~ix) = d;
   d= tmp;
end
end
%------------- END OF CODE --------------
