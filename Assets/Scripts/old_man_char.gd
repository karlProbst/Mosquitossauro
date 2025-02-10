extends CharacterBody2D

@onready var MaoTarget: Node2D= $RHand

@export var max_speed: Vector2 = Vector2(500, 120)  # Max speed (X: horizontal, Y: vertical)
@export var acceleration: float = 220.0           # Rate of acceleration
@export var friction: float = 815.0               # Rate of deceleration
@export var jump_force: float = 420.0              # Jumping force
@export var gravity: float = 1000.0      
@export var hitMarker:Node2D           
var time = 0
var feet_r_pos=Vector2.ZERO
var feet_l_pos=Vector2.ZERO
var floorbuffer = 0.0
var input_direction: Vector2 = Vector2.ZERO
var crouch=0
var kickoff=0
var chutando:float=0.0
var currentItem:String="raquete"
var initialtimesplit=1.5
var weightRot=0
@onready var genericItemScene:PackedScene=preload("res://Scenes/generic_item.tscn")
var topada=0
var originalhiprot=$Skeleton2D/Hip.rotation_degrees
var spawner = Spawner.new()
var locklmouse=false
var blood = preload("res://Scenes/Blood.tscn")
var hitted: float = 0.0
var hittedPos:Vector2 = Vector2.ZERO
func _ready() -> void:
	GlobalSingleton.player=self
	updateItemOnHand(currentItem)
	originalhiprot=$Skeleton2D/Hip.rotation_degrees
	$Skeleton2D/Hip.rotation_degrees=-135
	Engine.time_scale=0.2
	velocity.y=-400
	velocity.x=150
