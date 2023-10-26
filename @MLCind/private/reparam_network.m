function [m]=reparam_network(m,mlc_parameters)

minLength=mlc_parameters.micronetworkOptions.minLength;
maxLength=mlc_parameters.micronetworkOptions.maxLength;
stepLength=mlc_parameters.micronetworkOptions.stepLength;
minWidth=mlc_parameters.micronetworkOptions.minWidth;
maxWidth=mlc_parameters.micronetworkOptions.maxWidth;
stepWidth=mlc_parameters.micronetworkOptions.stepWidth;

prob=mlc_parameters.micronetworkOptions.ConstantChangeProb;
possible_lengths=minLength:stepLength:maxLength;
possible_widths=minWidth:stepWidth:maxWidth;





idx=(m>45).*(m<58);
idx2=find(diff(idx)==1);
idx3=find(diff(idx)==-1);
tochange=zeros(1,length(idx2));
while sum(tochange)<1
tochange=rand(1,length(idx2))<prob;
end


for i=length(idx2):-1:1
    if tochange(i)
        beg=m(1:idx2(i));
        en=m(idx3(i)+1:end);
        if bitget(i,1)==1 % odd number -> Length
            Const=possible_lengths(randi(length(possible_lengths)));
        else
            Const=possible_widths(randi(length(possible_widths)));
        end
        m=[beg num2str(Const,mlc_parameters.precision) en];
    end
end
end