extends Spatial

func _physics_process(_delta):
	var motion = Vector3(0, 0, 0);
	var basis = $Camera.transform.basis;
	if (Input.is_action_pressed("move_forward")):
		motion -= basis.z;
	if (Input.is_action_pressed("move_backward")):
		motion += basis.z;
	if (Input.is_action_pressed("move_left")):
		motion -= basis.x;
	if (Input.is_action_pressed("move_right")):
		motion += basis.x;
	$Ball.add_central_force(motion);