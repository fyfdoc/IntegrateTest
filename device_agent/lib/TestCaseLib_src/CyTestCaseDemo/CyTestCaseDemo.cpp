// CyTestCaseDemo.cpp : 定义应用程序的类行为。
//

#include "stdafx.h"
#include "CyTestCaseDemo.h"
#include "CyTestCaseDemoDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CCyTestCaseDemoApp

BEGIN_MESSAGE_MAP(CCyTestCaseDemoApp, CWinApp)
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()


// CCyTestCaseDemoApp 构造

CCyTestCaseDemoApp::CCyTestCaseDemoApp()
{
}


// 唯一的一个 CCyTestCaseDemoApp 对象

CCyTestCaseDemoApp theApp;


// CCyTestCaseDemoApp 初始化

BOOL CCyTestCaseDemoApp::InitInstance()
{
	// 如果一个运行在 Windows XP 上的应用程序清单指定要
	// 使用 ComCtl32.dll 版本 6 或更高版本来启用可视化方式，
	//则需要 InitCommonControls()。否则，将无法创建窗口。
	InitCommonControls();

	CWinApp::InitInstance();

	AfxEnableControlContainer();
	SetRegistryKey(_T("应用程序向导生成的本地应用程序"));

	CCyTestCaseDemoDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		
	}
	else if (nResponse == IDCANCEL)
	{
		
	}

	// 由于对话框已关闭，所以将返回 FALSE 以便退出应用程序，
	// 而不是启动应用程序的消息泵。
	return FALSE;
}
