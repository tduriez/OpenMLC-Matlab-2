function [PR,density,idx]=getParetoRank(J,badvalue)
try
    index=1:size(J,2);
    PR=zeros(1,size(J,2));
    i=0;
    while ~isempty(index)
        i=i+1;
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
    for i=1:size(J,1)
        PR(J(i,:)==badvalue)=max(PR);
    end
   
    

%% distance calculation
density=PR*0;
for i=1:max(PR)
    iPR=find(PR==i);
JJ=J(:,iPR);
[~,idx]=sort(JJ(1,:));
iPR=iPR(idx);
JJ=JJ(:,idx);
distance=iPR*0;
for j=1:length(iPR)
    if length(iPR)==1
        distance(j)=1;
    elseif j==1
        distance(j)=sqrt((JJ(1,1)-JJ(1,2))^2+(JJ(2,1)-JJ(2,2))^2);
    elseif j==length(iPR)
        distance(j)=sqrt((JJ(1,length(iPR))-JJ(1,length(iPR-1)))^2+(JJ(2,length(iPR))-JJ(2,length(iPR-1)))^2);
    else
        distance(j)=sqrt((JJ(1,j-1)-JJ(1,j+1))^2+(JJ(2,j-1)-JJ(2,j+1))^2);
    end
    
end
density(iPR)=distance;
end
catch err
    keyboard
end

    