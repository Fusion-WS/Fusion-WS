function [obj,fld] = defaults(obj,varobj)
% FWS.DEFAULTS: Used to handle default and custom options to be added to obj. 
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
%  VERSION:  0.0 CREATED: 01-Jul-2020 15:45:25
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

% New input fields to process
inputs = varobj(1:2:end);
% New input values to process
values = varobj(2:2:end);
              
% fields of existing obj
vars = fieldnames(obj);
% Go over each input & add to obj
for ii = 1:numel(inputs)
    [ia,ib]=ismember(inputs{ii},vars);
    if ia;obj.(vars{ib}) = values{ii};end
end
fld=fieldnames(obj);
%------------- END OF CODE --------------
