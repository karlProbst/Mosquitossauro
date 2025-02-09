extends Node2D

@export var line_path: Line2D  # Assign your Line2D node in the editor

func _process(delta: float) -> void:
	if not line_path:
		return

	# Get the mouse position in the scene
	var mouse_pos = get_global_mouse_position()

	# Find the closest point on the Line2D to the mouse
	var closest_point = find_closest_point_on_line(mouse_pos)
	# Move this node to the closest point on the line
	global_position = closest_point

func find_closest_point_on_line(point: Vector2) -> Vector2:
	var closest_point = line_path.points[0]  # Start with the first point
	var min_distance = point.distance_to(line_path.to_global(closest_point))

	# Iterate through the segments of the Line2D
	for i in range(line_path.points.size() - 1):
		var segment_start = line_path.to_global(line_path.points[i])
		var segment_end = line_path.to_global(line_path.points[i + 1])

		# Get the closest point on the current segment
		var closest_on_segment = get_closest_point_on_segment(point, segment_start, segment_end)
		var distance = point.distance_to(closest_on_segment)

		# Update the closest point if a nearer one is found
		#+1 fixes issue where node would vanish
		if distance < min_distance+1:
			min_distance = distance
			closest_point = closest_on_segment

	return closest_point

func get_closest_point_on_segment(point: Vector2, start: Vector2, end: Vector2) -> Vector2:
	var segment_vector = end - start
	var projected_length = segment_vector.dot(point - start) / segment_vector.length_squared()

	# Clamp the projection to stay on the segment
	projected_length = clamp(projected_length, 0.0, 1.0)

	return start + segment_vector * projected_length
