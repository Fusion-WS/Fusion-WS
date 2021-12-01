function radar(ax,M,gp,lim,labels,a,cmap,fs)
%% PLOT.NEWRADAR: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 06-Jan-2020 00:00:24
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
newRadar(input01,input02,input03,input04)
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
disp('')

box = ax.Position;
axis(ax,'off')
ax = axes('Position',[box(1)+box(3)*0.1,box(2)+box(4)*0.1,box(3)*0.8,box(4)*.8]);

Ticks = linspace(lim(1),lim(2),5);
[~,N] = size(M);
m = numel(unique(gp));
r = (Ticks(:)-lim(1))/range(lim)*ones(1,N);
th = (2*pi/N)*(ones(numel(Ticks),1)*(N:-1:1))+pi/2;
[x,y] = pol2cart(th, r);
h1 = line([x,x(:,1)]',[y,y(:,1)]','LineWidth',0.5,'Color',0.65.*ones(1,3),'Parent',ax);

% Plot label axes 
th = (2*pi/N)*(ones(2,1)*(N:-1:1))+pi/2;
radii   = [zeros(1,N); ones(1,N)];
[x,y]   = pol2cart(th, radii);
h2  = line(x,y,'LineWidth',1,'Color',0.65.*ones(1,3),'Parent',ax);



if exist('labels','var')
    y = y(2,:);
    x = x(2,:);
    for ii=1:N
        t = atan2(y(ii),x(ii));
        r = subsref({struct('rot', t*180/pi,'dir','left'); struct('rot', 180*(t/pi + 1),'dir','right')}, substruct('{}', {(abs(t) > pi/2)+ 1}));
        text(x(ii).*a,y(ii).*a,labels{ii},'rotation',  r.rot,'HorizontalAlignment',r.dir,'interpreter','none','parent', ax,'FontSize',fs);
    end
end



axis(ax, 'off')
daspect(ax,[1,1,1])
Xm = grpstats(M,gp,'mean');
Xs = grpstats(M,gp,'std');
Xp = Xm + Xs;
Xn = Xm - Xs;

hold(ax, 'on')
r = ([Xm,Xm(:,1)]-lim(1))/range(lim);
rp = ([Xp,Xp(:,1)]-lim(1))/range(lim);
rn = ([Xn,Xn(:,1)]-lim(1))/range(lim);
th = (2*pi/N)*((N+1:-1:1))+pi/2;
[xp,yp] = pol2cart(th, rp);
[xn,yn] = pol2cart(th, rn);
[x,y] = pol2cart(th, r);

for ii=1:m
patch([yp(ii,:),fliplr(yn(ii,:))]',[xp(ii,:),fliplr(xn(ii,:))]',cmap(ii,:),'FaceAlpha',0.65,'EdgeColor','none','Parent',ax);
plot(y(ii,:),x(ii,:),'LineWidth',1.5,'Color',cmap(ii,:),'Parent',ax)
end

r = (Ticks(:)-lim(1))/range(lim)*ones(1,N);
th = (2*pi/N)*(ones(2,1)*(N:-1:1))+pi/2;
[x,y] = pol2cart(th(:,1), r(:,1)');
text(ax,x(2,:),y(2,:),num2cell(Ticks),'HorizontalAlignment','left','FontSize',fs*0.8)


%------------- END OF CODE --------------
