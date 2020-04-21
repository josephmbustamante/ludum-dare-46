extends PanelContainer
class_name ParticipantInfo


onready var participant_name = $MarginContainer/HBoxContainer/RightSide/ParticipantName
onready var participant_engagement = $MarginContainer/HBoxContainer/RightSide/ParticipantEngagement
onready var participant_status = $MarginContainer/HBoxContainer/LeftSide/ParticipantStatus
onready var image_containers = $MarginContainer/HBoxContainer/LeftSide/ImageContainers


func _ready() -> void:
	var images = image_containers.get_children()
	for image in images:
		image.hide()

	randomize()
	var rand = randi() % images.size()
	images[rand].show()


func update_participant_name(participant_name: String):
	self.participant_name.text = participant_name


func update_participant_engagement_level(new_engagement_level: int):
	participant_engagement.value = new_engagement_level


func update_participant_status(status: String):
	participant_status.text = status


func handle_participant_left_meeting():
	participant_name.set("custom_colors/font_color", Color.red)
