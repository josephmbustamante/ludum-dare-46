extends VBoxContainer


onready var meeting_info_label = $MeetingInfoLabel
onready var participants_display = $ParticipantsDisplay


var participant_info_scene = preload("res://UI/ParticipantInfo.tscn")


const NO_MEETING_TEXT = "There is no meeting currently running."


func _ready() -> void:
	meeting_info_label.text = NO_MEETING_TEXT


func set_meeting_display(meeting: Meeting):
	meeting_info_label.text = meeting.meeting_name

	for participant_untyped in meeting.get_meeting_participants():
		var participant: Participant = participant_untyped
		var new_info_scene: ParticipantInfo = participant_info_scene.instance()
		participants_display.add_child(new_info_scene)

		new_info_scene.update_participant_name(participant.first_name + "\n" + participant.last_name)
		# new_info_scene.participant_image = ???
		new_info_scene.participant_engagement.value = participant.engagement_level

		participant.connect("participant_engagement_level_changed", new_info_scene, "update_participant_engagement_level")
