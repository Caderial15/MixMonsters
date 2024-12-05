@tool
extends Node2D

@export var mask_texture: Texture2D:
	set(value):
		mask_texture = value
		apply_mask()

@export var use_mask: bool = true:
	set(value):
		use_mask = value
		apply_mask()

const SHADER_PATH = "res://Shaders/mask_recolor_shader.tres"

func _ready():
	apply_mask()

func apply_mask():
	for child in get_children():
		if child is Sprite2D:
			apply_mask_to_sprite(child)

func apply_mask_to_sprite(sprite: Sprite2D):
	var shader_material = sprite.material
	
	if not shader_material is ShaderMaterial:
		shader_material = ShaderMaterial.new()
		sprite.material = shader_material
	
	var shader = load(SHADER_PATH)
	if shader:
		shader_material.shader = shader
	else:
		print("Failed to load shader for sprite: ", sprite.name)
		return
	
	shader_material.set_shader_parameter("mask_texture", mask_texture)
	shader_material.set_shader_parameter("use_mask", use_mask)
	shader_material.set_shader_parameter("recolor", Color(1, 1, 1, 0))  # Default to no recolor
	
	if Engine.is_editor_hint():
		sprite.notify_property_list_changed()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if use_mask and not mask_texture:
		warnings.append("Mask Texture is not set, but Use Mask is enabled.")
	return warnings
