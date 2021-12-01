function obj = generate_ROI(P,varargin)
% FWS.GENERATE_ROI: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 01-Jul-2020 16:02:57
%  0.1 UPDATED: 11-Jul-2020 16:02:57 (Eyal Soreq)
%
% INPUTS:
%    P - A full filepath to a NifTi (.nii or .nii.gz) that has been 
%        registered to MNI space
%    	 
% OUTPUT:
%   obj - A struct object containing 
%
% EXAMPLE:
%   P='/path/to/3d/nifti/file/;
%   obj = fws.generate_ROI(P, 'radius', 2) - Run FWS with a voxel radius of
%                                            2
%
%   obj = fws.generate_ROI('demo') - Runs FWS on a two-tailed unthresholded 
%                                    activation map (Fedorenko et al.,
%                                    2013).
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
%
%
%
%% Welcome logo
clc
disp('   __           _             ');
disp('  / _|         (_)            ');
disp(' | |_ _   _ ___ _  ___  _ __   ');
disp(' |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural ');
disp(' | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages');
disp(' |_|  \__,_|___/_|\___/|_| |_|');
fprintf('\n Generating ROIs in present working directory:\n\t%s\n',pwd)

%% DEFAULTS & INPUT HANDLING 

tc=tic;

% Load nifti
if any(strcmp(P,{'demo','demo_unthr'}))
    
    src = strsplit(which(['fws.' mfilename]), 'Fusion-Watershed');
    tmpP = [src{1} 'Fusion-Watershed' filesep 'data' filesep 'DMN_MD_Fedorenko.nii.gz'];

    fprintf('\n Loading image:\n\t%s\n',tmpP);
    [V,G,hdr] = load.vol(tmpP);
    
    if strcmp(P,'demo')
        V(V<1.5)=NaN; % Apply Federenko t-stat = 1.5 threshold
    end
    
    P=tmpP;
    
else
   
    fprintf('\n Loading image:\n\t%s\n',P);
    [V,G,hdr] = load.vol(P);    
    
end



% Put everything into a struct
obj = struct('path',P,'input_volume',double(V),'volume',double(V),'grid',G,...
             'header',hdr,'radius',1,'merge',100,'filter',300,'verbose',true,...
             'tail',false,'threshold_method','iqr','output',false,...
             'threshold_value',0.85,'threshold_plot',false,...
              'smooth',false,'plot',true,'export',true,'binary',false);
         
% Parse user inputs          
obj = fws.defaults(obj, varargin);

if ~obj.output
    D = new.folder([],pwd,{'output'});
end    

% Clear data that is now in obj
clear P V G hdr

%% PREPROCESS VOLUME

% Work out the kind of input
obj.K = fws.volume_kind(obj.volume,obj.tail); 

