# Micronetworks v2 (mn2) - Quick Guide

Micronetworks v2 generates loop-capable networks with tunable geometry, width distributions, and a final volume scaling step. Use the four mn2 files together:

- `mn2_init_points.m` — build initial node set (random internals, root at bottom, terminals at top).
- `mn2_generate_paths.m` — grow paths with snapping/loop closure, width sampling, volume target + final uniform width scaling.
- `mn2_store_network.m` — flatten results into nodes/segments/paths with stats and query helpers.
- `mn2_check_crossover.m` — segment intersection checks.

## Quick start (THIS IS HOW TO RUN IN MATLAB!!!)
```matlab
init = mn2_init_points();         % build domain
res  = mn2_generate_paths(init);  % grow paths (plots by default)
net  = mn2_store_network(res);    % flatten for downstream use (for Genetic Algorithm basically)
```
Inspect a path’s segments:
```matlab
p = 1;
seg_ids = net.Paths(p).segment_ids;
seg_len = [net.Segments(seg_ids).length];
seg_w   = [net.Segments(seg_ids).width];
```

## Key tunables
### mn2_init_points.m
- `num1` (default 1e4) : number of internal random points
- `width_m`, `height_m` (0.025, 0.050 m) : domain size
- `num2` (50) : number of terminals along top edge
- `seed` : RNG seed (empty -> shuffle)

### mn2_generate_paths.m
- `num3` : exclusion/snap radius; also clamps widths
- `num4` : terminal capture radius
- `num5` : volume target before final scaling
- `height_seg` : segment height for volume
- Direction bias/spread: `mu_angle`, `sigma_angle` in `computeCandidateWeights`
- Step length bias: `mu_dist`, `sigma_dist` in `computeCandidateWeights`
- Width distribution: `mu`, `sigma` in `generateSegmentWidth` (or bounds from `setMicronetworkDefaultParameters`)
- Final uniform scaling target: `targetVolume` (near end of file)
- Safety caps: `max_steps_per_path`, `max_candidates_per_step`, `max_total_segments`, `max_paths`, `time_limit_sec`

### mn2_store_network.m
- No tunables; compacts non-empty paths, builds `Nodes`, `Segments`, `Paths`, `Stats`, and `query` helpers.

### mn2_check_crossover.m
- Geometry-only; no tunables.

## Snapping / loops
- When a candidate node is within `num3` of any existing network node, it snaps to that node (merges), enabling loop closure.

## Final volume scaling
- After generation, all widths are uniformly scaled so total volume = `targetVolume`, preserving relative width variation.

## Plotting
- Enabled by default (`doPlot=true` in `mn2_generate_paths`).
- Disable plotting: `mn2_generate_paths(init, [], [], [], [], false);`