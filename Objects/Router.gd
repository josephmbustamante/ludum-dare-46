extends StaticBody2D

enum ObjectTypes {
	ROUTER
}

export (ObjectTypes) var object_type = ObjectTypes.ROUTER


func interact():
	print("interacted with the router!")
