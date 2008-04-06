#--
#	Rubygame -- Ruby code and bindings to SDL to facilitate game creation
#	Copyright (C) 2004-2008  John Croisant
#
#	This library is free software; you can redistribute it and/or
#	modify it under the terms of the GNU Lesser General Public
#	License as published by the Free Software Foundation; either
#	version 2.1 of the License, or (at your option) any later version.
#
#	This library is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#	Lesser General Public License for more details.
#
#	You should have received a copy of the GNU Lesser General Public
#	License along with this library; if not, write to the Free Software
#	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#++

module Rubygame

	# List of all Rubygame hardware event classes. *Do not modify!*
	SDL_EVENTS = [ActiveEvent, KeyDownEvent, KeyUpEvent,\
		MouseMotionEvent,MouseDownEvent,MouseUpEvent,JoyAxisEvent,\
		JoyBallEvent, JoyHatEvent,JoyDownEvent, JoyUpEvent,\
		ResizeEvent, QuitEvent]

	# The parent class for all event classes. You can make custom event classes,
  # if desired; inheriting this class is not necessary, but makes it easier
  # to check if an object is an event or not.
	class Event
	end

	# Indicates that the Rubygame window has gained or lost focus from the
	# window manager.
	# 
	# This event has these attributes:
	# gain::  true if the window gained focus, and false if it lost focus.
	# state:: symbol indicating what type of focus was gained or lost: 
	#         :mouse::    the mouse entered/exited the window
	#         :keyboard:: the window gained or lost input focus
	#         :active::   the window was minimized/iconified.
	class ActiveEvent < Event
		attr_accessor :gain, :state
		def initialize(gain,state)
			@gain = gain
			@state = state 
		end
	end

	# Indicates that a keyboard key was pressed.
	#
	# This event has these attributes:
	#
	# key::    A symbol representing the key that was pressed.
	# mods::   an Array of zero or more symbols indicating which modifier keys
	#          were active when the key was pressed.
	#
	#          :capslock::  Caps lock
	#          :compose::   Compose key
	#          :lalt::      Alt key (left side)
	#          :lctrl::     Ctrl key (left side)
	#          :lmeta::     Meta key (left side)
	#          :lshift::    Shift key (left side)
	#          :lsuper::    Super key, aka. Windows key (left side)
	#          :mode::      Mode key
	#          :numlock::   Num lock
	#          :ralt::      Alt key (right side)
	#          :rctrl::     Ctrl key (right side)
	#          :rmeta::     Meta key (right side)
	#          :rshift::    Shift key (right side)
	#          :rsuper::    Super key, aka. Windows key (right side)
	#
	# string:: a UTF8 string of the glyph generated by this keystroke (if any).
	#          This will be the null character "\000" if no glyph was created 
	#          (e.g. pressing a nonprintable key).
	#
	#          NOTE: string will always be "\000" for key releases, because no
	#          glyph is created when releasing a key.
	#
	#
	# *NOTE*: Caps Lock and Num Lock are special. Instead of emitting an event
	# when pressed or released, they emit events when activated or deactivated.
	# In other words, when the LED on your keyboard turns on, a KeyDownEvent
	# is emitted; when the light goes off, a KeyUpEvent is emitted.
	#
	# Similarly, the :capslock and :numlock modifiers indicate that those
	# features are active, not that the keys are being pressed right now.
	#
	class KeyDownEvent < Event
		attr_accessor :key, :mods, :string

		# Create a new KeyDownEvent. Generally speaking,
		#
		# key::     a symbol representing the key pressed. (Symbol, required)
		# mods::    Array of modifier key symbols. (Array of Symbols, optional)
		# string::  a UTF8 byte string. (String, optional)
		#
		# Example::
		#   KeyDownEvent.new( :a,      [],       "a"    )  # lowercase A
		#   KeyDownEvent.new( :a,      [:shift], "A"    )  # uppercase A
		#   KeyDownEvent.new( :escape, [],       "\000" )  # escape
		#   KeyDownEvent.new( :up,     [:ctrl],  "\000" )  # ctrl + up-arrow
		#
		def initialize( key, mods=[], string=nil )
			@key = key
			@mods = mods
			@string = string
		end
	end

	# Indicates that a keyboard key was released.
	#
	# Please refer to KeyDownEvent for use and examples, but note that
	# #string will be nil for all KeyUpEvents generated from SDL (i.e. from
	# real keyboard releases).
	#
	# See:
	#   http://lists.libsdl.org/pipermail/sdl-libsdl.org/2005-January/048355.html
	#
	class KeyUpEvent < Event
		attr_accessor :key, :mods, :string
		def initialize( key, mods=[], string=nil )
			@key = key
			@mods = mods
			@string = string
		end
	end

	# Indicates that the mouse cursor moved.
	# 
	# This event has these attributes:
	# pos::       the new position of the cursor on the screen.
	# rel::       the relative movement of the cursor since the last update, [x,y].
	# buttons::   the mouse buttons that were being held during the movement,
	#             an Array of zero or more of these symbols:
	#             :mouse_left::       left mouse button
	#             :mouse_middle::     middle mouse button (mouse wheel pressed)
	#             :mouse_right::      right mouse button
  #             :mouse_wheel_up::   mouse wheel up (may also be a real button)
  #             :mouse_wheel_down:: mouse wheel down (may also be a real button)
	# world_pos:: like _pos_, but converted into world coordinates based on the Scene's camera.
	#             By default, the same as _pos_, but may be set by the Scene.
	# world_rel:: like _rel_, but converted into world coordinates based on the Scene's camera.
	#             By default, the same as _rel_, but may be set by the Scene.
	class MouseMotionEvent < Event
		attr_accessor :pos,:rel,:buttons
		attr_accessor :world_pos, :world_rel
		def initialize(pos, rel, buttons, world_pos=nil, world_rel=nil)
			@pos, @rel, @buttons = pos, rel, buttons
			@world_pos = world_pos or pos
			@world_rel = world_rel or rel
		end
	end

	# Indicates that a mouse button was pressed.
	# 
	# This event has these attributes:
	# string::    string indicating the button that was pressed ("left","middle", or
	#             "right").
	# pos::       the position of the mouse cursor when the button was pressed,
	#             in the form [x,y].
	# button::    the mouse button that was pressed, one of these symbols:
	#             :mouse_left::       left mouse button
	#             :mouse_middle::     middle mouse button (mouse wheel pressed)
	#             :mouse_right::      right mouse button
  #             :mouse_wheel_up::   mouse wheel up (may also be a real button)
  #             :mouse_wheel_down:: mouse wheel down (may also be a real butto
	# world_pos:: like _pos_, but converted into world coordinates based on the Scene's camera.
	#             By default, the same as _pos_, but may be set by the Scene.
	class MouseDownEvent < Event
		attr_accessor :string,:pos,:button
		attr_accessor :world_pos
		def initialize(pos, button, world_pos=nil)
			@pos = pos
			@button = button
			@world_pos = world_pos or pos
		end
	end

	# Indicates that a mouse button was released.
	# 
	# See MouseDownEvent.
	class MouseUpEvent < Event
		attr_accessor :string,:pos,:button
		attr_accessor :world_pos
		
		def initialize(pos, button, world_pos=nil)
			@pos = pos
			@button = button
			@world_pos = world_pos or pos
		end
	end

	# Indicates that a Joystick axis was moved.
	# 
	# This event has these attributes:
	# joynum:: the identifier number of the affected Joystick.
	# axis::   the identifier number of the axis.
	# value::  the new value of the axis, between -32768 and 32767
	class JoyAxisEvent < Event
		attr_accessor :joynum,:axis,:value
		def initialize(joy,axis,value)
			# eventually, joy could be int OR a Rubygame::Joystick instance,
			# which would be stored as joy or maybe joyinstance?
			@joynum = joy
			@axis, @value = axis, value
		end
	end

	# Indicates that a Joystick trackball was moved.
	# 
	# This event has these attributes:
	# joynum:: the identifier number of the affected Joystick.
	# ball::   the identifier number of the trackball.
	# rel::    the relative movement of the trackball, [x,y].
	class JoyBallEvent < Event
		attr_accessor :joynum,:ball,:rel
		def initialize(joy,ball,rel)
			# eventually, joy could be int OR a Rubygame::Joystick instance,
			# which would be stored as joy or maybe joyinstance?
			@joynum = joy
			@ball, @rel = ball, rel
		end
	end

	# Indicates that a Joystick POV hat was moved.
	# 
	# This event has these attributes:
	# joynum:: the identifier number of the affected Joystick.
	# hat::    the identifier number of the hat.
	# value::  the new direction of the hat, one of these constants in module
	#          Rubygame (or the corresponding number):
	#          HAT_CENTERED::   0
	#          HAT_UP::         1 
	#          HAT_RIGHT::      2
	#          HAT_DOWN::       4 	
	#          HAT_LEFT::       8
	#          HAT_RIGHTUP::    3
	#          HAT_RIGHTDOWN::  6
	#          HAT_LEFTUP::     9
	#          HAT_LEFTDOWN::   12
	class JoyHatEvent < Event
		attr_accessor :joynum,:hat,:value
		def initialize(joy,hat,value)
			# eventually, joy could be int OR a Rubygame::Joystick instance,
			# which would be stored as joy or maybe joyinstance?
			@joynum = joy
			@hat, @value = hat, value
		end
	end

	# Indicates that a Joystick button was pressed.
	# 
	# This event has these attributes:
	# joynum:: the identifier number of the affected Joystick.
	# hat::    the identifier number of the button.
	class JoyDownEvent < Event
		attr_accessor :joynum, :button
		def initialize(joy,button)
			# eventually, joy could be int OR a Rubygame::Joystick instance,
			# which would be stored as joy or maybe joyinstance?
			@joynum = joy
			@button = button
		end
	end

	# Indicates that a Joystick button was released.
	# 
	# See JoyDownEvent.
	class JoyUpEvent < Event
		attr_accessor :joynum, :button
		def initialize(joy,button)
			# eventually, joy could be int OR a Rubygame::Joystick instance,
			# which would be stored as joy or maybe joyinstance?
			@joynum = joy
			@button = button
		end
	end

	# Indicates that the application window was resized. (After this event
	# occurs, you should use Screen#set_mode to change the display surface to
	# the new size.)
	# 
	# This event has these attributes:
	# size:: the new size of the window, in pixels [w,h].
	class ResizeEvent < Event
		attr_accessor :size
		def initialize(new_size)
			@size = new_size
		end
	end

	# Indicates that part of the application window was exposed or otherwise
	# changed, and perhaps the window needs to be refreshed. This event occurs,
	# for example, when an OpenGL display should be updated.
	class ExposeEvent < Event
	end
	
	# Indicates that the application has been signaled to quit. (E.g. the user
	# pressed the close button.)
	class QuitEvent < Event
	end
	
	class CollisionEvent < Struct.new(:a,:b,:contacts)
	end
	
	class CollisionStartEvent < Struct.new(:a,:b,:contacts)
	end
	
	class CollisionEndEvent < Struct.new(:a,:b,:contacts)
	end
		
	class DrawEvent < Struct.new(:camera)
	end
	
	class UndrawEvent < Struct.new(:camera)
	end
	
	class TickEvent
		attr_accessor :seconds, :created_at
		def initialize( seconds )
			@seconds = seconds
			@created_at = Time.now
		end
		
		def milliseconds
			@seconds * 1000.0
		end
		
		def milliseconds=( milliseconds )
			@seconds = milliseconds / 1000.0
		end
	end
	
	class PreStepEvent < Struct.new(:dt)
	end
	
end # module Rubygame
