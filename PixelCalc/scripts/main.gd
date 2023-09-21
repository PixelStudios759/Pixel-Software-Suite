extends Control

@onready var calc_key = $ButtonLayout/CalcButton
@onready var key_container = $ButtonLayout
@onready var color_picker = $Settings/Background/ColorPickerButton
@onready var background = $Background
@onready var open_image = $FileDialog
@onready var settings = $Settings
@onready var choose_image = $Settings/Background/ChooseImage
@onready var image_use = $Settings/Background/UseImage
@onready var display = $DisplayBG/Display

@export var selected_eq = ""
@export var local_data = {}

@export var buttons = [
	"1","2","3","+",
	"4","5","6","*",
	"7","8","9","-",
	"0","=","÷"
	]

var default_data = {
	"bg_type": "plain",
	"bg_color": [59,59,59,255],
	"bg_image": "",
	"using_image": false
}

var path = "user://save_data.json"

func save(content):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(content)
	file = null
	
func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_var()
	return content

func set_image(path):
	var stylebox_image = StyleBoxTexture.new()
	var image = Image.new()
	var photo = FileAccess.open(path,FileAccess.READ)
	var buffer = photo.get_buffer(photo.get_length())
	image.load_png_from_buffer(buffer)
	var texture = ImageTexture.create_from_image(image)
	stylebox_image.texture = texture
	background.add_theme_stylebox_override("panel",stylebox_image)

# Called when the node enters the scene tree for the first time.
func _ready():
	if !FileAccess.file_exists(path):
		save(default_data)
	
	local_data = load_game()
	
	if local_data["using_image"] == true:
		image_use.button_pressed = true
	else:
		image_use.button_pressed = false
	
	if local_data["bg_image"] != "" or local_data["using_image"] != false:
		set_image(local_data["bg_image"])
	else:
		var c = local_data["bg_color"]
		var stylebox_color = StyleBoxFlat.new()
		stylebox_color.bg_color = Color(c[0],c[1],c[2],c[3])
		background.add_theme_stylebox_override("panel",stylebox_color)
	
	get_viewport().set_embedding_subwindows(false)
	DirAccess.make_dir_absolute("user://BG Images")
	for num_button in len(buttons):
		var new_key = calc_key.duplicate()
		new_key.text = buttons[num_button]
		new_key.name = str(buttons[num_button])
		new_key.show()
		key_container.add_child.call_deferred(new_key)

func _on_color_picker_button_color_changed(color):
	var stylebox_color = StyleBoxFlat.new()
	stylebox_color.bg_color = color_picker.color
	background.add_theme_stylebox_override("panel",stylebox_color)

func _on_choose_image_pressed():
	open_image.popup()

func _on_file_dialog_file_selected(path): # If a PNG is selected, set it as the background.
	set_image(path)
	
	local_data["bg_image"] = str(path)

func _on_user_pressed(): # Opens the background image folder in user://
	var project_dir = ProjectSettings.globalize_path("user://BG Images")
	OS.shell_open(project_dir)

func _on_ok_pressed():
	settings.hide()
	save(local_data)

func _on_use_image_pressed():
	local_data["using_image"] = !local_data["using_image"]
	choose_image.disabled = !choose_image.disabled
	color_picker.disabled = !color_picker.disabled

func _on_settings_pressed():
	settings.show()

func _on_clear_pressed():
	display.text = "0"
	var key_path = "/root/Control/ButtonLayout/"
	for a in len(buttons):
		if not get_node(key_path + str(buttons[a])).text in ["1","2","3","4","5","6","7","8","9","0","="]:
			get_node(key_path + str(buttons[a])).disabled = false
