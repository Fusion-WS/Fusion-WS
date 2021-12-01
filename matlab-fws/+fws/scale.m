function A = scale(A,varargin)
%% FWS.SCALE: One line description of what the function or script performs
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
%    A - n-dimension
%    mn - 0
%    mx - 1
%    method - full,row,col
%
%
% OUTPUT:
%    S - 
%
% EXAMPLES:
%{
[S] = scale(M,lb,ub,method)
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

% Defualts 
obj = struct('mn',0,'mx',1,'method','full');

obj = fws.defaults(obj,varargin);

sz = size(A);

if any(isinf(A));A(isinf(A))=NaN;end

switch obj.method
    case 'row';A = fws.min_max_scale(A',obj.mn,obj.mx);
    case 'full';A = fws.min_max_scale(A(:),obj.mn,obj.mx);
    case 'col'
        tmp = zeros(sz);
        for ii=1:sz(2)
            tmp(:,ii) = fws.min_max_scale(A(:,ii),obj.mn,obj.mx);
        end
        A = tmp;
end

if strcmpi(obj.method,'full');A = reshape(A,sz);end
if strcmpi(obj.method,'row');A = A';end

end

%------------- END OF CODE --------------


