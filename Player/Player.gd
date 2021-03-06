extends Spatial
var speed = 5;

func _process(_delta):
	$Camera.distance_scale = pow($Ball.mass, 1.0/3.0);

func _physics_process(_delta):
	execute_movement();
	for body in $Ball.get_colliding_bodies():
		execute_collision(body);

func execute_movement():
	var torque = Vector3(0, 0, 0);
	var motion = Vector3(0, 0, 0);
	var basis = $Camera.transform.basis;
	if (Input.is_action_pressed("move_forward")):
		torque -= basis.x;
		motion -= basis.z;
	if (Input.is_action_pressed("move_backward")):
		torque += basis.x;
		motion += basis.z;
	if (Input.is_action_pressed("move_left")):
		torque += basis.z;
		motion -= basis.x;
	if (Input.is_action_pressed("move_right")):
		torque -= basis.z;
		motion += basis.x;
	$Ball.add_torque(torque * speed * $Ball.mass);
	$Ball.add_central_force(motion * speed * $Ball.mass);

func execute_collision(body: Node):
	if (body.is_in_group("collectable")):
		var rigid = body as RigidBody
		if (rigid.mass <= $Ball.mass * 0.25):
			absorb_object(rigid);
		else:
			var impulse = ($Ball.translation - rigid.translation).normalized();
			impulse.y += 0.1;
			$Ball.apply_central_impulse(impulse * $Ball.mass);

func absorb_object(other: RigidBody):
	for child in other.get_children():
		reparent_onto(child, $Ball);
	$Ball.mass += other.mass;
	other.queue_free();

func reparent_onto(node: Spatial, new_parent: Spatial):
	var previous_global = node.global_transform;
	node.get_parent().remove_child(node);
	new_parent.add_child(node);
	node.global_transform = previous_global;

func _on_Ball_body_entered(body):
	execute_collision(body);
