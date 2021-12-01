function [S] = select(varargin)
% FWS.SELECT: Wrapper to bash find 
%
%    __           _             
%   / _|         (_)            
%  | |_ _   _ ___ _  ___  _ __    
%  |  _| | | / __| |/ _ \| '_ \    :- Functional and Structural 
%  | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
%  |_|  \__,_|___/_|\___/|_| |_|
%
%
% AUTHOR:  Eyal Soreq
%  EMAIL:  e.soreq14@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 24-May-2017 15:18:27
%
% INPUTS:
%    varargin -  paired option and variable
%         maxdepth - k>=1
%         mindepth - k<maxdepth
%         regex - obides by the rules of bash regex
%         exec - excute a comand
%         name - all bash flages 
%         delete - delete the found files
%         type - either f or d (file or directory)
%         pth - the path to start the search in 
%         printf - 
%         output - type of output cell/char (cell is default,char is padded)  
%
% OUTPUT:
%    S - a cell of strings or padded chr array 
%
% EXAMPLES:
%{
[S] = fws.select('name','*.nii')
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

if ~isempty(varargin)
    if mod(numel(varargin),2)
        throw(MException('FUSION:Odd varargin','This function requires additional options to be supplied as pairs of parameter and value'));
    else 
        sel = setparams(varargin);
    end
else
    sel = setparams();
end

[~,S]=system(sel.cmd);
switch sel.out
    case 'cell'
        S = convert.string2cell(S,'\n');
    case 'char'    
        S = convert.cell2mat(convert.string2cell(S,'\n'));
    case 'name'
        S = strrep(S,[sel.pth,filesep],'');
        S = convert.string2cell(S,'\n');
        S(fws.strDetect(S,['.|',sel.pth]))=[];
    otherwise
            disp('Output format not recognized');
end

end
function sel = setparams(varargin)
% Go over the different options and form a find cmd 
prop = {'maxdepth','mindepth','regex','exec','name','delete','type','pth','printf','output','sel'};
input = varargin{1}(1:2:end);
for p=prop
    ia = find(fws.strDetect(input,p{1}));
    if isempty(ia);ia=0;end
    switch p{1}
        case 'maxdepth';if ia;mxd=sprintf(' -maxdepth %i', varargin{1}{ia*2});else; mxd='';end
        case 'mindepth';if ia;mnd=sprintf(' -mindepth %i', varargin{1}{ia*2});else; mnd='';end
        case 'name';if ia;nam=[' -name "' varargin{1}{ia*2} '"'];else; nam='';end
        case 'type';if ia;typ=[' -type ' varargin{1}{ia*2}];else; typ='';end    
        case 'exec';if ia;exc=[' -exec ' varargin{1}{ia*2}];else; exc='';end
        case 'pth';if ia;pth=varargin{1}{ia*2};else; pth=' $PWD ';end 
        case 'delete';if ia;del=' -delete ';else; del='';end        
        case 'output';if ia;out=varargin{1}{ia*2};else; out='cell';end                           
        case 'regex';if ia;reg=[' -regex ' varargin{1}{ia*2}];else; reg='';end
        case 'printf';if ia;prnf=[' -printf ' varargin{1}{ia*2}];else; prnf='';end 
        case 'sel'
            sel.cmd = sprintf('find %s $1 %s %s %s %s %s %s %s %s',pth,mnd,mxd,typ,nam,reg,del,exc,prnf);
            sel.out = out;
            sel.pth = pth;
    end
end
end
%------------- END OF CODE --------------
