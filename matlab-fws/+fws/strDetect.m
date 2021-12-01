function M = svtrDetect(names,cmd)
%% C3NL.STRDETECT: strDetect takes a cell array of strings and searches a logical command of
% string occurance and returns logicals.
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
%  VERSION:  0.0 CREATED: 07-Jun-2017 15:52:52
%
%% INPUTS:
%    names - cell array of strings
%    cmd - Format of cmd  <word><logical><word>

%
%
%% OUTPUT:
%
%% EXAMPLES:
%{
c3nl.strDetect(names,cmd)
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
if any(cellfun(@isnumeric,names))
    names{cellfun(@isnumeric,names)} = num2str(names{cellfun(@isnumeric,names)});
end
tokens = regexp(cmd,'[&|~]', 'split');
op = cmd(regexp(cmd,'[&|~]', 'start'))';
if (numel(tokens)~=size(op,1)+1)
    disp('ERROR - please supply n-1 logicals and n tokens')
    return
end
tmp = zeros(numel(names),numel(tokens));
ix = cellfun(@isempty, names);
for ii=1:numel(tokens)
    tmp(~ix,ii) = ~(cellfun('isempty',strfind(names(~ix),tokens{ii})));
end
m = tmp(:,1);
for ii=1:size(op,1)
    switch op(ii)
        case '&';m = m .* tmp(:,ii+1);
        case '|';m = m + tmp(:,ii+1);
        case '~';m = m .* ~tmp(:,ii+1);
    end
end
M=m>0;
%------------- END OF CODE --------------
