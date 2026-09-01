extends Control

@onready var logo = $logo
@onready var title = $title
@onready var subtitle = $subtitle
@onready var article_text = $article
@onready var image_container = $image_container
@onready var ad_container = $advertisement_container
@onready var image_text = $image_container/image_text

var articles_available = []
var article_chosen = ""
var pick_random: bool = true
var article_index = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !pick_random:
		return
	elif pick_random:
		articles_available = load_json_file("res://dialogue/news.json")
	
	if articles_available == null or articles_available.is_empty():
		return
		
	if articles_available.size() > 1:
		articles_available = articles_available.filter(
			func(article): 
				if Global.last_article is Dictionary:
					return int(article["id"]) != int(Global.last_article["id"])

				return int(article["id"]) != int(Global.last_article)
		)
		
		article_chosen = get_article(articles_available)
		
		process_article(article_chosen)
		article_effect(article_chosen)
		Global.last_article = int(article_chosen["id"])

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
			return article

				
	return {}

func process_article(article):
	if not article is Dictionary or article.is_empty():
		return
		
	image_container.hide()
	ad_container.hide()
	
	var is_rich_text: bool = title is RichTextLabel
	
	var saved_data = {}
	if article_index < Global.articles.size() and Global.articles[article_index] is Dictionary:
		saved_data = Global.articles[article_index]
	var name = saved_data.get("saved_name", Global.full_name_generator())
	
	var title_unformatted = article.get("title","")
	title_unformatted = title_unformatted.replace("[name]", name)
	
	title.add_theme_font_size_override("bold_font_size", 50 - round(len(article.get("title",""))) * 0.5)
	subtitle.text = "[center]" + article.get("subtitle","") + "[/center]"
	var article_itself = article.get("article","")
	
	article_itself = article_itself.replace("[name]", name)
	
	# Date calculation logic
	var rng = RandomNumberGenerator.new()
	var day_offset = rng.randi_range(1, 4)
	var date = ""
	var month_given = Global.month
	var year_given = Global.year
	var exception_day = 0
	
	if (Global.day - day_offset) < 1:
		month_given -= 1
		if month_given == 0:
			month_given = 12
			year_given -= 1
		if month_given in Global.months_30:
			exception_day = 30 + (Global.day - day_offset)
		elif month_given in Global.months_31:
			exception_day = 31 + (Global.day - day_offset)
		elif Global.is_leap_year(year_given):
			exception_day = 29 + (Global.day - day_offset)
		else:
			exception_day = 28 + (Global.day - day_offset)
			
	if (Global.day - day_offset) % 10 == 3 and (Global.day - day_offset) != 13 and (Global.day - day_offset) >= 1:
		date = "the " + str(Global.day - day_offset) + "rd"
	elif (Global.day - day_offset) % 10 == 2 and (Global.day - day_offset) != 12 and (Global.day - day_offset) >= 1:
		date = "the " + str(Global.day - day_offset) + "nd"	
	elif (Global.day - day_offset) % 10 == 1 and (Global.day - day_offset) != 11 and (Global.day - day_offset) >= 1:
		date = "the " + str(Global.day - day_offset) + "st"	
	elif (Global.day - day_offset) >= 1:
		date = "the " + str(Global.day - day_offset) + "th"	
	else:
		if exception_day % 10 == 3 and exception_day != 13 and exception_day >= 1:
			date = "the " + str(exception_day) + "rd"
		elif exception_day % 10 == 2 and exception_day != 12 and exception_day >= 1:
			date = "the " + str(exception_day) + "nd"	
		elif exception_day % 10 == 1 and exception_day != 11 and exception_day >= 1:
			date = "the " + str(exception_day) + "st"	
		elif exception_day >= 1:
			date = "the " + str(exception_day) + "th"	
		else:
			date = "Error"
	
	date = date + " of " + Global.get_month(month_given)
	
	var place = Global.place_generator()
	
	article_itself = article_itself.replace("[date]", date)
	article_itself = article_itself.replace("[percent]", str(rng.randi_range(5, 30)))
	article_itself = article_itself.replace("[age]", str(rng.randi_range(10, 100)))
	article_itself = article_itself.replace("[place]", place.capitalize())
	article_itself = article_itself.replace("[placeB]", Global.place_generatorB().capitalize())
	title_unformatted = title_unformatted.replace("[place]", place.capitalize()) 
	title_unformatted = title_unformatted.replace("[date]", date) 
	title_unformatted = title_unformatted.replace("[age]", str(rng.randi_range(10, 100))) 
	
	article_text.text = article_itself
	logo.text = article.get("source", "")
	var image = article.get("image", "none")
	var image_desc = article.get("image_desc", "")
	
	var image_desc_parsed = image_desc.replace("[name]", name)
	image_text.text = image_desc_parsed
	if image != "none":
		image_container.show()
		image_text.text = image_desc_parsed
	elif article.get("ad", false):
		ad_container.show()

	title.text = "[b]" + title_unformatted + "[/b]"

	if article_index < Global.articles.size():
		Global.articles[article_index]["saved_name"] = name
		Global.articles[article_index]["article"] = article_itself
		Global.articles[article_index]["title"] = title_unformatted
		Global.articles[article_index]["image_desc"] = image_desc_parsed

	if article.get("subtitle", "") == "":
		article_text.size = Vector2(380, 260)
		article_text.position = Vector2(12, 188)
		
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

func article_effect(article):
	var effect = article.get("effect","none")
	if effect == "less_buyers":
		Global.news_interest -= 0.4
	elif effect == "more_buyers":
		Global.news_interest += 0.4
