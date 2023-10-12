function [m]=reparam_network(m,gen_param)
idx=(m>45).*(m<58);
idx2=find(diff(idx)==1);
idx3=find(diff(idx)==-1);

keyboard