extends Node

var switch_selections = {}

func _ready():
	initialize_default_selections()
	print("Ready and initialized default selections.")

func initialize_default_selections():
	var default_selections = {
		"Switch_Head_Base": "Head_Base_1",
		"Switch_Head_Detail": "Head_Detail_1",
		"Switch_Eyes_Base_1": "Eyes_Base_1",
		"Switch_Mouth_Teeth_Top": "Mouth_Teeth_Top_1",
		"Switch_Mouth_Teeth_Bottom": "Mouth_Teeth_Bottom_1",
		"Switch_Body_Patch": "Body_Patch_1",
		"Switch_Body_Detail": "Body_Detail_1",
		"Arm_1_Control/Switch_Arm_1": "Arm_1_1",
		"Arm_2_Control/Switch_Arm_2": "Arm_2_1",
		"Arm_1_Control/Switch_Arm_1_Hand": "Arm_1_Hand_1",
		"Arm_2_Control/Switch_Arm_2_Hand": "Arm_2_Hand_1",
		"Switch_Leg_1_Toes": "Leg_1_Toes_1",
		"Switch_Leg_2_Toes": "Leg_2_Toes_1"
	}
	switch_selections = default_selections

func update_switch_selection(switch_name: String, selection_name: String) -> void:
	if switch_name in switch_selections:
		switch_selections[switch_name] = selection_name
		print("Updated switch selection: ", switch_name, " -> ", selection_name)

func get_switch_selections() -> Dictionary:
	return switch_selections

func get_current_colors() -> Dictionary:
	return ColorManager.get_color_json()

func export_to_json() -> String:
	var export_data = {
		"CharacterTemplateAssignment": {
			"SpeciesTemplate": "BigGreen_Template_Story_1"
		},
		"layerSwitchOptions": switch_selections,
		"colors": get_current_colors()
	}
	print("Exporting JSON: ", JSON.stringify(export_data, "\t", false))
	return JSON.stringify(export_data, "\t", false)
