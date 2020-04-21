extends VBoxContainer


onready var wifi_progress = $HBoxContainer/VBoxContainer/WifiBar
onready var stress_progress = $HBoxContainer/VBoxContainer/StressBar


func handle_wifi_level_changed(new_wifi_level):
	wifi_progress.value = new_wifi_level


func handle_stress_level_changed(new_stress_level):
	stress_progress.value = new_stress_level
