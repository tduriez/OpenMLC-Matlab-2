function out=compare(mlcind,mlcind2)
% COMPARE     compares two MLCind value properties.
%
%   ISEQUAL=COMPARE(MLCIND1,MLCIND2) returns 1 if both values are equal.
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

switch mlcind.type
	case 'tree'
            out=strcmp(mlcind.value,mlcind2.value);
    case 'micronetwork'
            out=strcmp(mlcind.value,mlcind2.value);
	case 'ga'
		out=all(mlcind.value==mlcind2.value);
end
end










