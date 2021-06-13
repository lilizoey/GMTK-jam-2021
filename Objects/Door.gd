extends Node2D

enum Type {
	logical_or,
	logical_and,
	logical_xor
}

export var inverted := false
onready var is_open := inverted
export(Type) var type 
export(Array, NodePath) var button_paths
var buttons := []


# Called when the node enters the scene tree for the first time.
func _ready():
	for path in button_paths:
		buttons.append(get_node(path))
	
	for button in buttons:
		button.connect("turned_on", self, "_on_Button_turned_on", [button])
		button.connect("turned_off", self, "_on_Button_turned_off", [button])
	
	if is_open:
		open()
	else:
		close()

func check_or() -> bool:
	for button in buttons:
		if button.on:
			return true
	return false

func check_and() -> bool:
	for button in buttons:
		if not button.on:
			return false
	return true

func check_xor() -> bool:
	var trues := 0
	for button in buttons:
		if button.on:
			trues += 1
	print(trues)
	return (trues % 2) == 0

func _on_Button_turned_on(body, button):
	update_state()

func _on_Button_turned_off(body, button):
	update_state()

func check_open() -> bool:
	var b := false
	match type:
		Type.logical_and:
			b = check_and()
		Type.logical_or:
			b = check_or()
		Type.logical_xor:
			b = check_xor()
	
	if inverted:
		return not b
	else:
		return b

func update_state():
	var desired_state := check_open()
	
	if desired_state and not is_open:
		open()
	elif not desired_state and is_open:
		close()

func open():
	$Sprite.frame = 3
	
	$StaticBody2D/CollisionShape2D.call_deferred("set_disabled", true)
	is_open = true

func close():
	match type:
		Type.logical_and:
			$Sprite.frame = 0
		Type.logical_or:
			$Sprite.frame = 1
		Type.logical_xor:
			$Sprite.frame = 2
	
	$StaticBody2D/CollisionShape2D.call_deferred("set_disabled", false)
	is_open = false
