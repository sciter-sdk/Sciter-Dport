// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

module sciter.definitions.sciter_dom;

import std.array;
import std.conv;

import sciter.tiscript;
import sciter.sciter_x_types;
import sciter.sciter_x_behaviors;
import sciter.definitions.api;


unittest
{
	import sciter.definitions.unittests;

	string html = r"
		<html>
		<div #inner .area .top>
			<span #child .bottom />
		</div>
		</html>";

	UnittestWindow((HWINDOW h)
	{
		element el_root = element.root_element(h);
		assert(el_root);

		auto span = el_root[0][0].get_tagname;
		auto div = el_root[0].get_tagname;

		assert(span=="span#child.bottom");
		assert(div=="div#inner.area.top");
	}, html);
}


struct node
{
private:
	HNODE hn;

	void use(HNODE h) { hn = .SciterNodeAddRef(h)==SCDOM_OK ? h : HNODE.init; }
	void unuse() { if(hn) .SciterNodeRelease(hn); hn = HNODE.init; }
	void set(HNODE h) { unuse(); use(h); }

public:
	this(HNODE h) { use(h); }
	this(HELEMENT h)
	{
		.SciterNodeCastFromElement(h,&hn); // always succeedes
		use(hn);
	}
	this(this) { use(hn); }
	~this() { unuse(); }
    bool is_valid() const { return hn != 0; }

	// Note: Although convenient, assigning different types to each other may cause confusions and errors.
	void opAssign(HNODE h)
	{
		unuse();
		use(h);
	}
	void opAssign(HELEMENT h)
	{
		.SciterNodeCastFromElement(h,&hn);
		set(hn);
	}

	node opIndex(uint idx)
	{
		HNODE hrn;
		.SciterNodeNthChild(hn,idx,&hrn) == SCDOM_OK || assert(false);
		return node(hrn);
	}

public:
	HELEMENT to_element() const
	{
		HELEMENT he;
		.SciterNodeCastToElement(hn, &he);// == SCDOM_OK || assert(false);
		return he;
	}

	bool is_text() const
	{
		NODE_TYPE nodeType;
		.SciterNodeType(hn, &cast(UINT)nodeType) == SCDOM_OK || assert(false);
		return nodeType == NODE_TYPE.NT_TEXT;
	}
	bool is_comment() const
	{
		NODE_TYPE nodeType;
		.SciterNodeType(hn, &cast(UINT)nodeType) == SCDOM_OK || assert(false);
		return nodeType == NODE_TYPE.NT_COMMENT;
	}
	bool is_element() const
	{
		NODE_TYPE nodeType;
		.SciterNodeType(hn, &cast(UINT)nodeType) == SCDOM_OK || assert(false);
		return nodeType == NODE_TYPE.NT_ELEMENT;
	}

	void remove()
	{
		.SciterNodeRemove(hn,TRUE) == SCDOM_OK || assert(false);
		.SciterNodeRelease(hn);
		hn = HNODE.init;
	}
	void detach()
	{
		.SciterNodeRemove(hn,FALSE) == SCDOM_OK || assert(false);
	}

	UINT children_count() const
	{
		UINT n;
		.SciterNodeChildrenCount(hn,&n) == SCDOM_OK || assert(false);
		return n;
	}
	HELEMENT parent() 
	{
		HELEMENT heParent;
		.SciterNodeParent(hn, &heParent) == SCDOM_OK || assert(false);
		return heParent;
	}

	HNODE next_sibling()
	{
		HNODE hrn;
		.SciterNodeNextSibling(hn,&hrn) == SCDOM_OK || assert(false);
		return hrn;
	}
	HNODE prev_sibling()
	{
		HNODE hrn;
		.SciterNodePrevSibling(hn,&hrn) == SCDOM_OK || assert(false);
		return hrn;
	}
	HNODE first_child()
	{
		HNODE hrn;
		.SciterNodeFirstChild(hn,&hrn) == SCDOM_OK || assert(false);
		return hrn;
	}
	HNODE last_child()
	{
		HNODE hrn;
		.SciterNodeLastChild(hn,&hrn) == SCDOM_OK || assert(false);
		return hrn;
	}

