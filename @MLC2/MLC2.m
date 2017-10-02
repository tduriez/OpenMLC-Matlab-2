classdef MLC2 < handle
% MLC2 constructor of the Machine Learning Control 2 class.
%   The MLC2 class is a handle class that implements <a href="matlab: 
%   web('http://www.arxiv.org/abs/1311.5250')">a machine learning control problem</a>.
%
%   OBJ_MLC=MLC2 implements a new MLC problem using default options
%   OBJ_MLC=MLC2('FILENAME') implements a MLC problem using options
%   defined in M-file FILENAME.
%
%   Ex:
%   TOY=MLC2;TOY.go(3); % computes 3 generations for the default problem.
%   TOY=MLC2;TOY.go(13,1); % computes 13 generations for the default problem
%   with graphical output.
%   TOY2=MLC('toy2_cfg');TOY2.go(2) % computes 2 generations of the problem
%   defined in toy2_cfg.m file.
%
%   MLC2 properties:
%      <a href="matlab:help MLCtable">table</a>        - contains the individual database as a <a href="matlab:help MLCtable">MLCtable</a> object.
%      <a href="matlab:help MLCpop">population</a>   - contains one <a href="matlab:help MLCpop">MLCpop</a> object per generation.
%      <a href="matlab:help MLCparameters">parameters</a>   - contains the parameters as a <a href="matlab:help MLCparameters">MLCparameters</a> object.
%      version      - current version of MLC2.
%
%   MLC2 methods:
%      generate_population  -  generate the initial population. 
%      evaluate_population  -  evaluate current unevaluated population.
%      evolve_population    -  evolve current evaluated population.
%      go                   -  automatize generation evaluation and evolution.
%      genealogy            -  draws the genealogy of the individuals.
%      show_best            -  returns and shows the best individual.
%      show_convergence     -  show the repartition of the population costs.
%
%   See also MLCPARAMETERS, MLCTABLE, MLCPOP, MLCIND
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
        table
        population
        parameters
        version
    end
    
    methods
        obj=generate_population(obj);
        obj=evaluate_population(obj,n);
        obj=evolve_population(obj,n);
        obj=go(obj,n,figs);
        genealogy(obj,ngen,idv);
        m=show_best(obj,fig);
        show_convergence(obj,nhisto,Jmin,Jmax,linlog,sat,gen_range,axis);
        
        function obj=MLC2(varargin)
            vers = '0.2.5';
            obj.table=[];
            obj.population=[];
            obj.parameters=MLCparameters(varargin{:});
            obj.parameters.opset=opset(obj.parameters.opsetrange);
            obj.version=vers;
            
            
            
            
            
            
            
            
            
        end
    end
end
            










