extends Control

@onready var grid_container = $News/ScrollContainer/GridContainer

func _ready() -> void:
	SignalBus.articles_changed.connect(_load_articles)
	if Global.articles.size() > 0:
		_load_articles()

func _load_articles():
	for child in grid_container.get_children():
		child.queue_free()
 
	var packed = preload("res://scenes/article.tscn")
	for article in Global.articles:
		var storage_ui = packed.instantiate()
		storage_ui.pick_random = false
		grid_container.add_child(storage_ui)
		storage_ui.process_article(article)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
