function result = mn2_generate_paths(init, num3, num4, num5, height_seg, doPlot)
%MN2_GENERATE_PATHS Grow multiple paths with loops until a volume target is reached.
%   RESULT = MN2_GENERATE_PATHS(INIT, NUM3, NUM4, NUM5, HEIGHT_SEG, DOPLOT)
%   builds paths from root to terminals, allowing loop closure (snap within
%   NUM3), stopping when total volume exceeds NUM5, then uniformly scales
%   widths to hit the final targetVolume.
%
%   Key tunables:
%     num3         - exclusion/snap radius (also clamps widths)
%     num4         - terminal capture radius
%     num5         - volume target before final scaling
%     height_seg   - segment height for volume computation
%     mu_angle/sigma_angle - direction bias/spread (computeCandidateWeights)
%     mu/sigma (widths)    - width distribution (generateSegmentWidth)
%     targetVolume         - final uniform width scale target (near end of file)
if nargin < 2 || isempty(num3),       num3       = 2e-3; end  % exclusion/snap radius (also max width)
if nargin < 3 || isempty(num4),       num4       = 2e-3; end  % terminal capture radius
if nargin < 4 || isempty(num5),       num5       = 1e-6; end  % volume target before scaling
if nargin < 5 || isempty(height_seg), height_seg = 1e-3; end  % segment height for volume
if nargin < 6 || isempty(doPlot),     doPlot     = true; end  % enable plotting
width_bounds = loadWidthBounds();
SAFETY_LIMITS = struct(...
    'max_steps_per_path', 300, ...
    'max_candidates_per_step', 200, ...
    'max_total_segments', 2000, ...
    'max_paths', 500, ...
    'time_limit_sec', 30);
validateInput(init);
[root_xy, term_keys, internal_keys] = extractNodeKeys(init);
paths = struct('nodes', {}, 'coords', {}, 'widths', {}, 'lengths', {});
all_paths_map = containers.Map;
used_nodes = {'root'};
totalVolume = 0;
path_lists = {};
global_segments = [];
total_segments = 0;
path_counter = 0;
t_start = tic;
while totalVolume < num5 && path_counter < SAFETY_LIMITS.max_paths
    path_counter = path_counter + 1;
    path_data = growSinglePath(init, root_xy, term_keys, internal_keys, ...
        num3, num4, used_nodes, global_segments, width_bounds, ...
        height_seg, num5, totalVolume, SAFETY_LIMITS);
    if path_data.success && ~isempty(path_data.lengths)
        paths(path_counter).nodes   = path_data.nodes;
        paths(path_counter).coords  = path_data.coords;
        paths(path_counter).widths  = path_data.widths;
        paths(path_counter).lengths = path_data.lengths;
        all_paths_map(sprintf('p%d', path_counter)) = path_data.nodes;
        path_lists{end+1} = path_data.nodes;
        global_segments = [global_segments; path_data.segments];
        total_segments = total_segments + size(path_data.segments, 1);
        totalVolume = totalVolume + path_data.volume;
        used_nodes = [used_nodes, path_data.used_nodes];
    end
    if total_segments >= SAFETY_LIMITS.max_total_segments  % global segment cap
        warning('Reached max segments limit');
        break;
    end
    if toc(t_start) > SAFETY_LIMITS.time_limit_sec  % wall-clock cap
        warning('Reached time limit');
        break;
    end
    if ~path_data.success && isempty(path_data.lengths)
        break;
    end
end
used_nodes = unique(used_nodes, 'stable');
init_pruned = containers.Map('KeyType', 'char', 'ValueType', 'any');
for k = 1:numel(used_nodes)
    if isKey(init, used_nodes{k})
        init_pruned(used_nodes{k}) = init(used_nodes{k});
    end
end
% Uniformly scale widths so total volume equals target
targetVolume = 1e6;
if totalVolume > 0
    alpha = targetVolume / totalVolume;
    totalVolume = targetVolume;
    for p = 1:numel(paths)
        if isempty(paths(p).widths), continue; end
        paths(p).widths = paths(p).widths * alpha;
    end
