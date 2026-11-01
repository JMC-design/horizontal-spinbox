@tool
class_name HorizontalSpinBox
extends PanelContainer

## A touch/mobile/VR friendly spinbox supporting auto-repeat, usage of ints, floats, booleans, and arbitrary arrays of standard variants.

## Connect to signal to receive changes to VALUE. Sends VARIANTS determined by set starting value. If ITEMS is set and SEND_VALUE is true, sends the array item, else sends items index in the array.
signal value_changed(value:Variant)
#region ui
@onready var _MinusButton:Button = $Buttons/MinusButton
@onready var _PlusButton:Button = $Buttons/PlusButton
@onready var _LabelUI:Label = $MarginContainer/HBoxContainer/Label
@onready var _ValueUI:Label = $MarginContainer/HBoxContainer/Value
#endregion

#region exported settings
## Text to be displayed in the spinbox
@export var text:String:
	set(str):
		text = str if str is String else str(str)
		set_text()

## Default starting value
@export var value:Variant:
	set(val):
		value = val
		_update_ui()
## For ints and floats the amount to increase/decrease value by when pressing buttons.
@export var step:float:
	set(value):
		step = value
		_step_delta = step * steps_per_second
## If checked displays value as an integer. Still allows VALUE and STEP to be floats.
@export var int_only:bool = true
## If checked VALUE is displayed as TRUE or FALSE. ITEMS is set to FALSE=0, TRUE = 1.
## VALUE can be set by code either using a boolean or 0/1.
@export var boolean:bool = false

#var index:int # why do we need this value is the index
## Minimum value of VALUE when value type is an INT or FLOAT.
@export var minimum:float = 0
## Maximum value of VALUE when value type is an INT or FLOAT.
@export var maximum:float = 100

## Auto increase/decrease when buttons are held.
@export_group("Repeat")
## If set to true, VALUE keeps increasing/decreasing the longer the button is held/pressed.
@export var auto_repeat:bool = true
## The amount of time in seconds before VALUE starts to repeatedly change when button is held.
@export var repeat_delay:float = 0.3
##  How many STEPs to increase VALUE by per second when REPEAT is enabled.
@export var steps_per_second:float =5.0:
	set(value):
		steps_per_second = value
		_step_delta = step * steps_per_second

@export_group("Items")
## An array of arbitrary VARIANTs to be cycled through.
@export var items:Array
## When TRUE the actual VARIANT is sent in the signal, otherwise the index of the item is sent.
@export var send_value:bool = true
#endregion

#region Basic Theming
@export_category("Basic Theming")
## Sets the colour of the descriptive text as well as the value if no colour for the value is set.
@export var text_colour:Color:
	set(value):
		text_colour = value
		theme.set_theme_item(Theme.DATA_TYPE_COLOR,"font_color","Label",value)
## Overrides the TEXT COLOUR for the value.
@export var value_colour:Color: #FIXME?: Consider different colours for different variant types?
	set(value):
		value_colour = value
		if !_ValueUI:
			return
		_ValueUI.add_theme_color_override("font_color",value)
		#theme.set_theme_item(Theme.DATA_TYPE_COLOR,"font_color","Label",value)
## Size of the button icons.
@export var button_font_size:int = 32:  #make this actual icons?
	set(value):
		button_font_size = value
		theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE,"font_size","Button",value)	
## Font size of the TEXT and VALUE.
@export var font_size:int = 32:
	set(value):
		font_size = value
		theme.set_theme_item(Theme.DATA_TYPE_FONT_SIZE,"font_size","Label",value)

@export_group("Buttons")

var _button_stylebox:StyleBox #= theme.get_stylebox("normal","Button")
var _button_hover_stylebox:StyleBox
var _button_pressed_stylebox:StyleBox
## Set the default colour for the spin box.
@export var button_colour:Color:
	set(value):
		button_colour = value
		if !_button_stylebox:
			_button_stylebox = theme.get_stylebox("normal","Button") 
		_button_stylebox.bg_color = value
## Set the colour of the button when pressed.
@export var button_pressed_colour:Color:
	set(value):
		button_pressed_colour = value
		if !_button_pressed_stylebox:
			_button_pressed_stylebox = theme.get_stylebox("pressed","Button") 
		_button_pressed_stylebox.bg_color = value
