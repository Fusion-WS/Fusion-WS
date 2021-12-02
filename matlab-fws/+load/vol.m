function varargout = vol(fn,cifti)
%% LOAD.VOL: detects the type of volume and loads it with the right loader
%    __           _
%   / _|         (_)
%  | |_ _   _ ___ _  ___  _ __
%  |  _| | | / __| |/ _ \| '_ \    :- Functional and Structural
%  | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
%  |_|  \__,_|___/_|\___/|_| |_|
%
%% AUTHOR:  Eyal Soreq
%  EMAIL:  e.soreq14@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 23-May-2017 18:10:47
%
%% TODO:
%  add error catching

%% INPUTS:
%    fn - either a char vector with one file name pointing to a 3D/4D volume
%         or a cell of strings each pointing to a volume
%         or an SPM12 struct
%    hdronly - if true only G will be extracted
%
%% OUTPUT:
%    V - either a 3D/4D matrix or a cell array of matrices
%    G - either one grid class or a cell array of grids
%
%% EXAMPLES:
%{
[V,G] = load.vol(fn)
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

% Input check. Throw error is filepath does not point an exsiting file
if exist(fn,'file')~=2; error(['Filepath does not exist: ' fn]); end

hdr = niftiinfo(fn);
varargout = cell(1,nargout);
for ii=1:nargout
    switch ii
        case 1;tmp = niftiread(fn);
            if hdr.MultiplicativeScaling<1 && hdr.MultiplicativeScaling > 0
                tmp = double(tmp).*hdr.MultiplicativeScaling;
            end
        case 2;tmp = new.Grid(hdr);
        case 3;tmp = hdr;
    end
    varargout{ii} = tmp;
end
end

%------------- END OF CODE --------------
