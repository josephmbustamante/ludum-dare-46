extends VBoxContainer


onready var wifi_progress = $WifiDisplay/WifiBar


func handle_wifi_level_changed(new_wifi_level):
	wifi_progress.value = new_wifi_level