end
result = struct();
result.paths       = paths;
result.totalVolume = totalVolume;
result.all_paths   = all_paths_map;
result.path_lists  = path_lists;
result.used_nodes  = used_nodes;
result.init_pruned = init_pruned;
if doPlot
    plotNetwork(init, root_xy, term_keys, internal_keys, paths, totalVolume);
end
fprintf('\n=== Generation Summary ===\n');
fprintf('Paths: %d | Volume: %.4e m^3 | Segments: %d\n', length(paths), totalVolume, total_segments);
end
function validateInput(init)
if ~isKey(init, 'root')
    error('mn2_generate_paths:missingRoot', 'INIT must contain a ''root'' key.');
end
keys_all = init.keys;
has_terms = any(startsWith(keys_all, 't'));
has_internals = any(~strcmp(keys_all, 'root') & ~startsWith(keys_all, 't'));
if ~has_terms
    error('mn2_generate_paths:noTerminals', 'INIT must contain terminal nodes t1, t2, ...');
end
if ~has_internals
    error('mn2_generate_paths:noInternals', 'INIT must contain internal nodes.');
end
end
function [root_xy, term_keys, internal_keys] = extractNodeKeys(init)
keys_all = init.keys;
is_root = strcmp(keys_all, 'root');
is_term = startsWith(keys_all, 't');
root_xy = init('root');
term_keys = keys_all(is_term);
internal_keys = keys_all(~is_root & ~is_term);
end
function bounds = loadWidthBounds()
bounds = struct('min', [], 'max', []);
try
    opts = setMicronetworkDefaultParameters();
    if isfield(opts, 'Scale') && isfield(opts, 'minWidth') && isfield(opts, 'maxWidth')
        bounds.min = opts.minWidth * opts.Scale;
        bounds.max = opts.maxWidth * opts.Scale;
    end
catch
end
end
function path_data = growSinglePath(init, root_xy, term_keys, internal_keys, ...
    exclusion_radius, capture_radius, used_nodes, global_segments, ...
    width_bounds, height_seg, volume_target, current_volume, safety_limits)
curr_key = 'root';
curr_xy  = root_xy;
nodes = {curr_key};
coords = curr_xy(:);
widths = [];
lengths = [];
visited_in_path = {curr_key};
local_segments = [];
local_volume = 0;
local_used = {};
step_count = 0;
while true
    step_count = step_count + 1;
    if step_count > safety_limits.max_steps_per_path  % cap per-path steps
        break;
    end
    [close_terminal_key, close_terminal_xy] = findCloseTerminal(...
        init, term_keys, curr_xy, capture_radius);
    [next_key, next_xy, accepted] = selectNextNode(init, curr_xy, ...
        close_terminal_key, close_terminal_xy, term_keys, internal_keys, ...
        visited_in_path, exclusion_radius, used_nodes, nodes, ...
        coords, global_segments, safety_limits.max_candidates_per_step);
    if ~accepted
        break;
    end
    seg_len = hypot(next_xy(1) - curr_xy(1), next_xy(2) - curr_xy(2));
    seg_width = generateSegmentWidth(width_bounds, exclusion_radius);
    seg_volume = seg_len * seg_width * height_seg;
    lengths(end+1) = seg_len;
    widths(end+1)  = seg_width;
    local_segments(end+1, :) = [curr_xy(:)', next_xy(:)'];
    local_volume = local_volume + seg_volume;
    nodes{end+1} = next_key;
    coords(:, end+1) = next_xy(:);
    visited_in_path{end+1} = next_key;
    if ~strcmp(next_key, 'root')
        local_used{end+1} = next_key;
    end
    curr_key = next_key;
    curr_xy  = next_xy;
    if startsWith(curr_key, 't') || (current_volume + local_volume) >= volume_target
        break;
    end
