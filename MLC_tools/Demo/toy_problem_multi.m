function J=toy_problem_multi(idv,params,idx,fig)
%TOY_PROBLEM implements a simple regression for MLC
%   J=TOY_PROBLEM(IND,MLC_PARAMETERS)   returns the average distance
%       between the relation described by the LISP expression IND and the
%       points (s_i,b_i) so that b_i=tanh(1.256*s_i)+1.2.
%
%   J=TOY_PROBLEM(IND,MLC_PARAMETERS,I,FIG)   additionally provides a
%       visual output as long as I and FIG are provided (any value will
%       trigger the plot).
%
%   This file is part of the OpenMLC toolbox 
s=params.problem_variables.time;
b=params.problem_variables.b;


for i=1:length(idv)
b2=b*0;
try
m=idv(i).formal;
m=strrep(m,'S0','s');
eval(['b2=b2+' m ';'])
J(1,i)=sqrt(sum((b2-b).^2))/length(s);
J(2,i)=idv(i).complexity;
catch err
    J(1:2,i)=params.badvalue;
    fprintf(err.message);
    keyboard
end
c2(i,:)=b2;

end


if nargin==4
    subplot(2,1,1)
    plot(s,b,'*','marker','o','markersize',8,'color','k');hold on
    plot(s,c2,'-k','linewidth',1.2);hold  off
    set(gca,'fontsize',13,'xlim',[min(s(:)),max(s(:))],'ylim',[min(b(:))-0.1*(max(b(:))),max(b(:))+0.1*(max(b(:)))]-mean(b))
    l=legend('$b_i$','${K(s_i)}$');
    set(l,'location','northwest','interpreter','latex')
    grid on
    xlabel('$s$','fontsize',16,'interpreter','latex')
    ylabel('$b$','fontsize',16,'interpreter','latex')
    subplot(2,1,2),
    plot(s,sqrt((b-b2).^2),'*k')    
    set(gca,'yscale','log')
    set(gca,'fontsize',13)
    xlabel('$s$','fontsize',16,'interpreter','latex')
    ylabel('$\sqrt{(b-K(s))^2}$','fontsize',16,'interpreter','latex')
    set(gcf,'PaperPositionMode','auto')
    grid on
set(gcf,'Position',[100 500 600 500])
end