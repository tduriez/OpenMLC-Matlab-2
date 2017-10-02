function b=my_log(arg1)
% copyright
    protec=0.00001;
    
    
    
   b=log10(abs(arg1).*(abs(arg1)>=protec)+protec*(abs(arg1)<protec));
    
 
end










