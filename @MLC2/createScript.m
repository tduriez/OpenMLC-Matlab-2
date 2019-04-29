function createScript(mlc,scriptname)
%CREATE_SCRIPT    Method of the MLC2 class. Writes MLC parameters in a M-file script. 
%   MLC_OBJ.CREATE_SCRIPT opens a GUI to select the file to write.
%   MLC_OBJ.CREATE_SCRIPT(FILENAME) creates the script in the current
%   folder with FILENAME.
%
%   All current members of the <a href="matlab:help
%   MLC/parameters">parameters</a> are written. Only strings and 1-D
%   arrays are supported. To create a script, it is easier to have the file
%   created then edit inside the file than change all parameters manually
%   and then create the script. But it is just my opinion, you do what you
%   want.
%
%   Ex: 
%      mlc=MLC;mlc.create_script('merguez');open('merguez.m');
%
%   See also MLC, PARAMETERS, Set_MLC_parameters, OPSET
%
%   Copyright (C) 2016 Thomas Duriez, Steven Brunton, Bernd Noack
%   This file is part of the OpenMLC Toolbox. Distributed under GPL v3.

%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

 
 
if nargin<2
    [fichier, chemin]=uiputfile('my_script.m','Choose your script file');
    scriptname=fichier;
else
    fichier=scriptname;
    chemin='';
end
k=strfind(scriptname,'.m');
    if isempty(k)
        fichier=[scriptname '.m'];
    else
        scriptname=scriptname(1:k-1);
    end
fid=fopen(fullfile(chemin,fichier),'w');

% string=['%%', upper(scriptname), '    parameters script for MLC\n'];
% fprintf(fid,string);
% fprintf(fid, ['%%    Type mlc=MLC(''' scriptname ''') to create corresponding MLC object\n']);
% changed to -->
fprintf(fid, '%% %s parameters script for MLC\n', upper(scriptname));
fprintf(fid, '%% Type mlc=MLC2(\x27%s\x27) to create corresponding MLC object\n', scriptname);

fields=fieldnames(mlc.parameters);
excludefields={'opset','dispswitch'};
for i=1:length(fields);
    if ~strcmp(fields{i},excludefields)        
        value=getfield(mlc.parameters,fields{i});
        if ischar(value)
            fieldvalue=['''' value ''''];
        elseif isstruct(value)
            fprintf(1,['Field "' fields{i} '" is a structure, add it later manually in the file.\n']);
            fprintf(1,'(I am lazy)\n');
        elseif isnumeric(value)
            if min(size(value))==1
                fieldvalue=['[' sprintf([repmat('%g ',[1 length(value)-1]) '%g'],value) ']'];
                if length(value)==1;
                    fieldvalue=fieldvalue(2:end-1);
                end
            else
                fprintf(1,['Field "' fields{i} '" is a matrix, add it later manually in the file.\n']);
                fprintf(1,'(Did you HAVE to do this ?)\n');
            end
        end
%       fprintf(fid, ['parameters.' fields{i} '=' fieldvalue ';\n']);
%       changed to -->
        fprintf(fid, 'parameters.%s = %s;\n', fields{i}', fieldvalue);
    end
end
fclose(fid);
end







































































