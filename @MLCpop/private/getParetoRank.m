function PR=getParetoRank(J)
idxs=sort(J,2); %get ranks for each J
RankSum=sum(idxs);
ParetoFronts=unique(RankSum);
PR=zeros(1,size(J,2));
for i=1:length(ParetoFronts)
    idx=find(RankSum==ParetoFronts(i));
    PR(idx)=i;
end
    
    