	wstring text()
	{
		static wstring str_rcv;
		LPCWSTR_RECEIVER rcv = function(LPCWSTR str, UINT str_length, LPVOID param)
		{
			str_rcv = str[0..str_length].idup;
		};

		auto res = .SciterNodeGetText(hn, rcv, null);
		res == SCDOM_OK || res == SCDOM_OK_NOT_HANDLED || assert(false);
		return str_rcv;
	}
	void text(wstring text)
	{
		.SciterNodeSetText(hn, text.ptr, cast(uint) text.length) == SCDOM_OK || assert(false);
	}

	static HNODE make_text_node(wstring text)
	{
		HNODE hrn;
		.SciterCreateTextNode(text.ptr, cast(uint) text.length, &hrn) == SCDOM_OK || assert(false);
		return hrn;
	}
	static HNODE make_comment_node(wstring text)
	{
		HNODE hrn;
		.SciterCreateCommentNode(text.ptr, cast(uint) text.length, &hrn) == SCDOM_OK || assert(false);
		return hrn;
	}

	void append(HNODE thatnode)
	{
		.SciterNodeInsert(hn,NODE_INS_TARGET.NIT_APPEND,thatnode) == SCDOM_OK || assert(false);
	}
	void prepend(HNODE thatnode)
	{
		.SciterNodeInsert(hn,NODE_INS_TARGET.NIT_PREPEND,thatnode) == SCDOM_OK || assert(false);
	}
	void insert_before(HNODE thatnode)
	{
		.SciterNodeInsert(hn,NODE_INS_TARGET.NIT_BEFORE,thatnode) == SCDOM_OK || assert(false);
	}
	void insert_after(HNODE thatnode)
	{
		.SciterNodeInsert(hn,NODE_INS_TARGET.NIT_AFTER,thatnode) == SCDOM_OK || assert(false);
	}
}


struct element
{
public:
	HELEMENT he;
	alias he this;

	//void use(HELEMENT h) { he = cast(HELEMENT)(.Sciter_UseElement(h)==SCDOM_OK ? h : HELEMENT.init); }
	void use(HELEMENT h) { .Sciter_UseElement(h)==SCDOM_OK || assert(false); he = h; }
	void unuse() { if(he) .Sciter_UnuseElement(he); he = HELEMENT.init; }
	void set(HELEMENT h) { unuse(); use(h); }

public:
	this(HELEMENT h) { use(h); }
	this(this) { use(he); }
	this(VALUE data)
	{
		import sciter.definitions.sciter_value;

		json_value jv = data;
		assert(jv.is_object());

		HELEMENT he = cast(size_t) jv.get_object_data();
		use(he);
	}
	~this() { unuse(); }
	bool is_valid() const { return he!=HELEMENT.init; }

	// Note: Although convenient, assigning different types to each other may cause confusions and errors.
	void opAssign(HELEMENT h)
	{
		unuse();
		use(h);
	}

	element opIndex(uint idx)
	{
		HELEMENT hre;
		.SciterGetNthChild(he,idx,&hre) == SCDOM_OK || assert(false);
		return element(hre);
	}

public:
	void destroy()
    {
		.SciterDeleteElement(he) == SCDOM_OK || assert(false);
    }
	void detach()
	{
		.SciterDetachElement(he) == SCDOM_OK || assert(false);
	}

	void clear()
	{
		.SciterSetElementText(he, null, 0) == SCDOM_OK || assert(false);
	}

	public
	{
		import sciter.definitions.behavior;

		void attach_event_handler(EventHandler evh) const
		{
			.SciterAttachEventHandler(he, &EventHandler.element_proc, cast(void*) evh) == SCDOM_OK || assert(false);
		}

		void detach_event_handler(EventHandler evh) const
		{
			.SciterDetachEventHandler(he, &EventHandler.element_proc, cast(void*) evh) == SCDOM_OK || assert(false);
		}
	}
	

	UINT children_count() const
	{
		UINT count;
		.SciterGetChildrenCount(he, &count);
		return count;
	}
	HELEMENT child( UINT index ) const
	{
		HELEMENT child;
		.SciterGetNthChild(he, index, &child);
		return child;
	}

