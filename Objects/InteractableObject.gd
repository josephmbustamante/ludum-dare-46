extends StaticBody2D


export (GlobalEnums.ObjectTypes) var object_type = GlobalEnums.ObjectTypes.COMPUTER


func interact() -> int:
	return object_type
