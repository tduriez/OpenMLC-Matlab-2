%TOY2_CFG    parameters script for MLC
%    Type mlc=MLC('toy_cfg') to create corresponding MLC object
parameters.size=1000;
parameters.sensors=1;
parameters.controls=1;
parameters.objectives=2;
parameters.range=10;
parameters.precision=4;
parameters.opsetrange=[1 2 3 4 5 6 7 8 9];
parameters.maxdepth=15;
parameters.maxdepthfirst=5;
parameters.mindepth=2;
parameters.mutmindepth=2;
parameters.mutmaxdepth=15;
parameters.mutsubtreemindepth=2;
parameters.generation_method='mixed_ramped_gauss';
parameters.gaussigma=3;
parameters.ramp=[2 3 4 5 6 7 8];
parameters.elitism=1;
parameters.probrep=0.1;
parameters.probmut=0.1;
parameters.probcro=0.8;
parameters.selectionmethod='MultiTournament';
parameters.tournamentsize=7;
parameters.lookforduplicates=1;
parameters.simplify=0;
parameters.evaluation_method='mfile_standalone';
parameters.evaluation_function='toy_problem_multi';
parameters.indfile='ind.dat';
parameters.Jfile='J.dat';
parameters.exchangedir='/home/tduriez/Dropbox/GP/MLC_withclasses_v3.0/MLC_tools/Lorenz_Problem/evaluator0';
parameters.evaluate_all=0;
parameters.artificialnoise=0;
parameters.execute_before_evaluation='';
parameters.badvalue=1e+36;
parameters.badvalues_elim='first';
parameters.save=0;
parameters.verbose=[0 0 0 0 0 0];
parameters.fgen=250;
parameters.show_best=1;
parameters.problem_variables.time=-10:0.01:10;
parameters.problem_variables.b=0.5*parameters.problem_variables.time.^2+sin(1.256*parameters.problem_variables.time)+1.2;












