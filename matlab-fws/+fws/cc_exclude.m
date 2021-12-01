function CC = cc_exclude(Y,exclude)
%% FWS.CC_EXCLUDE: Create connected components and cleanup up by removing small and independent components
%
%   __           _             
%  / _|         (_)            
% | |_ _   _ ___ _  ___  _ __    
% |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural 
% | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
% |_|  \__,_|___/_|\___/|_| |_|
%
%
%% AUTHOR:  Richard Daws
%  EMAIL:  r.daws@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 01-Jul-2020 12:32:44
%
% INPUTS:
%    Y       - volume
%    exclude - threshold to remove components
%
%
% OUTPUT:
%
% EXAMPLES:
%{
CC = cc_exclude(Y, 10)
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


% Create cc's & remove below exclude threshold
CC = bwconncomp(~isnan(Y),conndef(ndims(Y),'minimal'));
ix = cellfun(@numel, CC.PixelIdxList)<exclude;

% exlude small volumes  
for ii=1:numel(ix)
    if ix(ii)
        Y(CC.PixelIdxList{ii})=nan;
    end
end
CC = bwconncomp(~isnan(Y),conndef(ndims(Y),'minimal'));
%------------- END OF CODE --------------
