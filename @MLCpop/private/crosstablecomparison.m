function JJ=crosstablecomparison(J)
    JJ=zeros(length(J),length(J));
    try
    for k=1:size(J,1)
    for i=1:size(J,2)
        for j=1:length(J)
            JJ(i,j)=JJ(i,j)+(J(k,i)<J(k,j));
        end
    end
    end
    JJ=JJ>0;
    catch err
        keyboard
    end
end
    