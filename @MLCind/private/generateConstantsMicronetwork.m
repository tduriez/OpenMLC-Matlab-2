function value=generateConstantsMicronetwork(value,mlc_parameters)
    minLength=mlc_parameters.micronetworkOptions.minLength;
    maxLength=mlc_parameters.micronetworkOptions.maxLength;
    stepLength=mlc_parameters.micronetworkOptions.stepLength;
    minWidth=mlc_parameters.micronetworkOptions.minWidth;
    maxWidth=mlc_parameters.micronetworkOptions.maxWidth;
    stepWidth=mlc_parameters.micronetworkOptions.stepWidth;
    
    %% set length constants
    possible_lengths=minLength:stepLength:maxLength;
    idxL=strfind(value,'L');
    Ls=possible_lengths(randi(length(possible_lengths),[1 length(idxL)]));
    i=0;
    while contains(value,'L')
        i=i+1;
        idxL=strfind(value,'L');
        beg=value(1:idxL(1)-1);
        en=value(idxL(1)+1:end);
        value=[beg num2str(Ls(i),mlc_parameters.precision) en];
    end
    
    %% set width constants
    possible_widths=minWidth:stepWidth:maxWidth;
    idxW=strfind(value,'W');
    Ws=possible_widths(randi(length(possible_widths),[1 length(idxW)]));
    i=0;
    while contains(value,'W')
        i=i+1;
        idxW=strfind(value,'W');
        beg=value(1:idxW(1)-1);
        en=value(idxW(1)+1:end);
        value=[beg num2str(Ws(1),mlc_parameters.precision) en];
    end
    
    
    



end
