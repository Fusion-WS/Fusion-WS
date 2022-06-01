function [varargout]=deal(M,type)
%% fws.deal - deal inputs to outputs
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
%  VERSION:  0.0 CREATED: 3-June-2020 09:18:27
%
%% DEPENDENCIES:
%
% This file is part of fusion toolbox
% fusion toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% fusion toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with fusion toolbox. If not, see <http://www.gnu.org/licenses/>.
%------------- BEGIN CODE --------------
%
if nargin<2;type='col';end
if strcmpi(type,'row'); M = M';end
varargout = cell(size(M,2));   
for k = 1:size(M,2)
    varargout{k} = M(:,k);
end
%------------- END OF CODE --------------
