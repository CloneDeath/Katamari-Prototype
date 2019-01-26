extends Camera

export(NodePath) var target;
export(float) var speed = 10;
var distance: Vector2 = Vector2(0, 0);
var initial_rotation = 0;

func _ready():
	self.distance = distance_to_target()
	self.initial_rotation = self.rotation.x;

func _physics_process(delta):
	move_towards_target(delta);
	look_at_target();

func look_at_target():
	var target_node = get_target_node();
	self.look_at(target_node.translation, Vector3(0, 1, 0));
	self.rotation.x = self.initial_rotation;

func move_towards_target(delta):
	var idealPosition = get_ideal_position();
	var dp = min(speed * delta, abs(self.translation.distance_to(idealPosition)));
	var dv = (idealPosition - self.translation).normalized() * dp;
	self.translate(dv);

func get_ideal_position():
	var targetNode : Spatial = get_target_node();
	var offset: Vector3 = self.translation - targetNode.translation;
	offset.y = 0;
	offset = offset.normalized() * distance.x;
	offset.y = distance.y;
	return targetNode.translation + offset;

func get_target_node() -> Spatial:
	return get_node(target) as Spatial;

func distance_to_target() -> Vector2:
	var targetNode : Spatial = get_target_node();
	var dx = get_xz().distance_to(get_target_xz());
	var dy = self.translation.y - targetNode.translation.y;
	return Vector2(dx, dy);

func get_xz() -> Vector2:
	return Vector2(self.translation.x, self.translation.z);

func get_target_xz() -> Vector2:
	var targetNode = get_target_node();
	return Vector2(targetNode.translation.x, targetNode.translation.z);