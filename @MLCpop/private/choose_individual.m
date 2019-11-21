function idv_orig=choose_individual(mlcpop,mlc_parameters,idx_source_pool);
% copyright
switch mlc_parameters.selectionmethod
%% Tournament
    case 'tournament'
        selected=zeros(1,mlc_parameters.tournamentsize);  %% initialisation of selected individuals for tournament
        for i=1:mlc_parameters.tournamentsize             %% selecting the individuals
            n=ceil(rand*length(idx_source_pool));         %% random integer between 1 and length(idx_source_pool)
            while max(n==selected)                        %% avoid repetition 
                n=ceil(rand*length(idx_source_pool));
            end
            selected(i)=idx_source_pool(n);
        end
        
        [~,k]=min(mlcpop.costs(selected));
        idv_orig=selected(k);
        
    case 'FitnessProp'
        try 
        fitnesses=1./mlcpop.costs(idx_source_pool);
        probs=cumsum(fitnesses)/sum(fitnesses);
        idx=find(sign(rand-probs)==-1,1);
        idv_orig=idx_source_pool(idx);
        catch err
            keyboard
        end
        
    case 'FitnessPropAdj'
        fitnesses=1./(1+mlcpop.costs(idx_source_pool));
        probs=cumsum(fitnesses)/sum(fitnesses);
        idx=find(sign(rand-probs)==-1,1);
        idv_orig=idx_source_pool(idx);
        
        
end











