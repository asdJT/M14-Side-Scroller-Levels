@tool
class_name GameLevel extends Node2D

@export_file("*level.tscn") var next_level_path := ""

@export var gameplay_tilemap: TileMapLayer = null: set = set_gameplay_tilemap

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	await get_tree().process_frame
	for child in gameplay_tilemap.get_children():
		if child is EndFlag:
			child.body_entered.connect(func (body: Area2D) -> void:
				await get_tree().create_timer(2.0).timeout
				_change_to_next_level()
			)
			break

func _change_to_next_level() -> void:
	if next_level_path == null:
		get_tree().quit()
		return
	
	var result := get_tree().change_scene_to_file(next_level_path)
	if result != OK:
		push_error("Failed to load level: " + next_level_path + ".Quitting the game.")
		get_tree().quit()

func set_gameplay_tilemap(value: TileMapLayer) -> void:
	gameplay_tilemap = value
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if gameplay_tilemap == null:
		warnings.append("Missing ameplay tilemap")
	return warnings
