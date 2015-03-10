// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

// port of 'sciter-x-debug.h'
module sciter.definitions.dbg;

public import sciter.sciter_x;
import sciter.sciter_x_types;
import sciter.definitions.api;


VOID SciterSetupDebugOutput ( HWINDOW hwndOrNull, LPVOID param, DEBUG_OUTPUT_PROC pfOutput) { return SAPI().SciterSetupDebugOutput ( hwndOrNull,param,pfOutput); }
BOOL SciterDebugSetupClient ( HWINDOW hwnd, LPVOID param, SCITER_DEBUG_BP_HIT_CB onBreakpointHit, SCITER_DEBUG_DATA_CB onDataRead) { return SAPI().SciterDebugSetupClient ( hwnd, param, onBreakpointHit, onDataRead); }
BOOL SciterDebugAddBreakpoint ( HWINDOW hwnd, LPCWSTR  fileUrl, UINT lineNo ) { return SAPI().SciterDebugAddBreakpoint (hwnd,fileUrl,lineNo ); }
BOOL SciterDebugRemoveBreakpoint ( HWINDOW hwnd, LPCWSTR fileUrl, UINT lineNo ) { return SAPI().SciterDebugRemoveBreakpoint ( hwnd, fileUrl, lineNo ); }
BOOL SciterDebugEnumBreakpoints ( HWINDOW hwnd, LPVOID param, SCITER_DEBUG_BREAKPOINT_CB  receiver) { return SAPI().SciterDebugEnumBreakpoints (hwnd,param,receiver); }



extern(Windows)
{
	alias SciterWindowInspectorPF = void function(HWINDOW hwnd, ISciterAPI* papi);
}

void InspectWindow(HWINDOW hwnd)
{
	version(Windows)
	{
		import core.sys.windows.windows;
		HMODULE hinsp = LoadLibraryA("inspector32.dll".ptr);
		auto pSciterInspect = cast(SciterWindowInspectorPF) GetProcAddress(hinsp, "SciterWindowInspector");
		assert(pSciterInspect);

		pSciterInspect(hwnd, SAPI());
	}
}


abstract class debug_output
{
	public this()
	{
	}

	public this(HWINDOW hwnd)
	{
		SciterSetupDebugOutput(hwnd, cast(void*) this, &_output_debug);
	}

	public void setup(HWINDOW hwnd)
	{
		SciterSetupDebugOutput(hwnd, cast(void*) this, &_output_debug);
	}

	abstract void output(OUTPUT_SUBSYTEM subsystem, OUTPUT_SEVERITY severity, wstring text);

	extern(Windows) static void _output_debug(LPVOID param, UINT subsystem, UINT severity, LPCWSTR text, UINT text_length)
	{
		debug_output _this = cast(debug_output) param;
		_this.output(cast(OUTPUT_SUBSYTEM) subsystem, cast(OUTPUT_SEVERITY) severity, cast(wstring) text[0..text_length]);
	}
}


abstract class script_debugger_client
{
	private HWINDOW hSciterHost;

	public this(HWINDOW hwnd)
	{
		hSciterHost = hwnd;
	}

	public void attach()
	{
		SciterDebugSetupClient(hSciterHost, &this, &_SCITER_DEBUG_BP_HIT_CB, &_SCITER_DEBUG_DATA_CB) || assert(false);
	}
	public void detach()
	{
		SciterDebugSetupClient(hSciterHost, &this, null, null) || assert(false);
	}

	public void dbg_addBreakpoint(const WCHAR* fileUrl, uint lineNo)
	{
		SciterDebugAddBreakpoint(hSciterHost, fileUrl, lineNo);
	}

	public void dbg_removeBreakpoint(const WCHAR* fileUrl, uint lineNo)
	{
		SciterDebugRemoveBreakpoint(hSciterHost, fileUrl, lineNo);
	}

	/*public void dbg_enumBreakpoints( std::function<void(const WCHAR* fileUrl, unsigned lineNo)> receiver )
	{
		SciterDebugEnumBreakpoints(hSciterHost, &receiver, _SCITER_DEBUG_BREAKPOINT_CB);
	}*/


	void dbg_onDetached() {}
	UINT dbg_onBreakpointHit(wstring inFile, uint onLine, VALUE environmentData) { return 0; }
	void dbg_onDataReady(uint cmd, VALUE data) {}


	extern(Windows) static UINT _SCITER_DEBUG_BP_HIT_CB(LPCWSTR inFile, UINT atLine, const VALUE* envData, LPVOID param)// breakpoint hit event receiver
	{
		int strlen(const wchar* pstr)
		{
			int c;
			while( *(pstr+c)!='\0' )
				c++;
			return c;
		}

		auto _this = cast(script_debugger_client) param;

		/*
		What should be returned by the callback? I thinks one of those: (midi)
		const SCRIPT_DEBUG_CONTINUE = 1;
		const SCRIPT_DEBUG_STEP_INTO = 2;
		const SCRIPT_DEBUG_STEP_OVER = 3;
		const SCRIPT_DEBUG_STEP_OUT = 4;
		*/
		return _this.dbg_onBreakpointHit(cast(wstring) inFile[0..strlen(inFile)], atLine, *envData);
	}

	extern(Windows) static void _SCITER_DEBUG_DATA_CB(UINT onCmd, const VALUE* data, LPVOID param)// requested data ready receiver
	{
		auto _this = cast(script_debugger_client) param;
		if(data)
        { 
			_this.dbg_onDataReady(onCmd, *data);
        }
        else
        { 
			_this.dbg_onDetached(); 
			_this.hSciterHost = null; 
        }
	}
}