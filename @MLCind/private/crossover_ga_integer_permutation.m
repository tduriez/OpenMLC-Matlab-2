function [new_m1,new_m2,fail]=crossover_ga_integer_permutation(m1,m2,gen_param)
%CROSSOVER_GA private function of MLCind class. Achieves uniform crossover
%for GA regression.

s=[1 1 1];
while all(s==1) || all(s==0)
    s=rand(size(m1))>0.5;
end

new_m1=m1.*s+m2.*(1-s);
new_m2=m1.*(1-s)+m2.*s;

new_m1=rationalize(new_m1,gen_param);
new_m2=rationalize(new_m2,gen_param);


fail=0;
end

function new_m=rationalize(m,gen_param)
    [~,idx_new]=unique(m);
    new_m=m(sort(idx_new));
    if numel(new_m)<numel(m)
        n=setdiff(1:gen_param.sensors,new_m);
        new_m=[new_m n(randperm(numel(n)))];
    end
end
