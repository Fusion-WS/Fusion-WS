function [AX, im] = overlay(IM,alpha,cmap,ax)
%% PLOT.OVERLAY: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 06-Mar-2019 14:07:55
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
overlay(input01,input02,input03,input04)
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


if ~exist('ax','var');ax = gca;end




imagesc(ax,IM{1});
colormap(ax,cmap{1});
axis(ax,'image')
axis(ax,'off')
ax.YDir = 'reverse';
%ax.CLim = clim;
AX = {ax};
for ii=2:numel(IM)
    ax = axes('Position',ax.Position);
    AX{ii} = ax;
    imtmp = IM{ii};
    if size(imtmp,3)>1;altmp = c3nl.scale(double(rgb2gray(imtmp)),0.01,1);else;altmp= double(imtmp);end
    imagesc(ax,imtmp,'AlphaData',altmp.*(altmp>0).*alpha(ii-1));
    colormap(ax,cmap{ii});
    axis(ax,'image')
    axis(ax,'off')
end
linkaxes([AX{:}],'xy');
if nargout==1
    tmp = getframe(ax);
    im = imresize(tmp.cdata,size(imtmp));
end


%------------- END OF CODE --------------
