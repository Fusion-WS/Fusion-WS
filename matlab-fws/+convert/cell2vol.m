function [M] = cell2vol(C)
%% CONVERT.CELL2MAT: gets a cell of strings and converts it to char mat with padded space at the end
%
%    __           _             
%   / _|         (_)            
%  | |_ _   _ ___ _  ___  _ __    
%  |  _| | | / __| |/ _ \| '_ \    :- Functional and Structural 
%  | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
%  |_|  \__,_|___/_|\___/|_| |_|
%
%
%% AUTHOR:  Eyal Soreq
%  EMAIL:  e.soreq14@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 24-May-2017 09:48:03
%
%% INPUTS:
%    C - cell of volumes
%
%
%% OUTPUT:
%    M - mat of volumes concatenated on the n+1 dimension
%
%% EXAMPLES:
%{
[M] = cell2mat(C)
%}
%
%% DEPENDENCIES:
%
% This file is part of C^3NL Pipeline
% C^3NL Pipeline is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% C^3NL Pipeline is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with C^3NL Pipeline.If not, see <http://www.gnu.org/licenses/>.
%------------- BEGIN CODE --------------
%
d = size(C{1});
M = zeros([prod(d),numel(C)]);
for ii=1:numel(C)
    M(:,ii) = C{ii}(:);
end
M = reshape(M,[d,numel(C)]);
end

%------------- END OF CODE --------------
