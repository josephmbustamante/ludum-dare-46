extends StaticBody2D

enum ObjectTypes {
	COMPUTER
}

export (ObjectTypes) var object_type = ObjectTypes.COMPUTER


func interact():
	print("interacted with the computer!")
