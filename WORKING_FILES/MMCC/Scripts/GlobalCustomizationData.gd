extends Node

const categories = [
	"Head", "HeadDetail", "Eyes", "TopTeeth", "BtmTeeth", 
	"BodyPatch", "BodyDetail", "Arms", "Hands", "Toes"
]

const category_to_submenu = {
	"Head": "HeadOptionsSubMNU",
	"HeadDetail": "HeadDetailSubMNU",
	"Eyes": "EyeOptionsSubMNU",
	"TopTeeth": "TopTeethOptionsSubMNU",
	"BtmTeeth": "BtmTeethOptionsSubMNU",
	"BodyPatch": "BodyPatchOptionsSubMNU",
	"BodyDetail": "BodyDetailOptionsSubMNU",
	"Arms": "ArmOptionsSubMNU",
	"Hands": "HandOptionsSubMNU",
	"Toes": "ToeOptionsSubMNU2"
}

const character_parts = {
	"Arms": {
		"OptionSelect1": ["Arm_1_Control/Switch_Arm_1/Arm_1_1", "Arm_2_Control/Switch_Arm_2/Arm_2_1"],
		"OptionSelect2": ["Arm_1_Control/Switch_Arm_1/Arm_1_2", "Arm_2_Control/Switch_Arm_2/Arm_2_2"],
		"OptionSelect3": ["Arm_1_Control/Switch_Arm_1/Arm_1_3", "Arm_2_Control/Switch_Arm_2/Arm_2_3"]
	},
	"Hands": {
		"OptionSelect1": ["Arm_1_Control/Switch_Arm_1_Hand/Arm_1_Hand_1", "Arm_2_Control/Switch_Arm_2_Hand/Arm_2_Hand_1"],
		"OptionSelect2": ["Arm_1_Control/Switch_Arm_1_Hand/Arm_1_Hand_2", "Arm_2_Control/Switch_Arm_2_Hand/Arm_2_Hand_2"],
		"OptionSelect3": ["Arm_1_Control/Switch_Arm_1_Hand/Arm_1_Hand_3", "Arm_2_Control/Switch_Arm_2_Hand/Arm_2_Hand_3"]
	},
	"Toes": {
		"OptionSelect1": ["Switch_Leg_1_Toes/Leg_1_Toes_1", "Switch_Leg_2_Toes/Leg_2_Toes_1"],
		"OptionSelect2": ["Switch_Leg_1_Toes/Leg_1_Toes_2", "Switch_Leg_2_Toes/Leg_2_Toes_2"],
		"OptionSelect3": ["Switch_Leg_1_Toes/Leg_1_Toes_3", "Switch_Leg_2_Toes/Leg_2_Toes_3"]
	},
	"BodyPatch": {
		"OptionSelect1": ["Switch_Body_Patch/Body_Patch_1"],
		"OptionSelect2": ["Switch_Body_Patch/Body_Patch_2"],
		"OptionSelect3": ["Switch_Body_Patch/Body_Patch_3"]
	},
	"BodyDetail": {
		"OptionSelect1": ["Switch_Body_Detail/Body_Detail_1"],
		"OptionSelect2": ["Switch_Body_Detail/Body_Detail_2"],
		"OptionSelect3": ["Switch_Body_Detail/Body_Detail_3"]
	},
	"Head": {
		"OptionSelect1": ["Switch_Head_Base/Head_Base_1"],
		"OptionSelect2": ["Switch_Head_Base/Head_Base_2"],
		"OptionSelect3": ["Switch_Head_Base/Head_Base_3"]
	},
	"HeadDetail": {
		"OptionSelect1": ["Switch_Head_Detail/Head_Detail_1"],
		"OptionSelect2": ["Switch_Head_Detail/Head_Detail_2"],
		"OptionSelect3": ["Switch_Head_Detail/Head_Detail_3"]
	},
	"Eyes": {
		"OptionSelect1": ["Switch_Eyes_Base_1/Eyes_Base_1"],
		"OptionSelect2": ["Switch_Eyes_Base_1/Eyes_Base_2"],
		"OptionSelect3": ["Switch_Eyes_Base_1/Eyes_Base_3"]
	},
	"TopTeeth": {
		"OptionSelect1": ["Switch_Mouth_Teeth_Top/Mouth_Teeth_Top_1"],
		"OptionSelect2": ["Switch_Mouth_Teeth_Top/Mouth_Teeth_Top_2"],
		"OptionSelect3": ["Switch_Mouth_Teeth_Top/Mouth_Teeth_Top_3"]
	},
	"BtmTeeth": {
		"OptionSelect1": ["Switch_Mouth_Teeth_Bottom/Mouth_Teeth_Bottom_1"],
		"OptionSelect2": ["Switch_Mouth_Teeth_Bottom/Mouth_Teeth_Bottom_2"],
		"OptionSelect3": ["Switch_Mouth_Teeth_Bottom/Mouth_Teeth_Bottom_3"]
	}
}

var current_selections = {
	"Head": "OptionSelect1",
	"HeadDetail": "OptionSelect1",
	"Eyes": "OptionSelect1",
	"TopTeeth": "OptionSelect1",
	"BtmTeeth": "OptionSelect1",
	"BodyPatch": "OptionSelect1",
	"BodyDetail": "OptionSelect1",
	"Arms": "OptionSelect1",
	"Hands": "OptionSelect1",
	"Toes": "OptionSelect1"
}

signal category_changed(category: String)
signal option_selected(category: String, option: String)

func get_submenu_for_category(category: String) -> String:
	return category_to_submenu[category]

func get_parts_for_option(category: String, option: String) -> Array:
	return character_parts[category][option]

func set_current_selection(category: String, option: String) -> void:
	current_selections[category] = option
	option_selected.emit(category, option)

func get_current_selection(category: String) -> String:
	return current_selections[category]

func emit_category_changed(category: String) -> void:
	category_changed.emit(category)
