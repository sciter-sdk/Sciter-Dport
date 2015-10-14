// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with sciter-dport. If not, see http://www.gnu.org/licenses/.

module sciter.definitions.host;

import sciter.sciter_x_types;
import sciter.definitions.api;
import sciter.definitions.behavior;
import sciter.definitions.sciter_value;


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
		har = SAPI().SciterOpenArchive(data.ptr, cast(UINT/*x64 issue*/) data.length);
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
		UINT blen;

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

		json_value ret;
		.SciterCall(m_hwnd, (name ~ '\0').ptr, cast(UINT/*x64 issue*/) params.length, params.ptr, &ret.data) || assert(false);
		return ret;
	}

	json_value eval_script(wstring script)
	{
		assert(m_hwnd, "Call setup_callback() first");

		json_value ret;
		.SciterEval(m_hwnd, script.ptr, cast(UINT/*x64 issue*/) script.length, &ret.data) || assert(false);
		return ret;
	}

public:
	// overridable
	UINT on_load_data(LPSCN_LOAD_DATA pnmld) { return 0; }
	UINT on_data_loaded(LPSCN_DATA_LOADED pnmld) { return 0; }
	UINT on_attach_behavior(LPSCN_ATTACH_BEHAVIOR lpab) { return 0; }
	UINT on_engine_destroyed() { return 0; }
	UINT on_posted_notification(LPSCN_POSTED_NOTIFICATION lpab) { return 0; }

protected:
	HWINDOW m_hwnd;

	static extern(Windows) UINT callback(LPSCITER_CALLBACK_NOTIFICATION pnm, LPVOID param)
	{
		assert(param);
		SciterWindowHost self = cast(SciterWindowHost)(param);
		return self.handle_notification(pnm);
	}

	UINT handle_notification(LPSCITER_CALLBACK_NOTIFICATION pnm)
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