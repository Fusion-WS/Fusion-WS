function obj = interactive(obj)
% PLOT.INTERACTIVE: Function to generate the intertactive figure.
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
%  VERSION:  0.0 CREATED: 11-Jul-2020 22:00:02
%
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

% Orthogonal planes to visualise input volume
plane = ["a","rs","ca"];
tmp = {};
tic
for ii=1:3
    if obj.K.two_tailed
        tmp{ii} = plot.mip(cat(4,obj.pV,obj.nV),obj.grid,'plane',plane(ii),'color',{new.colour_map('map','pos_dist','n',100),new.colour_map('map','neg_dist','n',100)});
    elseif obj.K.negative
         tmp{ii} = plot.mip(obj.volume,obj.grid,'plane',plane(ii),'color',new.colour_map('map','neg_dist','n',100));
    else
        tmp{ii} = plot.mip(obj.volume,obj.grid,'plane',plane(ii),'color',new.colour_map('map','pos_dist','n',100));
    end
end

fg=figure('Name',obj.path,'NumberTitle','off','Position',[300 300 1100 600],'Visible','off','MenuBar', 'none','ToolBar', 'none'); clf;

% Panel positions 
P = [0,0.88,1,0.12; %top
    0,0.025,1,0.855; %main
    0,0,1,0.025]; %bottom
B = [0.3 0.92 0.06 0.04;  %filter
    0.46 0.92 0.06 0.04; %radius
    0.62 0.92 0.06 0.04; %merge
    0.74 0.91 0.12 0.06; %reapply
    0.87 0.91 0.12 0.06]; %export

T = [0.60,0.85; %Fusion
    0.625,1.195; %Watershed
    2.65,1;%Filter'
    4.25,1; %Radius'
    5.9,1]; %Merge
g = [0.004,0.015,0.165,0.0025];
w = [0.146,0.19,0.155,0.35,0.2,0.08];
h = [0.36,0.36,0.36,0.70,0.23,0.23];
c = [1,1,1,3,2,2];
x = [0,0.07,0.615];y=[0.46,0.15,0.1];

% Figure panel text(s)
Lt = ["Fusion","Watershed","Filter","Radius","Merge"];

% Main panels
top = axes('Position',P(1,:));disableDefaultInteractivity(top);
main = axes('Position',P(2,:));disableDefaultInteractivity(main);
bottom = axes('Position',P(3,:));disableDefaultInteractivity(bottom);

% Add the orthogonal panels
AX = {};
for ii=1:3
    AX{ii}=axes('Position',[x(c(ii))+g(1)+g(2)*ii+sum(w(1:(ii-1))),y(c(ii)),w(ii),h(ii)]);
end

AX{4}=axes('Position',[x(c(4)),y(c(4)),w(4),h(4)]);
for ii=5:6
    AX{ii}=axes('Position',[x(c(ii))+g(3)*(ii-5)+sum(w(5:(ii-1))),y(c(ii)),w(ii),h(ii)]); 
end

imagesc(top,ones(1,10));axis(top,'off');colormap(top,fws.hex2rgb("181932"));
imagesc(main,ones(1,10));axis(main,'off');colormap(main,fws.hex2rgb("F0F7FC"));
imagesc(bottom,ones(1,10));axis(bottom,'off');colormap(bottom,fws.hex2rgb("181932"));

% Add the parameter input fields
% Filter
uicontrol(fg, 'Style','edit','Units','normalized',...
    'Position',B(1,:),'CallBack',@callb,...
    'String',obj.filter,'FontUnits','normalized','FontSize',0.5,...
    'FontName','Helvetica','Tag','Filter');
% Radius
uicontrol(fg, 'Style','edit','Units','normalized',...
    'Position',B(2,:),'CallBack',@callb,...
    'String',obj.radius,'FontUnits','normalized','FontSize',0.5,...
    'FontName','Helvetica','Tag','Radius');
% Merge
uicontrol(fg, 'Style','edit','Units','normalized',...
    'Position',B(3,:),'CallBack',@callb,...
    'String',obj.merge,'FontUnits','normalized','FontSize',0.5,...
    'FontName','Helvetica','Tag','Merge');
% Reapply button 
ra = uicontrol(fg,'Style', 'pushbutton', 'String', 'Re-apply',...
    'Units','normalized','Position', B(4,:),'CallBack',@callb,...
    'FontUnits','normalized','FontSize',0.5,'FontName','Helvetica',...
    'FontWeight','bold','ForegroundColor',fws.hex2rgb("979797"),...
    'BackgroundColor',fws.hex2rgb("F2F2F2"),'Tag','Reapply');
% Export button
uicontrol(fg,'Style', 'pushbutton', 'String', 'Export',...
    'Units','normalized','Position', B(5,:),'CallBack',@callb,...
    'FontUnits','normalized','FontSize',0.5,'FontName','Helvetica',...
    'FontWeight','bold','ForegroundColor',fws.hex2rgb("181932"),...
    'BackgroundColor',fws.hex2rgb("BBDCF5"),'Tag','Export');

