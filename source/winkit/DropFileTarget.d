// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with sciter-dport. If not, see http://www.gnu.org/licenses/.

module winkit.DropFileTarget;


mixin template DropFileTarget()
{
public:
	import core.sys.windows.shellapi;

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
		assert(.IsWindow(wnd));

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
		// Get the count of the files dropped
		int nNumFiles = DragQueryFile(hDropInfo, 0xFFFFFFFF, null, 0);

		// Get the path size
		UINT sz = DragQueryFile(hDropInfo, 0, null, 0)+1;

		// Get the path of a single file that has been dropped
		TCHAR[] buffFilename = new TCHAR[sz];
		DragQueryFile(hDropInfo, 0, buffFilename.ptr, sz);
		buffFilename.length = sz-1;// removes the \0

		// Release the memory that the system allocated for use in transferring file 
		// names to the application
		DragFinish(hDropInfo);

		// Call the function to process the file name
		string filepath = to!string(buffFilename.idup);
		ProcessFile(filepath, nNumFiles);
	}
}