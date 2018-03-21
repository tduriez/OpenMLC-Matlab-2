function f=testt(t,T)
%TESTT program crashes when t>T 
%
%   F=TESTT(t,T)
%
%   Adding this to a function to integrate in ODExxx allows to trigger an error 
%   when t>T. Calling this function with t=TOC allows to stop integration
%   after T seconds in real time. Usually used inside a TRY/CATCH sequence.
%
%   Copyright (C) 2018 Thomas Duriez
%   This file is part of the OpenMLC Toolbox 2. Distributed under GPL v3.

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

 
    if t>T
   fprintf('Crash provided by testt. Consider augmenting the allowed evauation time if the occurence is high.m\n');
   crash % variable is not defined, hence produces an error
    else
        f=0;
    end


















































