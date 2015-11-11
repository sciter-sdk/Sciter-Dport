// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with sciter-dport. If not, see http://www.gnu.org/licenses/.

module sciter.definitions.behavior;

import sciter.tiscript;
import sciter.sciter_x;
import sciter.sciter_x_types;
public import sciter.definitions.types;
public import sciter.sciter_x_behaviors;


abstract class EventHandler
{
	debug
	{
		static bool terminating;
		static ~this() { terminating = true; }
		~this()
		{
			assert(is_attached==false || terminating==true, "Destroying an EventHandler which is attached!");
		}
		
		private bool is_attached;
		void attached(HELEMENT) { is_attached = true; }
		void detached(HELEMENT) { is_attached = false; }
	} else {
		void attached(HELEMENT) { }
		void detached(HELEMENT) { }
	}
	
	bool subscription(HELEMENT he, ref UINT event_groups)
	{
		event_groups = EVENT_GROUPS.HANDLE_ALL;
		return true;
	}
	
	bool on_mouse  (HELEMENT he, MOUSE_PARAMS* prms ) { return false; }
	bool on_key    (HELEMENT he, KEY_PARAMS* prms ) { return false; }
	bool on_focus  (HELEMENT he, FOCUS_PARAMS* prms ) { return false; }
	bool on_draw   (HELEMENT he, DRAW_PARAMS* prms ) { return false; /*do default draw*/ }
	
	bool on_timer  (HELEMENT he ) { return false; /*stop this timer*/ }
	bool on_timer  (HELEMENT he, UINT_PTR extTimerId ) { return false; /*stop this timer*/ }
	void on_size   (HELEMENT he ) { }
	
	bool on_method_call (HELEMENT he, UINT methodID) { return false; /*not handled*/ }
	
	// calls from CSSS! script and TIScript (if it was not handled by method below). Override this if you want your own methods to the CSSS! namespace.
	// Follwing declaration:
	// #my-active-on {
	//    when-click: r = self.my-method(1,"one");
	// }
	// will end up with on_script_call(he, "my-method" , 2, argv, retval );
	// where argv[0] will be 1 and argv[1] will be "one".
	bool on_script_call(HELEMENT he, SCRIPTING_METHOD_PARAMS* prms) { return false; }
	
	// Calls from TIScript. Override this if you want your own methods accessible directly from tiscript engine.
	// Use tiscript::args to access parameters.
	bool on_script_call(HELEMENT he, TISCRIPT_METHOD_PARAMS* prms) { return false; }
	
	// notification events from builtin behaviors - synthesized events: BUTTON_CLICK, VALUE_CHANGED
	// see enum BEHAVIOR_EVENTS
	bool on_event(HELEMENT he, BEHAVIOR_EVENT_PARAMS* prms) { return false; }
	
	// notification event: data requested by HTMLayoutRequestData just delivered
	bool on_data_arrived (HELEMENT he, DATA_ARRIVED_PARAMS* prms) { return false; }
	
	bool on_scroll(HELEMENT he, SCROLL_PARAMS* prms) { return false; }
	
	bool on_gesture(HELEMENT he, GESTURE_PARAMS* prms ) { return false; }
	
	extern(Windows) static BOOL element_proc(LPVOID tag, HELEMENT he, UINT evtg, LPVOID prms)
	{
		EventHandler evh = cast(EventHandler)tag;
		
		/*debug
		{
			static i = 0;
			import std.stdio;
			stderr.writeln("element_proc ", i++);
		}*/
		
		switch( cast(EVENT_GROUPS)evtg )
		{
			case EVENT_GROUPS.SUBSCRIPTIONS_REQUEST:
				{
					UINT* p = cast(UINT*) prms;
					return evh.subscription( he, *p );
				}

			case EVENT_GROUPS.HANDLE_INITIALIZATION:
				{
					INITIALIZATION_PARAMS* p = cast(INITIALIZATION_PARAMS*)prms;
					if(p.cmd == INITIALIZATION_EVENTS.BEHAVIOR_DETACH)
						evh.detached(he);
					else if(p.cmd == INITIALIZATION_EVENTS.BEHAVIOR_ATTACH)
						evh.attached(he);
					return true;
				}

			case EVENT_GROUPS.HANDLE_MOUSE:	{ MOUSE_PARAMS* p = cast(MOUSE_PARAMS*)prms; return evh.on_mouse( he, p );  }
			case EVENT_GROUPS.HANDLE_KEY:	{ KEY_PARAMS* p = cast(KEY_PARAMS*)prms; return evh.on_key( he, p ); }
			case EVENT_GROUPS.HANDLE_FOCUS:	{ FOCUS_PARAMS* p = cast(FOCUS_PARAMS*)prms; return evh.on_focus( he, p ); }
			//case EVENT_GROUPS.HANDLE_DRAW:	{ DRAW_PARAMS* p = cast(DRAW_PARAMS*)prms; return evh.on_draw( he, p ); }
			case EVENT_GROUPS.HANDLE_TIMER:
				{
					TIMER_PARAMS* p = cast(TIMER_PARAMS*)prms;
					if(p.timerId)
						return evh.on_timer( he, p.timerId );
					return evh.on_timer( he );
				}

			case EVENT_GROUPS.HANDLE_BEHAVIOR_EVENT:	{ BEHAVIOR_EVENT_PARAMS* p = cast(BEHAVIOR_EVENT_PARAMS*)prms; return evh.on_event(he, p); }
			case EVENT_GROUPS.HANDLE_METHOD_CALL:		{ METHOD_PARAMS* p = cast(METHOD_PARAMS*)prms; return evh.on_method_call(he, p.methodID); }
			case EVENT_GROUPS.HANDLE_DATA_ARRIVED:		{ DATA_ARRIVED_PARAMS* p = cast(DATA_ARRIVED_PARAMS*)prms; return evh.on_data_arrived(he, p); }
			case EVENT_GROUPS.HANDLE_SCROLL:			{ SCROLL_PARAMS* p = cast(SCROLL_PARAMS*)prms; return evh.on_scroll(he, p); }
			case EVENT_GROUPS.HANDLE_SIZE:				{ evh.on_size(he); return false; }

			// call using json::value's (from CSSS!)
			case EVENT_GROUPS.HANDLE_SCRIPTING_METHOD_CALL:			{ SCRIPTING_METHOD_PARAMS* p = cast(SCRIPTING_METHOD_PARAMS*)prms; return evh.on_script_call(he, p); }
			// call using tiscript::value's (from the script)
			case EVENT_GROUPS.HANDLE_TISCRIPT_METHOD_CALL:			{ TISCRIPT_METHOD_PARAMS* p = cast(TISCRIPT_METHOD_PARAMS*)prms; return evh.on_script_call(he, p); }

			case EVENT_GROUPS.HANDLE_GESTURE:						{ GESTURE_PARAMS* p = cast(GESTURE_PARAMS*)prms; return evh.on_gesture(he, p); }

			default: assert(false);
		}
		//return TRUE;
	}
}