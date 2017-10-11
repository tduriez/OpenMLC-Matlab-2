function new_value=mutate_LGP(old_value,parameters,type);
    nTypes=2;
    
    if nargin<3
        type=ceil(rand*nTypes);
    end
    
    switch type
        %% replace n instructions by new set of m instructions. 
        case 1
            iReplacement=ceil(rand*size(old_value,1));
            nReplacement=ceil(rand*
    
    

    