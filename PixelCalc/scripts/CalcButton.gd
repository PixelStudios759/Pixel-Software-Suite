extends Button

@onready var display = get_node("/root/Control/DisplayBG/Display")
@onready var main = get_node("/root/Control")
@onready var history_eq = get_node("/root/Control/History/ScrollContainer/VBoxContainer/Equasion")
@onready var history_con = get_node("/root/Control/History/ScrollContainer/VBoxContainer")

var key_path = "/root/Control/ButtonLayout/"
var numbers = ["1","2","3","4","5","6","7","8","9","0","="]
var equasions = ["+","-","*","d"]

func disable_equasion(argument):
	for a in len(main.buttons):
		if not get_node(key_path + str(main.buttons[a])).text in numbers:
			get_node(key_path + str(main.buttons[a])).disabled = argument

# Called when the node is pressed.
func _pressed():
	if display.text == "0":
		display.text = ""
	if not get_node(key_path + self.name).text in numbers and self.text != "=":
		disable_equasion(true)
		main.selected_eq = self.text
	display.text += self.text
	
	if self.text == "=":
		disable_equasion(false)
		display.text[-1] = ""
		var math = display.text.split(main.selected_eq)
		var result
		match main.selected_eq:
			"+":
				result = int(math[0]) + int(math[-1])
			"*":
				result = int(math[0]) * int(math[-1])
			"-":
				result = int(math[0]) - int(math[-1])
			"÷":
				result = int(math[0]) / int(math[-1])
		
		var new_history = history_eq.duplicate()
		new_history.text = display.text + " = " + str(result)
		new_history.show()
		history_con.add_child.call_deferred(new_history)
				
		display.text = str(result)
