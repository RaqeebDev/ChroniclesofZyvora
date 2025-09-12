extends WorldEnvironment

func _ready():
	var env = self.environment
	if not env:
		print("No environment resource found.")
		return

	var sky = env.sky
	if not sky:
		print("No sky resource found.")
		return

	print("Sky class: ", sky.get_class())
	for p in sky.get_property_list():
		print(" - ", p.name)
