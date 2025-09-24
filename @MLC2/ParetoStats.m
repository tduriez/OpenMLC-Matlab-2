function ParetoStats(mlc,ngen,thename)
    fprintf('News from the Pareto Front:\n')
    fprintf('Number of control objectives: %d\n',mlc.parameters.objectives);
    fprintf('Number of Pareto Fronts: %d\n',length(unique(mlc.population(ngen).ParetoRank)));
    fprintf('Size of first front: %d\n',sum(mlc.population(ngen).ParetoRank==1));
    disp(sprintf('View <a href="matlab:showParetoProgression(%s)">Graphic</a>',thename));
