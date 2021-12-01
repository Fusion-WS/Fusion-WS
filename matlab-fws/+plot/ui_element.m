function ui = ui_element(varargin)
% PLOT.UI_ELEMENT: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 29-Sep-2020 13:58:31
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
ui_element(input01,input02,input03,input04)
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
obj = struct('ax',false,'text',false,'ui_type',false,...
    'CallBack',false,'text_kwrg',false,'ui_kwrg',false,...
    'text_xy',[0.05,0.75],'B',false);
obj = fws.defaults(obj, varargin);
[x,y] = fws.deal(obj.text_xy);

if ~islogical(obj.text)
    text(x,y,obj.text,'Parent',obj.ax,  obj.text_kwrg{:})
    axis(obj.ax,'off');
end
if obj.ui_type   
    switch obj.ui_type
        case 'popupmenu'
            ui = uicontrol(obj.ax.Parent,'Style','popupmenu',...
                obj.ui_kwrg{:},'Position',obj.B);
        case 'edit'
            ui = uicontrol(obj.ax.Parent,'Style','edit',...
                obj.ui_kwrg{:},'Position',obj.B);
        case 'checkbox'
            ui = uicontrol(obj.ax.Parent,'Style','checkbox',...
                obj.ui_kwrg{:},'Position',obj.B,'ForegroundColor','none');
        case 'pushbutton'
            ui = uicontrol(obj.ax.Parent,'Style','pushbutton',...
                obj.ui_kwrg{:},'Position',obj.B,'ForegroundColor','none');
    end
    axis(obj.ax,'off');
end
disp('')    
end
%------------- END OF CODE --------------
