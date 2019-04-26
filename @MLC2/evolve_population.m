function mlc=evolve_population(mlc,n)
% EVOLVE_POPULATION evolves the population. (MLC2 Toolbox)
%
% OBJ.EVOLVE_POPULATION updates the OBJ MLC2 object with a new MLCpop object
%     in the OBJ.POPULATION array containing the evolved population                   
%
%   The evolution algorithm is implemented in the <a href="matlab:help MLCpop">MLCpop</a> class.
%
%   See also MLCPARAMETERS, MLCPOP
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

if nargin<2
        n=length(mlc.population);

end
    [mlc.population(n+1),mlc.table]=mlc.population(n).evolve(mlc.parameters,mlc.table);
    
    %% Remove duplicates
    if mlc.parameters.lookforduplicates
        mlc.population(n+1).remove_duplicates;
        idx=find(mlc.population(n+1).individuals==-1);
        while ~isempty(idx);
                [mlc.population(n+1),mlc.table]=mlc.population(n).evolve(mlc.parameters,mlc.table,mlc.population(n+1));
                mlc.population(n+1).remove_duplicates;
                idx=find(mlc.population(n+1).individuals==-1);
        end
    end
    mlc.population(n+1).state='created';
    
    
    










