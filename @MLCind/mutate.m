function [new_ind,fail]=mutate(mlcind,mlc_parameters)
% copyright
    switch mlc_parameters.individual_type
        case 'tree'
            [newvalue,fail]=mutate_tree(mlcind.value,mlc_parameters);
            new_ind=MLCind;
            new_ind.generate(mlc_parameters,newvalue);
	case 'ga'
            [newvalue,fail]=mutate_ga(mlcind.value,mlc_parameters);
            new_ind=MLCind;
            new_ind.generate(mlc_parameters,newvalue);
    end
            










