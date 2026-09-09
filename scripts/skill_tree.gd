extends Control

@onready var nodes = [$Control,$Control2,$Control3,$Control4]
var node_connections = [[0,1],[1,2],[0,3]]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in node_connections:
		var line = Line2D.new()
		add_child(line)
		
		line.add_point(nodes[i[0]].position+nodes[i[0]].size/2)
		line.add_point(nodes[i[1]].position+nodes[i[1]].size/2)
		
		line.default_color = Color.BLUE_VIOLET
		line.width = 5.0
		line.z_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
