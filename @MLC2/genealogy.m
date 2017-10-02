function genealogy(mlc,gen,idv)
% GENEALOGY (MLC2 Toolbox)
%
%   Directly taken from MLC. Dev version, not tested. 
%
%   Copyright (C) 2015-2017 Thomas Duriez.
%   This file is part of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

figure
    hold on
    for i=1:gen
        plot(ones(1,length(mlc.population(i).individuals))*i,1:length(mlc.population(i).individuals),'o');
    end
    lnwidth=1;
    idx1=idv;
    for i=gen:-1:2
        idx2=[];
        for j=idx1
        idxn=mlc.population(i).parents{j};
        hold on
        switch mlc.population(i).gen_method(j)
            case 1
                mkfc='b';
            case 2 
                mkfc='r';
            case 3
                mkfc='k';
            case 4
                mkfc='y';
        end
      %  set(p(i,j),'markerfacecolor',mkfc,'color',color);
        for k=idxn 
        plot([i i-1],[j,k],'color',mkfc,'linewidth',lnwidth)
%         if i==indiv
%             plot([i i-1],[j,k],'color','k','linewidth',1)
%             drawnow
%         end

        end
        %hold off
        idx2=[idx2 idxn];
        end
    idx1=idx2;
    end
        










