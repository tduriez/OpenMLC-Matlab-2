 function instructions=remove_irrelevant_instructions(instructions,nBuffers)
        useful_buffer=1;
        useful=zeros(1,size(instructions,1));
        for i=size(instructions,1):-1:1
            if ismember(instructions(i,1),useful_buffer)
                if ismember(instructions(i,1),useful_buffer)
                   useful(i)=1;
                end
                useful_buffer=setdiff(useful_buffer,instructions(i,1));
                useful_buffer=unique([useful_buffer instructions(i,2)]);
                if instructions(i,4) <= nBuffers
                    useful_buffer=unique([useful_buffer instructions(i,4)]);
                end
            end
        end
        useless_buffer=setdiff(1:nBuffers,useful_buffer);
        for i=1:numel(useless_buffer)
            instructions=instructions(instructions(:,1)~=useless_buffer(i),:);
        end
    end