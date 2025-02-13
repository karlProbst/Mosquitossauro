extends CanvasLayer

var la = 0
var lkilled=0
var lobjective:float=0

func _ready() -> void:
	
	updateHealth(GlobalSingleton.health)
	updateKilled(GlobalSingleton.killed)
func updateObjective(str:String):
	$ObjectiveLabel.text=str
	lobjective=0.7
func _process(delta: float) -> void:
	if la>1.2:
		la=1.2
	if la>0:
		$HeartsAndKilled.skew=la/1.2
		$HeartsAndKilled.scale.x=1+la/5
		$HeartsAndKilled.position.x=la*100
		la-=delta
	else:
		la=0
		
	if lkilled>0 and lkilled<10:
		$HeartsAndKilled/KilledLabel.position.x=55+lkilled*200
		lkilled-=delta*2
	else:
		lkilled=0
	
	if lobjective>0:
		$ObjectiveLabel.scale.x=0.5+lobjective/2
		$ObjectiveLabel.scale.y=0.5+lobjective*4
		$ObjectiveLabel.position.x=697-lobjective*697
		$ObjectiveLabel.position.y=25+lobjective*120
		$ObjectiveLabel.modulate.a=1-lobjective
		
		lobjective-=delta
	else:
		lobjective=0
func updateHealth(hearts:int):
	var txt="Health:  "
	for h in range(hearts):
		txt+="S2 "
	$HeartsAndKilled/HealthLabel.text=txt

	la+=1
func updateKilled(frag:int):
	var txt="Killed:  "
	txt+=str(frag)
	lkilled+=1
	$HeartsAndKilled/KilledLabel.text=txt
