function [rectangles,array] =  tree_map(ax,data,labels,cmap,fs,ar)
% PLOT.TREE_MAP: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 21-Sep-2020 13:28:00
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
tree_map(input01,input02,input03,input04)
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

set(0,'RecursionLimit',1000)
[w,h] = fws.deal(ax.Position(3:4));
area_ratio = (w * h) / sum(data);
[v,idx] = sort(data,'descend');
p = fws.tile(v,w,h,ar);
rectangles = zeros(4,length(data));
array = zeros(round(1e3*w),round(1e3*h));
[ox,oy] = fws.deal([0,0]);
is = 1;
ri = 1;
for ii = 1:length(p)
   ie = is+p(ii)-1;
   chunk = v(is:ie);
   is = ie+1;
   block_area = chunk * area_ratio;
   column_area = sum(block_area); 
   [bx,by] = fws.deal([ox,oy]);
   layout = subsref({'r';'c'}, substruct('{}',{(w>h)+1}));
   switch layout
       case 'r'
           column_height = column_area / w;
           for jj = 1:p(ii)
               block_width = block_area(jj) / column_height;
               rectangles(:,idx(ri)) = [bx,by,block_width,column_height];
               ri=ri+1;
               bx = bx+block_width;
           end
           oy = oy+column_height;
           h = h-column_height;
       case 'c'
           column_width = column_area / h;
           for jj = 1:p(ii)
               block_height = block_area(jj) / column_width;
               rectangles(:,idx(ri)) = [bx,by,column_width,block_height];
               ri=ri+1;
               by = by+block_height;
           end
           ox = ox+column_width;
           w = w-column_width;
   end
end
rec = round(rectangles*1e3);
for ii=1:size(rec,2)
   r = rec(:,ii);
   array(r(1)+1:r(1)+r(3),r(2)+1:r(2)+r(4))=ii;
end

plot.rectangles(ax,rectangles,labels,cmap,fs);

%------------- END OF CODE --------------
