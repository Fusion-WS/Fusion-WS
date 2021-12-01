function [V,G] = flip_volume(V,G,flip_dim)

% FWS.FLIP_VOLUME: One line description of what the function or script performs
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
%  VERSION:  0.0 CREATED: 03-Jul-2020 12:45:06
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
flip_volume(input01,input02,input03,input04)
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

if ~isempty(flip_dim)
    for ii=1:numel(flip_dim)
        switch flip_dim(ii)
            case 1 
                G.mm{1} = fliplr(G.mm{1});
                V = flip(V,1);
                [~,ix]=max(abs(G.mat(1,1:3)));                
                G.vx(1) = -G.vx(1);
                G.mat(1,[ix,4]) =   [-1*G.mat(ix,1),G.mm{1}(1)-G.vx(1)];
                G.bb(1,1:2)=G.bb(1,[2,1]);
            case 2
                G.mm{2} = fliplr(G.mm{2});
                V = flip(V,2);
                [~,ix]=max(abs(G.mat(2,1:3)));                
                G.vx(2) = -G.vx(2);
                G.mat(2,[ix,4]) =   [-1*G.mat(ix,2),G.mm{2}(1)-G.vx(2)];
                G.bb(2,1:2)=G.bb(2,[2,1]);
            case 3
                G.mm{3} = fliplr(G.mm{3});
                V = flip(V,3);
                [~,ix]=max(abs(G.mat(3,1:3)));                
                G.vx(3) = -G.vx(3);
                G.mat(3,[ix,4]) =   [-1*G.mat(ix,3),G.mm{3}(1)-G.vx(3)];
                G.bb(3,1:2)=G.bb(3,[2,1]);
        end
    end
end


%------------- END OF CODE --------------