text(T(1,1),T(1,2),'Fusion','FontName','Helvetica','Color',fws.hex2rgb("F0F7FC"),...
    'HorizontalAlignment','left','VerticalAlignment','middle','Parent',top,...
    'FontWeight','bold','FontUnits','normalized','FontSize',0.5)

for ii=2:5
    text(T(ii,1),T(ii,2),Lt(ii),'FontName','Courier','Color',fws.hex2rgb("BBDCF5"),...
        'HorizontalAlignment','left','VerticalAlignment','middle',...
        'FontUnits','normalized','FontSize',0.29,'Parent',top);
end


% fill panels 
titles = ["Axial";"Sagittal";"Coronal"];

for ii=1:3
    plot.mip_blend(AX{ii},tmp{ii});
    title(AX{ii},titles(ii));
    AX{ii}.FontSize = 20;
end

% Plot the 3D ROI plot
obj = plot.ui_roi(AX{4},obj);
text(main,7.5,0.535,'Fusion-WS ROIs','FontSize',22,'FontWeight','bold')

% Plot ROI stats
plot.ui_bar(AX{5},obj.table.Peak,1:height(obj.table),obj.colour_map,'Peak magnitude',[num2str(obj.nROI) ' ROIs']);
% Plot ROI volumes
plot.ui_barh(AX{6},obj);


rotate3d(top,'off');
rotate3d(main,'off');
for ii=1:6
    rotate3d(AX{ii},'off');
end
rotate3d(AX{4},'on');

    function [] = callb(H,E)
        a = str2double(H.String);
        switch H.Tag
            case {'Merge','Radius','Filter'}
                ra.BackgroundColor =   fws.hex2rgb("BBDCF5");   
                ra.ForegroundColor =    fws.hex2rgb("181932");   
                if strcmp(H.Tag,'Merge'); obj.merge = a;end
                if strcmp(H.Tag,'Radius'); obj.radius = a;end
                if strcmp(H.Tag,'Filter'); obj.filter = a;end
             case 'Reapply'
                if obj.verbose 
                    fprintf('\n Re-applying Fusion-WS');
                    fprintf('\n Parameters:\n\t filter: %s\n\t radius: %s\n\t merge : %s\n', num2str(obj.filter), num2str(obj.radius), num2str(obj.merge)); 
                end
                
                f = plot.wait_bar(0,'Reapplying Watershed');    
                if obj.K.two_tailed
                    pL = fws.watershed(obj.pV,'radius',obj.radius,'merge',obj.merge,'filter',obj.filter,'verbose',false);
                    plot.wait_bar(0.25,'Finished parcellating positive tail',f);   
                    nL = fws.watershed(obj.nV,'radius',obj.radius,'merge',obj.merge,'filter',obj.filter,'verbose',false);
                    plot.wait_bar(0.5,'Finished parcellating negative tail',f);   
                    obj.label = fws.combine_labels(nL, pL);
                    plot.wait_bar(0.65,'Finished merging parcellation sets',f);   
                else
                    obj.label = fws.watershed(obj.volume,'radius',obj.radius,'merge',obj.merge,'filter',obj.filter,'verbose',false); 
                    plot.wait_bar(0.65,'Finished parcellation',f); 
                end
                
                obj.table = fws.label_to_table('volume',obj.input_volume,'label', obj.label, 'grid', obj.grid);
                plot.wait_bar(0.75,'Finished label to table',f); 
                obj.nROI = height(obj.table);
                obj.table = sortrows(obj.table,'Peak', 'descend'); % Sort table 
                obj = plot.ui_roi(AX{4},obj);
                plot.wait_bar(0.9,'Finished ploting ROI sets',f); 
                plot.ui_bar(AX{5},obj.table.Peak,1:height(obj.table),obj.colour_map,'Peak magnitude',[num2str(obj.nROI) ' ROIs']);
                plot.ui_barh(AX{6},obj);
                ra.BackgroundColor =   fws.hex2rgb("F2F2F2");   
                ra.ForegroundColor =    fws.hex2rgb("979797"); 
                close(f);
                
                if obj.verbose; fprintf('\n'); end
                
            case 'Export'
                [~,name,~] = fileparts(obj.path);
                name = erase(name,'.nii');
                file_name = sprintf('%s_f-%i_r-%i_m-%i_tm-%s_tv-%.2f',name,obj.filter,obj.radius,obj.merge,obj.threshold_method,obj.threshold_value);
                file_name = [obj.output,filesep,file_name];
                
                if obj.verbose; fprintf('\n Exporting Label map NifTi & table csv to:\n\t%s\n', file_name); end 
                
                save.vol(obj.label,obj.grid,[file_name,'.nii'])
                writetable(obj.table,[file_name,'.csv'])
        end
    end

fg.Visible = 'on';
end


%------------- END OF CODE --------------