	HELEMENT parent() const
	{
		HELEMENT hparent;
		.SciterGetParentElement(he, &hparent) == SCDOM_OK || assert(false);
		return hparent;
	}

	UINT index() const
	{
		UINT idx;
		.SciterGetElementIndex(he, &idx) == SCDOM_OK || assert(false);
		return idx;
	}

	UINT get_attribute_count() const
	{
		UINT n;
		.SciterGetAttributeCount(he, &n) == SCDOM_OK || assert(false);
		return n;
	}

	wstring get_attribute(uint n) const
	{
		static wstring str_rcv;
		LPCWSTR_RECEIVER frcv = function(LPCWSTR str, UINT str_length, LPVOID param)
		{
			str_rcv = str[0..str_length].idup;
		};

		.SciterGetNthAttributeValueCB(he, n, frcv, null) == SCDOM_OK || assert(false);
		return str_rcv;
	}

	string get_attribute_name(uint n) const
	{
		static string str_rcv;
		LPCSTR_RECEIVER frcv = function(LPCSTR str, UINT str_length, LPVOID param)
		{
			str_rcv = str[0..str_length].idup;
		};

		.SciterGetNthAttributeNameCB(he, n, frcv, null) == SCDOM_OK || assert(false);
		return str_rcv;
	}

	wstring get_attribute(string name, wstring def_value = null) const
	{
		static wstring str_rcv;
		LPCWSTR_RECEIVER frcv = function(LPCWSTR str, UINT str_length, LPVOID param)
		{
			str_rcv = str[0..str_length].idup;
		};

		SCDOM_RESULT r = .SciterGetAttributeByNameCB(he, (name ~ '\0').ptr, frcv, null);
		if(r == SCDOM_OK_NOT_HANDLED)
			return def_value;
		return str_rcv;
	}

	void set_attribute(string name, wstring value)
	{ 
		.SciterSetAttributeByName(he, (name ~ '\0').ptr, (value ~ '\0').ptr) == SCDOM_OK || assert(false);
	}

	int get_attribute_int(string name, int def_val = 0)
	{ 
		wstring txt = get_attribute(name);
		if(txt.length == 0) return def_val;
		return to!int(txt);
	}

	void remove_attribute(string name)
	{
		.SciterSetAttributeByName(he, (name ~ '\0').ptr, null) == SCDOM_OK || assert(false);
	}

	/*sciter dport custom function*/
	wstring[string] get_attributes()
	{
		wstring[string] res;
		uint n = get_attribute_count();
		for(uint i=0; i<n; i++)
			res[ get_attribute_name(i) ] = get_attribute(i);
		return res;
	}


	void set_style_attribute(string name, wstring value)
	{
		.SciterSetStyleAttribute(he, name.ptr, value.ptr) == SCDOM_OK || assert(false);
	}


	static HELEMENT root_element(HWINDOW hSciterWnd)
	{
		HELEMENT h;
		.SciterGetRootElement(hSciterWnd, &h) == SCDOM_OK || assert(false);
		assert(h);
		return h;
	}
	static HELEMENT focus_element(HWINDOW hSciterWnd)
	{
		HELEMENT h;
		.SciterGetFocusElement(hSciterWnd, &h) == SCDOM_OK || assert(false);
		return h;
	}
	static HELEMENT find_element(HWINDOW hSciterWnd, POINT clientPt)
	{
		HELEMENT h;
		.SciterFindElement(hSciterWnd, clientPt, &h) == SCDOM_OK || assert(false);
		return h;
	 }


	void set_capture() { .SciterSetCapture(he) == SCDOM_OK || assert(false); }
	void release_capture() { .SciterReleaseCapture(he) == SCDOM_OK || assert(false); }

	// select_elements() supporting things
	private
	{
		static HELEMENT s_select_first;
		extern(Windows) static BOOL select_elements_callback_first(HELEMENT he, LPVOID param)
		{
			s_select_first = he;
			return true; /*stop enumeration*/
		}

		static HELEMENT[] s_select_all;
		extern(Windows) static BOOL select_elements_callback_all(HELEMENT he, LPVOID param)
		{
			s_select_all ~= he;
			return false;
		}
	}

