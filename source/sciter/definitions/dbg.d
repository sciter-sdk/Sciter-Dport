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
		_this.output(cast(OUTPUT_SUBSYTEM) subsystem, cast(OUTPUT_SEVERITY) severity, text[0..text_length].idup);
	}
}