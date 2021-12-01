function [Y,t] = threshold(varargin)
%% FWS.THRESHOLD: One line description of what the function or script performs
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
%    Y - 
%    method - 
%
%
% OUTPUT:
%    Yt - 
%
% EXAMPLES:
%{
[Yt] = threshold(Y,method)
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

if numel(obj.data)==1
    error('No data to threshold in obj.data')
end
data = obj.data(~isnan(obj.data)&obj.data~=0);
switch obj.threshold_method
    case 'iqr'; t = quantile(data,obj.threshold_value); 
    case 'pareto'; [~,t] = boundary(paretotails(data,0.0,1-obj.threshold_value));
    case 'z'; t = obj.threshold_value;
    otherwise
end

Y=obj.data;
Y(Y<t)=NaN;


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