func _process(delta: float) -> void:
	if initialtimesplit>0:
		$Skeleton2D/Hip.rotation_degrees=lerp($Skeleton2D/Hip.rotation_degrees,originalhiprot,delta*3.5)
		initialtimesplit-=delta
		if initialtimesplit<1:
			$Skeleton2D/Hip.rotation_degrees=originalhiprot
			Engine.time_scale=1
			initialtimesplit=0
	$CShapeL.global_position=$Skeleton2D/Hip/LegL/LegEndL/ShoeL.global_position
	$CShapeR.global_position=$Skeleton2D/Hip/LegR/LegEndR/ShoeR.global_position
	# Update MaoTarget position to follow the mouse
	if hitted<=0:
		MaoTarget.global_position = get_global_mouse_position()
		$LHand.global_position.x = lerpf($LHand.global_position.x,get_global_mouse_position().x+0,delta*6)
		$LHand.global_position.y = lerpf($LHand.global_position.y,get_global_mouse_position().y+50,delta*6)
	else:
		hitted-=delta
	# Reset input direction each frame
	input_direction.x = 0

	# Horizontal movement input
	if kickoff>0:
		kickoff-=1
	if kickoff<0:
		kickoff+=1
		

		

	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		input_direction.x += 1
		
	if Input.is_action_just_pressed("ui_left"):
		kickoff=-2
	elif Input.is_action_just_pressed("ui_right"):
		kickoff=2
	
	# Normalize input direction to prevent faster diagonal movement
	if input_direction.x != 0 and chutando==0:
		
		# Apply acceleration
		if crouch==0 and velocity.y>=0:
			if floorbuffer>0:
				velocity.x += input_direction.x * acceleration * delta
				if input_direction.x>0 and velocity.x<-10:
					velocity.x =20
				if input_direction.x<0 and velocity.x>10:
					velocity.x = -20
		if kickoff!=0 and crouch==0 and abs(velocity.x)<180:
			if floorbuffer>0:
				velocity.x += input_direction.x * acceleration * delta*20	
			elif abs(velocity.x)<50:
				velocity.x += input_direction.x * acceleration * delta*20*abs(kickoff)
	else:
		if crouch>0:
			velocity.x = move_toward(velocity.x, 0, friction/4 * delta)
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta/4)
	# Clamp horizontal velocity to max_speed.x
	velocity.x = clamp(velocity.x, -max_speed.x, max_speed.x)
	# Jumping
	if floorbuffer>0 and Input.is_action_just_pressed("ui_accept"):
		if crouch>0:
			$Targets/FeetR.position.x = -30.0
			$Targets/FeetR.position.y = 100.0
			$Targets/FeetL.position.x =  7.0
			$Targets/FeetL.position.y =100.0
		velocity.y = -jump_force-clampf(velocity.x,0,50)  # Apply upward force when jumping
		$Targets/FeetR.position= Vector2(-30,-50)
		$Targets/FeetL.position = Vector2(50,-50)
		floorbuffer=0

	if not is_on_floor():
		velocity.y += gravity * delta 
		
	
	move_and_slide()
	
	if position.y>5000:
		get_tree().reload_current_scene()
	
	

	# Calculate positions of the feet

	
	if is_on_floor():
		floorbuffer=0.3
	elif floorbuffer>0:
		floorbuffer-=delta
	if floorbuffer>0 and Input.is_action_pressed("ui_down"):
		if crouch<0.2:
			crouch=0.6
		if crouch<0.8:
			crouch+=delta*6
		if crouch<1:
			crouch+=delta*6
	else:
		if crouch>0:
			crouch-=delta*7
		else:
			crouch=0

	
	var animation_speed: float = velocity.x/15
	var feet_distance: float = 30.0
	time += delta * animation_speed
	var d20=delta*3
	
	if Input.is_action_pressed("chutar") and crouch==0 and chutando==0:
		chutando=1.4
	if topada>0:
		topada-=delta
		$Targets/FeetL.position.x = lerp($Targets/FeetL.position.x,0.0,delta)
		$Skeleton2D/Hip.rotation_degrees=13.8+(topada*5)
		velocity.x=-20
	if chutando>0:
		chutando-=delta*5
	else:
		$AreaChute.set_collision_layer_value(4,0)
		chutando=0
	if chutando>1.0:
		if topada<=0:
			$AreaChute.set_collision_layer_value(4,1)
			$Targets/FeetR.position.x = -30
			$Targets/FeetR.position.y = 100
			$Targets/FeetL.position.x = 165
			$Targets/FeetL.position.y = -54
			var rayl=$Body/FeetL/RayLFoot
		
			rayl.force_raycast_update()
			if rayl.is_colliding():
				$Targets/FeetL.position.x -= 10
				chutando=7
				topada=3		
	elif chutando>0:
	
		$AreaChute.set_collision_layer_value(1,0)
		$Targets/FeetR.position.x = lerp($Targets/FeetR.position.x, -30.0, d20)
		$Targets/FeetR.position.y = lerp($Targets/FeetR.position.y, 100.0, d20)
		$Targets/FeetL.position.x = lerp($Targets/FeetL.position.x, 20.0, d20)
		$Targets/FeetL.position.y = lerp($Targets/FeetL.position.y,100.0, d20)
	if chutando==0:
		if crouch>0:
			$Targets/FeetR.position.x = lerp($Targets/FeetR.position.x, -100.0, d20)
			$Targets/FeetR.position.y = lerp($Targets/FeetR.position.y, -crouch, d20)
			$Targets/FeetL.position.x = lerp($Targets/FeetL.position.x, -30.0, d20)
			$Targets/FeetL.position.y = lerp($Targets/FeetL.position.y,-crouch, d20)
		elif floorbuffer>0 and crouch<0.5:
			if abs(velocity.x)< 10 and velocity.y==0:
				$Targets/FeetR.position.x = lerp($Targets/FeetR.position.x, -30.0, d20)
				$Targets/FeetR.position.y = lerp($Targets/FeetR.position.y, 100.0, d20)
				$Targets/FeetL.position.x = lerp($Targets/FeetL.position.x, 7.0, d20)
				$Targets/FeetL.position.y = lerp($Targets/FeetL.position.y,100.0, d20)
				if kickoff >0:
				# Add a temporary offset for snappiness
					$Targets/FeetR.position.x+=kickoff*15
					$Targets/FeetR.position.y-=kickoff*20
			elif velocity.y>-50:
				var anim_speed = clamp(abs(velocity.x) / 200, 0.1, 0.5)
			
				feet_r_pos = Vector2(cos(time), sin(time)+2) * feet_distance
				feet_l_pos = Vector2(cos(time + PI), sin(time + PI)+2) * feet_distance
		
				$Targets/FeetR.position.x = lerp($Targets/FeetR.position.x, feet_r_pos.x, anim_speed)
				$Targets/FeetR.position.y = lerp($Targets/FeetR.position.y, feet_r_pos.y, anim_speed)
				$Targets/FeetL.position.x = lerp($Targets/FeetL.position.x, feet_l_pos.x, anim_speed)
				$Targets/FeetL.position.y = lerp($Targets/FeetL.position.y, feet_l_pos.y, anim_speed)

	#HANDLE RAYCAST OF RHAND
	

				
	#HANDLE ITEMS
	
	if  currentItem=="raquete" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if weightRot<12:
			weightRot+=delta*4.5
		if weightRot>1 and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			var raquetePos = $Body/HandR/Raquete.global_position
			var mousePos = get_global_mouse_position()
			var newVector = mousePos-raquetePos
			currentItem=throwItem(currentItem,newVector*weightRot/4.2)
			locklmouse=true
			
		$Body/HandR/Raquete.rotation_degrees+=weightRot
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			currentItem=throwItem(currentItem)
	else:
		weightRot=lerpf(weightRot,0,delta*30)
		$Body/HandR/Raquete.rotation_degrees=lerpf($Body/HandR/Raquete.rotation_degrees,85,delta*5)
		
	if  currentItem=="spray":
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$Body/HandR/Sbp/Spray.emitting=true
			$Body/HandR/Sbp/Drop.emitting=true
			$Body/HandR/Sbp/Spray/VenenoArea/CollisionShape2D.disabled=false
		else:
			$Body/HandR/Sbp/Spray.emitting=false
			$Body/HandR/Sbp/Drop.emitting=false
			$Body/HandR/Sbp/Spray/VenenoArea/CollisionShape2D.disabled=true
		
	var rHandRay=$Skeleton2D/Hip/Neck/ArmR/ArmEndR/HandR/RayCast2D
	rHandRay.force_raycast_update()
	if rHandRay.is_colliding():
		var node = rHandRay.get_collider()
		if node.is_in_group("item"):
			node.highlight=1
			if !locklmouse and currentItem=="none" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				currentItem=node.item
				updateItemOnHand(currentItem)
				node.queue_free()
		
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		currentItem=throwItem(currentItem)
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		locklmouse=false
func hitTest(pos):
	hitMarker.global_position=pos
	hitMarker.scale=Vector2(2,2)

