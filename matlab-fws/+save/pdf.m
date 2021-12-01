function pdf(name, width, height,render,bkg)
%% SAVE.PDF: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 17-Jun-2017 06:08:22
%
%% INPUTS:
%    input01 - 
%    input02 - 
%    input03 - 
%    input04 - 
%
%
%% OUTPUT:
%
%% EXAMPLES:
%{
pdf(input01,input02,input03,input04)
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
setenv('PATH', [getenv('PATH') ':/usr/local/bin'])
if ~exist('bkg','var');bkg='none';end
if ~exist('render','var');render='painter';end % zbuffer opengl painter
set(gcf, 'InvertHardCopy', 'off');
h=gcf;
h.Color = bkg;
h.Renderer = render;
h.PaperUnits = 'centimeters';
h.PaperPosition = [0, 0, width, height];
h.PaperSize = [width height];
saveas(h,[name '.pdf'],'pdf');
system(['gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sOutputFile=' name ' -f ' name '.pdf']);
system(['rm ' name '.pdf']);


%------------- END OF CODE --------------