	void select_elements(SciterElementCallback pcall, string selector)
	{
		.SciterSelectElements(he, std.string.toStringz(selector), pcall, null);// using wide-version of SciterSelectElements
	}

	HELEMENT get_element_by_id(string id)
	{
		return find_first( std.string.format("[id='%s']"w, id) );
	}

	HELEMENT find_first(string selector)// find first element satisfying given CSS selector
	{
		s_select_first = HELEMENT.init;
		select_elements(&select_elements_callback_first, selector); 
		return s_select_first;
	}

	HELEMENT[] find_all(string selector)
	{
		s_select_all.length = 0;
		select_elements(&select_elements_callback_all, selector); 
		return s_select_all;
	}

	HELEMENT find_nearest_parent(string selector) const// will find first parent satisfying given css selector(s)
	{
		HELEMENT heFound;
		.SciterSelectParent(he, std.string.toStringz(selector), 0, &heFound) == SCDOM_OK || assert(false);
		return heFound;
	}

	bool test(string selector) const// test this element against CSS selector(s)
	{
		HELEMENT heFound;
		.SciterSelectParent(he, std.string.toStringz(selector), 1, &heFound) == SCDOM_OK || assert(false);
		return heFound != 0;
	}

	void update(bool render_now = false)
	{
		.SciterUpdateElement(he, render_now ? TRUE : FALSE) == SCDOM_OK || assert(false);
	}

	void refresh(RECT rc) 
	{
		.SciterRefreshElementArea(he, rc) == SCDOM_OK || assert(false);
	}
	void refresh() 
	{
		RECT rc = get_location(ELEMENT_AREAS.SELF_RELATIVE | ELEMENT_AREAS.CONTENT_BOX);
		refresh(rc);
	}

	HELEMENT root() 
	{
		element pel = element(parent());
		if( pel.is_valid() )
			return pel.root();
		return he;
	}
	HELEMENT next_sibling() 
	{
		UINT idx = index() + 1;
		element pel = parent();

		if( !pel.is_valid() )
			return HELEMENT.init;
		if( idx>=pel.children_count() )
			return HELEMENT.init;

		return pel.child(idx);
	}
	HELEMENT prev_sibling() 
	{
		UINT idx = index() - 1;
		element pel = parent();

		if( !pel.is_valid() )
			return HELEMENT.init;
		if( idx < 0 )
			return HELEMENT.init;

		return pel.child(idx);
	}
	HELEMENT first_sibling() 
	{
		element pel = parent();
		if( !pel.is_valid() )
			return HELEMENT.init;
		return pel.child(0);
	}
	HELEMENT last_sibling() 
	{
		element pel = parent();
		if( !pel.is_valid() )
			return HELEMENT.init;
		return pel.child( pel.children_count() - 1 );
	}


	RECT get_location(UINT area = ELEMENT_AREAS.ROOT_RELATIVE | ELEMENT_AREAS.CONTENT_BOX)
	{
		RECT rc;
		.SciterGetElementLocation(he, &rc, area) == SCDOM_OK || assert(false);
		return rc;
	}

	bool is_inside(POINT client_pt)
	{
		RECT rc = get_location(ELEMENT_AREAS.ROOT_RELATIVE | ELEMENT_AREAS.BORDER_BOX);
		return client_pt.x >= rc.left
			&& client_pt.x < rc.right
			&& client_pt.y >= rc.top
			&& client_pt.y < rc.bottom;
	}

	void scroll_to_view(bool toTopOfView = false)
	{
		.SciterScrollToView(he, toTopOfView ? TRUE : FALSE) == SCDOM_OK || assert(false);
	}

	void get_scroll_info(out POINT scroll_pos, out RECT view_rect, out SIZE content_size)
	{
		.SciterGetScrollInfo(he, &scroll_pos, &view_rect, &content_size) == SCDOM_OK || assert(false);
	}
	void set_scroll_pos(POINT scroll_pos)
	{
		.SciterSetScrollPos(he, scroll_pos, TRUE) == SCDOM_OK || assert(false);
	}

