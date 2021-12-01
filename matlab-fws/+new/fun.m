function fun(fname,developer,obj)
%% NEW.FUN: Creates function files based on template in the right folder 
%
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
%  VERSION:  0.0 CREATED: 23-May-2017 11:26:51
%
%% INPUTS:
% fname - the name of the function (if separated by dot will create a
%              + folder if one does not exist and create a file under that hierarchy
% developer - a cell array with three cells {'full name', 'email','affiliation'}
% OBJ struct  - with the following fields
%  oneliner -
%  Synatax -
%  copyright -
%  numargin -
%  outputvar - 
%  inputvar - 
%  numargout -
%  example -
%  date -
%  library -
%  revision -
%  dependencies -
%  outdir -
%  logo -
%
%% OUTPUT:
%
%% EXAMPLES:
%
% new.fun('new.testFunction',{'Bob','bob@burgers.com','Bob's Burgers'},struct('inputvar',{{'test1','test2','test3'}}))
%
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
if ~exist('obj','var');obj=[];end
if ~exist(fname,'file')
    [FS,fid] = getparams(fname,developer,obj);
    for row = 1:numel(FS);fprintf(fid,'%s\n',FS{row});end
else 
    fprintf('File %s exists',fname)
end
end

function [FS,fid] = getparams(name,developer,obj)

prop = {'name','logo','outdir','oneliner','outputvar','numargout','inputvar','numargin','library','syntax','copyright','examples','revision','date','dependencies'};
if ~isstruct(obj);ia = zeros(numel(prop),1); else [ia,~] = ismember(prop,fieldnames(obj));end
source = which(['new.' mfilename]);
root= source(1:strfind(source,'+new')-2);
fn = strsplit(name,'.');
if numel(fn)>1
    od = strjoin([root;arrayfun(@(x) ['+' x{1}],fn(1:end-1)','un',0)],filesep);
else
    od = root;
end

for ii=1:length(ia)
    tmp = prop{ii};
    switch tmp
        case 'name';fid = new.file([fn{end},'.m'],od,'w'); % create a file to write to
        case 'logo';if ia(ii);logo=obj.(tmp);else; logo = {'%   __           _             ';
                    '%  / _|         (_)            ';
                    '% | |_ _   _ ___ _  ___  _ __    ';
                    '% |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural ';
                    '% | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages';
                    '% |_|  \__,_|___/_|\___/|_| |_|'};end % fusion logo
        case 'outdir';if ia(ii);outdir=obj.(tmp);else; outdir=root;end
        case 'oneliner';if ia(ii);oneliner=obj.(tmp);else; oneliner='One line description of what the function or script performs';end
        case 'outputvar';if ia(ii);outputvar=obj.(tmp);else; outputvar=[];end
        case 'numargout'
            if isempty(outputvar)
                if ia(ii);numargout=obj.(tmp);else;numargout=0;end
            else
                numargout = numel(outputvar);
            end
            if numargout && isempty(outputvar)
                outputvar = arrayfun(@(a) sprintf('output%02d',a),1:numargout,'un',0);
            end
        case 'inputvar';if ia(ii);inputvar=obj.(tmp);else; inputvar=[];end
        case 'numargin'
            if isempty(inputvar)
                if ia(ii);numargin=obj.(tmp);else;numargin=4;end
                inputvar = arrayfun(@(a) sprintf('input%02d',a),1:numargin,'un',0);
            else
                numargin = numel(inputvar);
            end    
        case 'library';if ia(ii);library=obj.(tmp);else; library='Fusion Pipeline';end
            
        case 'syntax';if ia(ii);syntax=obj.(tmp);else
                if ~isempty(outputvar)
                    syntax=sprintf('[%s] = %s(%s)',...
                        strjoin(outputvar,','),...
                        fn{end},strjoin(inputvar,','));
                else 
                    syntax=sprintf('%s(%s)',fn{end},strjoin(inputvar,','));
                end
            end
        case 'copyright';if ia(ii);copyright=obj.(tmp);else
                copyright= {['% This file is part of ',library];...
                    ['% ',library,' is free software: you can redistribute it and/or modify'];...
                    '% it under the terms of the GNU General Public License as published by';...
                    '% the Free Software Foundation, either version 3 of the License, or';...
                    '% (at your option) any later version.';...
                    ['% ',library,' is distributed in the hope that it will be useful,'];...
                    '% but WITHOUT ANY WARRANTY; without even the implied warranty of';...
                    '% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the';...
                    '% GNU General Public License for more details.';...
                    '% ';...
                    '% You should have received a copy of the GNU General Public License';...
                    ['% along with ',library,'.If not, see <http://www.gnu.org/licenses/>.']};
            end
        case 'example';if ia(ii);example=obj.(tmp);else;example='';end
        case 'revision';if ia(ii);revision=obj.(tmp);else; revision='0.0';end %
        case 'date';if ia(ii);date=obj.(tmp);else; date=datestr(datetime('now'));end %
        case 'dependencies';if ia(ii);dependencies=obj.(tmp);else; dependencies='';end %
    end
end
if ischar(developer)||isempty(developer)
    switch developer
        case 'eyalsoreq';dev = {'Eyal Soreq';'e.soreq14@imperial.ac.uk';'Imperial College London'};
        case 'rdaws';dev = {'Richard Daws';'r.daws@imperial.ac.uk';'Imperial College London'};
        otherwise;dev = {' ';' ';' '};
    end
else
    dev = developer;
end

FS = [ ['function ' syntax]
    sprintf('%s %s: %s','%',upper(name),oneliner)
    '%'
    logo
    '%'
    '%'
    sprintf('%s %s %s','%','AUTHOR: ',dev{1})
    sprintf('%s  %s %s','%','EMAIL: ',dev{2})
    sprintf('%s  %s %s','%','AFFILIATION: ',dev{3})
    sprintf('%s  %s %s CREATED: %s','%','VERSION: ',revision,date)
    '%'
    '% INPUTS:'
    arrayfun(@(x) ['%    ' x{1} ' - '],inputvar(:),'un',0)
    '%'
    '%'
    '% OUTPUT:'
    arrayfun(@(x) ['%    ' x{1} ' - '],outputvar(:),'un',0)
    '%'
    '% EXAMPLES:'
    '%{'
    syntax
    '%}'
    '%'
    '% DEPENDENCIES:'
    '%'
    copyright
    '%------------- BEGIN CODE --------------'
    '%'
    'Enter your commands here'
    '%------------- END OF CODE --------------'
    ];

end
%------------- END OF CODE --------------
