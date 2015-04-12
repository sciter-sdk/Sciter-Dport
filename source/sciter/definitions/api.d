// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

module sciter.definitions.api;

public import sciter.sciter_x;
public import sciter.definitions.types;
import sciter.sciter_x_types;
import sciter.sciter_x_behaviors;
import sciter.tiscript;


unittest
{
	// you need this port version to be the same version of Sciter SDK (else for sure it will crash)
	UINT major = SciterVersion(TRUE);
	UINT minor = SciterVersion(FALSE);
	assert(major==0x00030008);
	assert(minor==0x00000001);
	assert(SAPI()._version==0);
}



ISciterAPI* _SAPI;

static this()
{
	version(Windows)
	{
		_SAPI = SciterAPI();
	}
	version(linux)
	{
		import core.sys.posix.dlfcn;
		import core.stdc.stdio;
		import core.stdc.stdlib;

		void* lib_sciter_handle = dlopen("./sciter-gtk-64.so", RTLD_LOCAL|RTLD_LAZY);// there is not 32bits .so version in the SDK
		if(!lib_sciter_handle)
		{
			fprintf(stderr, "dlopen error: %s\n", dlerror());
			exit(1);
		}
		
		ISciterAPI* function() sapi = cast(ISciterAPI* function()) dlsym(lib_sciter_handle, "SciterAPI");
		char* error = dlerror();
		if(error)
		{
			fprintf(stderr, "dlsym error: %s\n", error);
			exit(1);
		}

		_SAPI = sapi();
	}
}

ISciterAPI* SAPI()
{
	return _SAPI;
}



