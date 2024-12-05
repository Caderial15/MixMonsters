extends Control

@export var animation_player_path: NodePath
@export var character_root_path: NodePath

@onready var animation_player: AnimationPlayer = get_node(animation_player_path) if animation_player_path else null
@onready var character_root: Node = get_node(character_root_path) if character_root_path else null

var current_index = 0
var initial_position_x = 0
var sub_menu_tween

func _ready():
	print("Customization Menu Controller initialized")
	$ArrowLeft.gui_input.connect(_on_arrow_input.bind(-1))
	$ArrowRight.gui_input.connect(_on_arrow_input.bind(1))
	initial_position_x = $MNUOptionIconsControl/CategoryMNUControl.position.x
	setup_initial_state()
	center_icons(current_index, true)
	hide_all_sub_menus()
	if GlobalCustomizationData.categories.size() > 0:
		animate_sub_menu(GlobalCustomizationData.categories[0])

func setup_initial_state():
	print("Setting up initial state")
	for category in GlobalCustomizationData.categories:
		var submenu_name = GlobalCustomizationData.get_submenu_for_category(category)
		var sub_menu = $SubMNUControl.get_node(submenu_name)
		if sub_menu:
			for i in range(sub_menu.get_child_count()):
				var icon = sub_menu.get_child(i)
				icon.gui_input.connect(_on_option_input.bind(category, "OptionSelect" + str(i + 1)))
		update_character_customization(category, GlobalCustomizationData.get_current_selection(category))
	print("Initial state setup complete")

