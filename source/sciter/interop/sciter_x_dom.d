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

module sciter.interop.sciter_x_dom;

import sciter.interop.sciter_x_types;


extern(Windows)
{
	/* Following types are strongly typedefed at 'sciter.types'
	HELEMENT
	HNODE
	HRANGE
	HSARCHIVE
	*/
	struct HPOSITION { HNODE hn; int pos; }


	alias int SCDOM_RESULT;
	const int SCDOM_OK = 0;
	const int SCDOM_INVALID_HWND = 1;
	const int SCDOM_INVALID_HANDLE = 2;
	const int SCDOM_PASSIVE_HANDLE = 3;
	const int SCDOM_INVALID_PARAMETER = 4;
	const int SCDOM_OPERATION_FAILED = 5;
	const int SCDOM_OK_NOT_HANDLED = (-1);

	struct METHOD_PARAMS
	{
		uint methodID;
	}
	struct REQUEST_PARAM
	{
		LPCWSTR name;
		LPCWSTR value;
	}


	/+SCDOM_RESULT SCAPI Sciter_UseElement(HELEMENT he);
	SCDOM_RESULT SCAPI Sciter_UnuseElement(HELEMENT he);
	SCDOM_RESULT SCAPI SciterGetRootElement(HWINDOW hwnd, HELEMENT *phe);
	SCDOM_RESULT SCAPI SciterGetFocusElement(HWINDOW hwnd, HELEMENT *phe);
	SCDOM_RESULT SCAPI SciterFindElement(HWINDOW hwnd, POINT pt, HELEMENT* phe);
	SCDOM_RESULT SCAPI SciterGetChildrenCount(HELEMENT he, uint* count);
	SCDOM_RESULT SCAPI SciterGetNthChild(HELEMENT he, uint n, HELEMENT* phe);
	SCDOM_RESULT SCAPI SciterGetParentElement(HELEMENT he, HELEMENT* p_parent_he);
	//OBSOLETE SCDOM_RESULT SCAPI SciterGetElementHtml(HELEMENT he, LPCBYTE* utf8bytes, BOOL outer);+/
	alias LPCBYTE_RECEIVER = void function(LPCBYTE bytes, uint num_bytes, void* param);
	/+SCDOM_RESULT SCAPI SciterGetElementHtmlCB(HELEMENT he, BOOL outer, LPCBYTE_RECEIVER* rcv, void* rcv_param);
	//OBSOLETE SCDOM_RESULT SCAPI SciterGetElementText(HELEMENT he, LPWSTR* utf16);+/
	alias LPCWSTR_RECEIVER = void function(LPCWSTR str, uint str_length, void* param);
	alias LPCSTR_RECEIVER = void function(LPCSTR str, uint str_length, void* param);
	/+SCDOM_RESULT SCAPI SciterGetElementTextCB(HELEMENT he, LPCWSTR_RECEIVER* rcv, void* rcv_param);
	SCDOM_RESULT SCAPI SciterSetElementText(HELEMENT he, LPCWSTR utf16, uint length);
	SCDOM_RESULT SCAPI SciterGetAttributeCount(HELEMENT he, LPuint p_count);
	SCDOM_RESULT SCAPI SciterGetNthAttributeNameCB(HELEMENT he, uint n, LPCSTR_RECEIVER* rcv, void* rcv_param);
	SCDOM_RESULT SCAPI SciterGetNthAttributeValueCB(HELEMENT he, uint n, LPCWSTR_RECEIVER* rcv, void* rcv_param);
	SCDOM_RESULT SCAPI SciterGetAttributeByNameCB(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER* rcv, void* rcv_param);
	SCDOM_RESULT SCAPI SciterSetAttributeByName(HELEMENT he, LPCSTR name, LPCWSTR value);
	SCDOM_RESULT SCAPI SciterClearAttributes(HELEMENT he);
	SCDOM_RESULT SCAPI SciterGetElementIndex(HELEMENT he, LPuint p_index);
	SCDOM_RESULT SCAPI SciterGetElementType(HELEMENT he, LPCSTR* p_type);
	SCDOM_RESULT SCAPI SciterGetElementTypeCB(HELEMENT he, LPCSTR_RECEIVER* rcv, void* rcv_param);
	SCDOM_RESULT SCAPI SciterGetStyleAttributeCB(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER* rcv, void* rcv_param);
	SCDOM_RESULT SCAPI SciterSetStyleAttribute(HELEMENT he, LPCSTR name, LPCWSTR value);+/


	enum ELEMENT_AREAS : uint
	{
		ROOT_RELATIVE = 0x01,		// - or this flag if you want to get HTMLayout window relative coordinates,
									//   otherwise it will use nearest windowed container e.g. popup window.
		SELF_RELATIVE = 0x02,		// - "or" this flag if you want to get coordinates relative to the origin
									//   of element iself.
		CONTAINER_RELATIVE = 0x03,  // - position inside immediate container.
		VIEW_RELATIVE = 0x04,       // - position relative to view - HTMLayout window

		CONTENT_BOX = 0x00,   // content (inner)  box
		PADDING_BOX = 0x10,   // content + paddings
		BORDER_BOX  = 0x20,   // content + paddings + border
		MARGIN_BOX  = 0x30,   // content + paddings + border + margins 

		BACK_IMAGE_AREA = 0x40, // relative to content origin - location of background image (if it set no-repeat)
		FORE_IMAGE_AREA = 0x50, // relative to content origin - location of foreground image (if it set no-repeat)

		SCROLLABLE_AREA = 0x60,	// scroll_area - scrollable area in content box 
	}
	//SCDOM_RESULT SCAPI SciterGetElementLocation(HELEMENT he, LPRECT p_location, uint areas /*ELEMENT_AREAS*/);



	enum SCITER_SCROLL_FLAGS : uint
	{
		SCROLL_TO_TOP = 0x01,
		SCROLL_SMOOTH = 0x10,
	}


	/+SCDOM_RESULT SCAPI SciterScrollToView(HELEMENT he, uint SciterScrollFlags);
	SCDOM_RESULT SCAPI SciterUpdateElement(HELEMENT he, BOOL andForceRender);
	SCDOM_RESULT SCAPI SciterRefreshElementArea(HELEMENT he, RECT rc);
	SCDOM_RESULT SCAPI SciterSetCapture(HELEMENT he);
	SCDOM_RESULT SCAPI SciterReleaseCapture(HELEMENT he);
	SCDOM_RESULT SCAPI SciterGetElementHwnd(HELEMENT he, HWINDOW* p_hwnd, BOOL rootWindow);
	SCDOM_RESULT SCAPI SciterCombineURL(HELEMENT he, LPWSTR szUrlBuffer, uint UrlBufferSize);+/
	alias BOOL function(HELEMENT he, void* param) SciterElementCallback;

	/+SCDOM_RESULT SCAPI SciterSelectElements(
													 HELEMENT  he, 
													 LPCSTR    CSS_selectors,
													 SciterElementCallback* 
													 callback, 
													 void*    param);

	SCDOM_RESULT SCAPI SciterSelectElementsW(
													  HELEMENT  he, 
													  LPCWSTR   CSS_selectors,
													  SciterElementCallback* 
													  callback, 
													  void*    param);

	SCDOM_RESULT SCAPI SciterSelectParent(
												   HELEMENT  he, 
												   LPCSTR    selector,
												   uint      depth,
												   /*out*/ HELEMENT* heFound);

	SCDOM_RESULT SCAPI SciterSelectParentW(
													HELEMENT  he, 
													LPCWSTR   selector,
													uint      depth,
													/*out*/ HELEMENT* heFound);+/

	enum SET_ELEMENT_HTML : uint
	{
		SIH_REPLACE_CONTENT     = 0, 
		SIH_INSERT_AT_START     = 1,
		SIH_APPEND_AFTER_LAST   = 2, 
		SOH_REPLACE             = 3,
		SOH_INSERT_BEFORE       = 4,
		SOH_INSERT_AFTER        = 5  
	}


	/+SCDOM_RESULT SCAPI SciterSetElementHtml(HELEMENT he, const BYTE* html, uint htmlLength, uint where);
	SCDOM_RESULT SCAPI SciterGetElementUID(HELEMENT he, uint* puid);
	SCDOM_RESULT SCAPI SciterGetElementByUID(HWINDOW hwnd, uint uid, HELEMENT* phe);
	SCDOM_RESULT SCAPI SciterShowPopup(HELEMENT hePopup, HELEMENT heAnchor, uint placement);
	SCDOM_RESULT SCAPI SciterShowPopupAt(HELEMENT hePopup, POINT pos, BOOL animate);
	SCDOM_RESULT SCAPI SciterHidePopup(HELEMENT he);+/
	alias BOOL function(void* tag, HELEMENT he, uint evtg, void* prms) ElementEventProc;
	alias ElementEventProc LPELEMENT_EVENT_PROC;

	enum ELEMENT_STATE_BITS : uint
	{
		STATE_LINK             = 0x00000001,
		STATE_HOVER            = 0x00000002,
		STATE_ACTIVE           = 0x00000004,
		STATE_FOCUS            = 0x00000008,
		STATE_VISITED          = 0x00000010,
		STATE_CURRENT          = 0x00000020,  // current (hot) item 
		STATE_CHECKED          = 0x00000040,  // element is checked (or selected)
		STATE_DISABLED         = 0x00000080,  // element is disabled
		STATE_READONLY         = 0x00000100,  // readonly input element 
		STATE_EXPANDED         = 0x00000200,  // expanded state - nodes in tree view 
		STATE_COLLAPSED        = 0x00000400,  // collapsed state - nodes in tree view - mutually exclusive with
		STATE_INCOMPLETE       = 0x00000800,  // one of fore/back images requested but not delivered
		STATE_ANIMATING        = 0x00001000,  // is animating currently
		STATE_FOCUSABLE        = 0x00002000,  // will accept focus
		STATE_ANCHOR           = 0x00004000,  // anchor in selection (used with current in selects)
		STATE_SYNTHETIC        = 0x00008000,  // this is a synthetic element - don't emit it's head/tail
		STATE_OWNS_POPUP       = 0x00010000,  // this is a synthetic element - don't emit it's head/tail
		STATE_TABFOCUS         = 0x00020000,  // focus gained by tab traversal
		STATE_EMPTY            = 0x00040000,  // empty - element is empty (text.size() == 0 && subs.size() == 0) 
											  //  if element has behavior attached then the behavior is responsible for the value of this flag.
		STATE_BUSY             = 0x00080000,  // busy; loading

		STATE_DRAG_OVER        = 0x00100000,  // drag over the block that can accept it (so is current drop target). Flag is set for the drop target block
		STATE_DROP_TARGET      = 0x00200000,  // active drop target.
		STATE_MOVING           = 0x00400000,  // dragging/moving - the flag is set for the moving block.
		STATE_COPYING          = 0x00800000,  // dragging/copying - the flag is set for the copying block.
		STATE_DRAG_SOURCE      = 0x01000000,  // element that is a drag source.
		STATE_DROP_MARKER      = 0x02000000,  // element is drop marker

		STATE_PRESSED          = 0x04000000,  // pressed - close to active but has wider life span - e.g. in MOUSE_UP it 
											  //   is still on; so behavior can check it in MOUSE_UP to discover CLICK condition.
		STATE_POPUP            = 0x08000000,  // this element is out of flow - popup 

		STATE_IS_LTR           = 0x10000000,  // the element or one of its containers has dir=ltr declared
		STATE_IS_RTL           = 0x20000000,  // the element or one of its containers has dir=rtl declared
	}

	/+SCDOM_RESULT SCAPI SciterGetElementState( HELEMENT he, uint* pstateBits);
	SCDOM_RESULT SCAPI SciterSetElementState( HELEMENT he, uint stateBitsToSet, uint stateBitsToClear, BOOL updateView);
	SCDOM_RESULT SCAPI SciterCreateElement( LPCSTR tagname, LPCWSTR textOrNull, /*out*/ HELEMENT *phe );
	SCDOM_RESULT SCAPI SciterCloneElement( HELEMENT he, /*out*/ HELEMENT *phe );
	SCDOM_RESULT SCAPI SciterInsertElement( HELEMENT he, HELEMENT hparent, uint index );
	SCDOM_RESULT SCAPI SciterDetachElement( HELEMENT he );
	SCDOM_RESULT SCAPI SciterDeleteElement(HELEMENT he);
	SCDOM_RESULT SCAPI SciterSetTimer( HELEMENT he, uint milliseconds, uint_PTR timer_id );
	SCDOM_RESULT SCAPI SciterDetachEventHandler( HELEMENT he, LPELEMENT_EVENT_PROC pep, void* tag );
	SCDOM_RESULT SCAPI SciterAttachEventHandler( HELEMENT he, LPELEMENT_EVENT_PROC pep, void* tag );
	SCDOM_RESULT SCAPI SciterWindowAttachEventHandler( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, void* tag, uint subscription );
	SCDOM_RESULT SCAPI SciterWindowDetachEventHandler( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, void* tag );
	SCDOM_RESULT SCAPI SciterSendEvent(HELEMENT he, uint appEventCode, HELEMENT heSource, uint reason, /*out*/ BOOL* handled);
	SCDOM_RESULT SCAPI SciterPostEvent( HELEMENT he, uint appEventCode, HELEMENT heSource, uint reason);
	SCDOM_RESULT SCAPI SciterFireEvent( const struct BEHAVIOR_EVENT_PARAMS* evt, BOOL post, BOOL *handled);
	SCDOM_RESULT SCAPI SciterCallBehaviorMethod(HELEMENT he, struct METHOD_PARAMS* params);
	SCDOM_RESULT SCAPI SciterRequestElementData( HELEMENT he, LPCWSTR url, uint dataType, HELEMENT initiator );+/

	enum REQUEST_TYPE
	{
		GET_ASYNC,  // async GET
		POST_ASYNC, // async POST
		GET_SYNC,   // synchronous GET 
		POST_SYNC   // synchronous POST 
	}

	/+SCDOM_RESULT SCAPI SciterHttpRequest(
													HELEMENT        he,           // element to deliver data 
													LPCWSTR         url,          // url 
													uint            dataType,     // data type, see SciterResourceType.
													uint            requestType,  // one of REQUEST_TYPE values
													struct REQUEST_PARAM*  requestParams,// parameters
													uint            nParams       // number of parameters 
													);

	SCDOM_RESULT SCAPI SciterGetScrollInfo(HELEMENT he, LPPOINT scrollPos, LPRECT viewRect, LPSIZE contentSize );
	SCDOM_RESULT SCAPI SciterSetScrollPos(HELEMENT he, POINT scrollPos, BOOL smooth );
	SCDOM_RESULT SCAPI SciterGetElementIntrinsicWidths( HELEMENT he, INT* pMinWidth, INT* pMaxWidth );
	SCDOM_RESULT SCAPI SciterGetElementIntrinsicHeight( HELEMENT he, INT forWidth, INT* pHeight );
	SCDOM_RESULT SCAPI SciterIsElementVisible( HELEMENT he, BOOL* pVisible);
	SCDOM_RESULT SCAPI SciterIsElementEnabled( HELEMENT he, BOOL* pEnabled);+/
	alias int function(HELEMENT he1, HELEMENT he2, void* param) ELEMENT_COMPARATOR;
	/+SCDOM_RESULT SCAPI SciterSortElements(HELEMENT he, uint firstIndex, uint lastIndex, ELEMENT_COMPARATOR* cmpFunc, void* cmpFuncParam);
	SCDOM_RESULT SCAPI SciterSwapElements(HELEMENT he1, HELEMENT he2);
	SCDOM_RESULT SCAPI SciterTraverseUIEvent(uint evt, void* eventCtlStruct, BOOL* bOutProcessed );
	SCDOM_RESULT SCAPI SciterCallScriptingMethod( HELEMENT he, LPCSTR name, const VALUE* argv, uint argc, VALUE* retval );
	SCDOM_RESULT SCAPI SciterCallScriptingFunction( HELEMENT he, LPCSTR name, const VALUE* argv, uint argc, VALUE* retval );
	SCDOM_RESULT SCAPI SciterEvalElementScript( HELEMENT he, LPCWSTR script, uint scriptLength, VALUE* retval );
	SCDOM_RESULT SCAPI SciterAttachHwndToElement(HELEMENT he, HWINDOW hwnd);+/

	enum CTL_TYPE : uint
	{
		CTL_NO,               ///< This dom element has no behavior at all.
		CTL_UNKNOWN = 1,      ///< This dom element has behavior but its type is unknown.
		CTL_EDIT,             ///< Single line edit box.
		CTL_NUMERIC,          ///< Numeric input with optional spin buttons.
		CTL_CLICKABLE,        ///< toolbar button, behavior:clickable.
		CTL_BUTTON,           ///< Command button.
		CTL_CHECKBOX,         ///< CheckBox (button).
		CTL_RADIO,            ///< OptionBox (button).
		CTL_SELECT_SINGLE,    ///< Single select, ListBox or TreeView.
		CTL_SELECT_MULTIPLE,  ///< Multiselectable select, ListBox or TreeView.
		CTL_DD_SELECT,        ///< Dropdown single select.
		CTL_TEXTAREA,         ///< Multiline TextBox.
		CTL_HTMLAREA,         ///< WYSIWYG HTML editor.
		CTL_PASSWORD,         ///< Password input element.
		CTL_PROGRESS,         ///< Progress element.
		CTL_SLIDER,           ///< Slider input element.  
		CTL_DECIMAL,          ///< Decimal number input element.
		CTL_CURRENCY,         ///< Currency input element.
		CTL_SCROLLBAR,

		CTL_HYPERLINK,

		CTL_MENUBAR,
		CTL_MENU,
		CTL_MENUBUTTON,

		CTL_CALENDAR,
		CTL_DATE,
		CTL_TIME,

		CTL_FRAME,
		CTL_FRAMESET,

		CTL_GRAPHICS,
		CTL_SPRITE,

		CTL_LIST,
		CTL_RICHTEXT,
		CTL_TOOLTIP,

		CTL_HIDDEN,
		CTL_URL,            ///< URL input element.
		CTL_TOOLBAR,

		CTL_FORM,
		CTL_FILE,           ///< file input element.
		CTL_PATH,           ///< path input element.
		CTL_WINDOW,         ///< has HWND attached to it

		CTL_LABEL,            
		CTL_IMAGE,            ///< image/object.  
	}

	/+SCDOM_RESULT SCAPI SciterControlGetType( HELEMENT he, /*CTL_TYPE*/ uint *pType );
	SCDOM_RESULT SCAPI SciterGetValue( HELEMENT he, VALUE* pval );
	SCDOM_RESULT SCAPI SciterSetValue( HELEMENT he, const VALUE* pval );
	SCDOM_RESULT SCAPI SciterGetExpando( HELEMENT he, VALUE* pval, BOOL forceCreation );
	SCDOM_RESULT SCAPI SciterGetObject( HELEMENT he, tiscript_value* pval, BOOL forceCreation );
	SCDOM_RESULT SCAPI SciterGetElementNamespace(  HELEMENT he, tiscript_value* pval);
	SCDOM_RESULT SCAPI SciterGetHighlightedElement(HWINDOW hwnd, HELEMENT* phe);
	SCDOM_RESULT SCAPI SciterSetHighlightedElement(HWINDOW hwnd, HELEMENT he);
	SCDOM_RESULT SCAPI SciterNodeAddRef(HNODE hn);
	SCDOM_RESULT SCAPI SciterNodeRelease(HNODE hn);
	SCDOM_RESULT SCAPI SciterNodeCastFromElement(HELEMENT he, HNODE* phn);
	SCDOM_RESULT SCAPI SciterNodeCastToElement(HNODE hn, HELEMENT* he);
	SCDOM_RESULT SCAPI SciterNodeFirstChild(HNODE hn, HNODE* phn);
	SCDOM_RESULT SCAPI SciterNodeLastChild(HNODE hn, HNODE* phn);
	SCDOM_RESULT SCAPI SciterNodeNextSibling(HNODE hn, HNODE* phn);
	SCDOM_RESULT SCAPI SciterNodePrevSibling(HNODE hn, HNODE* phn);
	SCDOM_RESULT SCAPI SciterNodeParent(HNODE hnode, HELEMENT* pheParent);
	SCDOM_RESULT SCAPI SciterNodeNthChild(HNODE hnode, uint n, HNODE* phn);
	SCDOM_RESULT SCAPI SciterNodeChildrenCount(HNODE hnode, uint* pn);+/

	enum NODE_TYPE : uint
	{
		NT_ELEMENT,
		NT_TEXT,
		NT_COMMENT 
	}

	/+SCDOM_RESULT SCAPI SciterNodeType(HNODE hnode, uint* pNodeType /*NODE_TYPE*/);
	SCDOM_RESULT SCAPI SciterNodeGetText(HNODE hnode, LPCWSTR_RECEIVER* rcv, void* rcv_param);
	SCDOM_RESULT SCAPI SciterNodeSetText(HNODE hnode, LPCWSTR text, uint textLength);+/

	enum NODE_INS_TARGET : uint
	{
		NIT_BEFORE,
		NIT_AFTER,
		NIT_APPEND,
		NIT_PREPEND,
	}

	/+SCDOM_RESULT SCAPI SciterNodeInsert(HNODE hnode, uint where /*NODE_INS_TARGET*/, HNODE what);
	SCDOM_RESULT SCAPI SciterNodeRemove(HNODE hnode, BOOL finalize);
	SCDOM_RESULT SCAPI SciterCreateTextNode(LPCWSTR text, uint textLength, HNODE* phnode);
	SCDOM_RESULT SCAPI SciterCreateCommentNode(LPCWSTR text, uint textLength, HNODE* phnode);+/
}