end
path_data = struct();
path_data.success = ~isempty(lengths) && startsWith(nodes{end}, 't');
path_data.nodes = nodes;
path_data.coords = coords;
path_data.widths = widths;
path_data.lengths = lengths;
path_data.volume = local_volume;
path_data.segments = local_segments;
path_data.used_nodes = local_used;
end
function [term_key, term_xy] = findCloseTerminal(init, term_keys, curr_xy, capture_radius)
term_key = '';
term_xy = [];
min_dist = inf;
for k = 1:numel(term_keys)
    txy = init(term_keys{k});
    dist = hypot(txy(1) - curr_xy(1), txy(2) - curr_xy(2));
    if dist <= capture_radius && dist < min_dist
        term_key = term_keys{k};
        term_xy = txy;
        min_dist = dist;
    end
end
end
function [next_key, next_xy, accepted] = selectNextNode(init, curr_xy, ...
    close_term_key, close_term_xy, term_keys, internal_keys, visited_in_path, ...
    exclusion_radius, used_nodes, current_path_nodes, current_path_coords, ...
    global_segments, max_candidates)
% Select next node; if candidate is within exclusion_radius of any existing
% network node, snap to that node (merge) to form loops.
accepted = false;
next_key = '';
next_xy = [];
if ~isempty(close_term_key)
    candidates = {close_term_key};
    candidate_xy = {close_term_xy};
else
    all_candidates = [internal_keys, term_keys];
    candidates = setdiff(all_candidates, visited_in_path);
    if isempty(candidates)
        candidates = all_candidates;
    end
    if numel(candidates) > max_candidates
        candidates = candidates(randperm(numel(candidates), max_candidates));
    end
    candidate_xy = cell(1, numel(candidates));
    for i = 1:numel(candidates)
        candidate_xy{i} = init(candidates{i});
    end
    weights = computeCandidateWeights(curr_xy, candidate_xy, exclusion_radius);
    [~, sort_idx] = sort(weights, 'descend');
    candidates = candidates(sort_idx);
    candidate_xy = candidate_xy(sort_idx);
end
for i = 1:numel(candidates)
    cand_key = candidates{i};
    cand_xy = candidate_xy{i};
    all_network_nodes = unique([used_nodes, current_path_nodes]);
    closest_key = '';
    closest_xy = [];
    min_d = inf;
    for k = 1:numel(all_network_nodes)
        ref_xy = init(all_network_nodes{k});
        dloop = hypot(cand_xy(1)-ref_xy(1), cand_xy(2)-ref_xy(2));
        if dloop < min_d
            min_d = dloop;
            closest_key = all_network_nodes{k};
            closest_xy = ref_xy;
        end
    end
    if min_d < exclusion_radius
        cand_key = closest_key;
        cand_xy = closest_xy;
    end
    local_ok = mn2_check_crossover(curr_xy, cand_xy, current_path_coords);
    global_ok = ~segmentIntersectsGlobal(curr_xy, cand_xy, global_segments);
    if local_ok && global_ok
        next_key = cand_key;
        next_xy = cand_xy;
        accepted = true;
        return;
    end
end
end
function weights = computeCandidateWeights(curr_xy, candidate_xy, exclusion_radius)
mu_dist = 0.007;           % preferred step length (m)
sigma_dist = 0.03;         % distance spread
mu_angle = pi/2;           % preferred direction (up)
sigma_angle = 2*pi;        % direction spread (larger = more lateral)
weights = zeros(1, numel(candidate_xy));
for i = 1:numel(candidate_xy)
    cand_xy = candidate_xy{i};
    dx = cand_xy(1) - curr_xy(1);
    dy = cand_xy(2) - curr_xy(2);
    dist = hypot(dx, dy);
    if dist <= exclusion_radius
        weights(i) = 0;
        continue;
    end
    dist_weight = exp(-0.5 * ((dist - mu_dist) / sigma_dist)^2);
    angle = atan2(dy, dx);
    angle_weight = exp(-0.5 * ((angle - mu_angle) / sigma_angle)^2);
    weights(i) = dist_weight * angle_weight;
