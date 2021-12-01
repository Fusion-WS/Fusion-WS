function group_hor_hist(X,gp,cmap,ax,Alpha)
%% PLOT.group_hor_hist: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 26-Jan-2020 09:33:33
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
gpHorHist(input01,input02,input03,input04)
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

hold(ax,'on');
order = categories(gp);
for c=1:numel(order)  
        xt =  fws.winsorize(X(gp==order{c}));
        pd = fitdist(xt,'Kernel');
        splt = range(xt);
        y = quantile(xt,[0,1]);
        xi = y(1)*0.9:splt/100:y(2)*1.1;
        f = pdf(pd,xi);
        xi(f<1e-3)=[];
        f(f<1e-3)=[];
        f = [0,f,0];
        patch([xi(1),xi,xi(end)],f,cmap(c,:).^0.5,'FaceAlpha',Alpha,'Edgecolor',max(cmap(c,:)-0.5,0),'parent',ax);
end


%------------- END OF CODE --------------
