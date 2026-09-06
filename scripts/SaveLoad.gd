extends Node
const save_location = "user://SaveFile.tres"
var SaveFileData: SaveDataResource = SaveDataResource.new()

func _ready() -> void:
	_load()

func _save():
	SaveFileData.global_data = Global.get_save_data()
	SaveFileData.inventory_data = Inventory.get_save_data()
	ResourceSaver.save(SaveFileData, save_location)

func _load():
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)
		Global.load_save_data(SaveFileData.global_data)
		Inventory.load_save_data(SaveFileData.inventory_data)

func _wipe():
	if FileAccess.file_exists(save_location):
		DirAccess.remove_absolute(save_location)
	
	SaveFileData = SaveDataResource.new()
	Global.reset_to_defaults()
	Inventory.reset_to_defaults()

func has_save() -> bool:
	return FileAccess.file_exists(save_location)
