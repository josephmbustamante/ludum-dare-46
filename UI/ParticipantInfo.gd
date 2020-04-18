extends PanelContainer
class_name ParticipantInfo


onready var participant_image = $HBoxContainer/ParticipantImage
onready var participant_name = $HBoxContainer/VBoxContainer/ParticipantName
onready var participant_engagement = $HBoxContainer/VBoxContainer/ParticipantEngagement


func update_participant_name(participant_name: String):
	self.participant_name.text = participant_name


func update_participant_engagement_level(new_engagement_level: int):
	participant_engagement.value = new_engagement_level
