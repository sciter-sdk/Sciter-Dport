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

module winkit.DropFileTarget;


mixin template DropFileTarget()
{
public:
	//-----------------------------------------------------------------------------
	// Function name	: RegisterDropTarget
	// Description	    : Registers whether a window accepts dropped files
	// Return type		: None
	// Parameter        : boolean indicator
	//					TRUE  - window accepts dropped files
	//					FALSE - window does not accept dropped files
	//-----------------------------------------------------------------------------
	void RegisterDropTarget(BOOL bAccept = TRUE)
	{
		import winkit.WinAPI;

		assert(IsWindow(wnd));

		// Turn the WS_EX_ACCEPTFILES style on or off based on the value of the
		// bAccept parameter
		DragAcceptFiles(wnd, bAccept);
		
		/*version(Windows7)
		{
			ChangeWindowMessageFilter(WM_DROPFILES, 1);
			ChangeWindowMessageFilter(WM_COPYDATA, 1);
			ChangeWindowMessageFilter(0x0049, 1);
		}*/
	}


private:

	//-----------------------------------------------------------------------------
	// Function name	: OnDropFiles
	// Description	    : Handler for WM_DROPFILES message
	// Return type		: LRESULT
	// Parameter        : 
	//-----------------------------------------------------------------------------
	void OnDropFiles(HDROP hDropInfo)
	{
		import winkit.WinAPI;

		// Get the count of the files dropped
		int nNumFiles = DragQueryFileW(hDropInfo, 0xFFFFFFFF, null, 0);

		// Get the path size
		UINT sz = DragQueryFileW(hDropInfo, 0, null, 0)+1;

		// Get the path of a single file that has been dropped
		wchar[] buffFilename = new wchar[sz];
		DragQueryFileW(hDropInfo, 0, buffFilename.ptr, sz);
		buffFilename.length = sz-1;// removes the \0

		// Release the memory that the system allocated for use in transferring file 
		// names to the application
		DragFinish(hDropInfo);

		// Call the function to process the file name
		string filepath = to!string(buffFilename.idup);
		ProcessFile(filepath, nNumFiles);
	}
}