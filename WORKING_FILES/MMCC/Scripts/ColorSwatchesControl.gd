extends Control

@export var animation_player_path: NodePath
@export var character_root_path: NodePath

@onready var animation_player: AnimationPlayer = get_node(animation_player_path) if animation_player_path else null
@onready var character_root: Node = get_node(character_root_path) if character_root_path else null

var selected_swatch = 0
var swatches = []
var toggle_buttons = []
var original_button_positions = []

const SWATCH_SCALE_SELECTED = Vector2(1.1, 1.1)
const SWATCH_SCALE_NORMAL = Vector2(1.0, 1.0)
const BUTTON_SLIDE_DISTANCE = 10.0
const ANIMATION_DURATION = 0.3
const CHARACTER_BOUNCE_SCALE = Vector2(1.05, 1.05)
const CHARACTER_BOUNCE_DURATION = 0.2

var color_config = {
	"main_body": {"node_path": "Switch_Head_Base", "default_color": Color("264A60")},
	"secondary": {"node_path": "Switch_Body_Patch", "default_color": Color("86B5C9")},
	"accent": {"node_path": "Arm_1_Control/Switch_Arm_1", "default_color": Color("316477")}
}

func _ready():
	for i in range(1, 5):
		swatches.append(get_node("ColorSwatch" + str(i)))
		var toggle_button = get_node("ToggleBtn" + str(i))
		toggle_buttons.append(toggle_button)
		original_button_positions.append(toggle_button.position.y)
		toggle_button.gui_input.connect(_on_toggle_gui_input.bind(i - 1))
	
	for swatch in swatches:
		swatch.pivot_offset = swatch.size / 2
	
	ColorManager.initialize_colors(color_config)
	select_swatch(0)

func _on_toggle_gui_input(event: InputEvent, index: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if selected_swatch != index:
			select_swatch(index)

func select_swatch(index: int):
	if selected_swatch != -1:
		deselect_swatch(selected_swatch)
	
	selected_swatch = index
	
	var tween = create_tween()
	tween.tween_property(swatches[index], "scale", SWATCH_SCALE_SELECTED, ANIMATION_DURATION).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(toggle_buttons[index], "position:y", original_button_positions[index] - BUTTON_SLIDE_DISTANCE, ANIMATION_DURATION).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	if animation_player and animation_player.has_animation("Recolor"):
		var anim = animation_player.get_animation("Recolor")
		var time = index * 0.5
		time = min(time, anim.length)
		
		animation_player.play("Recolor")
		animation_player.seek(time, true)
		animation_player.pause()
		
		get_tree().create_timer(0.1).timeout.connect(extract_and_update_colors)
	else:
		print("Animation player not found or 'Recolor' animation missing!")
	
	bounce_character()

func deselect_swatch(index: int):
	var tween = create_tween()
	tween.tween_property(swatches[index], "scale", SWATCH_SCALE_NORMAL, ANIMATION_DURATION).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(toggle_buttons[index], "position:y", original_button_positions[index], ANIMATION_DURATION).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func bounce_character():
	if character_root:
		var tween = create_tween()
		var original_scale = character_root.scale if character_root is Node2D else character_root.get("scale")
		var scale_property = "scale" if character_root is Node2D else "scale"
		
		tween.tween_property(character_root, scale_property, original_scale * CHARACTER_BOUNCE_SCALE, CHARACTER_BOUNCE_DURATION / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(character_root, scale_property, original_scale, CHARACTER_BOUNCE_DURATION / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	else:
		print("Character root not found! Please set the correct path in the Inspector.")

func extract_and_update_colors():
	var extracted_colors = {}
	for color_id in color_config:
		var node_path = color_config[color_id].node_path
		var parent_node = character_root.get_node_or_null(node_path)
		if parent_node:
			var color_node = get_visible_child(parent_node)
			if color_node and color_node.material:
				extracted_colors[color_id] = get_shader_color(color_node)
	
	for color_id in extracted_colors:
		apply_color(color_id, extracted_colors[color_id])

func get_visible_child(parent_node: Node) -> Node:
	for child in parent_node.get_children():
		if child is Sprite2D and child.visible:
			return child
	return null

func get_shader_color(node: Node) -> Color:
	if node and node.material:
		if node.material is ShaderMaterial:
			return node.material.get_shader_parameter("recolor")
	return Color.WHITE

func apply_color(color_id: String, color: Color):
	ColorManager.update_color(color_id, color)
	var node_path = color_config[color_id].node_path
	var parent_node = character_root.get_node_or_null(node_path)
	if parent_node:
		for child in parent_node.get_children():
			if child is Sprite2D and child.material is ShaderMaterial:
				child.material.set_shader_parameter("recolor", color)
				child.material.set_shader_parameter("flash_amount", 0.0)  # Reset flash amount
