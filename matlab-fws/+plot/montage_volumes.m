function im = montage_volumes(varargin)
% PLOT.MONTAGE_VOLUMES: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 29-Sep-2020 09:04:28
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
montage_volumes(input01,input02,input03,input04)
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

% Defaults
obj = struct('volume',false,'grid',false,'dim',3,'R',[],'C',[],'cmap',false,...
    'labels',false,'slice_info',false,'alpha',1,'selected_slices',false,...
    'ax',false,'output',false,'remove_empty',true);
obj = fws.defaults(obj, varargin);

% Make sure all volumes match the scale of the first volume
vol = obj.volume;
grid = obj.grid;

if numel(vol)>=2
    for ii=2:numel(vol)
        vol{ii} = fws.interpolator('source_volume',vol{ii},...
                                   'source_grid',grid{ii},...
                                   'target_volume',vol{1},'target_grid',grid{1});
    end
end

% Make sure all volumes are in the right orientation
ix = true(3,1);ix(obj.dim)=0;
[h,v] = fws.deal([find(ix,1,'first'),find(ix,1,'last')]);
for ii=1:numel(vol)
    vol{ii} = permute(vol{ii},[h v obj.dim]);
end


% If selected slices is not false extract only these from all volumes 
if obj.selected_slices
    for ii=1:numel(vol)
        vol{ii} = vol{ii}(:,:,obj.selected_slices);
    end
end

% if remove empty is not false identify slices that have no signal in the 
% overlay volumes and remove them from all volumes   
if obj.remove_empty

    
    end
% Now compute the montage grid
sz = size(vol{1});
mn = [isempty(obj.R)&isempty(obj.C),...  % No rows or cols defined
      isempty(obj.C)&~isempty(obj.R),... % Rows are defined
      isempty(obj.R)&~isempty(obj.C),... % Columns are defined
      ~isempty(obj.R)&~isempty(obj.C)];  % Both are defined

switch find(mn)
    case 1
        R = ceil(sqrt(sz(3)));
        if R*(R-1)>sz(3);C = R-1;else;C=R;end
    case 2; C = ceil(sz(3)/R);
    case 3; R = ceil(sz(3)/C);
    case 4; [R,C] = fws.deal(obj.R,obj.C);     
end


% For each volume fill the montage image with selected slices 
for k=1:numel(vol)
    tmp = nan(R*sz(2),C*sz(1));
    c = 1;
    for ii=1:R
        for jj=1:C
            x = (jj-1)*sz(1);
            y = (ii-1)*sz(2);
            if(c<=sz(3)); tmp(y+1:y+sz(2),x+1:x+sz(1)) = fliplr(rot90(vol{k}(:,:,c)));end
            c = c+1;
        end
    end
    im{k} = tmp;
end

% If axis is given we plot the image 
AX = [];
if ~islogical(obj.ax)
    % If no colormaps were given we apply heuristics to create them
    for k=1:numel(vol)
        ax = axes('Position',obj.ax.Position);
        
        imagesc(ax,im{k},'AlphaData',~isnan(im{k}));
        axis (ax,'off');
        colormap(ax,obj.cmap{k})
        AX = [AX,ax];    
    end
end


end



%------------- END OF CODE --------------
