function adj = sym_adj(adj,side)
%% C3NL.SYMADJ: symmetrize a square matrix using different ways
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
%  VERSION:  0.0 CREATED: 07-Jun-2017 16:31:54
%
%% INPUTS:
%    adj - 
%    side - 
%
%% EXAMPLES:
%{

%}
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

if ~exist('side','var');side='upper';end
A =     adj;
AA =    fliplr(rot90(adj,-1));
ix_l = tril(ones(size(adj)),-1)>0;
ix_u = triu(ones(size(adj)),1)>0;
switch side
    case 'lower'; adj = ix_l.*A+ix_u.*AA;
    case 'upper'; adj = ix_u.*A+ix_l.*AA;
    case 'mean';  adj = mean(cat(3,fws.sym_adj(adj,'lower'),fws.sym_adj(adj,'upper')),3);
    otherwise; disp('type is not recognized');return;
end
ix = eye(size(adj))>0;
adj(ix)= A(ix);
end


%------------- END OF CODE --------------