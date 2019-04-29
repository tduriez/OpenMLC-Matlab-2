function [new_m,fail]=mutate_ga(m,gen_param,forcetype)
fail=0;


%% equi probability for each mutation type selected.
if nargin<3
    type_mut=gen_param.mutation_types(floor(rand*(length(gen_param.mutation_types)))+1);
else
    type_mut=forcetype;
end

type_mut=ceil(type_mut/2);

switch type_mut
    %% mutation 'replace up to 50% of the content with uniform randomness'
    case 1
        Nchanges=0;
        while Nchanges==0
            Nchanges=round(rand*numel(m));
        end
        
        new_m=generate_indiv_ga(gen_param);
        idx=randperm(numel(m));
        m(idx(1:Nchanges))=new_m(idx(1:Nchanges));
        new_m=m;
        
        %% mutation gaussian shift
    case 2
        s=size(gen_param.range);
        
        if numel(gen_param.range)==1
            new_m=m+randn(1,gen_param.sensors)*gen_param.range;
        elseif s(1)==1 && s(2)==gen_param.sensors
            new_m=m+randn(1,gen_param.sensors).*gen_param.range;
        elseif s(1)==2 && s(2)==gen_param.sensors
            ranges=abs(diff(gen_param.range)/2);
            new_m=m+randn(1,gen_param.sensors).*ranges;
        end
        
end


%% enforce hard limits
s=size(gen_param.range);
if numel(gen_param.range)==1
    lb=ones(1,numel(m))*-abs(gen_param.range);
    ub=ones(1,numel(m))*abs(gen_param.range);  
elseif s(1)==1 && s(2)==gen_param.sensors
    lb=-abs(gen_param.range);
    ub=abs(gen_param.range);
elseif s(1)==2 && s(2)==gen_param.sensors
    ranges=sort(gen_param.range);
    lb=ranges(1,:);
    ub=ranges(2,:);
end

new_m(new_m<lb)=lb(new_m<lb);
new_m(new_m>ub)=ub(new_m>ub);


end













