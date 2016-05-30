// Copyright 2015 Ramon F. Mendes
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

// port of 'sciter-x-debug.h'
module sciter.dbg;

public import sciter.interop.sciter_x;
import sciter.interop.sciter_x_types;
import sciter.api;


void SciterSetupDebugOutput ( HWINDOW hwndOrNull, void* param, DEBUG_OUTPUT_PROC pfOutput) { return SAPI().SciterSetupDebugOutput(hwndOrNull,param,pfOutput); }


abstract class debug_output
{
	public this(HWINDOW hwnd = HWINDOW.init)
	{
		SciterSetupDebugOutput(hwnd, cast(void*) this, &_output_debug);
	}

	public void setup(HWINDOW hwnd = HWINDOW.init)
	{
		SciterSetupDebugOutput(hwnd, cast(void*) this, &_output_debug);
	}

	abstract void output(OUTPUT_SUBSYTEM subsystem, OUTPUT_SEVERITY severity, wstring text);

	extern(Windows) static void _output_debug(void* param, uint subsystem, uint severity, LPCWSTR text, uint text_length)
	{
		debug_output _this = cast(debug_output) param;
		_this.output(cast(OUTPUT_SUBSYTEM) subsystem, cast(OUTPUT_SEVERITY) severity, text[0..text_length].idup);
	}
}

version(Windows)
{
	class debug_output_console : debug_output
	{
		import winkit.WinAPI;

		private HANDLE m_trace_out;

		override void output(OUTPUT_SUBSYTEM subsystem, OUTPUT_SEVERITY severity, wstring text)
		{
			import std.conv;

			if(!m_trace_out)
			{
				AllocConsole();
				m_trace_out = GetStdHandle(STD_OUTPUT_HANDLE);
			}

			assert(m_trace_out);

			string msg = to!string(text); // ~ "\n";
			DWORD written;
			WriteFile(m_trace_out, msg.ptr, msg.length, &written, null);
		}
	}
}