extends StaticBody2D

enum ObjectTypes {
	COMPUTER,
	ROUTER
}

export (ObjectTypes) var object_type = ObjectTypes.COMPUTER


func interact() -> int:
	return object_type
