#pragma once

#include <WinSock2.h>
#include <map>
#include "FunctionDefine.h"
#include "MessageFormat.h"
#include "RecvPacketModel.h"
#include "ws2ipdef.h"

class CSockInfo
{
public:
	CSockInfo()
	{
		nPid = -1;// 保持原接口此值为-1
	}

	CString strIp;
	int nPid;
	int nPort;
	SOCKET sock;

	void SetPid(int nPidPara)
	{
		if(nPidPara<0)
		{
			nPid = -1;
			nPort = CONNECTTCPSERVER_PORT_NULL;
		}
		else
		{
			nPid = nPidPara;
			nPort = CONNECTTCPSERVER_PORT_OLD + 10*nPid;
		}
	}
};

class CWorkManager
{
public:
	CWorkManager(void);
	~CWorkManager(void);
	int TestCaseLibInit();
	// 2018-5-9 Start
	//int TestCaseLibRegisterProc(char* csProName,char* csIP);
	//int TestCaseLibUnRegisterProc(char* csProName,char* csIP);
	int TestCaseLibRegisterProc(char* csProName,char* csIP,s32 s32Pid, s32 s32SlutNum=0, s32 s32ProcId=0);
	int TestCaseLibUnRegisterProc(char* csProName,char* csIP, s32 s32Pid);

	int TestCaseLibExcuteCmd(char* csProName,char* csFunction,STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas,int nParaNum,int *pnRetVal,unsigned int *pu32SymbolAddr);
	int TestCaseLibSetTaskPrio(char* csProName,int nPrio);
	int TestCaseLibSetCmdTimeOut(u32 u32CmdTimeOutSec);// 参数为秒 RSP1 RSP2
	int TestCaseLibSetFtpTimeOut(u32 u32CmdTimeOutSec);// 参数为秒 FTP
	int TestCaseLibRestartExecuteTask(char* csProcName);
	int TestCaseLibDownloadFile(char* csProcName, char* csPCFilePath, char* csBoardFilePath, int nLoad,int nInflate);
	int TestCaseLibUploadFile(char* csProcName, char* csPCFilePath, char* csBoardFilePath);
	int TestCaseLibRegisterOutputFunc(TESTCASE_OUTPUT_FUNC pTestCaseOutputFunc);
	// 我增加的临时接口
	void TestCaseConfigTempfilePath(char* csTempfilePath);

private:

	TESTCASE_OUTPUT_FUNC g_pTestCaseOutputFunc;

	// 工作中的处理器管理
	//std::map<CString,CString> m_IpNameMap;//处理器IP和名字
	// 2018-5-10 Strat
	std::map<CString, CSockInfo> m_NameAddrMap;//<处理器名字，地址信息类>
	//std::map<CString,SOCKET> m_NameSockMap;//处理器名字和socket

	// 接收内容组包处理
	std::map<CString,CRecvPacketModel> m_NameDataMap;//<处理器名字，数据信息>

	// 响应及回复管理
	std::map<CString,UAGT_CMD_EXECUTE_RSP1> m_NameRsp1Map;//这个不用erase，实时更新就可以
	std::map<CString,UAGT_CMD_EXECUTE_RSP2_FORMAP> m_NameRsp2Map;// 不用erase
	std::map<CString,UAGT_FILE_TRANS_RSP> m_NameFileTransRspMap;

	// 通知的事件
	//HANDLE m_hLogonRspEvent;// logon 和 设置优先级的rsp,没法区分，全长20，消息长12，sigtype为1，cmdId是全f 
	                          //AAU的连服务和登录都不分,安全起见，信令都设为一个
	//HANDLE m_hServiceRspEvent;
	HANDLE m_hSigRspEvent;
    HANDLE m_hTaskRspEvent;// 设置任务优先级跟别的回应不一样 chaiye 20171122

	HANDLE m_hRsp1Event; // 其实我循环判断map也可以，理论上不会出现冲突
	HANDLE m_hRsp2Event;
	HANDLE m_hFileTransEvent;//文件传输 

	BOOL m_b64Bit; // 基站是否是64位系统

	FILE *m_pLog;

	HANDLE m_hRecvHandle;

	int m_nWaitTimeMSec; // 毫秒  等待RSP1 等待RSP2
	int m_nWaitTimeMSecForFtp;// 毫秒, 等待FTP上传或者下载，默认值为 WAIT_RSP_DOWNLOAD 10分钟

	CString m_strTempFilePath;// 日志存放和临时文件存放的位置,含结尾“\\”;
	CString m_strTransName;//填消息的是固定的文件名
	unsigned int m_nFileTransId;// 文件传输中用于消息配对

	CString m_strLogName;

	int SockInit();
	BOOL LogInit();
	BOOL MemberInit();// 成员清空
	BOOL RecvThreadStart();
	static DWORD WINAPI RecvThread(LPVOID lpParameter);	

	// 因为是等待的（不是异步的），所以即使多个板卡也是依次执行命令，同一时刻只会有一个在等消息
	// 此时收到的消息只会是这个板卡的

	// 传入IP，成功则返回socket，失败返回INVALID_SOCKET
	// 2018-5-9 ClientConnect增加参数nPort,nPort为0（CONNECTTCPSERVER_PORT_NULL），则还按原来的方式，两个端口轮换重复连接；如nPort非0,则只是用nPort指定端口
	SOCKET ClientConnect(CString strIP,int nPort, s32 s32SlotNum=0, s32 s32ProcId=0);
	BOOL ClientClose(SOCKET nSock);

    // 发送消息
	int SendMsg(CString strProName,char* pMsg, int nSendSize);
	// 接收消息
	void DealRecvBuff(CString strProcName,char* pData,int nDataLen);
	int DealMsg(CString strProcName,UAGENT_SIG_HEAD* pMsg);
	void RecvMsg();

	void Log(LOGENUM type,CString strInfo);
	void LogReset();// 文件大小判断，防止日志过大
	
    int SendMsg_LogOn(CString strProName);
    int SendMsg_ServReq(CString strProName,int nServiceId);// 发请求——可以执行命令
    int SendMsg_SetTaskPrio(CString strProName,int nPrio);
	// 只有ExecuteCmd是含等待处理的，其他的均在外面处理
	int SendMsg_ExecuteCmd(CString strProName,CString strFunction,STRU_TESTCASE_EXECUTECMD_PARAS *pstruParas,int nParaNum,int *pnRetVal,unsigned int *pu32SymbolAddr);
	int SendMsg_RestartTaskReq(CString strProName);
	// 根据下载、上传的不同填写
	int SendMsg_FileTransReq(CString strProName,CString strPCPath,CString strBoardPath,CString strFileName,int nTransAttr,int nFileLen,int nTransId);

	// 删除临时文件
	void DelTempFile();

	// 临界区
	CRITICAL_SECTION m_cs; 

	// 为兼容之前库的使用，由这个函数来确定是D盘还是C盘还是E盘，当然现在也支持设置
	void FindUseDisk();

	// 2018-5-10 检查地址是否已经使用
	BOOL AddrAlreadyInUse(CString strIp,int nPid);
	// 信息是否匹配
	BOOL IsInfoMatch(CString strProc,CString strIp,int nPid);
};
