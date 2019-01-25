// CyTestCaseDemoDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "CyTestCaseDemo.h"
#include "CyTestCaseDemoDlg.h"
#include ".\cytestcasedemodlg.h"

#include "..\include\TestCaseFuncs.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CCyTestCaseDemoDlg 对话框



CCyTestCaseDemoDlg::CCyTestCaseDemoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CCyTestCaseDemoDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CCyTestCaseDemoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CCyTestCaseDemoDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
	ON_BN_CLICKED(IDC_BUTTON1, OnBnClickedButton1)
	ON_BN_CLICKED(IDC_BUTTON2, OnBnClickedButton2)
	ON_BN_CLICKED(IDC_BUTTON3, OnBnClickedButton3)
	ON_BN_CLICKED(IDC_BUTTON4, OnBnClickedButton4)
	ON_BN_CLICKED(IDC_BUTTON5, OnBnClickedButton5)
	ON_BN_CLICKED(IDC_BUTTON6, OnBnClickedButton6)
	ON_BN_CLICKED(IDC_BUTTON7, OnBnClickedButton7)
	ON_BN_CLICKED(IDC_BUTTON8, OnBnClickedButton8)
END_MESSAGE_MAP()


// CCyTestCaseDemoDlg 消息处理程序

BOOL CCyTestCaseDemoDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// 将\“关于...\”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	
	ContentInit();
	return TRUE;  // 除非设置了控件的焦点，否则返回 TRUE
}

void CCyTestCaseDemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CCyTestCaseDemoDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标显示。
HCURSOR CCyTestCaseDemoDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CCyTestCaseDemoDlg::OnBnClickedOk()
{
	CString strProcName("");
	CString strCmd("");
	CString strIp("");
	CString strPid("");
	GetDlgItem(IDC_EDIT_NAME)->GetWindowText(strProcName);
	GetDlgItem(IDC_EDIT_CMD)->GetWindowText(strCmd);
	GetDlgItem(IDC_IPADDRESS1)->GetWindowText(strIp);
	GetDlgItem(IDC_EDIT_PID)->GetWindowText(strPid);
	ExecuteCmd(strProcName,strIp,strCmd,strPid);
	//OnOK();//不退出
}

// 调用接口测试
void CCyTestCaseDemoDlg::ExecuteCmd(CString strProcName,CString strIp,CString strCmd,CString strPid)
{
	int result = TestCase_Init();
	CString t1("");
	t1.Format("TestCase_Init:%d\n",result);
	TRACE(t1);

	int nPid = atoi(strPid);
	result = TestCase_RegisterTargetProc_Pid((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer(),nPid);
	CString t2("");
	t2.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t2);

	int s32RetVal = 0;
	//strCmd = "fdd_hal_epld_write 0x16,0x4c";
    result = TestCase_ExcuteCmd((const u8*)strProcName.GetBuffer(),(const u8*)strCmd.GetBuffer(),NULL,0,&s32RetVal);
	CString t3("");
	t3.Format("TestCase_ExcuteCmd:return %d  value %d\n",result,s32RetVal);
	TRACE(t3);

	result = TestCase_UnregisterTargetProc_Pid((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer(),nPid);
	CString t4("");
	t4.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t4);
}

// 常用信息初始化
void CCyTestCaseDemoDlg::ContentInit()
{
	GetDlgItem(IDC_EDIT_NAME)->SetWindowText("SCTF");
	GetDlgItem(IDC_IPADDRESS1)->SetWindowText("");
	GetDlgItem(IDC_EDIT_CMD)->SetWindowText("");//"fdd_hal_epld_read"
	GetDlgItem(IDC_EDIT_PCPATH)->SetWindowText("D:\\ChaiyeTestCase\\a.so"); // 自我测试
	GetDlgItem(IDC_EDIT_BOARDPATH)->SetWindowText("/ramDisk/a.so"); // 必须是/ 如果是\\则信令ok但是没有放到ramDisk上
}

