extends Node
class_name Spawner


func Instantiate(scene: PackedScene, pos: Vector2, fatherNode: Node2D) -> Node:
	var instance = scene.instantiate()
	instance.global_position = pos
	fatherNode.add_child(instance)

	#Return instanced node 
	return instance
# Apply args
func InjectArgs(node:Node2D,args:Dictionary ={}):
	for key in args.keys():
		if key in node:
			node.set(key, args[key])
		elif key in node.get_child(0):
			node.get_child(0).set(key, args[key])
		else:
			push_error(node," , has no arg: ",key)
#Inject Callable methods		
func InjectCallable(node:Node,callback: Callable, args: Array = []):
	if callback.is_valid():
		node.callback.callv(args)
	

func DeleteOnTimer(node: Node, lifetime: float):
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(node.queue_free)
	node.add_child(timer)
	timer.start()
	
func DeleteOnFinished(node:Node):
	if node.has_method("finished"):
		node.connect("finished", queue_free)
	
#EXAMPLE USAGE
#    instantiates the spawner class
#    var spawner = Spawner.new()
	# Spawn a fire particle scene
	
#	var fire_particle_scene = preload("res://path_to_fire_particle_scene.tscn")
#   fathernode is optional
#	var newFire = spawner.Instantiate(fire_particle_scene, Vector2(100, 100)
#    
#   inject 2 arguments
#    spawner.InjectArgs( newFire,{
#	    "visible": false,
#	    "scale": Vector2(2, 2)	
#      })
	# Inject a callable
# 
#	spawner.InjectCallable(Callable(self, "custom_function"), ["World"])

	# Delete a node after 5 seconds
	
#	var node_to_delete = spawner.InstantiateWithArgs(some_scene, Vector2(200, 200), self)
#	spawner.DeleteOnTimer(node_to_delete, 5.0)
