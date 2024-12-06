extends Node
class_name GameManager

@export var mini_game_manager: MiniGameManager
@export var player_ui: PackedScene	
@export var player_prefab: PackedScene
@export var spawn_points: Node2D
@export var world: Node2D
@export var ui_container: HBoxContainer
@export var goal: Goal
@export var game_duration: float = 10

var players_won: int = 0

var timer : float = 0
var player_data_array: Array[MiniGameManager.PlayerData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mini_game_manager.game_started.connect(_on_game_started)
	goal.player_win.connect(_on_player_win)
	
func _on_player_win(player: Player):
	var player_ui_inst: PlayerUI = ui_container.get_child(player.player.index)
	player_ui_inst.win(timer)
	player.enabled = false
	players_won += 1
	if players_won == len(player_data_array):
		end_game()
	
func end_game():
	const REWARDS = [3, 2, 1]
	
	var player_uis = ui_container.get_children()
	player_uis.sort_custom(compare)
	
	var results = []
	for i in range(len(player_uis)):
		if i < len(REWARDS):
			results.append({
				"player": player_uis[i].player_data.index,
				"points": REWARDS[i]
			})
			
	mini_game_manager.end_game(results)
	
		
func compare(a: PlayerUI, b: PlayerUI):
	return a.win_time < b.win_time
	 # Replace with function body.

func _on_game_started(player_data_array: Array[MiniGameManager.PlayerData]):
	self.player_data_array = player_data_array
	for i in range(len(player_data_array)):
		var spawnpoint: Marker2D = spawn_points.get_child(i) 
		var player_instance: Player = player_prefab.instantiate()
		var player_ui_instance: PlayerUI = player_ui.instantiate() 
		world.add_child(player_instance)
		ui_container.add_child(player_ui_instance)
		player_instance.global_position = spawnpoint.global_position
		player_instance.construct(player_data_array[i])
		player_ui_instance.construct(player_data_array[i])
	
	print("Game Started", player_data_array)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer < game_duration:
		timer += delta
		if timer > game_duration:
			end_game()
		for child: PlayerUI in ui_container.get_children():
			if not child.won:
				child.text = "%.2f" % [timer]
