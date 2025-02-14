extends CanvasLayer

var storytext
var c = 0.435
var textc = 0
var sText=""
func _ready() -> void:
	storytext = read_text_file("res://Assets/introStory.txt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if c <=0:
		if textc<storytext.length():
			sText =sText.substr(0, sText.length() - 1)
			sText+=storytext[textc]+'_'
			$StoryLabel.text=sText
			$StoryLabel.scroll_to_line($StoryLabel.get_line_count() - 1)
			textc+=1
			c=0.024
	c-=delta
func read_text_file(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)

	if file:
		var content = file.get_as_text()
		# File is automatically closed when 'file' goes out of scope
		return content
	else:
		var error = FileAccess.get_open_error()
		push_error("Failed to read file '%s'. Error: %s" % [file_path, error])
		return ""




func _on_start_game_button_mouse_entered() -> void:
	$StartGameButton.scale*=1.2


func _on_start_game_button_mouse_exited() -> void:
	$StartGameButton.scale.x=1
	$StartGameButton.scale.y=1


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_exit_button_mouse_entered() -> void:
	$ExitGameButton.scale*=1.1


func _on_exit_game_button_mouse_exited() -> void:
	$ExitGameButton.scale.x=1
	$ExitGameButton.scale.y=1


func _on_start_game_button_pressed() -> void:
	get_parent().get_node("AnimationPlayer").play("Intro")
	self.visible=false


func _on_mute_button_pressed() -> void:
	GlobalSingleton.toggle_main_bus_mute()
	$MuteButton/onOff.visible=!$MuteButton/onOff.visible
