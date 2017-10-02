function obj=insert_individual(obj,idv)
    if length(obj.population)>1
        error('Can''t insert individual once the process started.');
    end
    
    if length(obj.population)==1
        if any(strcmp(obj.population(1).state,{'evaluated','created'}))
            error('Can''t insert individual once the process started.');
        end
        
        if all(obj.population(1).individuals>0)
        error('Can''t insert individual. Population seems full.');
        end
    end
    
    if ~isa(idv,'MLCind')
        temp=idv;
        idv=MLCind;
        idv.generate(obj.parameters,temp);
    end
    if isempty(obj.table)
         obj.table=MLCtable(obj.parameters.size(1)*50);
    end
    [~,number]=obj.table.add_individual(idv);
    
    if isempty(obj.population)
        obj.population=MLCpop(obj.parameters);
    end
    
    idxes=find(obj.population(1).individuals==-1);
    obj.population(1).individuals(idxes(1))=number;
    

end