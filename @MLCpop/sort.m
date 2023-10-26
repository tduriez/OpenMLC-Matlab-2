function mlcpop=sort(mlcpop,mlc_parameters)
% copyright
idxsubgen=subgen(mlcpop,mlc_parameters);
%% normal sort




if mlc_parameters.objectives==1
    
    for i=1:length(idxsubgen)
        [~,idx]=sort(mlcpop.costs(idxsubgen{i}));
        mlcpop.individuals(idxsubgen{i})=mlcpop.individuals(idxsubgen{i}(idx));
        mlcpop.costs(idxsubgen{i})=mlcpop.costs(idxsubgen{i}(idx));
        mlcpop.parents(idxsubgen{i})=mlcpop.parents(idxsubgen{i}(idx));
        mlcpop.gen_method(idxsubgen{i})=mlcpop.gen_method(idxsubgen{i}(idx));
    end
    
%% multi ojective sort
% In this case the sort is not achieved in function of cost but on which
% Pareto front the individual is living
else
    mlcpop.ParetoRank=getParetoRank(mlcpop.costs,mlc_parameters.badvalue);
    for i=1:length(idxsubgen)
        [~,idx]=sort(mlcpop.ParetoRank(idxsubgen{i}));
        mlcpop.individuals(idxsubgen{i})=mlcpop.individuals(idxsubgen{i}(idx));
        mlcpop.costs(:,idxsubgen{i})=mlcpop.costs(:,idxsubgen{i}(idx));
        mlcpop.parents(idxsubgen{i})=mlcpop.parents(idxsubgen{i}(idx));
        mlcpop.gen_method(idxsubgen{i})=mlcpop.gen_method(idxsubgen{i}(idx));
        mlcpop.ParetoRank(idxsubgen{i})=mlcpop.ParetoRank(idxsubgen{i}(idx));
    end
end
    
    