end
end
function seg_width = generateSegmentWidth(width_bounds, max_width)
if ~isempty(width_bounds.min) && ~isempty(width_bounds.max)
    mu = (width_bounds.min + width_bounds.max) / 2;        % center from defaults
    sigma = (width_bounds.max - width_bounds.min) / 6;     % spread from defaults
    seg_width = mu + sigma * randn;
    seg_width = max(width_bounds.min, min(width_bounds.max, seg_width));
else
    mu = 4e-4;                                             % center (m)
    sigma = 1e-3;                                          % spread (m)
    seg_width = mu + sigma * randn;
    seg_width = max(1e-6, min(max_width, seg_width));  
end
end
function inter = segmentIntersectsGlobal(p3, p4, global_segments)
inter = false;
if isempty(global_segments)
    return;
end
tol = 1e-12;  
p3 = p3(:)';
p4 = p4(:)';
for i = 1:size(global_segments, 1)
    p1 = global_segments(i, 1:2);
    p2 = global_segments(i, 3:4);
    if all(abs(p1 - p3) < tol) || all(abs(p1 - p4) < tol) || ...
       all(abs(p2 - p3) < tol) || all(abs(p2 - p4) < tol)
        continue;
    end
    if segmentsIntersect(p1, p2, p3, p4)
        inter = true;
        return;
    end
end
end
function plotNetwork(init, root_xy, term_keys, internal_keys, paths, totalVolume)
fig = figure('Name', 'Micronetworks2: Generated Network', 'Color', 'w', ...
    'Position', [100, 100, 900, 700]);