// defining "official" API functions:
LPCWSTR SciterClassName () { return SAPI().SciterClassName(); }
UINT    SciterVersion (BOOL major) { return SAPI().SciterVersion (major); }
BOOL    SciterDataReady (HWINDOW hwnd,LPCWSTR uri,LPCBYTE data, UINT dataLength) { return SAPI().SciterDataReady (hwnd,uri,data,dataLength); }
BOOL    SciterDataReadyAsync (HWINDOW hwnd,LPCWSTR uri, LPCBYTE data, UINT dataLength, LPVOID requestId) { return SAPI().SciterDataReadyAsync (hwnd,uri, data, dataLength, requestId); }
version(Windows)
{
	LRESULT SciterProc (HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam) { return SAPI().SciterProc (hwnd,msg,wParam,lParam); }
	LRESULT SciterProcND (HWINDOW hwnd, UINT msg, WPARAM wParam, LPARAM lParam, BOOL* pbHandled) { return SAPI().SciterProcND (hwnd,msg,wParam,lParam,pbHandled); }
}
BOOL    SciterLoadFile (HWINDOW hWndSciter, LPCWSTR filename) { return SAPI().SciterLoadFile (hWndSciter,filename); }
BOOL    SciterLoadHtml (HWINDOW hWndSciter, LPCBYTE html, UINT htmlSize, LPCWSTR baseUrl) { return SAPI().SciterLoadHtml (hWndSciter,html,htmlSize,baseUrl); }
VOID    SciterSetCallback (HWINDOW hWndSciter, LPSciterHostCallback cb, LPVOID cbParam) { SAPI().SciterSetCallback (hWndSciter,cb,cbParam); }
BOOL    SciterSetMasterCSS (LPCBYTE utf8, UINT numBytes) { return SAPI().SciterSetMasterCSS (utf8,numBytes); }
BOOL    SciterAppendMasterCSS (LPCBYTE utf8, UINT numBytes) { return SAPI().SciterAppendMasterCSS (utf8,numBytes); }
BOOL    SciterSetCSS (HWINDOW hWndSciter, LPCBYTE utf8, UINT numBytes, LPCWSTR baseUrl, LPCWSTR mediaType) { return SAPI().SciterSetCSS (hWndSciter,utf8,numBytes,baseUrl,mediaType); }
BOOL    SciterSetMediaType (HWINDOW hWndSciter, LPCWSTR mediaType) { return SAPI().SciterSetMediaType (hWndSciter,mediaType); }
BOOL    SciterSetMediaVars (HWINDOW hWndSciter, const SCITER_VALUE *mediaVars) { return SAPI().SciterSetMediaVars (hWndSciter,mediaVars); }
UINT    SciterGetMinWidth (HWINDOW hWndSciter) { return SAPI().SciterGetMinWidth (hWndSciter); }
UINT    SciterGetMinHeight (HWINDOW hWndSciter, UINT width) { return SAPI().SciterGetMinHeight (hWndSciter,width); }
BOOL    SciterCall (HWINDOW hWnd, LPCSTR functionName, UINT argc, const SCITER_VALUE* argv, SCITER_VALUE* retval) { return SAPI().SciterCall (hWnd,functionName, argc,argv,retval); }
BOOL    SciterEval (HWINDOW hwnd, LPCWSTR script, UINT scriptLength, SCITER_VALUE* pretval) { return SAPI().SciterEval ( hwnd, script, scriptLength, pretval); }
VOID    SciterUpdateWindow(HWINDOW hwnd) { SAPI().SciterUpdateWindow(hwnd); }
version(Windows)
{
	BOOL    SciterTranslateMessage (MSG* lpMsg) { return SAPI().SciterTranslateMessage (lpMsg); }
}
BOOL    SciterSetOption (HWINDOW hWnd, SCITER_RT_OPTIONS option, UINT_PTR value ) { return SAPI().SciterSetOption (hWnd,option,value ); }
VOID    SciterGetPPI (HWINDOW hWndSciter, UINT* px, UINT* py) { SAPI().SciterGetPPI (hWndSciter,px,py); }
BOOL    SciterGetViewExpando ( HWINDOW hwnd, VALUE* pval ) { return SAPI().SciterGetViewExpando ( hwnd, pval ); }
BOOL    SciterEnumUrlData (HWINDOW hWndSciter, URL_DATA_RECEIVER receiver, LPVOID param, LPCSTR url) { return SAPI().SciterEnumUrlData (hWndSciter,receiver,param,url); }
version(Windows)
{
	BOOL    SciterRenderD2D (HWINDOW hWndSciter, ID2D1RenderTarget* prt) { return SAPI().SciterRenderD2D (hWndSciter,prt); }
	BOOL    SciterD2DFactory (ID2D1Factory ** ppf) { return SAPI().SciterD2DFactory (ppf); }
	BOOL    SciterDWFactory (IDWriteFactory ** ppf) { return SAPI().SciterDWFactory (ppf); }
}
BOOL    SciterGraphicsCaps (LPUINT pcaps) { return SAPI().SciterGraphicsCaps (pcaps); }
BOOL    SciterSetHomeURL (HWINDOW hWndSciter, LPCWSTR baseUrl) { return SAPI().SciterSetHomeURL (hWndSciter,baseUrl); }
version(OSX)
{
	HWINDOW	SciterCreateNSView ( LPRECT frame ) { return SAPI().SciterCreateNSView ( frame ); }
}
HWINDOW SciterCreateWindow ( UINT creationFlags /*SCITER_CREATE_WINDOW_FLAGS*/,LPRECT frame, SciterWindowDelegate* delegate_, LPVOID delegateParam, HWINDOW parent) { return SAPI().SciterCreateWindow (creationFlags,frame,delegate_,delegateParam,parent); }

