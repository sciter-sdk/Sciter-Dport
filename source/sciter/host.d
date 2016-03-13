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

module sciter.host;

import sciter.interop.sciter_x_types;
import sciter.api;
import sciter.behavior;
import sciter.sciter_value;


class SciterArchive
{
	unittest
	{
		ubyte[] resources = [// contains a single file 'test.txt' with its content == 'I see dead people'
			0x53,0x41,0x72,0x00,0x09,0x00,0x00,0x00,0x74,0x00,0xff,0xff,0x01,0x00,0xff,0xff,0x65,0x00,0xff,0xff,0x02,0x00,0xff,0xff,0x73,0x00,0xff,0xff,0x03,0x00,0xff,0xff,0x74,0x00,0xff,0xff,0x04,0x00,0xff,0xff,0x2e,
			0x00,0xff,0xff,0x05,0x00,0xff,0xff,0x74,0x00,0xff,0xff,0x06,0x00,0xff,0xff,0x78,0x00,0xff,0xff,0x07,0x00,0xff,0xff,0x74,0x00,0xff,0xff,0x08,0x00,0xff,0xff,0x00,0x00,0xff,0xff,0x01,0x00,0xff,0xff,0x01,0x00,
			0x00,0x00,0x60,0x00,0x00,0x00,0x11,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x49,0x20,0x73,0x65,0x65,0x20,0x64,0x65,0x61,0x64,0x20,0x70,0x65,0x6f,0x70,0x6c,0x65, ];

		SciterArchive arch = new SciterArchive;
		arch.open(resources);

		auto file_buff = arch.get("test.txt");
		string file_str = cast(string)(file_buff);
		assert(file_str=="I see dead people");
	}

private:
	 HSARCHIVE har;

public:
	// open archive blob:
	void open(const(ubyte)[] data)
	{
		close();
		har = SAPI().SciterOpenArchive(data.ptr, cast(uint/*x64 issue*/) data.length);
		assert(har);
	}
	
	void close()
	{
		if(har)
			SAPI().SciterCloseArchive(har);
		har = 0;
	}
	
	// get archive item:
	const(ubyte)[] get(wstring path)
	{
		assert(har);
		LPCBYTE pb;
		uint blen;

		path ~= '\0';
		bool found = !!SAPI().SciterGetArchiveItem(har, path.ptr, &pb, &blen);
		//debug assert(found);

		if(found==false)
			return null;
		return pb[0..blen];
	}
}

abstract class SciterWindowHost
{
	void setup_callback(HWINDOW hwnd)
	{
		assert(hwnd);
		assert(m_hwnd==HWINDOW.init, "You already called setup_callback()");
		m_hwnd = hwnd;
		.SciterSetCallback(hwnd, &callback, cast(void*)this);
	}
	
	void attach_evh(EventHandler evh)
	{
		assert(m_hwnd, "Call setup_callback() first");
		.SciterWindowAttachEventHandler(m_hwnd, &EventHandler.element_proc, cast(void*) evh, EVENT_GROUPS.HANDLE_ALL) == SCDOM_OK || assert(false);
	}
	
	json_value call_function(string name, VALUE[] params...)
	{
		assert(m_hwnd, "Call setup_callback() first");

		VALUE ret;
		.SciterCall(m_hwnd, (name ~ '\0').ptr, cast(uint/*x64 issue*/) params.length, params.ptr, &ret) || assert(false);
		return json_value(ret);
	}
	
	json_value eval_script(wstring script)
	{
		assert(m_hwnd, "Call setup_callback() first");

		VALUE ret;
		.SciterEval(m_hwnd, script.ptr, cast(uint/*x64 issue*/) script.length, &ret) || assert(false);
		return json_value(ret);
	}
	
public:
	// overridable
	uint on_load_data(LPSCN_LOAD_DATA pnmld) { return 0; }
	uint on_data_loaded(LPSCN_DATA_LOADED pnmld) { return 0; }
	uint on_attach_behavior(LPSCN_ATTACH_BEHAVIOR lpab) { return 0; }
	uint on_engine_destroyed() { return 0; }
	uint on_posted_notification(LPSCN_POSTED_NOTIFICATION lpab) { return 0; }

protected:
	HWINDOW m_hwnd;

	static extern(Windows) uint callback(LPSCITER_CALLBACK_NOTIFICATION pnm, void* param)
	{
		assert(param);
		SciterWindowHost self = cast(SciterWindowHost)(param);
		return self.handle_notification(pnm);
	}

	uint handle_notification(LPSCITER_CALLBACK_NOTIFICATION pnm)
	{
		switch(pnm.code)
		{
			case SC_LOAD_DATA:				return this.on_load_data(cast(LPSCN_LOAD_DATA) pnm);
			case SC_DATA_LOADED:			return this.on_data_loaded(cast(LPSCN_DATA_LOADED)pnm);
			case SC_ATTACH_BEHAVIOR:		return this.on_attach_behavior(cast(LPSCN_ATTACH_BEHAVIOR)pnm);
			case SC_ENGINE_DESTROYED:		return this.on_engine_destroyed();
			case SC_POSTED_NOTIFICATION:	return this.on_posted_notification(cast(LPSCN_POSTED_NOTIFICATION)pnm);
			default:
		}
		return 0;
	}
}