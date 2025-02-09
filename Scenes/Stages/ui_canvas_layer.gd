extends CanvasLayer

var la = 0
var lkilled=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateHealth(10)
	updateKilled(0)
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
		$HeartsAndKilled/KilledLabel.position.x=lkilled*200
		lkilled-=delta*2
	else:
		lkilled=0
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
