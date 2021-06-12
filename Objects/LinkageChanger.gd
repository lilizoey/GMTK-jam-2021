extends Node2D

enum LinkageType {
	rod = 0,
	rope = 1,
	spring = 2
}

export(LinkageType) var held_linkage = LinkageType.rope

const linkage_prefabs := {
	LinkageType.rod: preload("res://Character/Player/RodPlayers.tscn"),
	LinkageType.rope: preload("res://Character/Player/RopePlayers.tscn"),
	LinkageType.spring: preload("res://Character/Player/SpringPlayers.tscn"),
}

func _ready():
	for child in get_children():
		if child.has_signal("body_entered"):
			child.connect("body_entered", self, "_on_body_entered", [child])
		if child.has_signal("body_exited"):
			child.connect("body_exited", self, "_on_body_exited", [child])

onready var active_pads = {
	$Slot1: null,
	$Slot2: null
}

func _on_body_entered(body, child):
	if body.is_in_group("Player"):
		active_pads[child] = body
		try_swap()

func _on_body_exited(body, child):
	if body.is_in_group("Player"):
		active_pads[child] = null
		try_swap()

func try_swap():
	if not (active_pads[$Slot1] and active_pads[$Slot2]):
		return
	
	var assembly: Node2D = active_pads[$Slot1].get_parent()
	assembly.get_parent().remove_child(assembly)
	
	var previous_linkage = assembly.linkage_type
	var new_instance = linkage_prefabs[held_linkage].instance()
	new_instance.global_position = to_global(Vector2(0, 24))
	get_parent().add_child(new_instance)
	
	held_linkage = previous_linkage
	new_instance.connect("die", get_parent(), "_on_character_die")
