function mlc=go(mlc,ngen,figs)
% GO start MLC2 problem solving (MLC2 Toolbox)
%   
%   OBJ.GO(N) creates (if necessary) the population, evaluate and evolve it
%       until N evaluated generations are obtained.
%   OBJ.GO(N,1) additionaly displays the best individual if implemented in
%       the evaluation function at the end of each generation evaluation
%   OBJ.GO(N,2) additionaly displays the convergence graph at the end of
%       each generation evaluation
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

 
%% Reinitialize god.
try
    rng('shuffle'); % Official recommanded seed shuffling
catch %% take into account versions problems
    rand('seed',sum(100*clock)); % Old school deprecated seed shuffling
end

%% Solve the problem
    if nargin<3
        figs=0;
    end
    
    if nargin<2
        fprintf('Please provide an integer number of generations you want to compute\n')
        fprintf('ex: mlc=MLC2; mlc.go(15)\n')
        return
    end
    
    if ngen~=round(ngen)
        fprintf('Once you tell me how I can compute %f generations, I''ll consider doing it\n',ngen)
        fprintf('Please provide an integer, stupid!\n');
        return
    end
        
    
    curgen=length(mlc.population);
    if curgen==0 %% population is empty, we have to create it
        mlc.generate_population;
        curgen=1;
    end
    while curgen<=ngen %% ok we can do something
        switch mlc.population(curgen).state
            case 'init'  
                if curgen==1
                    mlc.generate_population;
                else     %% unlikely CHECK THIS.
                    mlc.evolve_population;
                end
            case 'created'
                if mlc.parameters.save==1;save(fullfile(mlc.parameters.savedir,'mlc_be.mat'),'mlc');end
                mlc.evaluate_population;
                if mlc.parameters.save==1;save(fullfile(mlc.parameters.savedir,'mlc_ae.mat'),'mlc');end
            case 'evaluated'
                curgen=curgen+1; 
                if figs>0
                    mlc.show_best;
                    drawnow;
                end
                if figs>1
                    mlc.show_convergence;
                    drawnow;
                end
                if curgen<=ngen
                    mlc.evolve_population;
                end     
        end

    end
end










