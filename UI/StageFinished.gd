extends Control

signal return_to_level_select
signal next_level
signal retry_level

func _on_Return_pressed():
	emit_signal("return_to_level_select")

func _on_Next_pressed():
	emit_signal("next_level")

func _on_Retry_pressed():
	emit_signal("retry_level")
