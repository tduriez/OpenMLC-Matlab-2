function m=show_best(mlc,fig)
% SHOW_BEST display current best individual (MLC2 Toolbox)
%
%   IND_OBJ=MLC_OBJ.SHOW_BEST(N) returns the <a href="matlab:help MLCind">MLCind</a> object corresponding to
%       the best individual. Additionaly calls the evaluation function avec
%       N as fourth argument, which can be used to implement graphic
%       functions.
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
        fig=1;
    end
    eval(['heval=@' mlc.parameters.evaluation_function ';']);
            f=heval;
     [~,idx]=min(mlc.population(length(mlc.population)).costs);
     m=mlc.table.individuals(mlc.population(length(mlc.population)).individuals(idx));        
    feval(f,m,mlc.parameters,1,fig);










