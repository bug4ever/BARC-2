extends Node
class_name GameManager

@export var mini_game_manager: MiniGameManager
@export var player_prefab: PackedScene
@export var spawn_points: Node2D
@export var world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mini_game_manager.game_started.connect(_on_game_started)
	pass # Replace with function body.

func _on_game_started(player_data_array: Array[MiniGameManager.PlayerData]):
	for i in range(len(player_data_array)):
		var spawnpoint: Marker2D = spawn_points.get_child(i) 
		var player_instance: Player = player_prefab.instantiate()
		world.add_child(player_instance)
		player_instance.global_position = spawnpoint.global_position
		player_instance.construct(player_data_array[i])
	
	print("Game Started", player_data_array)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
