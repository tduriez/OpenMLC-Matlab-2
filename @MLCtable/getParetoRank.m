function obj=getParetoRank(obj)
J=obj.costlist(:,1:obj.number);
obj.ParetoRank=zeros(1,size(J,2));
try
    index=1:size(J,2);
    PR=zeros(1,size(J,2));
    i=0;
    while ~isempty(index)
        i=i+1
        length(index)
        if length(index)==1
            PR(index)=i;
            index=[];
        else 
            crosstable=crosstablecomparison(J(:,index));
            dominationrank=sum(crosstable,2)';
            idx=dominationrank==max(dominationrank);
            PR(index(idx))=i;
            index=setdiff(index,index(idx));
        end
    end
    
    % eliminating badvalues
%     for i=1:size(J,1)
%         PR(J(i,:)==badvalue)=max(PR);
%     end
   
    
catch err
    keyboard
end
    obj.ParetoRank=PR;
end
    