extends Area2D
class_name Goal

signal player_win(player: Player)

func _on_body_entered(body: Node2D) -> void:
	if body is Player: 
		player_win.emit(body)
