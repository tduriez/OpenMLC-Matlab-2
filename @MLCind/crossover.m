function [new_ind1,new_ind2,fail]=crossover(mlcind,mlcind2,mlc_parameters)
% CROSSOVER crosses two MLCind individuals.
%
%   [NEW_IND1,NEW_IND2,FAIL]=CROSSOVER(MLCIND1,MLCIND2,MLC_PARAMETERS);
%
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

switch mlc_parameters.individual_type
        case 'tree'
            [m1,m2,fail]=crossover_tree(mlcind.value,mlcind2.value,mlc_parameters);
            new_ind1=MLCind;
            new_ind1.generate(mlc_parameters,m1);
            new_ind2=MLCind;
            new_ind2.generate(mlc_parameters,m2);
	case 'ga'
            [m1,m2,fail]=crossover_ga(mlcind.value,mlcind2.value,mlc_parameters);
            new_ind1=MLCind;
            new_ind1.generate(mlc_parameters,m1);
            new_ind2=MLCind;
            new_ind2.generate(mlc_parameters,m2);
		

    end










