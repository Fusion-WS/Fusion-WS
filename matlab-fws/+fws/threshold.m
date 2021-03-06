function [Y,t] = threshold(varargin)
%% FWS.THRESHOLD: Apply a threshold to the input volume
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
%  VERSION:  0.0 CREATED: 30-Jun-2020 18:46:39
%
% INPUTS:
%       data - input volume
%       threshold_method - iqr (use the interquartile range)
%                        - pareto (use pareto distribution)
%                        - z (Define your own value, e.g, z-score)
%
%       threshold_value - Depends on threshold_method, e.g., 0.9 with an iqr method
%                         keeps the top 10% of voxels in the distribution. 
%       
%       plot - True/False plot the unthresholded and thresholded voxel
%              distributions (default=false)
%
%
% OUTPUT:
%       Y - Thresholded volume
%       t - Threshold value
%
% EXAMPLES:
%{
[threshold_volume, threshold_value] = fws.threshold('data', volume, 'threshold_method', 'iqr', 'threshold_value', 0.90, 'plot',false); 
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

% Defaults
obj = struct('data',false,'threshold_method','iqr','threshold_value',0.90,'threshold_plot',false);
obj = fws.defaults(obj, varargin);

% Catch if data is missing
if numel(obj.data)==1
    error('No data to threshold in obj.data')
end

% Find voxels that aren't NaN or equal to 0
data = obj.data(~isnan(obj.data)&obj.data~=0);

% Define threshold value, t, by the requested method
switch obj.threshold_method
    case 'iqr'; t = quantile(data,obj.threshold_value); 
    case 'pareto'; [~,t] = boundary(paretotails(data,0.0,1-obj.threshold_value));
    case 'z'; t = obj.threshold_value;
    otherwise
end

% Threshold volume
Y=obj.data;
Y(abs(Y)<t)=NaN;

% Plot un/thresholded distributions, if requested. 
if obj.threshold_plot
    figure(); hold on;
        histogram(obj.data);
        histogram(Y);
        legend({'raw','threshold'})
        xlabel('Voxel intensity')
        drawnow
end

end

%------------- END OF CODE --------------
