function [p,SEM,ts,CI] = empiricalP(perm,obs,N,stat)
% GET.EMPIRICALP: get empirical p from permutation and null results
% based on https://arxiv.org/pdf/1603.05766.pdf
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
%  VERSION:  0.0 CREATED: 22-Dec-2017 12:49:45
%
%% INPUTS:
%    perm - 
%    obs - 
%    stat - 
%
%
%% OUTPUT:
%
%% EXAMPLES:
%{
empiricalP(input01,input02,input03,input04)
%}
%
%% DEPENDENCIES:
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

if ~exist('stat','var');stat='mean';end
switch stat
    case 'mean';p = (nnz(perm>mean(obs))+1)/(nnz(perm)+1);
    case 'median';p = (nnz(perm>median(obs))+1)/(nnz(perm)+1);
    case 'min';p = (nnz(perm>min(obs))+1)/(nnz(perm)+1);
    case 'full';p = [(nnz(perm>mean(obs))+1)/(nnz(perm)+1),(nnz(perm>median(obs))+1)/(nnz(perm)+1),(nnz(perm>min(obs))+1)/(nnz(perm)+1)];
end

SEM = std(obs)/sqrt(N);                       % Standard Error
ts = tinv([0.025  0.975],length(obs)-1);      % T-Score
CI = mean(obs) + ts*SEM;                      % Confidence Intervals

end



%------------- END OF CODE --------------