all_coords = cell2mat(cellfun(@(k) init(k)', [term_keys, internal_keys, {'root'}], 'UniformOutput', false));
x_min = 0;  
x_max = max(all_coords(1, :));
y_min = 0;  
y_max = max(all_coords(2, :));  
rectangle('Position', [x_min, y_min, x_max, y_max], ...
    'FaceColor', [0.99 0.99 0.99], 'EdgeColor', [0.2 0.2 0.2], ...
    'LineWidth', 2, 'LineStyle', '-');
hold on;
internal_xy_all = cell2mat(cellfun(@(k) init(k)', internal_keys, 'UniformOutput', false));
max_internal_plot = 8000;
if size(internal_xy_all, 2) > max_internal_plot
    idx = randperm(size(internal_xy_all, 2), max_internal_plot);
    internal_xy = internal_xy_all(:, idx);
else
    internal_xy = internal_xy_all;
end
scatter(internal_xy(1, :), internal_xy(2, :), 3, [0.7 0.7 0.7], 'filled', ...
    'MarkerFaceAlpha', 0.25, 'HandleVisibility', 'off', ...
    'PickableParts', 'none', 'HitTest', 'off');
path_color = [0.1 0.6 0.3];  
have_path_legend = false;
for p = 1:numel(paths)
    if isempty(paths(p).coords), continue; end
    coords = paths(p).coords;
    widths = paths(p).widths;
    if isempty(widths)
        continue;
    end
    widths_norm = widths / median(widths);
    for seg = 1:size(coords, 2) - 1
        x_seg = coords(1, seg:seg+1);
        y_seg = coords(2, seg:seg+1);
        line_width = max(0.8, min(4, widths_norm(seg) * 1.8)); % normalized to preserve variation without clipping
        if ~have_path_legend && seg == 1 && p == 1
            plot(x_seg, y_seg, '-', 'Color', path_color, 'LineWidth', line_width, ...
                'DisplayName', 'Network Paths');
            have_path_legend = true;
        else
            plot(x_seg, y_seg, '-', 'Color', path_color, 'LineWidth', line_width, ...
                'HandleVisibility', 'off');
        end
    end
    scatter(coords(1, :), coords(2, :), 25, [0.2 0.8 0.9], 'filled', ...
        'MarkerEdgeColor', [0.1 0.5 0.6], 'LineWidth', 1, ...
        'HandleVisibility', 'off');
end
used_nodes_all = {};
for p = 1:numel(paths)
    if isempty(paths(p).nodes), continue; end
    used_nodes_all = [used_nodes_all, paths(p).nodes];
end
used_nodes_all = unique(used_nodes_all);
used_term_mask = ismember(term_keys, used_nodes_all);
used_term_keys = term_keys(used_term_mask);
unused_term_keys = term_keys(~used_term_mask);
if ~isempty(unused_term_keys)
    term_xy_unused = cell2mat(cellfun(@(k) init(k)', unused_term_keys, 'UniformOutput', false));
    scatter(term_xy_unused(1, :), term_xy_unused(2, :), 70, [0.7 0.7 0.7], 'filled', ...
        'MarkerEdgeColor', [0.6 0.6 0.6], 'LineWidth', 1, ...
        'MarkerFaceAlpha', 0.35, 'DisplayName', 'Unused Terminals', ...
        'PickableParts', 'none', 'HitTest', 'off');
end
if ~isempty(used_term_keys)
    term_xy_used = cell2mat(cellfun(@(k) init(k)', used_term_keys, 'UniformOutput', false));
    scatter(term_xy_used(1, :), term_xy_used(2, :), 100, [0.9 0.2 0.2], 'filled', ...
        'MarkerEdgeColor', [0.6 0.1 0.1], 'LineWidth', 2, ...
        'DisplayName', 'Terminal Nodes');
end
scatter(root_xy(1), root_xy(2), 140, [0.2 0.4 0.9], 'filled', ...
    'MarkerEdgeColor', [0.1 0.2 0.6], 'LineWidth', 2.5, ...
    'DisplayName', 'Root Node');
axis equal;
axis([x_min, x_max, y_min, y_max]);
grid on;
set(gca, 'GridColor', [0.85 0.85 0.85], 'GridAlpha', 0.6, ...
    'GridLineStyle', '--', 'MinorGridAlpha', 0.25);
set(gca, 'Box', 'on', 'LineWidth', 1.2, 'TickLength', [0.01 0.02]);
set(gca, 'FontSize', 11, 'FontName', 'Arial');
xlabel('x (m)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('y (m)', 'FontSize', 12, 'FontWeight', 'bold');
title(sprintf('Micronetwork: %d Paths | Total Volume: %.4g m^3', numel(paths), totalVolume), ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.15 0.15 0.15]);
lgd = legend('Location', 'southoutside', 'Orientation', 'horizontal', ...
    'FontSize', 10, 'Box', 'on', 'EdgeColor', [0.8 0.8 0.8], ...
    'NumColumns', 3);
lgd.ItemTokenSize = [18, 10];
zoom(fig, 'on');
pan(fig, 'on');
hold off;
end
function inter = segmentsIntersect(p1, p2, p3, p4)
inter = false;
o1 = computeOrientation(p1, p2, p3);
o2 = computeOrientation(p1, p2, p4);
o3 = computeOrientation(p3, p4, p1);
o4 = computeOrientation(p3, p4, p2);
if o1 ~= o2 && o3 ~= o4
    inter = true;
    return;
end
if o1 == 0 && pointOnSegment(p1, p3, p2), inter = true; return; end
if o2 == 0 && pointOnSegment(p1, p4, p2), inter = true; return; end
if o3 == 0 && pointOnSegment(p3, p1, p4), inter = true; return; end
if o4 == 0 && pointOnSegment(p3, p2, p4), inter = true; return; end
end
function o = computeOrientation(a, b, c)
val = (b(2) - a(2)) * (c(1) - b(1)) - (b(1) - a(1)) * (c(2) - b(2));
if abs(val) < eps
    o = 0;
elseif val > 0
    o = 1;
else
    o = 2;
end
end
function tf = pointOnSegment(a, b, c)
tf = b(1) <= max(a(1), c(1)) + eps && b(1) >= min(a(1), c(1)) - eps && ...
     b(2) <= max(a(2), c(2)) + eps && b(2) >= min(a(2), c(2)) - eps;
end