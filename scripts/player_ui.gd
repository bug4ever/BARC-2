extends Label
class_name PlayerUI

var won: bool = false
var win_time: float = INF
var player_data: MiniGameManager.PlayerData


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func construct(player_data: MiniGameManager.PlayerData):
	self.player_data = player_data
	add_theme_color_override("font_color", player_data.color)

func win(win_time: float):
	won = true
	self.win_time = win_time	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
