function nfv = bevel_text(varargin)
% FWS.BEVEL_TEXT: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 06-Aug-2020 22:11:37
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
bevel_text(input01,input02,input03,input04)
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
obj = struct('string','A','fontsize',100,'smooth',5,...
            'reducepatch',0.05,'w',400,'h',400,'s',3);
obj = fws.defaults(obj, varargin);

obj.x = linspace(-1,1,obj.w);        
obj.y = linspace(-1,1,obj.h);
obj.z = linspace(-0.1,0.1,obj.s);


hg = figure('Name','tmp','units','pixels','position',[100 100 obj.w obj.h],'Visible','off','resize','off');clf;

ax = axes(hg,'Position',[0,0,1,1]);
text(0.5,0.5,obj.string,'FontWeight','bold',...
    'FontUnits','pixels','FontSize',obj.fontsize,...
    'HorizontalAlignment','center','VerticalAlignment','middle');

tmp = getframe(ax);
tmp = tmp.cdata(:,:,1)==0;
tmp = imresize(imgaussfilt(double(tmp),obj.smooth),[obj.w,obj.h]);
[X,Y,Z]= meshgrid(obj.x,obj.y,obj.z);
tmp = cat(3,zeros(obj.w,obj.h,1),tmp,zeros(obj.w,obj.h,1));

fv = isosurface(X,Y,Z,tmp,0.5);
nfv = reducepatch(fv,0.05);
nfv.vertices = nfv.vertices - mean(nfv.vertices);
% 
% figure(2);clf
% ax= gca;
% patch(nfv,'FaceColor','k','EdgeColor','none',...
%       'facealpha',1,'facelighting','flat','Parent', gca);
% patch('Faces', fv.faces, 'Vertices', fv.vertices.*[10,10,10]+[10,-60,0])
% view(270,45)
% 
close(hg)
end

%------------- END OF CODE --------------
