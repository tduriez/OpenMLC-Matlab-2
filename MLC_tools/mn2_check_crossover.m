function ok = mn2_check_crossover(curr_xy, cand_xy, path_coords)
%MN2_CHECK_CROSSOVER True if adding curr->cand to path_coords does not intersect.
ok = true;
if isempty(path_coords) || size(path_coords, 2) < 2
    return;
end
p_new_start = curr_xy(:)';
p_new_end   = cand_xy(:)';
for i = 1:size(path_coords, 2) - 1
    p_existing_start = path_coords(:, i)';
    p_existing_end   = path_coords(:, i+1)';
    if isequal(p_existing_start, p_new_start) || ...
       isequal(p_existing_start, p_new_end) || ...
       isequal(p_existing_end, p_new_start) || ...
       isequal(p_existing_end, p_new_end)
        continue;
    end
    if segmentsIntersect(p_existing_start, p_existing_end, p_new_start, p_new_end)
        ok = false;
        return;
    end
end
end
function inter = segmentsIntersect(p1, p2, p3, p4)
% Segment intersection via orientation test (colinear handled)
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
% Orientation: 0 colinear, 1 ccw, 2 cw
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
% Point b lies on segment ac (colinear assumed)
tf = b(1) <= max(a(1), c(1)) + eps && b(1) >= min(a(1), c(1)) - eps && ...
     b(2) <= max(a(2), c(2)) + eps && b(2) >= min(a(2), c(2)) - eps;
end
