extends VBoxContainer


onready var meeting_info_label = $MeetingInfoLabel
onready var meeting_duration_label = $MeetingDurationLabel
onready var participants_display = $ParticipantsDisplay


var participant_info_scene = preload("res://UI/ParticipantInfo.tscn")


const NO_MEETING_TEXT = "There is no meeting currently running."


func _ready() -> void:
	set_time_until_next_meeting_text(10)


func set_time_until_next_meeting_text(time_until_next_meeting: int):
	meeting_info_label.text = NO_MEETING_TEXT
	meeting_duration_label.text = " Next meeting begins in %d..." % time_until_next_meeting


func set_time_remaining_in_meeting_text(time_remaining_in_meeting: int):
	meeting_duration_label.text = "%d seconds remaining..." % time_remaining_in_meeting


func set_meeting_display(meeting: Meeting):
	meeting_info_label.text = meeting.meeting_name
	set_time_remaining_in_meeting_text(meeting.meeting_duration)

	meeting.connect("meeting_duration_changed", self, "set_time_remaining_in_meeting_text")
	meeting.connect("meeting_finished", self, "clear_meeting_display")

	for participant_untyped in meeting.get_meeting_participants():
		var participant: Participant = participant_untyped
		var new_info_scene: ParticipantInfo = participant_info_scene.instance()
		participants_display.add_child(new_info_scene)

		new_info_scene.update_participant_name(participant.first_name + "\n" + participant.last_name)
		# new_info_scene.participant_image = ???
		new_info_scene.participant_engagement.value = participant.engagement_level
		new_info_scene.update_participant_status(participant.status)

		participant.connect("participant_engagement_level_changed", new_info_scene, "update_participant_engagement_level")
		participant.connect("participant_status_changed", new_info_scene, "update_participant_status")

func clear_meeting_display():
	for info_scene in participants_display.get_children():
		info_scene.queue_free()
