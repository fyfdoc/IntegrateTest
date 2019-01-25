// CyTestCaseLib.h : main header file for the CyTestCaseLib DLL
//

#pragma once

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols


// CCyTestCaseLibApp
// See CyTestCaseLib.cpp for the implementation of this class
//

class CCyTestCaseLibApp : public CWinApp
{
public:
	CCyTestCaseLibApp();

// Overrides
public:
	virtual BOOL InitInstance();

	DECLARE_MESSAGE_MAP()
};