SCDOM_RESULT Sciter_UseElement(HELEMENT he) { return SAPI().Sciter_UseElement(he); }
SCDOM_RESULT Sciter_UnuseElement(HELEMENT he) { return SAPI().Sciter_UnuseElement(he); }
SCDOM_RESULT SciterGetRootElement(HWINDOW hwnd, HELEMENT *phe) { return SAPI().SciterGetRootElement(hwnd, phe); }
SCDOM_RESULT SciterGetFocusElement(HWINDOW hwnd, HELEMENT *phe) { return SAPI().SciterGetFocusElement(hwnd, phe); }
SCDOM_RESULT SciterFindElement(HWINDOW hwnd, POINT pt, HELEMENT* phe) { return SAPI().SciterFindElement(hwnd,pt,phe); }
SCDOM_RESULT SciterGetChildrenCount(HELEMENT he, UINT* count) { return SAPI().SciterGetChildrenCount(he, count); }
SCDOM_RESULT SciterGetNthChild(HELEMENT he, UINT n, HELEMENT* phe) { return SAPI().SciterGetNthChild(he,n,phe); }
SCDOM_RESULT SciterGetParentElement(HELEMENT he, HELEMENT* p_parent_he) { return SAPI().SciterGetParentElement(he,p_parent_he); }
SCDOM_RESULT SciterGetElementHtmlCB(HELEMENT he, BOOL outer, LPCBYTE_RECEIVER rcv, LPVOID rcv_param) { return SAPI().SciterGetElementHtmlCB( he, outer, rcv, rcv_param); }
SCDOM_RESULT SciterGetElementTextCB(HELEMENT he, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) { return SAPI().SciterGetElementTextCB(he, rcv, rcv_param); }
SCDOM_RESULT SciterSetElementText(HELEMENT he, LPCWSTR utf16, UINT length) { return SAPI().SciterSetElementText(he, utf16, length); }
SCDOM_RESULT SciterGetAttributeCount(HELEMENT he, LPUINT p_count) { return SAPI().SciterGetAttributeCount(he, p_count); }
SCDOM_RESULT SciterGetNthAttributeNameCB(HELEMENT he, UINT n, LPCSTR_RECEIVER rcv, LPVOID rcv_param) { return SAPI().SciterGetNthAttributeNameCB(he,n,rcv,rcv_param); }
SCDOM_RESULT SciterGetNthAttributeValueCB(HELEMENT he, UINT n, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) { return SAPI().SciterGetNthAttributeValueCB(he, n, rcv, rcv_param); }
SCDOM_RESULT SciterGetAttributeByNameCB(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) { return SAPI().SciterGetAttributeByNameCB(he,name,rcv,rcv_param); }
SCDOM_RESULT SciterSetAttributeByName(HELEMENT he, LPCSTR name, LPCWSTR value) { return SAPI().SciterSetAttributeByName(he,name,value); }
SCDOM_RESULT SciterClearAttributes(HELEMENT he) { return SAPI().SciterClearAttributes(he); }
SCDOM_RESULT SciterGetElementIndex(HELEMENT he, LPUINT p_index) { return SAPI().SciterGetElementIndex(he,p_index); }
SCDOM_RESULT SciterGetElementType(HELEMENT he, LPCSTR* p_type) { return SAPI().SciterGetElementType(he,p_type); }
SCDOM_RESULT SciterGetElementTypeCB(HELEMENT he, LPCSTR_RECEIVER rcv, LPVOID rcv_param) { return SAPI().SciterGetElementTypeCB(he,rcv,rcv_param); }
SCDOM_RESULT SciterGetStyleAttributeCB(HELEMENT he, LPCSTR name, LPCWSTR_RECEIVER* rcv, LPVOID rcv_param) { return SAPI().SciterGetStyleAttributeCB(he,name,rcv,rcv_param); }
SCDOM_RESULT SciterSetStyleAttribute(HELEMENT he, LPCSTR name, LPCWSTR value) { return SAPI().SciterSetStyleAttribute(he,name,value); }
SCDOM_RESULT SciterGetElementLocation(HELEMENT he, LPRECT p_location, UINT areas /*ELEMENT_AREAS*/) { return SAPI().SciterGetElementLocation(he,p_location,areas); }
SCDOM_RESULT SciterScrollToView(HELEMENT he, UINT SciterScrollFlags) { return SAPI().SciterScrollToView(he,SciterScrollFlags); }
SCDOM_RESULT SciterUpdateElement(HELEMENT he, BOOL andForceRender) { return SAPI().SciterUpdateElement(he,andForceRender); }
SCDOM_RESULT SciterRefreshElementArea(HELEMENT he, RECT rc) { return SAPI().SciterRefreshElementArea(he,rc); }
SCDOM_RESULT SciterSetCapture(HELEMENT he) { return SAPI().SciterSetCapture(he); }
SCDOM_RESULT SciterReleaseCapture(HELEMENT he) { return SAPI().SciterReleaseCapture(he); }
SCDOM_RESULT SciterGetElementHwnd(HELEMENT he, HWINDOW* p_hwnd, BOOL rootWindow) { return SAPI().SciterGetElementHwnd(he,p_hwnd,rootWindow); }
SCDOM_RESULT SciterCombineURL(HELEMENT he, LPWSTR szUrlBuffer, UINT UrlBufferSize) { return SAPI().SciterCombineURL(he,szUrlBuffer,UrlBufferSize); }
SCDOM_RESULT SciterSelectElements(HELEMENT  he, LPCSTR    CSS_selectors, SciterElementCallback callback, LPVOID param) { return SAPI().SciterSelectElements(he,CSS_selectors,callback,param); }
SCDOM_RESULT SciterSelectElementsW(HELEMENT  he, LPCWSTR   CSS_selectors, SciterElementCallback callback, LPVOID param) { return SAPI().SciterSelectElementsW(he,CSS_selectors,callback,param); }
SCDOM_RESULT SciterSelectParent(HELEMENT  he, LPCSTR    selector, UINT      depth, HELEMENT* heFound) { return SAPI().SciterSelectParent(he,selector,depth,heFound); }
SCDOM_RESULT SciterSelectParentW(HELEMENT  he, LPCWSTR   selector, UINT      depth, HELEMENT* heFound) { return SAPI().SciterSelectParentW(he,selector,depth,heFound); }
SCDOM_RESULT SciterSetElementHtml(HELEMENT he, const BYTE* html, UINT htmlLength, UINT where) { return SAPI().SciterSetElementHtml(he,html,htmlLength,where); }
SCDOM_RESULT SciterGetElementUID(HELEMENT he, UINT* puid) { return SAPI().SciterGetElementUID(he,puid); }
SCDOM_RESULT SciterGetElementByUID(HWINDOW hwnd, UINT uid, HELEMENT* phe) { return SAPI().SciterGetElementByUID(hwnd,uid,phe); }
SCDOM_RESULT SciterShowPopup(HELEMENT hePopup, HELEMENT heAnchor, UINT placement) { return SAPI().SciterShowPopup(hePopup,heAnchor,placement); }
SCDOM_RESULT SciterShowPopupAt(HELEMENT hePopup, POINT pos, BOOL animate) { return SAPI().SciterShowPopupAt(hePopup,pos,animate); }
SCDOM_RESULT SciterHidePopup(HELEMENT he) { return SAPI().SciterHidePopup(he); }
SCDOM_RESULT SciterGetElementState( HELEMENT he, UINT* pstateBits) { return SAPI().SciterGetElementState(he,pstateBits); }
SCDOM_RESULT SciterSetElementState( HELEMENT he, UINT stateBitsToSet, UINT stateBitsToClear, BOOL updateView) { return SAPI().SciterSetElementState(he,stateBitsToSet,stateBitsToClear,updateView); }
SCDOM_RESULT SciterCreateElement( LPCSTR tagname, LPCWSTR textOrNull, /*out*/ HELEMENT *phe ) { return SAPI().SciterCreateElement(tagname,textOrNull,phe ); }
SCDOM_RESULT SciterCloneElement( HELEMENT he, /*out*/ HELEMENT *phe ) { return SAPI().SciterCloneElement(he,phe ); }
SCDOM_RESULT SciterInsertElement( HELEMENT he, HELEMENT hparent, UINT index ) { return SAPI().SciterInsertElement(he,hparent,index ); }
SCDOM_RESULT SciterDetachElement( HELEMENT he ) { return SAPI().SciterDetachElement( he ); }
SCDOM_RESULT SciterDeleteElement(HELEMENT he) { return SAPI().SciterDeleteElement(he); }
SCDOM_RESULT SciterSetTimer( HELEMENT he, UINT milliseconds, UINT_PTR timer_id ) { return SAPI().SciterSetTimer(he,milliseconds,timer_id ); }
SCDOM_RESULT SciterDetachEventHandler( HELEMENT he, LPELEMENT_EVENT_PROC pep, LPVOID tag ) { return SAPI().SciterDetachEventHandler(he,pep,tag ); }
SCDOM_RESULT SciterAttachEventHandler( HELEMENT he, LPELEMENT_EVENT_PROC pep, LPVOID tag ) { return SAPI().SciterAttachEventHandler( he,pep,tag ); }
SCDOM_RESULT SciterWindowAttachEventHandler( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, LPVOID tag, UINT subscription ) { return SAPI().SciterWindowAttachEventHandler(hwndLayout,pep,tag,subscription ); }
SCDOM_RESULT SciterWindowDetachEventHandler( HWINDOW hwndLayout, LPELEMENT_EVENT_PROC pep, LPVOID tag ) { return SAPI().SciterWindowDetachEventHandler(hwndLayout,pep,tag ); }
SCDOM_RESULT SciterSendEvent( HELEMENT he, UINT appEventCode, HELEMENT heSource, UINT reason, /*out*/ BOOL* handled) { return SAPI().SciterSendEvent( he,appEventCode,heSource,reason,handled); }
SCDOM_RESULT SciterPostEvent( HELEMENT he, UINT appEventCode, HELEMENT heSource, UINT reason) { return SAPI().SciterPostEvent(he,appEventCode,heSource,reason); }
SCDOM_RESULT SciterFireEvent( const BEHAVIOR_EVENT_PARAMS* evt, BOOL post, BOOL *handled) { return SAPI().SciterFireEvent( evt, post, handled ); }
SCDOM_RESULT SciterCallBehaviorMethod(HELEMENT he, METHOD_PARAMS* params) { return SAPI().SciterCallBehaviorMethod(he,params); }
SCDOM_RESULT SciterRequestElementData( HELEMENT he, LPCWSTR url, UINT dataType, HELEMENT initiator ) { return SAPI().SciterRequestElementData(he,url,dataType,initiator ); }
SCDOM_RESULT SciterHttpRequest( HELEMENT he, LPCWSTR url, UINT dataType, UINT requestType, REQUEST_PARAM* requestParams, UINT nParams) { return SAPI().SciterHttpRequest(he,url,dataType,requestType,requestParams,nParams); }
SCDOM_RESULT SciterGetScrollInfo( HELEMENT he, LPPOINT scrollPos, LPRECT viewRect, LPSIZE contentSize ) { return SAPI().SciterGetScrollInfo( he,scrollPos,viewRect,contentSize ); }
SCDOM_RESULT SciterSetScrollPos( HELEMENT he, POINT scrollPos, BOOL smooth ) { return SAPI().SciterSetScrollPos( he,scrollPos,smooth ); }
SCDOM_RESULT SciterGetElementIntrinsicWidths( HELEMENT he, INT* pMinWidth, INT* pMaxWidth ) { return SAPI().SciterGetElementIntrinsicWidths(he,pMinWidth,pMaxWidth ); }
SCDOM_RESULT SciterGetElementIntrinsicHeight( HELEMENT he, INT forWidth, INT* pHeight ) { return SAPI().SciterGetElementIntrinsicHeight( he,forWidth,pHeight ); }
SCDOM_RESULT SciterIsElementVisible( HELEMENT he, BOOL* pVisible) { return SAPI().SciterIsElementVisible( he,pVisible); }
SCDOM_RESULT SciterIsElementEnabled( HELEMENT he, BOOL* pEnabled ) { return SAPI().SciterIsElementEnabled( he, pEnabled ); }
SCDOM_RESULT SciterSortElements( HELEMENT he, UINT firstIndex, UINT lastIndex, ELEMENT_COMPARATOR* cmpFunc, LPVOID cmpFuncParam ) { return SAPI().SciterSortElements( he, firstIndex, lastIndex, cmpFunc, cmpFuncParam ); }
SCDOM_RESULT SciterSwapElements( HELEMENT he1, HELEMENT he2 ) { return SAPI().SciterSwapElements( he1,he2 ); }
SCDOM_RESULT SciterTraverseUIEvent( UINT evt, LPVOID eventCtlStruct, BOOL* bOutProcessed ) { return SAPI().SciterTraverseUIEvent( evt,eventCtlStruct,bOutProcessed ); }
SCDOM_RESULT SciterCallScriptingMethod( HELEMENT he, LPCSTR name, const VALUE* argv, UINT argc, VALUE* retval ) { return SAPI().SciterCallScriptingMethod( he,name,argv,argc,retval ); }
SCDOM_RESULT SciterCallScriptingFunction( HELEMENT he, LPCSTR name, const VALUE* argv, UINT argc, VALUE* retval ) { return SAPI().SciterCallScriptingFunction( he,name,argv,argc,retval ); }
SCDOM_RESULT SciterEvalElementScript( HELEMENT he, LPCWSTR script, UINT scriptLength, VALUE* retval ) { return SAPI().SciterEvalElementScript( he, script, scriptLength, retval ); }
SCDOM_RESULT SciterAttachHwndToElement(HELEMENT he, HWINDOW hwnd) { return SAPI().SciterAttachHwndToElement(he,hwnd); }
SCDOM_RESULT SciterControlGetType( HELEMENT he, /*CTL_TYPE*/ UINT *pType ) { return SAPI().SciterControlGetType( he, pType ); }
SCDOM_RESULT SciterGetValue( HELEMENT he, VALUE* pval ) { return SAPI().SciterGetValue( he,pval ); }
SCDOM_RESULT SciterSetValue( HELEMENT he, const VALUE* pval ) { return SAPI().SciterSetValue( he, pval ); }
SCDOM_RESULT SciterGetExpando( HELEMENT he, VALUE* pval, BOOL forceCreation ) { return SAPI().SciterGetExpando( he, pval, forceCreation ); }
SCDOM_RESULT SciterGetObject( HELEMENT he, tiscript_value* pval, BOOL forceCreation ) { return SAPI().SciterGetObject( he, pval, forceCreation ); }
SCDOM_RESULT SciterGetElementNamespace(  HELEMENT he, tiscript_value* pval) { return SAPI().SciterGetElementNamespace( he,pval); }
SCDOM_RESULT SciterGetHighlightedElement(HWINDOW hwnd, HELEMENT* phe) { return SAPI().SciterGetHighlightedElement(hwnd, phe); }
SCDOM_RESULT SciterSetHighlightedElement(HWINDOW hwnd, HELEMENT he) { return SAPI().SciterSetHighlightedElement(hwnd,he); }
SCDOM_RESULT SciterNodeAddRef(HNODE hn) { return SAPI().SciterNodeAddRef(hn); }
SCDOM_RESULT SciterNodeRelease(HNODE hn) { return SAPI().SciterNodeRelease(hn); }
SCDOM_RESULT SciterNodeCastFromElement(HELEMENT he, HNODE* phn) { return SAPI().SciterNodeCastFromElement(he,phn); }
SCDOM_RESULT SciterNodeCastToElement(HNODE hn, HELEMENT* he) { return SAPI().SciterNodeCastToElement(hn,he); }
SCDOM_RESULT SciterNodeFirstChild(HNODE hn, HNODE* phn) { return SAPI().SciterNodeFirstChild(hn,phn); }
SCDOM_RESULT SciterNodeLastChild(HNODE hn, HNODE* phn) { return SAPI().SciterNodeLastChild(hn, phn); }
SCDOM_RESULT SciterNodeNextSibling(HNODE hn, HNODE* phn) { return SAPI().SciterNodeNextSibling(hn, phn); }
SCDOM_RESULT SciterNodePrevSibling(HNODE hn, HNODE* phn) { return SAPI().SciterNodePrevSibling(hn,phn); }
SCDOM_RESULT SciterNodeParent(HNODE hnode, HELEMENT* pheParent) { return SAPI().SciterNodeParent(hnode,pheParent) ; }
SCDOM_RESULT SciterNodeNthChild(HNODE hnode, UINT n, HNODE* phn) { return SAPI().SciterNodeNthChild(hnode,n,phn); }
SCDOM_RESULT SciterNodeChildrenCount(HNODE hnode, UINT* pn) { return SAPI().SciterNodeChildrenCount(hnode, pn); }
SCDOM_RESULT SciterNodeType(HNODE hnode, UINT* pNodeType /*NODE_TYPE*/) { return SAPI().SciterNodeType(hnode,pNodeType); }
SCDOM_RESULT SciterNodeGetText(HNODE hnode, LPCWSTR_RECEIVER rcv, LPVOID rcv_param) { return SAPI().SciterNodeGetText(hnode,rcv,rcv_param); }
SCDOM_RESULT SciterNodeSetText(HNODE hnode, LPCWSTR text, UINT textLength) { return SAPI().SciterNodeSetText(hnode,text,textLength); }
SCDOM_RESULT SciterNodeInsert(HNODE hnode, UINT where /*NODE_INS_TARGET*/, HNODE what) { return SAPI().SciterNodeInsert(hnode,where,what); }
SCDOM_RESULT SciterNodeRemove(HNODE hnode, BOOL finalize) { return SAPI().SciterNodeRemove(hnode,finalize); }
SCDOM_RESULT SciterCreateTextNode(LPCWSTR text, UINT textLength, HNODE* phnode) { return SAPI().SciterCreateTextNode(text,textLength,phnode); }
SCDOM_RESULT SciterCreateCommentNode(LPCWSTR text, UINT textLength, HNODE* phnode) { return SAPI().SciterCreateCommentNode(text,textLength,phnode); }

