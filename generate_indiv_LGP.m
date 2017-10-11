function instructions=generate_indiv_LGP(parameters,mode);
%generate_indiv_LGP     Private function of the MLC CLASS. Grow LGP
%                       individuals.
%    [M]=generate_indiv_LGP(parameters,TYPE) seriously... that's a
%    PRIVATE function...
%
%    parameters contains the parameters from the MLC object.
%    (obj.parameters)
%
%    TYPE will condition how the LGP individual grows:
%           - 0 Random program length between parameters.mindepth and
%           parameters.maxdepth
%           - 1 generates a instruction set of exactly parameters.maxdepthfirst.
%           - 2 generates a instruction set up to parameters.maxdepthfirst.
%           - 3 Reserved for trees
%           - 4 Reserved for trees
%
%   Instruction sets are always four numbers
%   OB IB OP IB2
%   OB: output buffer
%   IB: input buffer
%   OP: operation number
%   IB2: input buffer or constant number
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
    mode=-1;
end

if isempty(mode)
    mode=-1;
end

if mode==1;
    mindepth=parameters.maxdepthfirst;
    maxdepth=parameters.maxdepthfirst;
elseif mode==2
    mindepth=parameters.mindepth;
    maxdepth=parameters.maxdepthfirst;
else
    mindepth=parameters.mindepth;
    maxdepth=parameters.maxdepth;
end




nInstructions=mindepth+ceil(rand*(maxdepth-mindepth));
nBuffers=max(parameters.sensors*parameters.bufferspersensor,parameters.controls);
Constants=linspace(-parameters.range,parameters.range,round(2/(10^-parameters.precision)));
nConstants=numel(Constants);
instructions=generate_instruction_set(nInstructions,nBuffers,nConstants,parameters);
instructions=remove_irrelevant_instructions(instructions,nBuffers);
while size(instructions,1)<nInstructions
    instructions=generate_instruction_set(nInstructions-size(instructions,1),nBuffers,nConstants,parameters,instructions);
    instructions=remove_irrelevant_instructions(instructions,nBuffers);
end
end

 

   










