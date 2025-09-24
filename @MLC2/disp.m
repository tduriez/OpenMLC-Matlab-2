function disp(obj)
            if strcmp(inputname(1),'ans')
                fprintf('Done\n');
                return
            end
            %% Header
           
            fprintf('-------------------------------------\n')
            fprintf('    Machine Learning Control Object  \n')
            fprintf('-------------------------------------\n')
            
            fprintf('\n') 
            
            %% Individual type
            switch obj.parameters.individual_type
                case 'tree'
                    fprintf('Individual type: LISP expresion trees\n')
                    fprintf('Nb inputs: \t\t%i\n',obj.parameters.sensors);
                    fprintf('Constants range: \t[-%.2f %.2f]\n',obj.parameters.range,obj.parameters.range);
                    operations=[];
                    for i=1:length(obj.parameters.opset)-1
                        operations=[operations obj.parameters.opset(i).op ','];
                    end
                    operations=[operations obj.parameters.opset(length(obj.parameters.opset)).op];
                    fprintf('Selected operations: \t(%s)\n',operations);
                    fprintf('\n');
                case 'ga'
                    fprintf('Individual type: GA vector\n')
                    fprintf('Nb Inputs: \t\t%i\n',obj.parameters.sensors);
                case 'micronetwork'
                    fprintf('Individual type: micronetworks\n')
            end
                    
                
           %% Evaluation method
            
            
            if  strcmp(obj.parameters.evaluation_method,'files') 
                fprintf('Problem linked with files :\n');
                fprintf('Directory: \t\t''%s''\n',obj.parameters.exchangedir);
                fprintf('Individual: \t\t''%s''\n',obj.parameters.indfile);
                fprintf('Cost function value: \t''%s''\n',obj.parameters.Jfile);
            elseif strcmp(obj.parameters.evaluation_method,'mfile_standalone')
                fprintf('Evaluation by standalone processing\n'); 
                fprintf('Problem = ''%s''\n',obj.parameters.evaluation_function);
            elseif strcmp(obj.parameters.evaluation_method,'mfile_multi')
                fprintf('Evaluation by multithread processing\n'); 
                fprintf('Problem = ''%s''\n',obj.parameters.evaluation_function);
            end
            fprintf('\n');
            %% Problem parameters
            fprintf('Population size: \t\t%i\n',obj.parameters.size);
            
            %% Problem state
            if isempty(obj.population)
                fprintf('Population ');
                fprintf('empty');
                fprintf('. Start problem with ');
                fprintf([inputname(1) '.go(nb)']);
                fprintf('.\n');
                fprintf('Fill population with ');
                fprintf([inputname(1) '.generate_population']);
                fprintf('.\n');
            else
                ngen=length(obj.population);
                if min(obj.population(ngen).costs)==-1; to_evaluate=1;else to_evaluate=0;end
                fprintf('%i generations filled, %i generations evaluated.\n',ngen,ngen-to_evaluate);
                if ngen-to_evaluate >0
                    fprintf('\n')
                    obj.stats(ngen-to_evaluate,inputname(1));
                    fprintf('\n')
                end
                fprintf(['Continue problem with ' inputname(1) '.go(nb) (nb >= ' num2str(ngen+1-to_evaluate) ').\n']);
                %% What to do now
                if to_evaluate              
                    fprintf(['Evaluate last generation with ' inputname(1) '.evaluate_population.\n']);
                else
                    fprintf(['Breed next generation with ' inputname(1) '.evolve_population.\n']);
                end
               
            end
            disp('Find <a href="matlab:help MLC">Help</a>');
            
        end