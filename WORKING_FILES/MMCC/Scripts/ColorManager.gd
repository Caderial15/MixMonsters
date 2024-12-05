extends Node

var current_colors = {}
var original_colors = {}
var color_config = {}

signal colors_updated(colors)

func initialize_colors(config):
	color_config = config
	for color_id in config:
		original_colors[color_id] = config[color_id].default_color
		current_colors[color_id] = config[color_id].default_color
	print_current_colors()

func update_color(color_id: String, new_color: Color):
	if color_id in current_colors:
		current_colors[color_id] = new_color
		emit_signal("colors_updated", current_colors)
		print_current_colors()

func print_current_colors():
	print("Current colors:")
	for color_id in current_colors:
		print("%s: %s" % [color_id, current_colors[color_id].to_html(false)])

func get_current_colors() -> Dictionary:
	return current_colors

func get_color_json():
	var color_data = []
	for color_id in current_colors:
		color_data.append({
			"oldFillColor": "#" + original_colors[color_id].to_html(false),
			"newFillColor": "#" + current_colors[color_id].to_html(false),
			"oldLineColor": "#" + original_colors[color_id].to_html(false),
			"newLineColor": "#" + current_colors[color_id].to_html(false)
		})
	return {"Swatch_1": color_data}