## Set the colour of the button when it's focused or hovered.
@export var hover_colour_button:Color:
	set(value):
		hover_colour_button = value
		if !_button_hover_stylebox:
			_button_hover_stylebox = theme.get_stylebox("hover","Button") 
		_button_pressed_stylebox.bg_color = value
@export_group("Icons")
## Determines the default colour of the button icons.
@export var icon_colour:Color:
	set(value):
		icon_colour = value
		theme.set_theme_item(Theme.DATA_TYPE_COLOR,"font_color","Button",value)
## The colour to set the button icons to when pressed.
@export var icon_pressed_colour:Color:
	set(value):
		icon_pressed_colour = value
		theme.set_theme_item(Theme.DATA_TYPE_COLOR,"font_pressed_color","Button",value)
## The colour to set the button icons to when hovered or focused.
@export var icon_hover_colour:Color:
	set(value):
		icon_hover_colour = value
		theme.set_theme_item(Theme.DATA_TYPE_COLOR,"font_hover_color","Button",value)

#endregion
## Set the text for the spinbox.
func set_text():
	if _LabelUI:
		_LabelUI.text = text
	if _ValueUI:
		_update_ui()

func _ready():
	if boolean:
		items = [false,true]
		value = false
		step = 1
		steps_per_second = 1
	set_text()
	value_colour = value_colour

func _update_ui():
	if is_inside_tree():
		if items.is_empty() and (value != null):
			_ValueUI.text = str(int(value)) if int_only  else "%0.2f" % value #TODO?:significant values should depend on UI control
		elif boolean:
			_ValueUI.text = str(value)
		elif (value != null) and (items.size() > value): #FFS, 0 is false!!! #FIXME: Why is this going wrong on OPERATION OF A Distributor?
			var val = items[int(value)]
			_ValueUI.text = str(val)

var _step_delta:float
var _repeat_counter:float = 0.0
var _repeat_accumulator:float = 0.0
var _minus_pressed:bool = false
var _plus_pressed:bool = false

func _process(delta: float) -> void:
	if items.is_empty():
		if _repeat_counter >= repeat_delay:	
			if auto_repeat:
				_repeat_accumulator += _step_delta * delta
				if _repeat_accumulator >= step:
					_repeat_accumulator -= step
					if _minus_pressed and (value > minimum):
						value -= step
						_emit_signals()
					elif _plus_pressed and (value < maximum):
						value += step
						_emit_signals()
		else:
			_repeat_counter += delta

#region signal handling
func _emit_signals():
	if items.is_empty():
		value_changed.emit(value)
	else:
		var val = items[int(value)]
		if send_value:
			value_changed.emit(val)
		else:
			value_changed.emit(value)

func _on_minus_button_pressed() -> void:
	if items.is_empty():
		value = max(minimum,value - step)
		_repeat_counter = 0.0
	elif boolean:
		value = false
	else:
		value = max(0,int(value)-1)#TODO?: Maybe change this up for other variants
	_emit_signals()

func _on_plus_button_pressed() -> void:
	if items.is_empty() and (value != null):
		value = min(maximum,value + step)#TODO?: Deal with possible under minimums here? or assume they should never happen?
	elif boolean: 
		value = true
	else:
		value = min(int(value) + 1,items.size()-1)
	_emit_signals()

func _on_minus_button_down() -> void:
	_minus_pressed = true
	_repeat_counter = 0.0
func _on_minus_button_up() -> void:
	_minus_pressed = false
func _on_plus_button_down() -> void:
	_plus_pressed = true
	_repeat_counter = 0.0
func _on_plus_button_up() -> void:
	_plus_pressed = false

func _on_minus_button_mouse_entered() -> void:
	_MinusButton.grab_focus()
func _on_plus_button_mouse_entered() -> void:
	_PlusButton.grab_focus()
func _on_minus_button_mouse_exited() -> void:
	_MinusButton.release_focus()
func _on_plus_button_mouse_exited() -> void:
	_PlusButton.release_focus()

#endregion
  
