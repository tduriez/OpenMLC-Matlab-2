function [m,J]=show_ind(mlc,n,N)
% SHOW_IND display selected individual (MLC2 Toolbox)
%
%   IND_OBJ=MLC_OBJ.SHOW_IND(n,N) returns the <a href="matlab:help MLCind">MLCind</a> object corresponding to
%       the individual as per index in the <a href="matlab:help MLCtable">MLCind</a>. Additionaly calls the evaluation function avec
%       N as fourth argument, which can be used to implement graphic
%       functions.
%
%   Copyright (C) 2015-2019 Thomas Duriez.
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

    if nargin<3
        fig=1;
    end
    eval(['heval=@' mlc.parameters.evaluation_function ';']);
            f=heval;
     
     m=mlc.table.individuals(n);        
    J=feval(f,m,mlc.parameters,1,fig);