HVM SciterGetVM( HWINDOW hwnd )  { return SAPI().SciterGetVM(hwnd); }

UINT ValueInit ( VALUE* pval ) { return SAPI().ValueInit(pval); }
UINT ValueClear ( VALUE* pval ) { return SAPI().ValueClear(pval); } 
UINT ValueCompare ( const VALUE* pval1, const VALUE* pval2 ) { return SAPI().ValueCompare(pval1,pval2); }
UINT ValueCopy ( VALUE* pdst, const VALUE* psrc ) { return SAPI().ValueCopy(pdst, psrc); }
UINT ValueIsolate ( VALUE* pdst ) { return SAPI().ValueIsolate(pdst); }
UINT ValueType ( const VALUE* pval, UINT* pType, UINT* pUnits ) { return SAPI().ValueType(pval,pType,pUnits); }
UINT ValueStringData ( const VALUE* pval, LPCWSTR* pChars, UINT* pNumChars ) { return SAPI().ValueStringData(pval,pChars,pNumChars); }
UINT ValueStringDataSet ( VALUE* pval, LPCWSTR chars, UINT numChars, UINT units ) { return SAPI().ValueStringDataSet(pval, chars, numChars, units); }
UINT ValueIntData ( const VALUE* pval, INT* pData ) { return SAPI().ValueIntData ( pval, pData ); }
UINT ValueIntDataSet ( VALUE* pval, INT data, UINT type, UINT units ) { return SAPI().ValueIntDataSet ( pval, data,type,units ); }
UINT ValueInt64Data ( const VALUE* pval, INT64* pData ) { return SAPI().ValueInt64Data ( pval,pData ); }
UINT ValueInt64DataSet ( VALUE* pval, INT64 data, UINT type, UINT units ) { return SAPI().ValueInt64DataSet ( pval,data,type,units ); }
UINT ValueFloatData ( const VALUE* pval, FLOAT_VALUE* pData ) { return SAPI().ValueFloatData ( pval,pData ); }
UINT ValueFloatDataSet ( VALUE* pval, FLOAT_VALUE data, UINT type, UINT units ) { return SAPI().ValueFloatDataSet ( pval,data,type,units ); }
UINT ValueBinaryData ( const VALUE* pval, LPCBYTE* pBytes, UINT* pnBytes ) { return SAPI().ValueBinaryData ( pval,pBytes,pnBytes ); }
UINT ValueBinaryDataSet ( VALUE* pval, LPCBYTE pBytes, UINT nBytes, UINT type, UINT units ) { return SAPI().ValueBinaryDataSet ( pval,pBytes,nBytes,type,units ); }
UINT ValueElementsCount ( const VALUE* pval, INT* pn) { return SAPI().ValueElementsCount ( pval,pn); }
UINT ValueNthElementValue ( const VALUE* pval, INT n, VALUE* pretval) { return SAPI().ValueNthElementValue ( pval, n, pretval); }
UINT ValueNthElementValueSet ( VALUE* pval, INT n, const VALUE* pval_to_set) { return SAPI().ValueNthElementValueSet ( pval,n,pval_to_set); }
UINT ValueNthElementKey ( const VALUE* pval, INT n, VALUE* pretval) { return SAPI().ValueNthElementKey ( pval,n,pretval); }
UINT ValueEnumElements ( VALUE* pval, KeyValueCallback* penum, LPVOID param) { return SAPI().ValueEnumElements (pval,penum,param); }
UINT ValueSetValueToKey ( VALUE* pval, const VALUE* pkey, const VALUE* pval_to_set) { return SAPI().ValueSetValueToKey ( pval, pkey, pval_to_set); }
UINT ValueGetValueOfKey ( const VALUE* pval, const VALUE* pkey, VALUE* pretval) { return SAPI().ValueGetValueOfKey ( pval, pkey,pretval); }
UINT ValueToString ( VALUE* pval, UINT how ) { return SAPI().ValueToString ( pval,how ); }
UINT ValueFromString ( VALUE* pval, LPCWSTR str, UINT strLength, UINT how ) { return SAPI().ValueFromString ( pval, str,strLength,how ); }
UINT ValueInvoke ( VALUE* pval, VALUE* pthis, UINT argc, const VALUE* argv, VALUE* pretval, LPCWSTR url) { return SAPI().ValueInvoke ( pval, pthis, argc, argv, pretval, url); }
UINT ValueNativeFunctorSet ( VALUE* pval, NATIVE_FUNCTOR_VALUE* pnfv) { return SAPI().ValueNativeFunctorSet ( pval, pnfv); }
BOOL ValueIsNativeFunctor ( const VALUE* pval) { return SAPI().ValueIsNativeFunctor (pval); }

// conversion between script (managed) value and the VALUE ( com::variant alike thing )
BOOL Sciter_v2V(HVM vm, const tiscript_value script_value, VALUE* out_value, BOOL isolate) { return SAPI().Sciter_v2V(vm,script_value,out_value, isolate); }
BOOL Sciter_V2v(HVM vm, const VALUE* value, tiscript_value* out_script_value) { return SAPI().Sciter_V2v(vm,value,out_script_value); }

// added by midi, not present in official SDK
UINT_PTR SciterPostCallback(HWINDOW hwnd, UINT_PTR wparam, UINT_PTR lparam, UINT timeoutms) { return SAPI().SciterPostCallback(hwnd, wparam, lparam, timeoutms); }
