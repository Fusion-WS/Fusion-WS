function K = volume_kind(V,tail)
% FWS.VOLUME_KIND: Returns a classification of the volume "kind"
%
%   __           _             
%  / _|         (_)            
% | |_ _   _ ___ _  ___  _ __    
% |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural 
% | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
% |_|  \__,_|___/_|\___/|_| |_|
%
%
% AUTHOR:  Richard Daws
%  EMAIL:  r.daws@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 01-Jul-2020 15:09:14
%
% INPUTS:
%    V - Data to be classified into a kind (e.g., Binary, positive etc). 
% OUTPUT:
%    K - Kind is a struct with the following fields containing logicals
%       
%       'binary'      - Contains 1 & 0's
%       'two_tailed'  - Contains negative and positive values
%       'positive'    - Only contains positive values
%       'negative'    - Only contains negative values
%       'Thresholded' - Volume appears to have been statistically 
%
%
%
% EXAMPLES:
%{
K=volume_kind(V)
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


% Is the volume binary ?
if fws.isbinary(V)
    K.binary = true;
    K.two_tailed = false;
    K.positive = false;
    K.negative = false;
    K.thresholded = false;    
    
else % Continuous 
    
    K.binary = false;    
    K.positive = nnz(V(:)>0)>0; % logical :- Contains positive
    K.negative = nnz(V(:)<0)>0; % logical :- Contains negative     
    K.two_tailed = K.positive & K.negative; % Contains both positive & negative
    % Threshold check to see if nans (if present) are just outside the
    % brain or not
    CC = bwconncomp(~isnan(V)); 
    K.thresholded = CC.NumObjects>1;
    
    if tail
        switch tail
            case 'positive';K.positive = true;K.negative =false;K.two_tailed=false;
            case 'negative';K.negative = true;K.positive =false;K.two_tailed=false;
            case 'both';    K.negative = true;K.positive =true;K.two_tailed=true;
        end
    end
end

end
%------------- END OF CODE --------------
