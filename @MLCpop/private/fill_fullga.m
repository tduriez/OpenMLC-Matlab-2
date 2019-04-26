function [mlcpop,mlctable,i]=fill_fullga(mlcpop,mlctable,mlc_parameters,indiv_to_generate,i,verb)
% copyright
n_indiv_to_generate=length(indiv_to_generate);


s=size(mlc_parameters.range);

if numel(mlc_parameters.range)==1
    values=(rand(n_indiv_to_generate,mlc_parameters.sensors)*2-1)*mlc_parameters.range;
elseif s(1)==1 && s(2)==mlc_parameters.sensors
    values=(rand(n_indiv_to_generate,mlc_parameters.sensors)*2-1).*repmat(mlc_parameters.range,[n_indiv_to_generate,1]);
elseif s(1)==2 && s(2)==mlc_parameters.sensors
    offsets=mean(mlc_parameters.range);
    ranges=abs(diff(mlc_parameters.range)/2);
    values=(rand(n_indiv_to_generate,mlc_parameters.sensors)*2-1).*repmat(ranges,[n_indiv_to_generate 1])+repmat(offsets,[n_indiv_to_generate 1]);
end

parfor j=1:n_indiv_to_generate
    mlcind(j)=MLCind;
    mlcind(j).generate(mlc_parameters,values(j,:));
end

for i=1:numel(mlcind)
    [mlctable,number,already_exist]=mlctable.add_individual(mlcind(i));
    mlcpop.individuals(indiv_to_generate(i))=number;
end
% while i<=n_indiv_to_generate
%     mlcind=MLCind;
%     mlcind.generate(mlc_parameters,type);
%     [mlctable,number,already_exist]=mlctable.add_individual(mlcind);
%     if already_exist==0
%         if verb>1;fprintf('Generating individual %i\n',indiv_to_generate(i));end
%         if verb>2;mlcind.textoutput;end
%          
%             if  mlcind.preev(mlc_parameters) 
%                 mlcpop.individuals(indiv_to_generate(i))=number;
%                 i=i+1;
%             else
%                 if verb>1;fprintf('preevaluation fail\n');end
%             end
%         
%     else
%         if verb>3;fprintf('replica\n');end
%     end
% end