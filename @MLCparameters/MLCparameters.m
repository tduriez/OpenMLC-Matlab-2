classdef MLCparameters < handle
%SET_MLCPARAMETERS   Function for the constructor the MLC Class. Sets default values and calls parameters script.
%  PARAMETERS=set_MLC_parameters returns a pre-structure of parameters for
%  the MLC Class, with default values. (solves 'toy_problem').
%  PARAMETERS=set_MLC_parameters(FILENAME) returns a pre-structure of 
%  parameters for the MLC Class with default values overriden by
%  instructions in the FILENAME M-script. Ex: <a href="matlab:help GP_lorenz">GP_lorenz.m</a>
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

 

properties
    size
    sensors
    sensor_spec
    sensor_list
    controls
    sensor_prob
    leaf_prob
    range
    precision
    opsetrange
    opset
    formal
    end_character
    individual_type
    
    maxdepth
    maxdepthfirst
    mindepth
    mutmaxdepth
    mutmindepth
    mutsubtreemindepth
    generation_method
    gaussigma
    ramp
    maxtries
    mutation_types
    
    elitism
    probrep
    probmut
    probcro
    selectionmethod
    tournamentsize
    lookforduplicates
    simplify
    cascade

    evaluation_method
    evaluation_function
    indfile
    Jfile
    exchangedir
    evaluate_all
    ev_again_best
    ev_again_nb
    ev_again_times
    artificialnoise
    execute_before_evaluation
    badvalue
    badvalues_elim
    preevaluation
    preev_function
    
    save
    saveincomplete
    verbose
    fgen
    show_best
    problem_variables
end

properties 
    savedir
end

properties (SetAccess = private, Hidden)   
    badvalues_elimswitch=1;
    dispswitch=0;
end

methods
    function parameters=elimswitch(parameters,value)
        parameters.badvalues_elimswitch=value;
    end
    function parameters=disp_switch(parameters,value)
        parameters.dispswitch=value;
    end
    
    %% Constructor
    function parameters=MLCparameters(filename)
        %% Call defaults
        mlcdir=which('MLCparameters');
        idx=strfind(mlcdir,'@MLCparameters');
        mlcdir=mlcdir(1:idx-1);
        run(fullfile(mlcdir,'@MLCparameters','private','MLCparameters_default.m'));

        %% Call configuration script if present
        if nargin==1
            fprintf(1,'%s\n',filename);
            run(filename)
        
        end
        
        
        parameters.savedir=fullfile(parameters.savedir,datestr(now,'yyyymmdd-HHMM'));
        [s,mess,messid] = mkdir(parameters.savedir);
        if s==1
            clear s;clear mess;clear messid;
        else
           fprintf('%s',mess);
        end

    end
end
end













