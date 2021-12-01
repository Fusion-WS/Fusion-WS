function [V,G] = interpolator(varargin)
% FWS.INTERPOLATOR: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 03-Jul-2020 12:21:50
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
interpolator(input01,input02,input03,input04)
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
obj = struct('method','nearest'...
            ,'source_volume',false,'source_grid',false...
            ,'target_volume',false,'target_grid',false);
        
obj = fws.defaults(obj, varargin);

if numel(obj.source_volume)==1 && numel(obj.target_volume)==1
   error('This function needs two volumes to work with')  
end

% source dimensions 
sd = obj.source_grid.d;

%% find dimension to flip to ensure monotonic increasing grids in both target and source
obj.source_flip = fws.flip_order(obj.source_grid.mat);
obj.target_flip = fws.flip_order(obj.target_grid.mat);


%% flip dimensions if needed 
[fsv,fsg]= fws.flip_volume(obj.source_volume,obj.source_grid,obj.source_flip);
[~,ftg]= fws.flip_volume(obj.target_volume,obj.target_grid,obj.target_flip);


%% Create source and target mesh grids 

[Xs,Ys,Zs] = meshgrid(fsg.mm{2},fsg.mm{1},fsg.mm{3});
[Xt,Yt,Zt] = meshgrid(ftg.mm{2},ftg.mm{1},ftg.mm{3});       


if numel(sd)==3
    V = interp3(Xs,Ys,Zs,fsv,Xt,Yt,Zt,obj.method);           
    G = ftg;
    if ~isempty(obj.target_flip)
        [V,G]= fws.flip_volume(V,ftg,obj.target_flip); % flip back to match target grid
    end
else
    V = zeros([td(1:3),sd(4)]);
    for ii=1:sd(4)
        V(:,:,:,ii) = interp3(Xs,Ys,Zs,fsv(:,:,:,ii),Xt,Yt,Zt,obj.method);           
    end
    G = ftg;
    if ~isempty(obj.target_flip)
        [V,G]= fws.flip_volume(V,ftg,obj.target_flip); % flip back to match target grid
    end
    G.d = size(V);
end


    
%------------- END OF CODE --------------
