function [m]=generate_indiv_regressive_micronetwork(m,gen_param,type)

%generate_indiv_regressive_micronetwork    Private function of the MLC CLASS. Grow individuals from seed '@';
%    [M]=generate_indiv_regressive_tree(M,GEN_PARAM,TYPE) seriously... that's a
%    PRIVATE function... Well, basically a seed '@' is placed in a string.
%    The function detect it and replace by one posible node. This node can
%    be a "leaf" (constant or tree input), or an operator. If an operator
%    is selected then as many seeds '@' as arguments needed are placed and
%    the function is called again. 
%
%    M is a string containing a seed. Initial call should be M='@', but it
%    can also be a truncated individual, during a mutation for instance.
%    (Ex : '(+ S1 (* @ S2))' will grow from the @).
%
%    GEN_PARAM contains the parameters from the MLC object.
%    (obj.parameters)
%
%    TYPE will condition how the tree grows:
%           - 0 free until absolute parameters.maxdepth (can stop before).
%           - 1 generates a tree of exactly parameters.maxdepthfirst.
%           - 2 free until absolute parameters.maxdepthfirst (can stop 
%               before).
%           - 3 full, all leaves are at depth parameters.maxdepthfirst.
%           - 4 generate a leave directly
%
%   Copyright (C) 2015-2017 Thomas Duriez.
%   This file is part of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

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

if isempty(type)
    type=-1;
end
    if nargin==3   
        if type==1
            mindepth=gen_param.maxdepthfirst;
            maxdepth=gen_param.maxdepthfirst;
        elseif type==2 || type==3
            mindepth=gen_param.mindepth;
            maxdepth=gen_param.maxdepthfirst;
        elseif type==4
            mindepth=gen_param.mindepth;
            maxdepth=1;
        else
            mindepth=gen_param.mindepth;
            maxdepth=gen_param.maxdepth;
        end
    else
         mindepth=gen_param.mindepth;
         maxdepth=gen_param.maxdepth;
    end
    
    idx=strfind(m,'@');
    if isempty(idx)    %% No seed...
        return
    else
        idx=idx(1);    %% one call of the function only cares about one seed.
        if idx==1
            begstr=[];
            endstr=[];
        else
            begstr=m(1:idx-1);
            endstr=m(idx+1:end);
        end
        leftpar=cumsum(m=='(');
        rightpar=cumsum(m==')');
        currank=(m=='@').*(leftpar-rightpar); %% detecting the depth of the seed.
        %% Choose next node.
        
        if max(currank)>=maxdepth   %% Cannot go deeper => leaf
            choice=1;
        elseif (max(currank)<mindepth && ~contains(endstr,'@'))...
                || (max(currank)<maxdepth && type==3) %% cannot stop here => operator
            choice=0;      
        else
            choice=rand<gen_param.leaf_prob;  %% freedom
        end
        %% Create node or leaf.
            if choice
                    newexp='(l L W)';
                    m=[begstr newexp endstr];
            else
                    
                    n=nodemultiplicity(gen_param);
                    pattern=repmat(' @',[1 n]);
                    m=sprintf('%s(+ L W%s)%s',begstr,pattern,endstr);
                    for i=1:n
                        [m]=generate_indiv_regressive_micronetwork(m,gen_param,type);
                    end
            end    
    end
end

function n=nodemultiplicity(gen_param)
    r=rand;
    if isfield(gen_param.micronetworkOptions,'multiplicity')
        nmax=gen_param.micronetworkOptions.multiplicity.nmax;
        law=gen_param.micronetworkOptions.multiplicity.law;
        pmin=gen_param.micronetworkOptions.multiplicity.pmin;
    else
        nmax=5;
        law='linear';
        pmin=0.05;
    end

    Bins=buildBins(nmax,law,pmin);
    a=find(r<Bins);
    n=a(1);
end

function [Bins,Probs]=buildBins(Nmax,type,pmin)
    Probs=1:Nmax-1;
    
    switch type
        case 'linear'
            f=@(x)(-x);
            
        case '1/x'
            f=@(x)(1./x);
        case 'uniform'
            f=@(x)(1);
            Probs=1/(Nmax-1);
            Bins=cumsum(Probs);
            return

    end
            Probs=f(Probs);
            Probs=Probs-min(Probs);
            alpha=(1-(Nmax-1)*pmin)/sum(Probs);
            Probs=alpha*Probs+pmin;
            Bins=cumsum(Probs);
end
    












