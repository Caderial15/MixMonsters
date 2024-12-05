extends Node2D

func _ready():
	var save_character_button = $MASTER/SaveCharacterButton
	if save_character_button:
		save_character_button.pressed.connect(_on_SaveCharacterButton_pressed)
	else:
		print("Error: SaveCharacterButton not found in the scene tree")

func _on_SaveCharacterButton_pressed():
	var json_data = GlobalCustomizationManager.export_to_json()
	print("JSON Output:")
	print(json_data)  # This will print the JSON to the output panel for testing
	
	var save_dialog = FileDialog.new()
	save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_dialog.add_filter("*.json ; JSON Files")
	save_dialog.file_selected.connect(_on_SaveDialog_file_selected.bind(json_data))
	add_child(save_dialog)
	save_dialog.popup_centered(Vector2(800, 600))

func _on_SaveDialog_file_selected(path: String, json_data: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(json_data)
		file.close()
		print("JSON file saved to: " + path)
	else:
		print("Error: Unable to open file for writing.")
