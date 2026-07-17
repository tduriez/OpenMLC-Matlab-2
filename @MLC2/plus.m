function mlcc=plus(mlca,mlcb,option)
        try
        mlcc=MLC2;
        mlcc.parameters=MLCparameters;
        fname=fieldnames(mlcc.parameters);
        for i=1:length(fname)
            mlcc.parameters.(fname{i})=mlca.parameters.(fname{i});
        end
        
        mlcc.parameters.savedir=fullfile(mlca.parameters.savedir,sprintf('sum-%s',datestr(now,'yyyymmdd-HHMM')));
        mkdir(mlcc.parameters.savedir);
        save sumdata mlca mlcb
        movefile('sumdata.mat',fullfile(mlcc.parameters.savedir,'sumdata.mat'));
        
        
        
        
        
        
        if nargin < 3
            option='lastgen'
        end
        switch option
            case 'lastgen'
                mlcc.parameters.size=mlca.parameters.size+mlcb.parameters.size;
                idvsa=mlca.table.individuals(mlca.population(end).individuals);
                idvsb=mlcb.table.individuals(mlcb.population(end).individuals);
            case 'pareto1'
                idvsa=mlca.table.individuals(mlca.population(end).individuals(mlca.population(end).ParetoRank==1));
                idvsb=mlcb.table.individuals(mlcb.population(end).individuals(mlcb.population(end).ParetoRank==1));
                n1=length(idvsa)+length(idvsb);
                if n1>mlcc.parameters.size
                    mlcc.parameters.size=n1;
                end
        end
                
        for i=1:length(idvsa)
            mlcc.insert_individual(idvsa(i));
        end
        for i=1:length(idvsb)
            mlcc.insert_individual(idvsb(i));
        end
        mlcc.generate_population;
        catch err
            keyboard
        end
end
        
        