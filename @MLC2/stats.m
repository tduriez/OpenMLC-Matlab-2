function stats(mlc,nb)
%STATS    Method of the MLC class. Computes statistics.
%
%   MLC_OBJ.STATS displays statistics on the MLC process. Show statistics
%   for all generations.
%   MLC_OBJ.STATS(NB) displays statistics on the MLC process. Show statistics
%   for generation NB.
%
%   See also MLC, SHOW_CONVERGENCE, SHOW_STATS, SHOW_TREEDEPTH
%
%   Copyright (C) 2016 Thomas Duriez, Steven Brunton, Bernd Noack
%   This file is part of the OpenMLC Toolbox. Distributed under GPL v3.

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

if nargin>1
    sgen=nb;
else
    sgen=1;
end
lgen=length(mlc.population);
if min(mlc.population(lgen).costs)==-1
    lgen=lgen-1;
end
for ngen=sgen:lgen;
    if isempty(mlc.population(1).costs)
        fprintf('Maybe start the GP before you ask some stats\n');
        fprintf('(And that''s me beeing polite here...)\n');
    else
        [minJ,k]=min(mlc.population(ngen).costs);
        bestidv=mlc.table.individuals(mlc.population(ngen).individuals(k));
        meanJ=mean(mlc.population(ngen).costs(mlc.population(ngen).costs<mlc.parameters.badvalue));
        stdJ=std(mlc.population(ngen).costs(mlc.population(ngen).costs<mlc.parameters.badvalue));
        toohigh=sum(mlc.population(ngen).costs==mlc.parameters.badvalue);
        fprintf('After generation %i:\n',ngen);
        fprintf('Best individual:\n');
        if ~strcmp(mlc.parameters.individual_type,'ga')
        fprintf('%s\n',bestidv.value);
        else
            theformat=['%4.2f'];
            for i=1:mlc.parameters.sensors-1
                theformat=sprintf('%s %s',theformat,'%4.2f');
            end
            fprintf(theformat,bestidv.value);fprintf('\n');
        end
        fprintf('Best J (average over %i occurence(s)): \t %e\n',numel(bestidv.cost_history),minJ);
        fprintf('Average J of population:\t\t %e\n',meanJ);
        fprintf('Std deviation of J in Population:\t %e\n',stdJ);
        fprintf('Average and std computed for values below %e (%i cases)\n',mlc.parameters.badvalue,toohigh);
        if ngen<lgen;fprintf('\n\n');end
    end
end