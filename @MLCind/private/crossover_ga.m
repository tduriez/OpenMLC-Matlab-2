function [new_m1,new_m2,fail]=crossover_ga(m1,m2,gen_param)
%CROSSOVER_GA private function of MLCind class. Achieves uniform crossover
%for GA regression.

s=[1 1 1];
while all(s==1) || all(s==0)
    s=rand(size(m1))>0.5;
end

new_m1=m1.*s+m2.*(1-s);
new_m2=m1.*(1-s)+m2.*s;

fail=0;













