# horizontal-spinbox

https://imgur.com/a/I78NGq9

Touch/mobile/VR friendly horizontal spin box for Godot

Class:   HorizontalSpinBox

Inherits:   PanelContainer <   Container <   Control <   CanvasItem <   Node <   Object

Description

A touch/mobile/VR friendly spinbox supporting auto-repeat, usage of ints, floats, booleans, and arbitrary arrays of standard variants.


Methods

Variant set_text()

 
Signals

● value_changed(value: Variant)

Connect to signal to receive changes to VALUE. Sends VARIANTS determined by set starting value. If ITEMS is set and SEND_VALUE is true, sends the array item, else sends items index in the array.

 
Property Descriptions

● bool auto_repeat [default: true]

If set to true, VALUE keeps increasing/decreasing the longer the button is held/pressed.

 
● bool boolean [default: false]

If checked VALUE is displayed as TRUE or FALSE. ITEMS is set to FALSE=0, TRUE = 1. VALUE can be set by code either using a boolean or 0/1.

 
● Color button_colour [property: setter]

Set the default colour for the spin box.

 
● int button_font_size [default: 32] [property: setter]

Size of the button icons.

 
● Color button_pressed_colour [property: setter]

Set the colour of the button when pressed.

 
● int font_size [default: 32] [property: setter]

Font size of the TEXT and VALUE.

 
● Color hover_colour_button [property: setter]

Set the colour of the button when it's focused or hovered.

 
● Color icon_colour [property: setter]

Determines the default colour of the button icons.

 
● Color icon_hover_colour [property: setter]

The colour to set the button icons to when hovered or focused.

 
● Color icon_pressed_colour [property: setter]

The colour to set the button icons to when pressed.

 
● bool int_only [default: true]

If checked displays value as an integer. Still allows VALUE and STEP to be floats.

 
● Array items

An array of arbitrary VARIANTs to be cycled through.

 
● float maximum [default: 100.0]

Maximum value of VALUE when value type is an INT or FLOAT.

 
● float minimum [default: 0.0]

Minimum value of VALUE when value type is an INT or FLOAT.

 
● float repeat_delay [default: 0.3]

The amount of time in seconds before VALUE starts to repeatedly change when button is held.

 
● bool send_value [default: true]

When TRUE the actual VARIANT is sent in the signal, otherwise the index of the item is sent.

 
● float step [property: setter]

For ints and floats the amount to increase/decrease value by when pressing buttons.

 
● float steps_per_second [default: 5.0] [property: setter]

How many STEPs to increase VALUE by per second when REPEAT is enabled.

 
● String text [property: setter]

Text to be displayed in the spinbox

 
● Color text_colour [property: setter]

Sets the colour of the descriptive text as well as the value if no colour for the value is set.

 
● Variant value [property: setter]

Default starting value

 
● Color value_colour [property: setter]

Overrides the TEXT COLOUR for the value.

 
Method Descriptions

● Variant set_text()

Set the text for the spinbox.