func throwItem(item,vel:Vector2=Vector2.ZERO)->String:
	
	
	match item:
		"none":
			print("No item is selected.")
		"spray":
			print("Current item is a spray.")
			var rInst = spawner.Instantiate(genericItemScene,$Skeleton2D/Hip/Neck/ArmR/ArmEndR/HandR.global_position,get_parent())
			spawner.InjectArgs(rInst,{"velocity":vel,"item":item})
			rInst.updateItem()
		"raquete":
			
			var rInst = spawner.Instantiate(genericItemScene,$Skeleton2D/Hip/Neck/ArmR/ArmEndR/HandR.global_position,get_parent())
			spawner.InjectArgs(rInst,{"velocity":vel,"item":item})
			rInst.updateItem()
		"watercup":
			print("Current item is a water cup.")
			spawner.Instantiate(genericItemScene,$Skeleton2D/Hip/Neck/ArmR/ArmEndR/HandR.global_position,get_parent())
		"awp":
			print("Current item is an AWP.")
			# Add logic for AWP
		_:
			print("Unknown item:", item)
			# Handle unknown items
	updateItemOnHand(item)
	return "none"

func updateItemOnHand(item):
	currentItem=item
	
	var handnode=$Body/HandR
	handnode.get_node("Sbp/Spray/VenenoArea/CollisionShape2D").disabled=true
	handnode.get_node("Raquete/RaqueteArea/CollisionShape2D").disabled=true
	for c in handnode.get_children():
		c.visible=false
	match item:
		"none":
			pass
		"spray":
			handnode.get_node("Sbp").visible=true
		"raquete":
			handnode.get_node("Raquete/RaqueteArea/CollisionShape2D").disabled=false
			handnode.get_node("Raquete").visible=true
		"awp":
			print("Current item is an AWP.")
			# Add logic for AWP
		_:
			print("Unknown item:", item)
			# Handle unknown items

	
func gotHit(_damage:int = 1, pos:Vector2=position):
	hitted = 0.3
	$LHand.global_position = pos
	var bloodcena = spawner.Instantiate(blood,pos,get_parent())
	spawner.InjectArgs(bloodcena,{"emitting": "true"})
	GlobalSingleton.remove_hearts(1)
