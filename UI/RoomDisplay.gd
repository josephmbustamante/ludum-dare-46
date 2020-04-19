extends VBoxContainer


onready var wifi_progress = $WifiDisplay/WifiBar
onready var stress_progress = $StressDisplay/StressBar


func handle_wifi_level_changed(new_wifi_level):
	wifi_progress.value = new_wifi_level


func handle_stress_level_changed(new_stress_level):
	stress_progress.value = new_stress_level
