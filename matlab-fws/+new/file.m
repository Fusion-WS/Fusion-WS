function [fid,FN] = file(fn,od,type,rand)
%% NEW.FILE: Creates a file after making sure that a folder exists
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
%  VERSION:  0.0 CREATED: 23-May-2017 10:32:13
%
%% INPUTS:
%   fn - file name (with suffix)
%   od - output directory
%   type - 
%       'r'     open file for reading
%       'w'     open file for writing; discard existing contents
%       'a'     open or create file for writing; append data to end of file
%       'r+'    open (do not create) file for reading and writing
%       'w+'    open or create file for reading and writing; discard 
%               existing contents
%       'a+'    open or create file for reading and writing; append data 
%               to end of file
%       'W'     open file for writing without automatic flushing
%       'A'     open file for appending without automatic flushing
%
%
%% OUTPUT:
%   fid - file identifier 
%
%% EXAMPLES:
%{
[fid] = new.file('test.txt',pwd,'w')
for row = 1:10;fprintf(fid,'%s\n',char(randi([57,90],20,1)));end
new.Function('folders','eyalsoreq',struct('outputvar',{'D'},'inputvar',{'id','inDir','folders'}))
%}
%
%% DEPENDENCIES: none
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
%
%------------- BEGIN CODE --------------
%
new.folder([],od);
if ~exist('rand','var')
    FN = [od,filesep,fn];
else 
    s = RandStream('mt19937ar','Seed','shuffle');
    RandStream.setGlobalStream(s);
    [~,name,ext]= fileparts(fn);
    if isempty(ext);ext = '.sh';end
    tk = [48:57,65:90];
    FN = [od,filesep,name '.' char(tk(randperm(numel(tk),10))) ext];
end
fid = fopen(FN,type);
%------------- END OF CODE --------------
end



