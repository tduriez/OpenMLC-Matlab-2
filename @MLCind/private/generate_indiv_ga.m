function [m]=generate_indiv_ga(gen_param)
%generate_indiv_ga    Private function of the MLC CLASS. 
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

s=size(gen_param.range);

if numel(gen_param.range)==1
    m=(rand(1,gen_param.sensors)*2-1)*gen_param.range;
elseif s(1)==1 && s(2)==gen_param.sensors
    m=(rand(1,gen_param.sensors)*2-1).*gen_param.range;
elseif s(1)==2 && s(2)==gen_param.sensors
    offsets=mean(gen_param.range);
    ranges=abs(diff(gen_param.range)/2);
    m=(rand(1,gen_param.sensors)*2-1).*ranges+offsets;
end


    










