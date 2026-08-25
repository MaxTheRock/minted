extends OptionButton

enum AAMode { NONE, FXAA, MSAA_2X, MSAA_4X, MSAA_8X, TAA }

func _ready():
	add_item("None", AAMode.NONE)
	add_item("FXAA", AAMode.FXAA)
	add_item("MSAA 2x", AAMode.MSAA_2X)
	add_item("MSAA 4x", AAMode.MSAA_4X)
	add_item("MSAA 8x", AAMode.MSAA_8X)
	add_item("TAA", AAMode.TAA)

	item_selected.connect(_on_aa_selected)

func _on_aa_selected(index: int):
	var mode = get_item_id(index)
	var vp = get_viewport()

	vp.msaa_3d = Viewport.MSAA_DISABLED
	vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	vp.use_taa = false

	match mode:
		AAMode.FXAA:
			vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		AAMode.MSAA_2X:
			vp.msaa_3d = Viewport.MSAA_2X
		AAMode.MSAA_4X:
			vp.msaa_3d = Viewport.MSAA_4X
		AAMode.MSAA_8X:
			vp.msaa_3d = Viewport.MSAA_8X
		AAMode.TAA:
			vp.use_taa = true
