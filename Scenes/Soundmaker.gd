extends Control
export var volume = 0.0
export var pitch = 0.0
var applied_pitch = 0.0
var selected_sample = 1
var samples = ["Samples/Drone 0","Samples/Drone 1","Samples/Drone 2","Samples/Drone 3","Samples/Drone 4","Samples/Drone 5","Samples/Drone 6","Samples/Drone 7","Samples/Drone 8","Samples/Drone 9"]
var animation = ["sine","square","saw","triangle"]
var is_static = true
var selected_volume_animation = 1
var selected_bus = 0
var bordercolor = Color()

var volume_amplitude = 0.0
var pitch_amplitude = 0.0
var volume_speed = 0.0
var pitch_speed = 0.0
var volume_base = 0.0
var pitch_base = 0.0
var actual_pitch = 0.0
var actual_volume = 0.0

export var high_pitch_color = Color()
export var Low_pitch_color = Color()
var lowest_pitch = -10
var highest_pitch = 20
var lowest_volume = -40
var highest_volume = 0
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	selected_sample = $"Container/Panel/Sample selector".selected
	is_static = $Container/Panel/Buttonmode.pressed
	$Pitch_animation.play("sine")
	$Volume_animation.play("sine")
	pass

func _process(delta):
	var sample = get_node(samples[selected_sample])
	if is_static:
		actual_volume = $Container/Panel/Volume.value
		actual_pitch = $Container/Panel/Pitch.value
		$Container/Panel/Volume.editable = true
		$Container/Panel/Pitch.editable = true
		$Pitch_animation.playback_speed = 0
		$Volume_animation.playback_speed = 0
		
		if $Container/Panel/Pitch.value>=0: 
			applied_pitch = 1*($Container/Panel/Pitch.value+1)
		else:
			applied_pitch = 1/(-$Container/Panel/Pitch.value+1)
		
		if sample.playing == true:
			var blendfactor = ($Container/Panel/Pitch.value - lowest_pitch)/(highest_pitch - lowest_pitch)
			var brightnes = (actual_volume - lowest_volume)/(highest_volume - lowest_volume)
			bordercolor.r = (Low_pitch_color.r*blendfactor + high_pitch_color.r*(1-blendfactor))*brightnes
			bordercolor.g = (Low_pitch_color.g*blendfactor + high_pitch_color.g*(1-blendfactor))*brightnes
			bordercolor.b = (Low_pitch_color.b*blendfactor + high_pitch_color.b*(1-blendfactor))*brightnes
		else:
			bordercolor.r = 0
			bordercolor.b = 0
			bordercolor.g = 0
	else:
		volume_amplitude = $Container/Panel/Volume/Amplitude.value
		volume_speed = $Container/Panel/Volume/Speed.value
		volume_base = $Container/Panel/Volume/Base.value
		
		pitch_base = $Container/Panel/Pitch/Base.value
		pitch_speed = $Container/Panel/Pitch/Speed.value
		pitch_amplitude = $Container/Panel/Pitch/Amplitude.value
		
		actual_pitch = pitch*pitch_amplitude + pitch_base
		actual_volume = volume*volume_amplitude + volume_base
		
		$Pitch_animation.playback_speed = pitch_speed
		$Volume_animation.playback_speed = volume_speed 
		$Container/Panel/Pitch.value = actual_pitch
		$Container/Panel/Volume.value = actual_volume
		$Container/Panel/Volume.editable = false
		$Container/Panel/Pitch.editable = false
		if pitch>=0: 
			applied_pitch = 1*(actual_pitch+1)
		else:
			applied_pitch = 1/(abs(actual_pitch)+1)
		
#		if sample.playing == true:
#			var blendfactor = (actual_pitch - lowest_pitch)/(highest_pitch - lowest_pitch)
#			var brightnes = (actual_volume - lowest_volume)/(highest_volume - lowest_volume)
#			bordercolor.r = (Low_pitch_color.r*blendfactor + high_pitch_color.r*(1-blendfactor))*brightnes
#			bordercolor.g = (Low_pitch_color.g*blendfactor + high_pitch_color.g*(1-blendfactor))*brightnes
#			bordercolor.b = (Low_pitch_color.b*blendfactor + high_pitch_color.b*(1-blendfactor))*brightnes
#		else:
#			bordercolor.r = 0
#			bordercolor.b = 0
#			bordercolor.g = 0
	
	
	
	if sample.playing == true:
		var blendfactor = (actual_pitch - lowest_pitch)/(highest_pitch - lowest_pitch)
		var brightnes = (actual_volume - lowest_volume)/(highest_volume - lowest_volume)
		bordercolor.r = (Low_pitch_color.r*blendfactor + high_pitch_color.r*(1-blendfactor))*brightnes
		bordercolor.g = (Low_pitch_color.g*blendfactor + high_pitch_color.g*(1-blendfactor))*brightnes
		bordercolor.b = (Low_pitch_color.b*blendfactor + high_pitch_color.b*(1-blendfactor))*brightnes
	else:
		bordercolor.r = 0
		bordercolor.b = 0
		bordercolor.g = 0
	
	$Container/Panel/Polygon2D.color = bordercolor
	
	print("---")
	print(actual_pitch)
	print(actual_volume)
	
	sample.pitch_scale = max(applied_pitch,0)
	sample.volume_db = actual_volume
	if selected_bus == 0:
		sample.bus = "Master"
	else:
		sample.bus = "New Bus " + str(selected_bus)
	#print(sample.playing)
	pass



func _on_Trigger_pressed(): 	
	var sample = get_node(samples[selected_sample])
	sample.playing = !sample.playing
	pass


func _on_Sample_selector_item_selected(ID):
	get_node(samples[selected_sample]).playing = false
	selected_sample = ID
	pass # replace with function body

func _on_Volume_value_changed(value):
	volume = value
	pass # replace with function body

func _on_Pitch_value_changed(value):
	pitch = value
	pass # replace with function body


func _on_OptionButton2_item_selected(ID):
	$Volume_animation.play(animation[ID])
	pass # replace with function body

func _on_Buttonmode_toggled(button_pressed):
	is_static = button_pressed
	pass # replace with function body

func _on_OptionButton_item_selected(ID):
	$Pitch_animation.play(animation[ID])
	pass # replace with function body


func _on_LineEdit_text_changed(new_text):
	pass # replace with function body


func _on_SpinBox_value_changed(value):
	selected_bus = value
	pass # replace with function body
