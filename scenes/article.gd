extends Control

@onready var logo = $logo
@onready var title = $title
@onready var subtitle = $subtitle
@onready var article_text = $article
@onready var image_container = $image_container
@onready var ad_container = $advertisement_container
@onready var image_text = $image_container/image_text

var articles_available = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	articles_available = load_json_file("res://dialogue/news.json")
	articles_available.erase(Global.last_article)
	var article_chosen = get_article(articles_available)
	
	process_article(article_chosen)
	Global.last_article = article_chosen

func load_json_file(file_path: String) -> Variant:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		return parsed_data
	else:
		print("file does not exist!")
		return null

func get_article(articles):
	if articles.is_empty():
		return {}
	var total_weight: int = 0
	for article in articles:
		total_weight += article.get("weight", 0)
	var roll: int = randi_range(0, total_weight - 1)
	
	var cumulative_weight = 0
	for article in articles:
		cumulative_weight += article.get("weight", 0)
		if roll < cumulative_weight:
			if article != Global.last_article:
				return article

				
	return "error"

func process_article(article):
	image_container.hide()
	ad_container.hide()
	
	var is_rich_text: bool = title is RichTextLabel
	title.text = "[b]"+article.get("title","")+"[/b]"
	title.add_theme_font_size_override("bold_font_size",50 - round(len(article.get("title",""))) * 0.5)
	subtitle.text = "[center]"+article.get("subtitle","")+"[/center]"
	article_text.text = article.get("article","")
	logo.text = article.get("source","")
	var image = article.get("image","none")
	var image_desc = article.get("image_desc","")
	
	var ad = article.get("ad",false)
	if image != "none":
		image_container.show()
		image_text.text = image_desc
	elif ad:
		ad_container.show()
		
	title.text = article.get("title", "No Title")
	
	var start_size: int = 38
	var min_size: int = 14
	var current_size: int = start_size
	
	if is_rich_text:
		title.add_theme_font_size_override("bold_font_size", start_size)
		title.add_theme_font_size_override("normal_font_size", start_size)
	else:
		title.add_theme_font_size_override("font_size", start_size)
	
	await get_tree().process_frame

	while title.get_combined_minimum_size().x > title.size.x - 50:
		current_size -= 3
		
		if is_rich_text:
			title.add_theme_font_size_override("bold_font_size", current_size)
			title.add_theme_font_size_override("normal_font_size", current_size)
		else:
			title.add_theme_font_size_override("font_size", current_size)
			
		if current_size <= min_size:
			title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			break
