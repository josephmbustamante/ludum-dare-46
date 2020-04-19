extends HBoxContainer


onready var wifi_progress = $WifiDisplay/ProgressBar


func handle_wifi_level_changed(new_wifi_level):
	print("hello!")
	wifi_progress.value = new_wifi_level
