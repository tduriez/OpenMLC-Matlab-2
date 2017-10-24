function [new_value,fail]=mutate_LGP(old_value,parameters,type);
    nTypes=3;
    fail=0;
    
    
    if nargin<3
        type=ceil(rand*nTypes);
    end
    
    nBuffers=max(parameters.sensors*parameters.bufferspersensor,parameters.controls);
    Constants=linspace(-parameters.range,parameters.range,round(2/(10^-parameters.precision)));
    nConstants=numel(Constants);

    
    switch type
        %% replace n consecutive instructions by new set of m consecutive instructions. 
        case 1
            iReplacement=ceil(rand*size(old_value,1));
            nReplacement=ceil(rand*size(old_value,1))-iReplacement;
            nReplacement=max(1,nReplacement);
            mReplacement=ceil((rand+0.5)*nReplacement*1.5);
            
            new_value1=old_value(1:iReplacement-1,:);
            new_value2=old_value(iReplacement+nReplacement:end,:);
            new_value=[new_value1; generate_instruction_set(mReplacement,nBuffers,nConstants,parameters); new_value2];
        
        %% replace n random instructions by n random instructions.
        case 2
            nRep=ceil(rand*size(old_value,1)/2); % max replacement rate 50%, minimum 1.
            idxRep=randperm(size(old_value,1));
            idxRep=idxRep(1:nRep);
            ReplacementInstructions=generate_instruction_set(nRep,nBuffers,nConstants,parameters);
            new_value=old_value;
            new_value(idxRep,:)=ReplacementInstructions;
        
        %% Remove first n instructions
        case 3
            nRep=ceil(rand*size(old_value,1)/2); % max suppression rate 25%, minimum 1.
            new_value=old_value(nRep+1:end,:);
            
    end
            
    
    

    