// 循环执行
void CCyTestCaseDemoDlg::OnBnClickedButton1()
{
	CString strNum("");
	GetDlgItem(IDC_EDIT_NUM)->GetWindowText(strNum);
	int nNum = atoi(strNum.GetBuffer());

	CString strProcName("");
	CString strCmd("");
	CString strIp("");
	GetDlgItem(IDC_EDIT_NAME)->GetWindowText(strProcName);
	GetDlgItem(IDC_EDIT_CMD)->GetWindowText(strCmd);
	GetDlgItem(IDC_IPADDRESS1)->GetWindowText(strIp);

	int result = TestCase_Init();
	CString t1("");
	t1.Format("TestCase_Init:%d\n",result);
	TRACE(t1);

	for(int i = 0;i<nNum;i++)
	{
		Sleep(1000);//我的测试程序
		TRACE("\n\n\n%d\n",i);
		result = TestCase_RegisterTargetProc_Ex((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
		CString t2("");
		t2.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
		TRACE(t2);

		int s32RetVal = 0;
		//strCmd = "fdd_hal_epld_write 0x16,0x4c";
		result = TestCase_ExcuteCmd((const u8*)strProcName.GetBuffer(),(const u8*)strCmd.GetBuffer(),NULL,0,&s32RetVal);
		CString t3("");
		t3.Format("TestCase_ExcuteCmd:return %d  value %d\n",result,s32RetVal);
		TRACE(t3);

		result = TestCase_UnregisterTargetProc((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
		CString t4("");
		t4.Format("TestCase_UnregisterTargetProc:%d\n",result);
		TRACE(t4);
	}
}

void CCyTestCaseDemoDlg::OnBnClickedButton2()
{
	CString strProcName("");
	CString strIp("");
	GetDlgItem(IDC_EDIT_NAME)->GetWindowText(strProcName);
	GetDlgItem(IDC_IPADDRESS1)->GetWindowText(strIp);

	int result = TestCase_Init();
	CString t1("");
	t1.Format("TestCase_Init:%d\n",result);
	TRACE(t1);

	result = TestCase_RegisterTargetProc_Ex((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	CString t2("");
	t2.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t2);

	result = TestCase_SetExecuteTaskPrio((const u8*)strProcName.GetBuffer(),52);
	CString t3("");
	t3.Format("TestCase_SetExecuteTaskPrio:%d\n",result);
	TRACE(t3);

	result = TestCase_UnregisterTargetProc((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	CString t4("");
	t4.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t4);
	
}

// 模拟两个板卡测试
void CCyTestCaseDemoDlg::OnBnClickedButton3()
{
	CString strPro1("SCTF");
	CString strPro2("BPOI");//246.6
	CString strIP1("172.27.245.92");
	CString strIP2("172.27.246.6");
	CString strCmd("i");

	int result = TestCase_Init();
	CString t("");
	t.Format("TestCase_Init:%d\n",result);
	TRACE(t);

	result = TestCase_RegisterTargetProc_Ex((const u8*)strPro1.GetBuffer(),(const u8*)strIP1.GetBuffer());
	t.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t);

	result = TestCase_RegisterTargetProc_Ex((const u8*)strPro2.GetBuffer(),(const u8*)strIP2.GetBuffer());
	t.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t);

	/*result = TestCase_SetExecuteTaskPrio((const u8*)strProcName.GetBuffer(),52);
	CString t3("");
	t3.Format("TestCase_SetExecuteTaskPrio:%d\n",result);
	TRACE(t3);*/

	result = TestCase_UnregisterTargetProc((const u8*)strPro1.GetBuffer(),(const u8*)strIP1.GetBuffer());
	t.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t);

	result = TestCase_UnregisterTargetProc((const u8*)strPro2.GetBuffer(),(const u8*)strIP2.GetBuffer());
	t.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t);
}

// 上传测试
void CCyTestCaseDemoDlg::OnBnClickedButton4()
{
	CString strPath("");
	GetDlgItem(IDC_EDIT_PCPATH )->GetWindowText(strPath);
	CString strBoardPath("");
	GetDlgItem(IDC_EDIT_BOARDPATH )->GetWindowText(strBoardPath);

	CString strProcName("");
	CString strIp("");
	GetDlgItem(IDC_EDIT_NAME)->GetWindowText(strProcName);
	GetDlgItem(IDC_IPADDRESS1)->GetWindowText(strIp);

	

	int result = TestCase_Init();
	CString t("");
	t.Format("TestCase_Init:%d\n",result);
	TRACE(t);

	result = TestCase_RegisterTargetProc_Ex((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t);

	result = TestCase_UploadFile((const u8*)strProcName.GetBuffer(),(const u8*)strPath.GetBuffer(),(const u8*)strBoardPath.GetBuffer());
	t.Format("TestCase_UploadFile:%d\n",result);
	TRACE(t);

	result = TestCase_UnregisterTargetProc((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t);

}

// 下载测试
void CCyTestCaseDemoDlg::OnBnClickedButton5()
{
	CString strPath("");
	GetDlgItem(IDC_EDIT_PCPATH )->GetWindowText(strPath);
	CString strBoardPath("");
	GetDlgItem(IDC_EDIT_BOARDPATH )->GetWindowText(strBoardPath);

	CString strProcName("");
	CString strIp("");
	GetDlgItem(IDC_EDIT_NAME)->GetWindowText(strProcName);
	GetDlgItem(IDC_IPADDRESS1)->GetWindowText(strIp);

	int result = TestCase_Init();
	CString t("");
	t.Format("TestCase_Init:%d\n",result);
	TRACE(t);

	result = TestCase_RegisterTargetProc_Ex((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t);

	result = TestCase_DownloadFile((const u8*)strProcName.GetBuffer(),(const u8*)strPath.GetBuffer(),(const u8*)strBoardPath.GetBuffer(),0,0);
	t.Format("TestCase_DownloadFile:%d\n",result);
	TRACE(t);

	result = TestCase_UnregisterTargetProc((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t);
	
}

//
//  AAU读Eeprom
//
void CCyTestCaseDemoDlg::OnBnClickedButton6()
{
	CString strProcName("AIU");
	CString strIp("172.27.45.250");
	CString strCmd("Product_Test_Rru_Read_Eeprom");
	int nParaNum = 5;

	int result = TestCase_Init();
	CString t("");
	t.Format("TestCase_Init:%d\n",result);
	TRACE(t);

	result = TestCase_RegisterTargetProc_Ex((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t);

	int nRetVal = 0;

	

    STRU_TESTCASE_EXECUTECMD_PARAS para[32];
	memset(para,0,sizeof(STRU_TESTCASE_EXECUTECMD_PARAS)*32);
	//#define TESTCASE_EXECUTECMD_PARATYPE_NUMBER        1
    //#define TESTCASE_EXECUTECMD_PARATYPE_BUFFER        2



	char buff1[4096];
	char buff2[4096];
	char buff3[4096];
	char buff4[4096];
	memset(buff1,0,4096);
	memset(buff2,0,4096);
	memset(buff3,0,4096);
	memset(buff4,0,4096);

	/////////////////////////////////////////////////////////////////
	// 第一次
	para[0].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[0].s32ParaVal = 99;

	para[1].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[1].s32ParaVal = 0;

	para[2].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[2].s32ParaVal = 0;

	para[3].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[3].s32ParaVal = 4096;

	para[4].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_BUFFER;
	para[4].s32ParaVal = 4096;
	para[4].pParaBuf = buff1;
	
	result = TestCase_ExcuteCmd((const u8*)strProcName.GetBuffer(),(const u8*)strCmd.GetBuffer(),para,nParaNum,&nRetVal);
	t.Format("TestCase_ExcuteCmd:%d\n",result);
	TRACE(t);

	/////////////////////////////////////////////////////////////////
	// 第二次
	para[0].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[0].s32ParaVal = 99;

	para[1].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[1].s32ParaVal = 0;

	para[2].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[2].s32ParaVal = 4096*1;

	para[3].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[3].s32ParaVal = 4096;

	para[4].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_BUFFER;
	para[4].s32ParaVal = 4096;
	para[4].pParaBuf = buff2;

	result = TestCase_ExcuteCmd((const u8*)strProcName.GetBuffer(),(const u8*)strCmd.GetBuffer(),para,nParaNum,&nRetVal);
	t.Format("TestCase_ExcuteCmd:%d\n",result);
	TRACE(t);

	/////////////////////////////////////////////////////////////////
	// 第三次
	para[0].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[0].s32ParaVal = 99;

	para[1].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[1].s32ParaVal = 0;

	para[2].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[2].s32ParaVal = 4096*2;

	para[3].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[3].s32ParaVal = 4096;

	para[4].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_BUFFER;
	para[4].s32ParaVal = 4096;
	para[4].pParaBuf = buff3;

	result = TestCase_ExcuteCmd((const u8*)strProcName.GetBuffer(),(const u8*)strCmd.GetBuffer(),para,nParaNum,&nRetVal);
	t.Format("TestCase_ExcuteCmd:%d\n",result);
	TRACE(t);

	/////////////////////////////////////////////////////////////////
	// 第四次
	para[0].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[0].s32ParaVal = 99;

	para[1].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[1].s32ParaVal = 0;

	para[2].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[2].s32ParaVal = 4096*3;

	para[3].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_NUMBER;
	para[3].s32ParaVal = 4096;

	para[4].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_BUFFER;
	para[4].s32ParaVal = 4096;
	para[4].pParaBuf = buff4;

	result = TestCase_ExcuteCmd((const u8*)strProcName.GetBuffer(),(const u8*)strCmd.GetBuffer(),para,nParaNum,&nRetVal);
	t.Format("TestCase_ExcuteCmd:%d\n",result);
	TRACE(t);


	result = TestCase_UnregisterTargetProc((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t);
}

// 测试CMD命令
void CCyTestCaseDemoDlg::OnBnClickedButton7()
{
	CString strProcName("SCTF");
	CString strIp("172.27.245.92");
	CString strCmd("cmd");
	

	int result = TestCase_Init();
	CString t("");
	t.Format("TestCase_Init:%d\n",result);
	TRACE(t);

	result = TestCase_RegisterTargetProc_Ex((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_RegisterTargetProc_Ex:%d\n",result);
	TRACE(t);

	int nRetVal = 0;



	STRU_TESTCASE_EXECUTECMD_PARAS para[32];
	memset(para,0,sizeof(STRU_TESTCASE_EXECUTECMD_PARAS)*32);
	//#define TESTCASE_EXECUTECMD_PARATYPE_NUMBER        1
	//#define TESTCASE_EXECUTECMD_PARATYPE_BUFFER        2



	char buff1[4096];
	memset(buff1,0,4096);
	
	//CString strTemp("ls /flashDev");
	CString strTemp("reboot");
	//CString strTemp("./firmware/upgrade_bios/firmware/spi_image_HV5.bin.");//这个命令我觉得是那个人写错了
	strcat(buff1,strTemp.GetBuffer());


	para[0].s32ParaType = TESTCASE_EXECUTECMD_PARATYPE_BUFFER;
	para[0].s32ParaVal = strTemp.GetLength();
	para[0].pParaBuf = buff1;

    int nParaNum = 1;
	result = TestCase_ExcuteCmd((const u8*)strProcName.GetBuffer(),(const u8*)strCmd.GetBuffer(),para,nParaNum,&nRetVal);
	t.Format("TestCase_ExcuteCmd:%d\n",result);
	TRACE(t);

	result = TestCase_UnregisterTargetProc((const u8*)strProcName.GetBuffer(),(const u8*)strIp.GetBuffer());
	t.Format("TestCase_UnregisterTargetProc:%d\n",result);
	TRACE(t);
}

// 动态加载测试  —— Bsp_Get_BoardType
typedef int(*lpFun_TestCase_Init)(void);
typedef int(*lpFun_TestCase_RegisterTargetProc_Ex)(const unsigned char*, const unsigned char*);
typedef int(*lpFun_TestCase_ExcuteCmd)(const unsigned char*pu8ProcName, const unsigned char*pu8Funcname,STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas,unsigned int u32ParaNum,int *ps32RetVal);

void CCyTestCaseDemoDlg::OnBnClickedButton8()
{
	HMODULE hModule = LoadLibrary("TestCaseLib.dll");
	lpFun_TestCase_Init fun_TestInit = (lpFun_TestCase_Init)GetProcAddress(hModule,"TestCase_Init");
	int nResult = fun_TestInit();
	TRACE("TestCase_Init %d\n",nResult);

	lpFun_TestCase_RegisterTargetProc_Ex fun_TestCase_RegisterTargetProc_Ex = (lpFun_TestCase_RegisterTargetProc_Ex)GetProcAddress(hModule,"TestCase_RegisterTargetProc_Ex");
	nResult = fun_TestCase_RegisterTargetProc_Ex((const unsigned char*)"SCTF",(const unsigned char*)"2001::11:5");
	TRACE("TestCase_RegisterTargetProc_Ex %d\n",nResult);

	lpFun_TestCase_ExcuteCmd fun_TestCase_ExcuteCmd = (lpFun_TestCase_ExcuteCmd)GetProcAddress(hModule,"TestCase_ExcuteCmd");
	int s32RetVal = 0;
	int* pType = new int;
	*pType = 0;
	STRU_TESTCASE_EXECUTECMD_PARAS para[32];
	memset(para,0,sizeof(STRU_TESTCASE_EXECUTECMD_PARAS)*32);
	para[0].s32ParaType = 2;//TESTCASE_EXECUTECMD_PARATYPE_BUFFER;
	para[0].s32ParaVal = sizeof(int);
	para[0].pParaBuf = (void*)pType; 
	nResult = fun_TestCase_ExcuteCmd((const unsigned char*)"SCTF",(const unsigned char*)"Bsp_Get_BoardType",para,1,&s32RetVal);
	TRACE("TestCase_ExcuteCmd %d\n",nResult);

	TRACE("END\n");
}

// 好用的测试命令
// Bsp_Monitor  无参数，OspStudio上可见硬件信息打印
// Bsp_Reboot  复位版本，有些板卡不支持，但是可以在OspStuido上看到错误原因
