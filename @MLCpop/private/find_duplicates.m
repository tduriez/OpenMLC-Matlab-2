function idx_dup=find_duplicates(list)
% copyright
    [sort_list,idx_sort]=sort(list);
    idx_dup=idx_sort(find(diff(sort_list)==0)+1);










