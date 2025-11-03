function showParetoFronts(obj,n);
if nargin<2
    n=floor(0.9*max(obj.ParetoRank));
end
figure
    for i=1:n;
        Js=obj.costlist(:,obj.ParetoRank==i);
        [~,idx]=sort(Js(1,:));
        Js=Js(:,idx);
        
        hold on
        loglog(Js(1,:),Js(2,:));
        hold off
    end
    