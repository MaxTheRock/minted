extends TabBar

var master_bus_index = AudioServer.get_bus_index("Master")
var sfx_bus_index = AudioServer.get_bus_index("SFX")
var music_bus_index = AudioServer.get_bus_index("Music")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))


func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))
