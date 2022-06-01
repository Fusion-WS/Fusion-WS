function [L,stats] = watershed(Y,varargin)
%% FWS.WATERSHED: Transform statistical map into discrete ROIs using the watershed transform
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
%    fws.watershed(Y) produces a set of discrete (non-overlapping) region's
%    of interest (ROIs) from statistical images. 
%
% OPTIONAL PARAMETERS:
%    'radius'  - Search radius, size is the number of neighbouring voxels.
%                Typically, a larger radius produces fewer parcels (default = 1). 
%    
%    'exclude' - Threshold for removing spatially indepent components (default = 0).
%             
%    'lower'   - Lower threshold for volumes of final ROI set (default, no lower limit). 
%
%    'verbose' - Logical - Display code progress 
%
% OUTPUT:
%     L     - Label integer ROI map
%     stats - Table of summary statistics for each ROI 
%
% EXAMPLES:
%{
[L,stats] = watershed(Y,varargin)
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

% handle input
if mod(numel(varargin),2)
    error('Field and value input arguments must come in pairs.')
end


% Defaults
obj = struct('radius',1,'merge',20,'filter',50,'verbose',true,'sz',size(Y),'nvx',numel(Y));
obj = fws.defaults(obj, varargin);


% Remove components below the exclude threshold
CC = fws.cc_exclude(Y, obj.filter);

tc=tic;
% Cluster the volume to indpendent parcels using watershed 
L = fws.cluster(Y,CC,obj);

% If user defines a lower limit, merge small parcels with nearest cluster
[L,stats] = fws.merge_neighbours(L,Y,CC,obj);
L(Y==-inf)=nan;

tC=toc(tc);
if obj.verbose
    fprintf(' Completed in %s seconds',num2str(tC))
end

%------------- END OF CODE --------------