func _on_arrow_input(event: InputEvent, direction: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Arrow clicked. Direction: ", "Right" if direction > 0 else "Left")
		slide_icons(direction)

func slide_icons(direction: int):
	current_index = (current_index + direction) % $MNUOptionIconsControl/CategoryMNUControl.get_child_count()
	if current_index < 0:
		current_index = $MNUOptionIconsControl/CategoryMNUControl.get_child_count() - 1
	print("Sliding to category index: ", current_index)
	center_icons(current_index)

func center_icons(index: int, instant: bool = false):
	var target_position = initial_position_x - (index * 50)
	
	if instant:
		$MNUOptionIconsControl/CategoryMNUControl.position.x = target_position
	else:
		var tween = create_tween()
		tween.tween_property($MNUOptionIconsControl/CategoryMNUControl, "position:x", target_position, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if index < GlobalCustomizationData.categories.size():
		var current_category = GlobalCustomizationData.categories[index]
		print("Centering on category: ", current_category)
		GlobalCustomizationData.emit_category_changed(current_category)
		animate_sub_menu(current_category)

func animate_sub_menu(category: String):
	print("Animating sub-menu for category: ", category)
	hide_all_sub_menus()
	var submenu_name = GlobalCustomizationData.get_submenu_for_category(category)
	var sub_menu = $SubMNUControl.get_node(submenu_name)
	if sub_menu:
		sub_menu.show()
		var icons = sub_menu.get_children()
		var tween = create_tween()
		for i in range(icons.size()):
			var icon = icons[i]
			icon.position.y = 0
			icon.modulate.a = 0
			tween.parallel().tween_property(icon, "modulate:a", 1, 0.3).set_delay(i * 0.1)
		update_option_visibility(category)

func hide_all_sub_menus():
	print("Hiding all sub-menus")
	for sub_menu in $SubMNUControl.get_children():
		sub_menu.hide()

func _on_option_input(event: InputEvent, category: String, option: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Option clicked: Category - ", category, ", Option - ", option)
		if GlobalCustomizationData.get_current_selection(category) != option:
			GlobalCustomizationData.set_current_selection(category, option)
			update_option_visibility(category)
			update_character_customization(category, option)
		
		var switch_names = get_switch_names_for_category(category)
		var selection_names = get_sprite_names_for_option(category, option)
		for i in range(switch_names.size()):
			GlobalCustomizationManager.update_switch_selection(switch_names[i], selection_names[i])

func get_switch_names_for_category(category: String) -> Array:
	match category:
		"Head":
			return ["Switch_Head_Base"]
		"HeadDetail":
			return ["Switch_Head_Detail"]
		"Eyes":
			return ["Switch_Eyes_Base_1"]
		"TopTeeth":
			return ["Switch_Mouth_Teeth_Top"]
		"BtmTeeth":
			return ["Switch_Mouth_Teeth_Bottom"]
		"BodyPatch":
			return ["Switch_Body_Patch"]
		"BodyDetail":
			return ["Switch_Body_Detail"]
		"Arms":
			return ["Arm_1_Control/Switch_Arm_1", "Arm_2_Control/Switch_Arm_2"]
		"Hands":
			return ["Arm_1_Control/Switch_Arm_1_Hand", "Arm_2_Control/Switch_Arm_2_Hand"]
		"Toes":
			return ["Switch_Leg_1_Toes", "Switch_Leg_2_Toes"]
		_:
			return ["Switch_" + category]

func get_sprite_names_for_option(category: String, option: String) -> Array:
	var option_number = option.replace("OptionSelect", "")
	match category:
		"Head":
			return ["Head_Base_" + option_number]
		"HeadDetail":
			return ["Head_Detail_" + option_number]
		"Eyes":
			return ["Eyes_Base_" + option_number]
		"TopTeeth":
			return ["Mouth_Teeth_Top_" + option_number]
		"BtmTeeth":
			return ["Mouth_Teeth_Bottom_" + option_number]
		"BodyPatch":
			return ["Body_Patch_" + option_number]
		"BodyDetail":
			return ["Body_Detail_" + option_number]
		"Arms":
			return ["Arm_1_" + option_number, "Arm_2_" + option_number]
		"Hands":
			return ["Arm_1_Hand_" + option_number, "Arm_2_Hand_" + option_number]
		"Toes":
			return ["Leg_1_Toes_" + option_number, "Leg_2_Toes_" + option_number]
		_:
			return [option]

func update_option_visibility(category: String):
	print("Updating option visibility for category: ", category)
	var submenu_name = GlobalCustomizationData.get_submenu_for_category(category)
	var sub_menu = $SubMNUControl.get_node(submenu_name)
	if sub_menu:
		var current_option = GlobalCustomizationData.get_current_selection(category)
		var tween = create_tween()
		for i in range(sub_menu.get_child_count()):
			var icon = sub_menu.get_child(i)
			var option = "OptionSelect" + str(i + 1)
			if option == current_option:
				print("Raising selected option: ", option)
				tween.parallel().tween_property(icon, "position:y", -5, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			else:
				tween.parallel().tween_property(icon, "position:y", 0, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func update_character_customization(category: String, option: String):
	print("Updating character customization: Category - ", category, ", Option - ", option)
	if character_root:
		var parts = GlobalCustomizationData.get_parts_for_option(category, option)
		for part_path in parts:
			var part = character_root.get_node_or_null(part_path)
			if part:
				part.visible = true
				print("Showing part: ", part_path)
				var parent = part.get_parent()
				for sibling in parent.get_children():
					if sibling != part:
						sibling.visible = false
						print("Hiding sibling: ", sibling.name)
				
				animate_part(part)
	else:
		print("Error: character_root is null. Make sure to set the character_root_path in the Inspector.")

func animate_part(part: Node):
	if part is Sprite2D and part.material is ShaderMaterial:
		var original_modulate = part.modulate
		var original_flash_amount = part.material.get_shader_parameter("flash_amount")
		
		var tween = create_tween()
		
		# Flash effect using shader parameter
		tween.tween_method(set_flash_amount.bind(part), 0.0, 1.0, 0.1)
		tween.tween_method(set_flash_amount.bind(part), 1.0, 0.0, 0.1)
		
		# Original modulate animation
		tween.parallel().tween_property(part, "modulate", Color(1.5, 1.5, 1.5, 1), 0.1)
		tween.parallel().tween_property(part, "modulate", original_modulate, 0.1).set_delay(0.1)
		
		await tween.finished
		
		# Ensure we reset to the original state
		part.modulate = original_modulate
		set_flash_amount(original_flash_amount, part)
	else:
		print("Warning: Attempted to animate a part that is not a Sprite2D or doesn't have a ShaderMaterial")

func set_flash_amount(amount: float, part: Sprite2D):
	if part.material is ShaderMaterial:
		part.material.set_shader_parameter("flash_amount", amount)
	
func _on_category_changed(category: String):
	print("Category changed to:", category)

func _on_option_selected(category: String, option: String):
	print("Option selected: Category -", category, ", Option -", option)
