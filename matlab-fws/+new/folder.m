function [D] = folder(id,inDir,folders)
%% NEW.FOLDER: creates a shallow folder structure (up to 3 levels and returns a structure with the path's 
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
%  VERSION:  0.0 CREATED: 23-May-2017 11:35:46
%
%% INPUTS:
%    id - file id to be concatentated in folder tree
%    inDir - the root folder to construct 
%    folders - the tree to construct 
%
%
%% OUTPUT:
%    D - folder paths 
%
%% EXAMPLES:
%{
[D] = new.folders([],pwd,{'test','test2'})
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

if ~(exist(inDir,'dir'));mkdir(inDir);end
   
if exist('folders','var')
if ~isempty(id)
    for ii=1:length(folders)
        D.(folders{ii}) = [inDir,filesep,folders{ii},filesep,id];
        if ~(exist(D.(folders{ii}),'dir')); mkdir(D.(folders{ii}));end
    end
else
    for ii=1:length(folders)
        D.(folders{ii}) = [inDir,filesep,folders{ii}];
        if ~(exist(D.(folders{ii}),'dir')); mkdir(D.(folders{ii}));end
    end
end
end
D.root = inDir;
end
%------------- END OF CODE --------------
