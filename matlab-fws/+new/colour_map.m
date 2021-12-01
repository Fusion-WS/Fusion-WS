function map = colour_map(varargin)
% NEW.COLOUR_MAP: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 08-Jul-2020 12:00:14
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
colour_map(input01,input02,input03,input04)
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



CM = struct('colour',false,'n',64,'weights',false,'map',false);
CM = fws.defaults(CM, varargin);


% Default colours
if ~islogical(CM.map)
    switch CM.map
        case 'pos';   CM.colour = fws.hex2rgb(["B21212";"F59B1A"]);
        case 'neg';   CM.colour = fws.hex2rgb(["3361AB";"2DBDE9"]);
        case 'both';  CM.colour = fws.hex2rgb(["2DBDE9";"3361AB";"C1BDBD";"B21212";"F59B1A"]);
        case 'pos_dist';  CM.colour = fws.hex2rgb(["510707";"B21212";"F59B1A";"F9F685"]);%"FCFCF7"
        case 'neg_dist';  CM.colour = fws.hex2rgb(["0A1260";"3361AB";"2DBDE9";"B0F0FF"]);%;"EBFBFF"    
        case 'soreq'; CM.colour = [0.2745 0.251 0.6; 0.1176 0.5961 0.8353; 0 0 0; 0.9843 0.7765 0.3333; 0.9569 0.9216 0.1451];
        otherwise
            error(['Error: ' CM.map 'not recognised'])
    end
end


if size(CM.colour,2) ~= 3 || size(CM.colour,1) < 2
   error('Error: colour must be a nx3 matrix with at least 2 rows') 
end

if ~CM.weights
    CM.weights = linspace(0,1,size(CM.colour,1));
end

if (range(min(CM.colour(:),max(CM.colour(:))))>1||any(CM.colour(:)>1))
    CM.color = fws.scale(CM.colour);
end
map = interp1(CM.weights,CM.colour,linspace(0,1,CM.n));
%------------- END OF CODE --------------
