function table(mdl,fn,output,caption,label,resize)
% SAVE.TABLE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 21-Sep-2020 22:02:26
%
% INPUTS:
%    input01 - 
%    input02 - 
%    input03 - 
%    input04 - 
%
%
% OUTPUT:
%
% EXAMPLES:
%{
table(input01,input02,input03,input04)
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
if ~exist('resize','var');resize=0;end

if isfield(mdl.Properties,'VarNames')
    fin =mdl.Properties.VarNames;
else 
    fin = mdl.Properties.VariableNames;
end
data = table();
for ii=1:numel(fin)
    tmp  = mdl.(fin{ii});
    data.(fin{ii}) =  mdl.(fin{ii});
    switch class(tmp)
        case 'categorical';format{ii} = '%s';
        case 'cell';format{ii} = '%s';
        case 'char';format{ii} = '%s';
        case 'double' 
            if any(mod(tmp,1))
               format{ii} = '%0.4f';
            else 
               format{ii} = '%i';
            end
        case {'uint16','uint8'};format{ii} = '%i';
    end
    
end
rows = {size(data,1)};
for ii=1:size(data,1)
row ='';
for k=1:numel(format)
    tmp = data{ii,k};
    if iscell(tmp)
        tmp=tmp{1};
        if ~isempty(tmp)
            tmp(strfind(tmp,'_'))=' ';
        else
            tmp = ' ';
        end
    end
    row = [row,sprintf([format{k} ' & '],tmp)];
end
if ii~=size(data,1);row=[row(1:end-2), '\\\midrule'];else; row= [row(1:end-2), '\\\bottomrule[0.2em]'];end
rows{ii,1} = row;
end
toprow = [strjoin(data.Properties.VariableNames,' & ') '\\\toprule[0.2em]'];
toprow(strfind(toprow,'_'))=' ';
rows = [toprow;rows];
rows = strrep(rows,'NaN',' ');
rows{end+1} = '\end{tabular}';
switch  output
    case 'latex'
        top = {
            '\begin{table}';...
            '\centering'};
        if resize
            top{end+1}='\resizebox{\textwidth}{!}{%';
            rows{end}(end+1) = '}';
        end
        bottom = {'\end{table}'};
        caption = {['\caption{' caption '\label{tabel:' label '}}']};
        header = {['\begin{tabular}[0.2em]','{@{}l',repmat('l',1,size(data,2)),'@{}}\toprule']};
        outputtable = [top;header;rows;caption;bottom];
        fid=fopen(fn,'w');
        [nrows,~] = size(outputtable);
        for row = 1:nrows
            fprintf(fid,'%s\n',outputtable{row});
        end
        fclose(fid);
    case 'csv'
        writetable(data,fn);
    otherwise    
end
        
end
%------------- END OF CODE --------------
