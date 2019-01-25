/*******************************************************************************
* COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
********************************************************************************
* 文件名称:  TestCaseFuncs.h
* 功    能:  用于测试脚本的函数接口
* 版    本:  V0.1
* 编写日期:  2009/01/17
* 说    明:
* 修改历史:
* 001 2009/01/17  刘博强 文件创建
*******************************************************************************/


/******************************** 头文件保护开头 ******************************/
#ifndef TESTCASE_FUNCS_H
#define TESTCASE_FUNCS_H
/******************************** 包含文件声明 ********************************/
#define TESTCASE_SCRIPT_ERRBASE                                    -100
#define TESTCASE_FILETRANS_ERRBASE                                 -200
#define TESTCASE_EXECUTECMD_ERRBASE                                -300

/******************************** 宏和常量定义 ********************************/

#define DllImport   __declspec( dllimport )
#define DllExport   __declspec( dllexport )


/* 自定义数据类型 */
typedef unsigned int            u32;
/* 自定义数据类型 */
typedef unsigned short          u16;
/* 自定义数据类型 */
typedef unsigned char           u8;
/* 自定义数据类型 */
typedef int                     s32;
/* 自定义数据类型 */
typedef signed short            s16;
/* 自定义数据类型 */
typedef signed char             s8;
/* 自定义数据类型 */
typedef volatile unsigned short vu16;

