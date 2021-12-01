function T = label_to_table(varargin)
%% FWS.LABEL_TO_TABLE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 30-Jun-2020 18:46:39
%
% INPUTS:
%    L - 
%
%
% OUTPUT:
%    T - 
%
% EXAMPLES:
%{
[T] = label_to_table(L)
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

source = strsplit(which(['fws.' mfilename]),'+');
load([source{1} filesep '+fws' filesep 'atlas.mat']);


obj = struct('atlas',{fieldnames(Atlas)},'volume',false,'label',false,'grid',false,'verbose',true);
obj = fws.defaults(obj, varargin);

if numel(obj.label)==1
    error('Label map not found')
end

if islogical(obj.grid)
    error('Grid is not found')
end

if ~islogical(obj.volume)
    magnitude = true;
else
    magnitude = false;
end

% Interpolate atlas(es) to match label grid
if obj.verbose
    fprintf(['\n Interpolating %s atlases' repmat(' ',1,10)],numel(obj.atlas))
    tic;
end


for ii = 1:numel(obj.atlas)
    Atlas.(obj.atlas{ii}).Lr = fws.interpolator('source_volume',Atlas.(obj.atlas{ii}).L,'source_grid',Atlas.(obj.atlas{ii}).G,'target_volume',obj.label,'target_grid',obj.grid);
    fprintf('*')
end

if obj.verbose
    tC=toc; 
    fprintf(' Completed in %s seconds\n',num2str(tC))
end


% number of clusters / ROIs
id = unique(obj.label(~isnan(obj.label))); 

if obj.verbose
   fprintf('\n Assigning labels to %s ROIs\t', num2str(numel(id(2:end)))) 
end


T = table();
if obj.verbose; tc=tic; end
for ii=id(2:end)' % Skipping 0's
    tmp = table();
    tmp.ROIid = ii;
    
% Spatial location function    
    BW = obj.label==ii; % ROI mask 
    ix = find(obj.label==ii); % finding the linear index of voxels in mask
    tmp.Volume = numel(ix); % ROI size (n voxels)
    [x,y,z] = ind2sub(size(obj.label),ix); % Convert to 3D indx
    [I,J,K]=deal(fix(mean(x)),fix(mean(y)),fix(mean(z))); % Find the centre coordinates of the ROI
    
    % Hack to deal with euclidean centre being outside of volume
    if ~BW(I,J,K) % this means that the shape is irregular and that the centroid is out of the volume
        [I,J,K]=ind2sub(size(BW),ix(knnsearch([x,y,z],[I,J,K]))); % so we find the closest 
    end
    
    % Pull summary statistics 
    if magnitude
         
        tmpBW = obj.label==ii; % ROI index
        tmpVx = obj.volume(tmpBW); % Pull a vector of the statistical values within the ROI
        tmpMx = max(abs(tmpVx)); % Max ROI value
        
        % Find the subscript index of the max voxel location 
        [I,J,K]=ind2sub(size(tmpBW), find((abs(obj.volume).*tmpBW) == tmpMx, 1,'first')); 

        % Store max, mean and standard deviation and the location of the max coorindate in tmp
        tmp = [tmp, array2table([max(abs(tmpVx)) * mode(sign(tmpVx)) mean(tmpVx) std(tmpVx)], 'VariableNames', {'Peak','Mean','SD'}) table(obj.grid.convert([J,I,K]),'VariableNames',{'Peak_Magnitude_XYZ'})];
        tmpXYZ = tmp.Peak_Magnitude_XYZ; % Max/peak coordinate in MNI
        
    else % Binary maps
        tmp = [tmp,table(obj.grid.convert([J,I,K]),'VariableNames',{'Centre_of_mass_XYZ'})];
        tmpXYZ = tmp.Centre_of_mass_XYZ;
    end  
    
% AAL function    
    tmp.hemisphere = categorical(find([tmpXYZ(1)==0,tmpXYZ(1)<0,tmpXYZ(1)>0]),1:3,{'Medial','Left','Right'}); % Find which hemisphere the peak is in
    
    % Use the AAL to define which lobe to define which lobe that most of the ROI voxels are in
    tmp1 = Atlas.AAL2.Lr(BW); 
    if any(tmp1)
        tmp1 = Atlas.AAL2.T(Atlas.AAL2.T.ROIid==mode(tmp1(tmp1~=0)),:);
        tmp.lobe = categorical(floor(tmp1.regioncode/1000),1:9,{'Nan','Frontal','Insula','Limbic','Occipital','Parietal','subcorticalGM','Temporal','Cerebelum'});
    else
        tmp.lobe = categorical({'null'});
    end
    
% Pull labels from each atlas
    for in=1:numel(obj.atlas)
        tmp1 = Atlas.(obj.atlas{in}).Lr;
        tmp1 = tmp1(ix(tmp1(ix)~=0));
        if ~isempty(tmp1)
            Lid = mode(tmp1); % Define label using the voxel-atlas intersection mode 
            Lp = nnz(tmp1==Lid)/nnz(ix); % Label probability - number of voxels matching label / number of ROI voxels 
            Lname = Atlas.(obj.atlas{in}).T.ROIname(Atlas.(obj.atlas{in}).T.ROIid==Lid); % Label name
        else 
            Lid = 0;Lp = 0; Lname = categorical({'null'});
        end
       tmp = [tmp,table(Lid,Lp,Lname,'VariableNames',cellfun(@(a) sprintf('%s_%s',a,obj.atlas{in}),{'id','P','name'},'un',0))];
    end

    % Store ROI labels in T
    T = [T;tmp];
    
    if obj.verbose
        fprintf('*');
        if ~mod(ii,80); fprintf(['\n' repmat(' ',1,32)]);end 
    end
end

if obj.verbose
    fprintf(['\n' repmat(' ',1,32) 'Completed in %s seconds\n'],num2str(toc(tc)))
end

end

%------------- END OF CODE --------------