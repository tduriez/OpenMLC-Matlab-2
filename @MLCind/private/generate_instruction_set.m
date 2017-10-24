   function instructions=generate_instruction_set(nInstructions,nBuffers,nConstants,parameters,previous_instructions)
   debug=0;     
        
        if debug
            fprintf('nInstructions = %d\n',nInstructions);
            fprintf('nBuffers = %d\n',nInstructions);
            fprintf('nConstants = %d\n',nInstructions);
            fprintf('nargin = %d\n',nargin);
        end
   
        SensorOrConstant=rand(nInstructions,1)<parameters.sensor_prob;
        Operations=parameters.opsetrange(ceil(rand(nInstructions,1)*numel(parameters.opsetrange)));
        OutputBuffer=ceil(rand(nInstructions,1)*nBuffers);
        InputBuffer1=ceil(rand(nInstructions,1)*nBuffers);
        InputBuffer2=zeros(nInstructions,1);
        InputBuffer2(SensorOrConstant==1)=ceil(rand(sum(SensorOrConstant),1)*nBuffers);
        InputBuffer2(InputBuffer2==0)=ceil(rand(sum(InputBuffer2==0),1)*nConstants)+nBuffers;
        instructions=[OutputBuffer InputBuffer1 Operations(:) InputBuffer2];
        instructions(end,1)=1;
        if nargin==5
            instructions=[previous_instructions; instructions];
        end
    end