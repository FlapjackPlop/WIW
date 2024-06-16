extends Control

# Audio variables
@onready var evolve = $Audio/Evolve

# New stat variables
var new_tox = 0
var new_end = 0
var new_flm = 0

# Change variables
var tox_change = 0
var end_change = 0
var flm_change = 0

var total_change = 0

# Misc variables
var cost = 0

func _process(delta):
	if !$EvolvePanel.visible:
		reset()
	else:
		Global.heals = Global.max_heals  
	
	# Shows level
	$EvolvePanel/LevelCount.text = "Level " + str(Global.level)
	
	# Sets new stats
	new_tox = Global.toxicity + tox_change
	new_end = Global.endurance + end_change
	new_flm = Global.flame + flm_change
	
	total_change = tox_change + end_change + flm_change
	
	# Shows new stats
	if cost > Global.isotopes or cost == 0:
		$EvolvePanel/NewNums/ToxNumNew.modulate = Color(1,0,0)
		$EvolvePanel/NewNums/EndNumNew.modulate = Color(1,0,0)
		$EvolvePanel/NewNums/FlmNumNew.modulate = Color(1,0,0)
	else:
		if new_tox > Global.toxicity:
			$EvolvePanel/NewNums/ToxNumNew.modulate = Color(0,1,0)
		else:
			$EvolvePanel/NewNums/ToxNumNew.modulate = Color(1,1,1)
		if new_end > Global.endurance:
			$EvolvePanel/NewNums/EndNumNew.modulate = Color(0,1,0)
		else:
			$EvolvePanel/NewNums/EndNumNew.modulate = Color(1,1,1)
		if new_flm > Global.flame:
			$EvolvePanel/NewNums/FlmNumNew.modulate = Color(0,1,0)
		else:
			$EvolvePanel/NewNums/FlmNumNew.modulate = Color(1,1,1)
	
	$EvolvePanel/NewNums/ToxNumNew.text = str(new_tox)
	$EvolvePanel/NewNums/EndNumNew.text = str(new_end)
	$EvolvePanel/NewNums/FlmNumNew.text = str(new_flm)
	
	# Show current stats
	$EvolvePanel/CurrentNums/ToxNumCurrent.text = str(Global.toxicity)
	$EvolvePanel/CurrentNums/EndNumCurrent.text = str(Global.endurance)
	$EvolvePanel/CurrentNums/FlmNumCurrent.text = str(Global.flame)
	
	$EvolvePanel/IsotopeCount.text = str(Global.isotopes)
	
	# Calculates cost
	var x = Global.level + total_change
	
	if total_change > 0:
		cost = 0.5*(x**3)-0.05*(x**2)+15*x+0
	else:
		cost = 0
	
	# Shows cost
	if cost > Global.isotopes or cost == 0:
		$EvolvePanel/Cost.modulate = Color(1,0,0)
	else:
		$EvolvePanel/Cost.modulate = Color(0,1,0)
	
	$EvolvePanel/Cost.text = str(cost) + " Isotopes needed."

# Plus buttons
func _on_tox_plus_pressed():
	if cost <= Global.isotopes:
		tox_change += 1
func _on_end_plus_pressed():
	if cost <= Global.isotopes:
		end_change += 1
func _on_flm_plus_pressed():
	if cost <= Global.isotopes:
		flm_change += 1

# Minus buttons
func _on_tox_minus_pressed():
	if new_tox > Global.toxicity:
		tox_change -= 1
func _on_end_minus_pressed():
	if new_end > Global.endurance:
		end_change -= 1
func _on_flm_minus_pressed():
	if new_flm > Global.flame:
		flm_change -= 1

# Evolve button
func _on_evolve_button_pressed():
	if cost < Global.isotopes and cost > 0:
		Global.isotopes -= cost
		
		Global.toxicity += tox_change
		Global.endurance += end_change
		Global.flame += flm_change
		
		Global.level += total_change
		
		evolve.play()
		
		reset()

# Resets variables
func reset():
	cost = 0
	
	tox_change = 0
	end_change = 0
	flm_change = 0
