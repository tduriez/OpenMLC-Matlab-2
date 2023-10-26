function textoutput(mlcind);
% copyright
switch mlcind.type
    case 'tree'
        fprintf([mlcind.value '\n']);
	case 'ga'
        disp(mlcind.value);
    case 'network'
        fprintf([mlcind.value '\n']);
end










