function [mlcpop,mlctable]=evaluate(mlcpop,mlctable,mlc_parameters,eval_idx);
% copyright
    verb=mlc_parameters.verbose;
    ngen=mlcpop.gen;
    %% If present, execute_before_evaluation
    if ~isempty(mlc_parameters.execute_before_evaluation)
        feval(mlc_parameters.execute_before_evaluation,mlc_parameters,mlcpop,mlctable);
    end
        
    
    %% Determine individuals to evaluate
    idv_to_evaluate=mlcpop.individuals(eval_idx);
    JJ=zeros(1,length(idv_to_evaluate));
    date_ev=JJ;
    if verb>0;fprintf('Evaluation of generation %d\n',ngen);end
    if verb>1;fprintf(['Evaluation method: "' mlc_parameters.evaluation_method '"\n']);end
    %% Check if method was interupted
    if exist(fullfile(mlc_parameters.savedir,'MLC_incomplete.mat'),'file') && mlc_parameters.saveincomplete==1;
        ic=0;
        load(fullfile(mlc_parameters.savedir,'MLC_incomplete.mat'),'JJ','ic');
        istart=ic;
    else
        istart=1;
    end

    %% Beginning method dependent evaluation
   	
    switch mlc_parameters.evaluation_method
        case 'test'
            for i=istart:length(eval_idx);
                if mlc_parameters.saveincomplete==1
                    ic=i;
                    save(fullfile(mlc_parameters.savedir,'MLC_incomplete.mat'),'JJ','ic');
                end
                if verb>1;fprintf('Individual %i from generation %i\n',eval_idx(i),ngen);end
                if verb>2;fprintf('%s\n',mlctable.individuals(idv_to_evaluate(i)).value);end
                JJ(i)=rand+(rand<0.1)*10^50;
            end
        case 'mfile_multi'
            eval(['heval=@' mlc_parameters.evaluation_function ';']);
            f=heval;
            try 
                parpool
            end
           
            
            nidx=length(eval_idx);
          %  ppm = ParforProgMon('MLC multithread evaluation', nidx);
            parfor i=istart:nidx
           %     ppm.increment();
                if verb>3;fprintf('Individual %i from generation %i\n',eval_idx(i),ngen);end
                if verb>4;fprintf('%s\n',mlctable.individuals(idv_to_evaluate(i)).value);end
                %retrieve object in the table
                m=mlctable.individuals((idv_to_evaluate(i)));
                JJ(i)=feval(f,m,mlc_parameters,i);
                
                date_ev(i)=now;
                if verb>2;loopprog(nidx);end
            end
           
            
           
            case 'mfile_all'
		tic
                eval(['heval=@' mlc_parameters.evaluation_function ';']);
                f=heval;
                JJ=feval(f,mlctable.individuals(idv_to_evaluate),mlc_parameters);
		if verb>1;fprintf('Done in %f s\n',toc);end
            
                
            
            case 'mfile_standalone'
            eval(['heval=@' mlc_parameters.evaluation_function ';']);
            f=heval;
            for i=istart:length(eval_idx);
                if mlc_parameters.saveincomplete==1
                    ic=i;
                    save(fullfile(mlc_parameters.savedir,'MLC_incomplete.mat'),'JJ','ic');
                end
                if verb>1;fprintf('Individual %i from generation %i\n',eval_idx(i),ngen);end
                if verb>2;fprintf('%s\n',mlctable.individuals(idv_to_evaluate(i)).value);end
                %retrieve object in the table
                m=mlctable.individuals((idv_to_evaluate(i)));
                JJ(i)=feval(f,m,mlc_parameters,i);
                date_ev(i)=now;
            end
            
            
    end

    %% End of effective evaluation
    if  mlc_parameters.saveincomplete==1 && any(strfind(mlc_parameters.evaluation_method,'standalone'));
        delete(fullfile(mlc_parameters.savedir,'MLC_incomplete.mat'));
    end


    %% MLCtable update
    if verb>0;fprintf('Updating database\n');end
    
    %% Checking numerical value
    JJ(isnan(JJ) | isinf(JJ) | JJ>mlc_parameters.badvalue)=mlc_parameters.badvalue;
    J2=JJ;
    idvs=mlctable.individuals(idv_to_evaluate);
    
    try 
        parpool
    end
    
    try
        
    parfor i=1:length(eval_idx);
      %  save test idv_to_evaluate
        idvs(i).evaluate(JJ(i));
        J2(i)=idvs(i).cost;
        idvs(i).comment='';
    end
    mlctable.individuals(idv_to_evaluate)=idvs;
    mlctable.costlist(idv_to_evaluate)=J2;
    catch
        fprintf('Parralel computing not possible, updating database slowly\n')
       for i=1:length(eval_idx);
      %  save test idv_to_evaluate
        idvs(i).evaluate(JJ(i));
        J2(i)=idvs(i).cost;
       end
       
       mlctable.costlist(size(J2,1),idv_to_evaluate)=J2;
    end
    mlcpop.costs(eval_idx)=J2;
end
















