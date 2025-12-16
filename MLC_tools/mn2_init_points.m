function init = mn2_init_points(num1, width_m, height_m, seed, num2)
%MN2_INIT_POINTS Generate initial node set (internal points, root, terminals).
%   INIT = MN2_INIT_POINTS(NUM1, WIDTH_M, HEIGHT_M, SEED, NUM2)
%   Builds a rectangular region with random internal points, one root on
%   the bottom edge, and evenly spaced terminals on the top edge.
%
%   Inputs (tunable):
%     NUM1     - number of random internal points (default 1e4)
%     WIDTH_M  - domain width in meters (default 0.025)
%     HEIGHT_M - domain height in meters (default 0.050)
%     SEED     - RNG seed (default shuffle)
%     NUM2     - number of terminals along top edge (default 50)
%
%   Output:
%     INIT - containers.Map: keys 'root', t1..tN, n1..nM with [x y] coords.

if nargin < 1 || isempty(num1),    num1    = 1e4;   end
if nargin < 2 || isempty(width_m), width_m = 0.025; end
if nargin < 3 || isempty(height_m),height_m= 0.050; end
if nargin < 5 || isempty(num2),    num2    = 50;    end

if nargin < 4 || isempty(seed)
    rng('shuffle');
else
    rng(seed);
end

init = containers.Map('KeyType', 'char', 'ValueType', 'any');

% Internal nodes
x_coords = width_m * rand(num1, 1);
y_coords = height_m * rand(num1, 1);
for i = 1:num1
    node_key = sprintf('n%d', i);
    init(node_key) = [x_coords(i), y_coords(i)];
end

% Root at bottom center
root_position = [width_m/2, 0];
init('root') = root_position;

% Terminals along top edge
terminal_spacing = width_m / (num2 + 1);
terminal_x = linspace(terminal_spacing, width_m - terminal_spacing, num2);
terminal_y = height_m * ones(1, num2);
for k = 1:num2
    terminal_key = sprintf('t%d', k);
    init(terminal_key) = [terminal_x(k), terminal_y(k)];
end

% Plot
fig = figure('Name', 'Micronetworks2: Initialization', 'Color', 'w', ...
    'Position', [100, 100, 800, 600]);
rectangle('Position', [0, 0, width_m, height_m], ...
    'FaceColor', [0.98 0.98 0.98], 'EdgeColor', [0.3 0.3 0.3], ...
    'LineWidth', 1.5, 'LineStyle', '-');
hold on;
scatter(x_coords, y_coords, 4, [0.6 0.6 0.6], 'filled', ...
    'MarkerFaceAlpha', 0.4, 'DisplayName', 'Internal Points');
scatter(root_position(1), root_position(2), 120, [0.2 0.4 0.9], 'filled', ...
    'MarkerEdgeColor', [0.1 0.2 0.6], 'LineWidth', 2, ...
    'DisplayName', 'Root Node');
scatter(terminal_x, terminal_y, 80, [0.9 0.2 0.2], 'filled', ...
    'MarkerEdgeColor', [0.6 0.1 0.1], 'LineWidth', 1.5, ...
    'DisplayName', 'Terminal Nodes');
axis equal;
axis([0, width_m, 0, height_m]);
grid on;
set(gca, 'GridColor', [0.85 0.85 0.85], 'GridAlpha', 0.5, ...
    'GridLineStyle', '--', 'MinorGridAlpha', 0.2);
set(gca, 'Box', 'on', 'LineWidth', 1, 'TickLength', [0.01 0.02]);
set(gca, 'FontSize', 11, 'FontName', 'Arial');
xlabel('x (m)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('y (m)', 'FontSize', 12, 'FontWeight', 'bold');
title(sprintf('Network Initialization: %d points, %d terminals, %.3f m x %.3f m', ...
    num1, num2, width_m, height_m), 'FontSize', 13, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.2]);
lgd = legend('Location', 'southoutside', 'Orientation', 'horizontal', ...
    'FontSize', 10, 'Box', 'on', 'EdgeColor', [0.8 0.8 0.8]);
lgd.ItemTokenSize = [15, 8];
zoom(fig, 'on');
pan(fig, 'on');
hold off;
end
