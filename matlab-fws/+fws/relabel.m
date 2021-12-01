function rL = relabel(L,offset)
% FWS.RE_LABEL: Efficient class relabeling with offset
%
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
%  VERSION:  0.8 CREATED: 30-Jun-2020 18:46:38
%
% INPUTS:
%    L - Label matrix 
%    offset - Numeric number to offest 
%
%
% OUTPUT:
%    rL - relabeled matrix 
%
% EXAMPLES:
%{
[l,t] = fws.relabel(L,offset,T)
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

if ~exist('offset','var');offset=0;end

% Extract unique labels
idL = unique(L(~isnan(L)));
idL(idL==0)=[];% ignore zero's
% Count number of classes
nL = numel(idL);
% Use integer look up table to remap labels 
if max(idL)>=nL
    LUT = zeros(2^16,1,'uint16');
    LUT(idL+1) = offset+1:offset+nL;
    rL = intlut(uint16(L),LUT);
else
    rL=L;
end

end
%------------- END OF CODE --------------