	void get_intrinsic_widths(out int min_width, out int max_width)
	{
		.SciterGetElementIntrinsicWidths(he, &min_width, &max_width) == SCDOM_OK || assert(false);
	}
	void get_intrinsic_height(int for_width, out int min_height)
	{
		.SciterGetElementIntrinsicHeight(he, for_width, &min_height) == SCDOM_OK || assert(false);
	}

	string get_element_type() const
	{
		static string str_rcv;
		debug str_rcv = "string_must_be_set_by_sciter_API";
		LPCSTR_RECEIVER frcv = function(LPCSTR str, UINT str_length, LPVOID param)
		{
			str_rcv = str[0..str_length].idup;
		};
		.SciterGetElementTypeCB(he, frcv, null) == SCDOM_OK || assert(false);
		debug assert(str_rcv!="string_must_be_set_by_sciter_API");
		return str_rcv;
	}

	string get_tag() { return get_element_type(); }

	HWINDOW get_element_hwnd(bool root_window)
	{
		HWINDOW hwnd;
		.SciterGetElementHwnd(he, &hwnd, root_window) == SCDOM_OK || assert(false);
		return hwnd;
	}

	void attach_hwnd(HWINDOW child)
	{
		.SciterAttachHwndToElement(he, child) == SCDOM_OK || assert(false);
	}

	UINT get_element_uid()
	{
		UINT uid;
		.SciterGetElementUID(he, &uid) == SCDOM_OK || assert(false);
		return uid;
	}

	static HELEMENT element_by_uid(HWINDOW hSciterWnd, UINT uid)
	{
		HELEMENT h;
		.SciterGetElementByUID(hSciterWnd, uid, &h) == SCDOM_OK || assert(false);
		return h;
	}

	wchar[] combine_url(wstring url)
	{
		wchar[] buff = new wchar[1024];// made it using a dynamic array
		buff[0..url.length+1] = url ~ '\0';
		.SciterCombineURL(he, buff.ptr, 1024) == SCDOM_OK || assert(false);
		return buff;
	}

	void set_html(string html, SET_ELEMENT_HTML where = SET_ELEMENT_HTML.SIH_REPLACE_CONTENT)
	{
		if( html.empty )
			clear();
		else
			.SciterSetElementHtml(he, cast(LPCBYTE)html.ptr, cast(uint)html.length, where) == SCDOM_OK || assert(false);// param 2 (the html content) should be UTF8 encoded text
	}

	string get_html(bool outer = true)
	{
		static string str_rcv;
		LPCBYTE_RECEIVER rcv = function(LPCBYTE bytes, UINT num_bytes, LPVOID param)
		{
			str_rcv = cast(string) bytes[0..num_bytes].idup;
		};
		.SciterGetElementHtmlCB(he, outer, rcv, null) == SCDOM_OK || assert(false);
		return str_rcv;
	}

	/*json::astring get_html(bool outer = true) 
	{ 
		json::astring s;
		.SciterGetElementHtmlCB(he, outer? TRUE:FALSE, &_LPCBYTE2ASTRING,&s) == SCDOM_OK || assert(false);
		return s;
	}

	json::string text()
	{
		json::string s;
		.SciterGetElementTextCB(he, &_LPCWSTR2STRING, &s) == SCDOM_OK || assert(false);
		return s;
	}*/


	wstring get_text()
	{
		static wstring str_rcv;
		LPCWSTR_RECEIVER rcv = function(LPCWSTR str, UINT str_length, LPVOID param)
		{
			str_rcv = str[0..str_length].idup;
		};
		.SciterGetElementTextCB(he, rcv, null);
		return str_rcv;
	}

	void set_text(wstring utf16_text)
	{
		.SciterSetElementText(he, utf16_text.ptr, cast(uint)utf16_text.length) == SCDOM_OK || assert(false);
	}



