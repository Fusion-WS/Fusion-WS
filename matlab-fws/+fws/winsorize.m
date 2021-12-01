function Xw =winsorize(X,fc,method)
%% C3NL.WINSORIZE: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 08-Jun-2017 16:32:40
%
%% INPUTS:
%    X - input data in m x n format where rows represent observation and columns represent features
%    fc - the trimming factor either percentage or in std
%    method - 0 is percentage 1 = std (default is std)
%
%
%% OUTPUT:
%
%% EXAMPLES:
%{
Xw = c3nl.winsorize(X);
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
if nargin<3;method = 1;end % default is std
if nargin<2;fc = 2.5;end % default is 2.5 std

d = size(X);
if numel(d)>2
    disp('ERROR this function can only deal with 2D matrixes')
    return
end

Xw = nan(d);
for ii=1:d(2)
    ix =isnan(X(:,ii));
    switch method
        case 0
           t_thr =  prctile(X(~ix,ii), 100-fc);
           b_thr =  prctile(X(~ix,ii), fc);
        case 1   
           t_thr =  mean(X(~ix,ii)) + std(X(~ix,ii))*fc;
           b_thr =  mean(X(~ix,ii)) - std(X(~ix,ii))*fc;
        case 2   
           [~,thr]=boundary(paretotails(X(:),fc/100,(100-fc)/100));
           t_thr = thr(2);
           b_thr = thr(1);
    end
    Xw(~ix,ii) = max(min(X(~ix,ii),t_thr),b_thr);    
end

%------------- END OF CODE --------------
