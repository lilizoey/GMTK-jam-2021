extends Node2D

enum Type {
	logical_or,
	logical_and,
	logical_xor
}

export var is_open := false
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
	return trues % 2 == 1


func _on_Button_turned_on(body, button):
	var do_open = false
	match type:
		Type.logical_and:
			do_open = check_and()
		Type.logical_or:
			do_open = check_or()
		Type.logical_xor:
			do_open = check_xor()
	
	if do_open and not is_open:
		open()

func _on_Button_turned_off(body, button):
	var do_close = false
	match type:
		Type.logical_and:
			do_close = not check_and()
		Type.logical_or:
			do_close = not check_or()
		Type.logical_xor:
			do_close = not check_xor()
	if do_close and is_open:
		close()

func open():
	visible = false
	$StaticBody2D/CollisionShape2D.call_deferred("set_disabled", true)
	is_open = true

func close():
	visible = true
	$StaticBody2D/CollisionShape2D.call_deferred("set_disabled", false)
	is_open = true
