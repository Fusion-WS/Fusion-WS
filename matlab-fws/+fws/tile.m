function partition = tile(v,w,h,ar)
% FWS.PARTITION_AREA: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 21-Sep-2020 13:40:20
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
partition_area(input01,input02,input03,input04)
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
[long_side,short_side] = fws.deal(subsref({ [h,w];[w,h]}, substruct('{}',{(w>h)+1})));
best_aspect_ratio = inf;
area_ratio = (w * h) / sum(v);
partition = [];
for ii = 1:length(v) % go over elemnets in v
    column_total = sum(v(1:ii));
    column_area = column_total * area_ratio;
    column_width = column_area / short_side;
    sum_aspect_ratio = 0;
    for jj = 1:ii
        block_area = v(jj) * area_ratio;
        block_height = block_area / column_width;
        aspect_ratio = block_height / column_width;
        if(aspect_ratio < ar) % make sure aspect_ratio is larger than one
            aspect_ratio = ar;
        end
        sum_aspect_ratio = sum_aspect_ratio + aspect_ratio;
    end
    mu_aspect_ratio = sum_aspect_ratio/ii;
    if (mu_aspect_ratio >= best_aspect_ratio)
        if (partition < ii)        
            p = fws.tile(v(ii:end),short_side,long_side - column_width,ar);
            partition = [partition,p];
        end
        return
    end
    best_aspect_ratio = mu_aspect_ratio;
    partition = ii;
end
end
            
%------------- END OF CODE --------------
