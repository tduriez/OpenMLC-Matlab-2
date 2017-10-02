function pre=preev(mlcind,mlc_parameters)
% copyright
    if mlc_parameters.preevaluation==0
        pre=1;
    else
        eval(['heval=@' mlc_parameters.preev_function ';']);
        pre=feval(heval,mlcind,mlc_parameters); 
    end
end










