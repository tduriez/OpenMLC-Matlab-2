function mlc=generate_population(mlc)
% GENERATE_POPULATION initializes the population. (MLC2 Toolbox)
%
% OBJ.GENERATE_POPULATION updates the OBJ MLC2 object with an initial population 
%
% The function creates a  <a href="matlab:help MLCpop">MLCpop</a> object defining the population and launch its 
% creation method according to the OBJ.PARAMETERS content.
% The creation algorithm is implemented in the <a href="matlab:help MLCpop">MLCpop</a> class.
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

mlc.population=MLCpop(mlc.parameters);
    [mlc.population(1),mlc.table]=mlc.population.create(mlc.parameters);
    mlc.population(1).state='created';