% Progress update
if obj.verbose
    fd=fieldnames(obj.K);
    
    fprintf('\n Input kind:\n')
    if obj.K.binary
        fprintf(['\t binary: %s\n'], mat2str(obj.K.binary))
    else
        fprintf(['\t thresholded: %s\n'], mat2str(obj.K.thresholded))
        if obj.K.two_tailed
            fprintf(['\t two-tailed: %s\n'], mat2str(obj.K.two_tailed))
        else
            fprintf(['\t one-tailed: %s\n'], fd{contains(fd, {'positive','negative'}) & struct2array(obj.K)'})
        end
    end
    clear fd
end    
    
if obj.smooth
    obj.volume = imgaussfilt3(obj.volume,obj.smooth);
end
% Is volume binary?
if obj.K.binary
    % Convert volume into an inverted distance matrix
    obj.volume = fws.bin_to_inv_distance(obj.volume);

else % If volume is parametric/continuous 
    if obj.K.two_tailed % Two-tailed, it has both positive and negative values

        % Split volume into seperate pos & neg volumes
        [pV,nV]=deal(obj.volume);        pV(pV<=0)= NaN; nV(nV>=0)= NaN;
        if ~obj.K.thresholded
                if obj.verbose; fprintf('\n Unthresholded map: \n\t Applying threshold to positive & negative values...\t%s\n',''); end
                [obj.pV,pt] = fws.threshold('data', pV, 'threshold_method',obj.threshold_method, 'threshold_value',obj.threshold_value,'plot',obj.threshold_plot); 
                [obj.nV,nt] = fws.threshold('data', abs(nV), 'threshold_method',obj.threshold_method, 'threshold_value',obj.threshold_value,'plot',obj.threshold_plot); % Return neg as absolute values
        else
            obj.threshold_method = 'predefined';
            [pt,nt] = fws.deal([min(pV(~isnan(pV))),min(abs(nV(~isnan(nV))))]);
        end
        obj.volume = cat(4,obj.pV,obj.nV);
        obj.threshold_value = [pt,-nt];
    
        
    else % One_tailed, it has either positive or negative values
        if ~obj.K.thresholded % IQR threshold% IQR threshold
            if obj.verbose; fprintf('\n Unthresholded map: thresholding...\t%s\n',''); end

           switch obj.tail
               case 'positive';obj.volume(obj.volume<=0)=nan;
               case 'negative';obj.volume(obj.volume>=0)=nan;    
           end
                
            [obj.volume,obj.threshold_value] = fws.threshold('data', abs(obj.volume),'threshold_method',obj.threshold_method, 'threshold_value',obj.threshold_value,'plot',obj.threshold_plot);
        else 
            obj.threshold_value = min(obj.volume(~isnan(obj.volume)));
            obj.threshold_method = 'predefined';
        end
        
    end
end

if obj.binary
    obj.volume = fws.bin_to_inv_distance(~isnan(obj.volume));
end

%% WATERSHED

if obj.K.two_tailed
    % Seprate watershed calls on positive and negative volumes
    if obj.verbose; fprintf('\n Segmenting positives\t%s',''); end
    pL = fws.watershed(obj.pV,'radius',obj.radius,'merge',obj.merge,'filter',obj.filter,'verbose',obj.verbose); % Pos watershed
    
    if obj.verbose; fprintf('\n Segmenting negatives\t%s',''); end
    nL = fws.watershed(obj.nV,'radius',obj.radius,'merge',obj.merge,'filter',obj.filter,'verbose',obj.verbose); % Neg watershed    
           
    % combine labels
    if obj.verbose; fprintf('\n Combining labels%s',''); end
    obj.label = fws.combine_labels(nL, pL);
    obj.pL = obj.label.*(pL>0);
    obj.nL = obj.label.*(nL>0);
else % Binary or one_tailed
    if obj.verbose; fprintf('\n Segmenting map \t\t%s',''); end
    obj.label = fws.watershed(obj.volume,'radius',obj.radius,'merge',obj.merge,'filter',obj.filter,'verbose',obj.verbose); 
end


%% TABLE

% Assign each ROI with atlas information
if ~islogical(obj.tail)
    switch obj.tail
        case 'negative';obj.table = fws.label_to_table('volume',-obj.volume,'label', obj.label, 'grid', obj.grid);
        otherwise;obj.table = fws.label_to_table('volume',obj.volume,'label', obj.label, 'grid', obj.grid);
    end
else
    obj.table = fws.label_to_table('volume',obj.input_volume,'label', obj.label, 'grid', obj.grid);
end
% Define number of ROIs in parcellation 
obj.nROI = height(obj.table);
% Sort table rows from largest positive peak to largest negative
obj.table = sortrows(obj.table,'Peak', 'descend'); % Sort table 

if obj.K.two_tailed 
    obj.nROI_negative = numel(unique(obj.nL(obj.nL>0)));
    obj.nROI_positive = numel(unique(obj.pL(obj.pL>0)));  
end


if obj.plot % Minimal visualisation figure
    fprintf('\n Generating interactive figure\n')
    obj = plot.interactive(obj);
    
    if obj.verbose
        fprintf(' Completed segmentation & ROI visualisation in %s seconds\n',num2str(toc(tc))) 
    end
    
elseif obj.verbose
    fprintf('\n Completed segmentation in %s seconds\n',num2str(toc(tc)))  
end

%------------- END OF CODE --------------
end