	// State funcs flags are all the ones from eElemetStateBits enum - midi
	UINT get_state()
	{
		UINT state;
		.SciterGetElementState(he,&state) == SCDOM_OK || assert(false);
		return state;
	}
	bool get_state(UINT bits)
	{
		UINT state;
		.SciterGetElementState(he,&state) == SCDOM_OK || assert(false);
		return (state & bits) != 0;
	}
	void set_state(UINT bitsToSet /*ELEMENT_STATE_BITS*/, UINT bitsToClear = 0 /*ELEMENT_STATE_BITS*/, bool update = true)
	{
		.SciterSetElementState(he,bitsToSet,bitsToClear, update?TRUE:FALSE) == SCDOM_OK || assert(false);
	}
	bool enabled() // deeply enabled
	{
		BOOL b;
		.SciterIsElementEnabled(he,&b) == SCDOM_OK || assert(false);
		return b != FALSE;
	}
	bool visible() // deeply visible
	{
		BOOL b;
		.SciterIsElementVisible(he,&b) == SCDOM_OK || assert(false);
		return b != FALSE;
	}

	void start_timer(UINT ms, UINT timer_id = 0)
	{
		.SciterSetTimer(he,ms,timer_id) == SCDOM_OK || assert(false);
	}
	void stop_timer(UINT timer_id = 0)
	{
		assert(he);
		.SciterSetTimer(he,0,timer_id) == SCDOM_OK || assert(false);
	}

	static HELEMENT create(string tagname, wstring text = null)
	{
		HELEMENT he;
		.SciterCreateElement( tagname.ptr, text.ptr, &he ) == SCDOM_OK || assert(false);// don't need 'use' here, as it is already "addrefed"
		return he;
	}

	HELEMENT clone()
	{
		HELEMENT he;
		.SciterCloneElement( he, &he ) == SCDOM_OK || assert(false);
		return he;
	}

	void insert(HELEMENT e, UINT index)
	{
		.SciterInsertElement( e, he, index ) == SCDOM_OK || assert(false);
	}
	void append(HELEMENT e)
	{
		insert(e, 0x7FFFFFFF);
	}
	void swap(HELEMENT ewith)
	{
		.SciterSwapElements(he, ewith) == SCDOM_OK || assert(false);
	}

	bool send_event(UINT event_code, UINT reason = 0, HELEMENT heSource = HELEMENT.init)
	{
		BOOL handled;
		.SciterSendEvent(he, event_code, heSource? heSource: he, reason, &handled) == SCDOM_OK || assert(false);
		return handled != FALSE;
	}
	void post_event(UINT event_code, UINT reason = 0, HELEMENT heSource = HELEMENT.init)
	{
		.SciterPostEvent(he, event_code, heSource? heSource: he, reason) == SCDOM_OK || assert(false);
	}
	bool fire_event(ref const BEHAVIOR_EVENT_PARAMS evt, bool post = true)
    {
		BOOL handled = false;
		.SciterFireEvent(&evt, post, &handled) == SCDOM_OK || assert(false);
		return handled != 0;
    }

	bool call_behavior_method(METHOD_PARAMS* mp)// this call need a pointer that is actually of a struct that inherits METHOD_PARAMS
	{
		assert(is_valid());
		return .SciterCallBehaviorMethod(he, mp) == SCDOM_OK;
	}

	void load_html(wstring url, HELEMENT initiator = HELEMENT.init)
	{
		load_data(url, SciterResourceType.RT_DATA_HTML, initiator);
	}
	void load_data(wstring url, UINT dataType, HELEMENT initiator = HELEMENT.init)
	{
		.SciterRequestElementData(he, (url ~ '\0').ptr, dataType, initiator) == SCDOM_OK || assert(false);
	}

	/*struct comparator 
	{
		virtual int compare(const sciter::dom::element& e1, const sciter::dom::element& e2) = 0;

		static INT CALLBACK scmp( HELEMENT he1, HELEMENT he2, LPVOID param )
		{
			sciter::dom::element::comparator* self = 
			static_cast<sciter::dom::element::comparator*>(param);

			sciter::dom::element e1 = he1;
			sciter::dom::element e2 = he2;

			return self->compare( e1,e2 );
		}
	};

	void sort( comparator& cmp, int start = 0, int end = -1 )
	{
		if (end == -1)
		end = children_count();

		SCDOM_RESULT r = SciterSortElements(he, start, end, &comparator::scmp, &cmp);
		assert(r == SCDOM_OK); r;
	}*/

