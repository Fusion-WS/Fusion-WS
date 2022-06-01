function L = cluster(Y,CC,obj)
%% FWS.CLUSTER: Cluster Y connected componenets independently using morphology
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
%  VERSION:  0.0 CREATED: 30-Jun-2020 18:46:38
%
% INPUTS:
%    Y  - thresholded distance volume with positive values 
%    CC - connected componenets 
%
%
% OUTPUT:
%    L - Label map
%
% EXAMPLES:
%{
[L] = cluster(Y,CC)
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

% Define the size of the input volume
sz = size(Y); 
% preal zeros to build label map into
LL=zeros(sz); 

% Class counter - Keep track of the unique classes found
m=1;  

% We cluster within each spatial component
for jj=1:CC.NumObjects
    
    y = -inf(sz); % Create an n-dim void space of neg inf (this avoids adjacent components from being accidentally merged)
    y(CC.PixelIdxList{jj})=Y(CC.PixelIdxList{jj}); % Place the original values of the jjth component into the void (creating a mountain)
 
    d = fws.get_cc_ix(sz, obj.radius); % get connected components linear index
    [~,idx] = sort(-y(:)); % Sorted values from the inverted jjth component. This forces maxima to minima. 
  
    L = zeros(sz); % Temporary volume
    
    % for each voxel in the component
    for ii = 1:size(idx,1) 
        idx1=idx(ii);
        if y(idx1) == -inf;break;end % This is faster than removing inf from the volume
        
        % Searching for voxels in the neighbourhood that have already been labelled
        idx2=idx1+d; % Create an n-dim linear search space from the iith voxel
        c = L(idx2(idx2>0&idx2<obj.nvx));% get voxel neighborhood (asking if any neighouring voxel is labelled)
        l  = sort(c(:)); % Sort this subset
        l(~diff(l)) = []; % remove non-unique
        l(l==0) = []; % remove 0's 
        
        % t is a conditional. Either, 1. the local minima has no labels, 2. There is 1 local minima. 3 There are competing local minima
        t = find([isempty(l),numel(l)==1,numel(l)>1],1,'first');
        switch t
            case 1; L(idx(ii))=m;m=m+1; % local minima with no surrounding labels
            case 2; L(idx(ii))=l(1); % Assign this voxel to the singular local mimima neighbour
            case 3; L(idx(ii))=mode(c(c>0)); % Survival of the largest, majority vote wins. 
        end
        % Progress report
        if ~mod(ii,1000) && obj.verbose
            if mod(ii,50000);fprintf('*');else;fprintf('\n\t\t\t\t');end
        end
    end
    LL = LL + L; % Add cluster to label map
end
L = LL; % return final label map

end
%------------- END OF CODE --------------
