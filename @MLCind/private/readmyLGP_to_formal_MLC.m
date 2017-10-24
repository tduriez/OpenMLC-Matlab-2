function idv_formal=readmyLGP_to_formal_MLC(idv_value,parameters)
    nBuffers=max(parameters.sensors*parameters.bufferspersensor,parameters.controls);
    Buffers=cell(1,nBuffers);
    Constants=linspace(-parameters.range,parameters.range,round(2/(10^-parameters.precision)));
    for i=1:nBuffers
        Buffers{i}=sprintf('S%i',mod(i-1,parameters.sensors));
    end
    
    for i=1:size(idv_value,1);
        the_op=parameters.opset(parameters.opsetrange==idv_value(i,3));
        the_exp=the_op.litop;
        arg1=Buffers{idv_value(i,2)};
        the_exp=strrep(the_exp,'arg1',arg1);
        if the_op.nbarg==2
            if idv_value(i,4)<=nBuffers;
                arg2=Buffers{idv_value(i,4)};
            else
                arg2=sprintf('%f',Constants(idv_value(i,4)-nBuffers));
            end
            the_exp=strrep(the_exp,'arg2',arg2);
        end
        Buffers{idv_value(i,1)}=sprintf('(%s)',the_exp);
    end
    
    idv_formal=Buffers{1};
end
            
        
        
        