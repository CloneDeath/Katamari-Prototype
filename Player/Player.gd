extends Spatial
var speed = 5;

func _physics_process(_delta):
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
	$Ball.add_torque(torque * speed);
	$Ball.add_central_force(motion * speed);

func _on_Ball_body_entered(body: Node):
	if (body.is_in_group("collectable")):
		var shape = body.get_node("CollisionShape") as CollisionShape;
		var mesh = body.get_node("MeshInstance") as MeshInstance;
		reparent_onto(shape, $Ball);
		reparent_onto(mesh, $Ball);
		body.queue_free();

func reparent_onto(node: Spatial, new_parent: Spatial):
	var previous_global = node.global_transform;
	node.get_parent().remove_child(node);
	new_parent.add_child(node);
	node.global_transform = previous_global;