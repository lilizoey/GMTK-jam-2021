extends RigidBody2D

func set_length(val: int):
	var shape := CapsuleShape2D.new()
	shape.height = val
	shape.radius = 2
	$CollisionShape2D.shape = shape
	$Sprite.region_rect.size.y = val
