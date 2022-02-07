function [new_m,fail]=mutate_ga_integer_permutation(m,gen_param,forcetype)
fail=0;




%% equi probability for each mutation type selected.
if nargin<3
    type_mut=gen_param.mutation_types(floor(rand*(length(gen_param.mutation_types)))+1);
else
    type_mut=forcetype;
end

type_mut=1;

switch type_mut
    %% mutation 'replace up to 50% of the content'
    case 1
        nrep=randi(round(gen_param.sensors/2))+1;
        idx1=randperm(gen_param.sensors,nrep);
        
        new_m=m;
        new_m(idx1)=m(idx1(randperm(numel(idx1))));
        
        %% rearrage part of the way
    case 2
       
end





end













