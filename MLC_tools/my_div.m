function b=my_div(arg1,arg2)
% copyright
    protec=0.001;
    b=arg1./(arg2.*(abs(arg2)>=protec)+protec*sign(arg2).*(abs(arg2)<protec));
end










