#include "stdafx.h"
#include "WorkManager.h"
#include "FunctionDefine.h"

CWorkManager mgr;



// 初始化
extern "C" TESTCASE_DLL_API int TestCase_Init()
{
	int nResult = mgr.TestCaseLibInit();
	return nResult;
}

// 注册
extern "C" TESTCASE_DLL_API int TestCase_RegisterTargetProc_Ex(const u8* pu8ProcName, const u8* pu8ProcIpAddr)
{
	int nResult = mgr.TestCaseLibRegisterProc((char*)pu8ProcName,(char*)pu8ProcIpAddr,-1);
	return nResult;
}

// 注册
extern "C" TESTCASE_DLL_API int TestCase_RegisterTargetProc(const u8* pu8ProcName, const u8* pu8ProcIpAddr)
{
	// 有用_Ex的，纪松那边用不带Ex的
	// 不带EX的是服务都注册，带EX的是只注册信令和传输的
	int nResult = mgr.TestCaseLibRegisterProc((char*)pu8ProcName,(char*)pu8ProcIpAddr,-1);
	return nResult;
}

// 取消注册
extern "C" TESTCASE_DLL_API int TestCase_UnregisterTargetProc(const u8* pu8ProcName, const u8* pu8ProcIpAddr)
{
	int nResult = mgr.TestCaseLibUnRegisterProc((char*)pu8ProcName,(char*)pu8ProcIpAddr,-1);
	return nResult;
}

// 注册——增加pid参数
// 因为要导出，所以重命名为_Pid
extern "C" TESTCASE_DLL_API int TestCase_RegisterTargetProc_Pid(const u8* pu8ProcName, const u8* pu8ProcIpAddr, u32 u32Pid,s32 s32SlotNum, s32 s32ProcId)
{
	// 有用_Ex的，纪松那边用不带Ex的
	// 不带EX的是服务都注册，带EX的是只注册信令和传输的
	int nResult = mgr.TestCaseLibRegisterProc((char*)pu8ProcName,(char*)pu8ProcIpAddr,u32Pid,s32SlotNum, s32ProcId);
	return nResult;
}

// 取消注册——增加pid参数
extern "C" TESTCASE_DLL_API int TestCase_UnregisterTargetProc_Pid(const u8* pu8ProcName, const u8* pu8ProcIpAddr,u32 u32Pid)
{
	int nResult = mgr.TestCaseLibUnRegisterProc((char*)pu8ProcName,(char*)pu8ProcIpAddr,u32Pid);
	return nResult;
}

// 执行命令
extern "C" TESTCASE_DLL_API int TestCase_ExcuteCmd(const u8 *pu8ProcName, const u8 *pu8Funcname,STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas,u32 u32ParaNum,s32 *ps32RetVal)
{
	unsigned int u32SymbolAddr = 0;
	int nResult = mgr.TestCaseLibExcuteCmd((char*)pu8ProcName,(char*)pu8Funcname,pstruParas,u32ParaNum,ps32RetVal,&u32SymbolAddr);
	return nResult;
}

// EX就是对外多提供一个函数地址
// 2018.6.4 执行命令这一内容，其中的输出参数pu32SymbolAddr 可能受基站64位的影响
// 但输出参数ps32RetVal及pu32SymbolAddr并未见到使用
// 可以存在解决方法，从RSP1进行分析，后续不同处理
extern "C" TESTCASE_DLL_API int TestCase_ExcuteCmd_Ex(const u8 *pu8ProcName, const u8 *pu8Funcname,STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas,u32 u32ParaNum,s32 *ps32RetVal,u32 *pu32SymbolAddr)
{
	int nResult = mgr.TestCaseLibExcuteCmd((char*)pu8ProcName,(char*)pu8Funcname,pstruParas,u32ParaNum,ps32RetVal,pu32SymbolAddr);
	return nResult;
}

// 设置优先级
extern "C" TESTCASE_DLL_API int TestCase_SetExecuteTaskPrio(const u8 *pu8ProcName, u32 u32Prio)
{
	int nResult = mgr.TestCaseLibSetTaskPrio((char*)pu8ProcName,u32Prio);
	return nResult;
}

// 设置命令超时时间
extern "C" TESTCASE_DLL_API int TestCase_SetCmdTimeOut(u32 u32CmdTimeOutSec)
{
	int nResult = mgr.TestCaseLibSetCmdTimeOut(u32CmdTimeOutSec);//单位是秒，控制RSP1、RSP2的等待时间
	return nResult;
}

// 复位任务
extern "C" TESTCASE_DLL_API int TestCase_RestartExecuteTask(const u8 *pu8ProcName)
{
	int nResult = mgr.TestCaseLibRestartExecuteTask((char*)pu8ProcName);
	return nResult;
}


/* 下载文件 */
extern "C" TESTCASE_DLL_API int TestCase_DownloadFile(const u8* pu8ProcName, 
										   const u8* pu8PCFilePath, 
										   const u8* pu8BoardFilePath, 
										   s32 s32Load,s32 s32Inflate)
{
	int nResult = mgr.TestCaseLibDownloadFile((char*)pu8ProcName,(char*)pu8PCFilePath,(char*)pu8BoardFilePath,s32Load,s32Inflate);
	return nResult;
}
/* 上传文件 */
extern "C" TESTCASE_DLL_API int TestCase_UploadFile(const u8* pu8ProcName, 
										 const u8* pu8PCFilePath, 
										 const u8* pu8BoardFilePath)
{
	int nResult = mgr.TestCaseLibUploadFile((char*)pu8ProcName,(char*)pu8PCFilePath,(char*)pu8BoardFilePath);
	return nResult;
}

//注册调试输出函数
extern "C" TESTCASE_DLL_API int TestCase_RegisterOutputFunc(TESTCASE_OUTPUT_FUNC pTestCaseOutputFunc)
{
	int nResult = mgr.TestCaseLibRegisterOutputFunc(pTestCaseOutputFunc);
	return nResult;
}

// 临时接口，用于应对没有D盘的情况
// 需要在TestCase_Init之前调用，否则日志记录不了
// 末尾需要包含"\\"
extern "C" TESTCASE_DLL_API void TestCaseConfig_TempfilePath(char* csTempfilePath)
{
	mgr.TestCaseConfigTempfilePath(csTempfilePath);
}

// 设置FTP上传下载超时时间
extern "C" TESTCASE_DLL_API int TestCase_SetFtpTimeOut(u32 u32CmdTimeOutSec)
{
	int nResult = mgr.TestCaseLibSetFtpTimeOut(u32CmdTimeOutSec);//单位是秒，控制FTP上传下载的等待时间
	return nResult;
}