#ifdef __cplusplus
extern "C" { 
#endif

typedef void (*TESTCASE_OUTPUT_FUNC)(u8* pu8OutputMsg, s32 s32OutputMsgType, s32 s32DebugLevel);
typedef void (*TESTCASE_ALERT_FUNC)(u8* pu8AlertInfo);
typedef s32 (*TESTCASE_CONFIRM_FUNC)(u8* pu8ConfirmInfo);

#define TESTCASE_EXECUTECMD_PARATYPE_NUMBER        1
#define TESTCASE_EXECUTECMD_PARATYPE_BUFFER        2

typedef struct tag_STRU_TESTCASE_EXECUTECMD_PARAS
{ 
	s32  s32ParaType; /* 参数类型：数值/数据缓冲区 */ 
	s32  s32ParaVal;  /* 数值/数据缓冲区长度  */ 
	void *pParaBuf;   /* 数据缓冲区首地址 */
}STRU_TESTCASE_EXECUTECMD_PARAS;


/******************************** 函数定义 ************************************/
/* 库初始化函数 */
extern DllImport s32 TestCase_Init();
/* 登陆 */
extern DllImport s32 TestCase_RegisterTargetProc(const u8* pu8ProcName, 
												 const u8* pu8ProcIpAddr);
extern DllImport s32 TestCase_RegisterTargetProc_Pid(const u8* pu8ProcName, 
												 const u8* pu8ProcIpAddr,
												 int s32Pid,
												 s32 s32SlotNum=0, 
												 s32 s32ProcId=0);
/* 登陆 */
extern DllImport s32 TestCase_RegisterTargetProc_Ex(const u8* pu8ProcName, 
												    const u8* pu8ProcIpAddr);

/* chaiye 2017-10-18 新增接口，因板卡的使用端口不同，考虑到兼容性，增加此接口 */
/* 端口默认10021,适用于BPOK、SCTF ，此接口调用仍可使用TestCase_RegisterTargetProc_Ex*/
/* AAU使用10001，可使用此接口 */
extern DllImport s32 TestCase_RegisterTargetProc_Ex_CfgPort(const u8* pu8ProcName, 
													const u8* pu8ProcIpAddr,int nPort);
/* 登陆Udp */
extern DllImport s32 TestCase_RegisterTargetProc_Udp(const u8* pu8ProcName, 
													 const u8* pu8ProcIpAddr);

/* 仅登陆TestCase,供"OldStyle"调用 */
extern DllImport s32 TestCase_RegisterTargetProc_Ex2(const u8* pu8ProcName,
													 const u8* pu8ProcIpAddr);

/* 设置连接重试次数 */
extern DllImport s32 TestCase_SetRegisterTargetProcRetryTimes(u32 u32Times);

/* 退出 */
extern DllImport s32 TestCase_UnregisterTargetProc(const u8* pu8ProcName, 
												   const u8* pu8ProcIpAddr);
extern DllImport s32 TestCase_UnregisterTargetProc_Pid(const u8* pu8ProcName, 
												   const u8* pu8ProcIpAddr,
												   int s32Pid);
/* 下载文件 */
extern DllImport s32 TestCase_DownloadFile(const u8* pu8ProcName, 
										   const u8* pu8PCFilePath, 
										   const u8* pu8BoardFilePath, 
										   s32 s32Load,s32 s32Inflate);
/* 上传文件 */
extern DllImport s32 TestCase_UploadFile(const u8* pu8ProcName, 
										 const u8* pu8PCFilePath, 
										 const u8* pu8BoardFilePath);
/* 配置日志路径 old */
extern DllImport s32 TestCase_SetReportFile(const u8* pu8ReportFile);
/* 配置已编译脚本 old */
extern DllImport s32 TestCase_SetCompiledScriptFile(const u8* pu8CompiledScriptFile);
/* 配置源脚本 old */
extern DllImport s32 TestCase_SetSrcScriptFile(const u8* pu8SrcScriptFile);
/* 执行所有测试用例 old */
extern DllImport s32 TestCase_RunTestCaseScript(void);
/* 执行一个测试用例，返回用例执行结果 old */
extern DllImport s32 TestCase_RunOneTestCase(const u8* pu8TestCaseName);

/* 注册调试输出函数 */
extern DllImport s32 TestCase_RegisterOutputFunc(TESTCASE_OUTPUT_FUNC pTestCaseOutputFunc);
/* 注册Alert函数 */
extern DllImport s32 TestCase_RegisterAlertFunc(TESTCASE_ALERT_FUNC pTestCaseAlertFunc);
/* 注册Confirm函数 */
extern DllImport s32 TestCase_RegisterConfirmFunc(TESTCASE_CONFIRM_FUNC pTestCaseConfirmFunc);
/* 开启部分执行模式 old */
extern DllImport s32 TestCase_EnableFilterMode(void);
/* 关闭部分执行模式 old */
extern DllImport s32 TestCase_DisableFilterMode(void);
/* 重置部分执行模式过滤规则 old */
extern DllImport s32 TestCase_ResetFilter(void);
/* 添加测试用例到部分执行模式规则 old */
extern DllImport s32 TestCase_ActiveTestCase(const u8* pstrTestCase);
/* 获取已编译脚本文件中的测试用例名称 old */
extern DllImport s32 TestCase_GetTestCaseName(u32 u32StartLine, 
											  u8* pstrTestCaseName, 
											  u32 u32BufLen);
/* 重新生成已编译的脚本文件 old */
extern DllImport s32 TestCase_RegenerateCompiledScriptFile(const u8* pu8FileName);
/* 增量加载脚本 old */
extern DllImport s32 TestCase_AppendCompiledTestCaseScriptFile(const u8* pu8FileName);
/* 重新加载脚本 old */
extern DllImport s32 TestCase_ReloadCompiledTestCaseScriptFile(const u8* pu8FileName);

/* 执行测试命令 */
extern DllImport s32 TestCase_ExcuteCmd(const u8 *pu8ProcName, 
										const u8 *pu8Funcname, 
										STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas, 
										u32 u32ParaNum, 
										s32 *ps32RetVal);

extern DllImport s32 TestCase_ExcuteCmd_Ex(const u8 *pu8ProcName, 
										   const u8 *pu8Funcname, 
										   STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas, 
										   u32 u32ParaNum, 
										   s32 *ps32RetVal,
										   u32 *pu32SymbolAddr);

extern DllImport s32 TestCase_ExecuteCmd_Addr(const u8 *pu8ProcName,
											  u32 u32FuncAddr,
											  STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas, 
											  u32 u32ParaNum, 
											  s32 *ps32RetVal);

/* 执行测试命令功能系列 */
extern DllImport s32 TestCase_ExecuteCmd_Series(s32 s32Series,
												const u8 *pu8ProcName,
												const u8 *pu8Funcname,
												u32 u32FuncAddr,
												STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas, 
												u32 u32ParaNum, 
												s32 *ps32RetVal);

/* 复位任务 */
extern DllImport s32 TestCase_RestartExecuteTask(const u8 *pu8ProcName);

/* 设置任务优先级 */
extern DllImport s32 TestCase_SetExecuteTaskPrio(const u8 *pu8ProcName, u32 u32Prio);

/* 设置命令超时时间 */
extern DllImport s32 TestCase_SetCmdTimeOut(u32 u32CmdTimeOutSec);

/* 获取当前连接状态 */
extern DllImport s32 TestCase_GetConnState(const u8 *pu8ProcName);

/* 向测试日志添加输出信息 */
extern DllImport s32 TestCase_LogMsg(u8* pu8OutputMsg);

/* 等待板卡端消息 */
extern DllImport s32 TestCase_WaitRemoteData(u32 u32BufferSize, u32 u32SecTimeOut, u8* pu8ProcFrom, u8* pu8Data, u32* pu32ReceivedSize);

#ifdef __cplusplus
}
#endif

/******************************** 头文件保护结尾 ******************************/

#endif /* TESTCASE_FUNCS_H */
/******************************** 头文件结束 **********************************/









