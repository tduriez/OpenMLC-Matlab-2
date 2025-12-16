function network = mn2_store_network(result)
%MN2_STORE_NETWORK Flatten generated network into nodes, segments, paths.
network = struct();
Nodes = result.init_pruned;
network.Nodes = Nodes;
node_names = Nodes.keys;
network.NodeList = node_names;  % names of all nodes
NodeArray = struct('name', {}, 'coords', {}, 'is_terminal', {}, 'is_root', {});
for i = 1:length(node_names)
    NodeArray(i).name = node_names{i};
    NodeArray(i).coords = Nodes(node_names{i});
    NodeArray(i).is_terminal = startsWith(node_names{i}, 't');
    NodeArray(i).is_root = strcmp(node_names{i}, 'root');
end
network.NodeArray = NodeArray;
node_to_idx = containers.Map(node_names, 1:length(node_names));  % name -> index
network.node_to_idx = node_to_idx;
% Collect non-empty paths first
valid_idx = [];
for p = 1:length(result.paths)
    path = result.paths(p);
    if isfield(path,'nodes') && ~isempty(path.nodes) && isfield(path,'lengths') && ~isempty(path.lengths)
        valid_idx(end+1) = p; %#ok<AGROW>
    end
end

Segments = struct('id', {}, 'path_id', {}, 'seg_in_path', {}, ...
                  'start_node', {}, 'end_node', {}, ...
                  'start_idx', {}, 'end_idx', {}, ...
                  'length', {}, 'width', {}, ...
                  'start_coords', {}, 'end_coords', {});
seg_count = 0;
for out_p = 1:numel(valid_idx)
    p = valid_idx(out_p);
    path = result.paths(p);
    nodes_cell = path.nodes;
    if ischar(nodes_cell)
        nodes_cell = {nodes_cell};
    elseif isstring(nodes_cell)
        nodes_cell = cellstr(nodes_cell);
    end
    for s = 1:length(path.lengths)
        seg_count = seg_count + 1;
        start_name = nodes_cell{s};
        end_name = nodes_cell{s+1};
        Segments(seg_count).id = seg_count;
        Segments(seg_count).path_id = out_p;      % compact path id
        Segments(seg_count).seg_in_path = s;
        Segments(seg_count).start_node = start_name;
        Segments(seg_count).end_node = end_name;
        Segments(seg_count).start_idx = node_to_idx(start_name);
        Segments(seg_count).end_idx = node_to_idx(end_name);
        Segments(seg_count).length = path.lengths(s);
        Segments(seg_count).width = path.widths(s);
        Segments(seg_count).start_coords = path.coords(:, s)';
        Segments(seg_count).end_coords = path.coords(:, s+1)';
    end
end
network.Segments = Segments;
Paths = struct('id', {}, 'nodes', {}, 'node_indices', {}, 'segment_ids', {}, ...
               'terminal', {}, 'terminal_idx', {}, ...
               'total_length', {}, 'total_volume', {}, 'n_segments', {});
seg_id = 0;
for out_p = 1:numel(valid_idx)
    p = valid_idx(out_p);
    path = result.paths(p);
    nodes_cell = path.nodes;
    if ischar(nodes_cell)
        nodes_cell = {nodes_cell};
    elseif isstring(nodes_cell)
        nodes_cell = cellstr(nodes_cell);
    end
    n_segs = length(path.lengths);
    seg_ids = seg_id + (1:n_segs);
    seg_id = seg_id + n_segs;
    node_indices = zeros(1, length(nodes_cell));
    for n = 1:length(nodes_cell)
        node_indices(n) = node_to_idx(nodes_cell{n});
    end
    Paths(out_p).id = out_p;
    Paths(out_p).nodes = nodes_cell;
    Paths(out_p).node_indices = node_indices;
    Paths(out_p).segment_ids = seg_ids;
    Paths(out_p).terminal = nodes_cell{end};
    Paths(out_p).terminal_idx = node_indices(end);
    Paths(out_p).total_length = sum(path.lengths);
    Paths(out_p).n_segments = n_segs;
    if isfield(result, 'totalVolume')
        path_frac = Paths(out_p).total_length / sum([Paths.total_length]);
        Paths(out_p).total_volume = result.totalVolume * path_frac;
    end
end
network.Paths = Paths;
Stats = struct();
Stats.n_paths = length(Paths);
Stats.n_segments = length(Segments);
Stats.n_nodes = length(node_names);
Stats.n_terminals = sum([NodeArray.is_terminal]);
Stats.n_internal = Stats.n_nodes - Stats.n_terminals - 1;
Stats.seg_length_mean = mean([Segments.length]);
Stats.seg_length_std = std([Segments.length]);
Stats.seg_length_min = min([Segments.length]);
Stats.seg_length_max = max([Segments.length]);
Stats.seg_width_mean = mean([Segments.width]);
Stats.seg_width_std = std([Segments.width]);
Stats.seg_width_min = min([Segments.width]);
Stats.seg_width_max = max([Segments.width]);
Stats.path_length_mean = mean([Paths.total_length]);
Stats.path_length_std = std([Paths.total_length]);
Stats.path_length_min = min([Paths.total_length]);
Stats.path_length_max = max([Paths.total_length]);
Stats.segs_per_path_mean = mean([Paths.n_segments]);
Stats.segs_per_path_std = std([Paths.n_segments]);
Stats.total_volume = result.totalVolume;
network.Stats = Stats;
connectivity = struct('segments_from', {}, 'segments_to', {}, ...
                      'paths_through', {});
for i = 1:length(node_names)
    connectivity(i).segments_from = find([Segments.start_idx] == i);
    connectivity(i).segments_to = find([Segments.end_idx] == i);
    connectivity(i).paths_through = find(cellfun(@(x) any(x == i), {Paths.node_indices}));
end
network.Connectivity = connectivity;
network.query = struct();
network.query.segments_in_path = @(pid) network.Paths(pid).segment_ids;
network.query.segments_from_node = @(node_name) find(strcmp({network.Segments.start_node}, node_name));
network.query.segments_to_node = @(node_name) find(strcmp({network.Segments.end_node}, node_name));
network.query.paths_through_node = @(node_name) find(cellfun(@(x) any(strcmp(x, node_name)), {network.Paths.nodes}));
network.query.get_path_coords = @(pid) get_path_coordinates(network, pid);
network.query.node_connectivity = @(node_idx) network.Connectivity(node_idx);
end
function coords = get_path_coordinates(network, path_id)
    path = network.Paths(path_id);
    seg_ids = path.segment_ids;
    coords = network.Segments(seg_ids(1)).start_coords;
    for i = 1:length(seg_ids)
        coords = [coords; network.Segments(seg_ids(i)).end_coords];
    end
end