	// Homogeneous Variadic Functions, see TDPL (hope it works, not tested)
	// arguments can be passable directly or via an array.
	VALUE call_method(string name, VALUE[] params...)
	{
		VALUE rv;
		.SciterCallScriptingMethod(he, (name ~ '\0').ptr, params.ptr, cast(uint)params.length, &rv) == SCDOM_OK || assert(false);
		return rv;
	}
	VALUE call_function(string name, VALUE[] params...)
	{
		VALUE rv;
		.SciterCallScriptingFunction(he, (name ~ '\0').ptr, params.ptr, cast(uint)params.length, &rv) == SCDOM_OK || assert(false);
		return rv;
	}

	// evaluate script in element context:
	// 'this' in script will be the element
	// and in namespace of element's document.
	VALUE eval(wstring script)
	{
		VALUE rv;
		.SciterEvalElementScript( he, script.ptr, cast(uint)script.length, &rv );// == SCDOM_OK || assert(false); // can fail gracefully on invalid input
		return rv;
	}

	CTL_TYPE get_ctl_type()
	{
		CTL_TYPE t;
		.SciterControlGetType(he, &cast(UINT)t) == SCDOM_OK || assert(false);
		return t;
	}

	VALUE get_value()
	{
		VALUE rv;
		.SciterGetValue(he, &rv) == SCDOM_OK || assert(false);
		return rv;
	}
	void set_value(VALUE v)
	{
		.SciterSetValue(he, &v) == SCDOM_OK || assert(false);
	}

	VALUE get_expando(bool force_create = false)
	{
		VALUE rv;
		.SciterGetExpando(he, &rv, force_create) == SCDOM_OK || assert(false);
		return rv;
	}

	tiscript_value get_object(bool force_create = false)
	{
		tiscript_value rv;
		.SciterGetObject(he, &rv, force_create) == SCDOM_OK || assert(false);
		return rv;
	}

	tiscript_value get_namespace()
	{
		tiscript_value rv;
		.SciterGetElementNamespace(he, &rv) == SCDOM_OK || assert(false);
		return rv;
	}

	void highlight()
	{
		HWINDOW hwnd = get_element_hwnd(true);
		set_highlighted(hwnd);
	}
	void set_highlighted(HWINDOW hSciterWnd)
	{
		.SciterSetHighlightedElement(hSciterWnd,he) == SCDOM_OK || assert(false);
	}

	static HELEMENT get_highlighted(HWINDOW hSciterWnd)
	{
		HELEMENT h;
		.SciterGetHighlightedElement(hSciterWnd,&h) == SCDOM_OK || assert(false);
		return h;
	}
	static void remove_highlightion(HWINDOW hSciterWnd)
	{
		.SciterSetHighlightedElement(hSciterWnd,HELEMENT.init) == SCDOM_OK || assert(false);
	}

// sciter-dport custom functions - midi
public:
	bool is_child_of(HELEMENT parent_test)
	{
		assert(is_valid());

		element el_it = this;
		while(true)
		{
			el_it = el_it.parent();
			if(!el_it.is_valid())
				break;
			if(el_it==parent_test)
				return true;
		}
		return false;
	}

	string get_tagname()
	{
		assert(is_valid());

		string name = get_tag();
		wstring id = get_attribute("id");
		wstring classes = get_attribute("class");
		if(id)
			name ~= '#' ~ to!string(id);
		if(classes)
			name ~= '.' ~ to!string(classes.splitter(' ').join("."));
		return name;
	}

	string get_path()
	{
		assert(is_valid());

		string path = "";
		element root = this;
		do
		{
			string name = root.get_tagname();
			root = root.parent();
			if(root)
				path = " > " ~ name ~ path;
		} while(root);

		return path;
	}

	static element[] from_path(HWINDOW hSciterWnd, string path)
	{
		return element[].init;
	}
}