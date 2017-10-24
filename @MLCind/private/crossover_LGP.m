function [new_value1,new_value2,fail]=crossover_LGP(old_value1,old_value2)
fail=0;


iReplacement1=ceil(rand*size(old_value1,1));
nReplacement1=ceil(rand*size(old_value1,1))-iReplacement1;


iReplacement2=ceil(rand*size(old_value2,1));
nReplacement2=ceil(rand*size(old_value2,1))-iReplacement2;

new_value1=[old_value1(1:iReplacement1-1,:);
    old_value2(iReplacement2:nReplacement2-1,:);
    old_value1(iReplacement1+nReplacement1:end,:)];

new_value2=[old_value2(1:iReplacement2-1,:);
    old_value1(iReplacement1:nReplacement1-1,:);
    old_value2(iReplacement2+nReplacement2:end,:)];
