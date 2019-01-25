#pragma once

#include "TestCaseTypeDef.h"

//--------------------TCP默认端口------------------------
//AAU BPOI SCTA SCTE
#define CONNECTTCPSERVER_PORT_OLD                      10001 
// SCTF BPOK
#define CONNECTTCPSERVER_PORT_NEW                      10021 
#define CONNECTTCPSERVER_PORT_NULL                     0 // 函数兼容之前
/*经了解*/ 

//---------------------数据结构---------------------------
#define SERVICE_CONTROL_SIGNAL 0 // 用0的太多了，又很乱,这个不知道啥意思，我用自己的了
//#define SERVICE_DATA_SIGNAL 0// 数据的不知道是啥

typedef struct 
{
	u32 u32ServiceId;
	u32 u32MsgSize;
}UAGENT_MSG_HEAD; // 通用


typedef struct
{
	UAGENT_MSG_HEAD  msgHead;
	u32              u32SigType;
}UAGENT_SIG_HEAD;// 信令 后面可能跟随信令


// 信令——登陆板卡请求
typedef struct
{
	UAGENT_SIG_HEAD  sigHead; /* u32SigType = 0 */ 
}UAGENT_SIG_LOGON_REQ;




/* 数据包类型(非控制信令) */
typedef struct 
{
	UAGENT_MSG_HEAD  msgHead;
	u32              u32TransId; 
}UAGENT_DATA_MSG; // 数据 // 后面跟随数据

typedef struct tag_STRU_CMD_EXCUTE_PARAS
{ 
	s32  s32ParaType;       /* 参数类型：数值/数据缓冲区 */ 
	s32  s32ParaVal;        /* 数值/数据缓冲区长度  */ 
	s32  s32ParaDataIndex;  /* 参数数据索引 */
	s32  s32ParaLen;        /* 参数长度     */
}STRU_CMD_EXCUTE_PARAS;// 长度为16

#define CMD_MAX_PARA_NUM 32 //最多10个参数，从消息结构看，最多可以32个


typedef struct
{
	UAGENT_SIG_HEAD         sigHead;//uagent头里是4，sigtype是5 能生效  
	u32                     u32CmdId;
	u32                     u32CmdAttr;
	u32                     u32ParaNum;
	STRU_CMD_EXCUTE_PARAS   struCmdPara[CMD_MAX_PARA_NUM];
	u32                     u32DataAreaLen;
}UAGT_CMD_EXECUTE_REQ_HEAD;

typedef struct
{
	UAGENT_SIG_HEAD         sigHead;//uagent头里是4，sigtype是5 能生效 // 我自己补充header
	u32                     u32CmdId;
	u32                     u32CmdAttr;
	u32                     u32ParaNum;
	STRU_CMD_EXCUTE_PARAS   struCmdPara[CMD_MAX_PARA_NUM];
	u32                     u32DataAreaLen;
	char                    u8DataArea[102400]; //我改的
}UAGT_CMD_EXECUTE_REQ; // 后面跟随数据


#define UAGENT_TCP_PACKET_SIGN 0x5a //界定符



/* 登陆板卡请求 */
#define UAGENT_SIGTYPE_LOGON_REQ                   0
/* 登陆板卡响应 */
#define UAGENT_SIGTYPE_LOGON_RSP                   1
/* 存活监测请求 */
#define UAGENT_SIGTYPE_ALIVE_REQ                   2
/* 存活监测响应 */
#define UAGENT_SIGTYPE_ALIVE_RSP                   3
/* 服务请求 */
#define UAGENT_SIGTYPE_SERVICE_REQ                 4
/* 服务请求响应 */
#define UAGENT_SIGTYPE_SERVICE_RSP                 5
/* 数据应答(ACK) */
#define UAGENT_SIGTYPE_DATA_ACK                    6





// 调整任务优先级请求
typedef struct 
{
	UAGENT_DATA_MSG header;//我补充
	u32                     u32CmdId; //0xFFFFFFFF
	u32                     u32Prio;
}UAGT_CMD_SET_TASK_PRIO_REQ;


// @@ serviceID 这个我觉得就是下面的分类
//service = UAgent_Register_Service(ipAddr, TESTCASE_SERVICE_ID, UAGENT_PROTOCOL_TCP, 1, (u8*)" ", (IMsgHandler*)pMsgHandler);

#define TESTCASE_SERVICE_ID            2 //脚本的
/* 文件传输服务类型 */
#define UAGT_FILE_TRANS_SERVICE_ID     3 //文件传输的

#define UAGT_CMD_EXECUTE_SERVICE_ID     4 //命令执行的

#define CONTROL_SIGNAL_SERVICE_ID 0 // 我补充0


/* 服务请求 */
typedef struct
{
	UAGENT_SIG_HEAD  sigHead;    /* u32SigType = 4 */	//12
	u32              u32ServiceId;                      //16
	u8               u8Options; // 就是一个空格
	u8               pad[3];//这个不需要
}UAGENT_SIG_SERVICE_REQ;



// 消息结构
#define TESTCASE_EXECUTECMD_PARATYPE_NUMBER        1
#define TESTCASE_EXECUTECMD_PARATYPE_BUFFER        2

/* 参数类型 */
#define UAGT_CMD_PARATYPE_NUMBER        1
#define UAGT_CMD_PARATYPE_BUFFER        2

typedef struct tag_STRU_TESTCASE_EXECUTECMD_PARAS
{ 
	s32  s32ParaType; //参数类型：数值/数据缓冲区
	s32  s32ParaVal;  // 数值/数据缓冲区长度
	void *pParaBuf;   // 数据缓冲区首地址
}STRU_TESTCASE_EXECUTECMD_PARAS;


// 对应的是RSP1的s32CmdExecResult
#define UAGT_CMD_RSP1_OK                    0
#define UAGT_CMD_RSP1_NO_SYMBOL            -1
#define UAGT_CMD_RSP1_NONE_EXECUTE_SYMBOL  -2
#define UAGT_CMD_RSP1_BUSY                 -3
#define UAGT_CMD_RSP1_INVALID_CMDID        -4
#define UAGT_CMD_RSP1_BUF_FULL             -5
#define UAGT_CMD_RSP1_INVALID_SIG          -6
typedef struct
{
	UAGENT_DATA_MSG         cmdHead;// 我填的
	u32                     u32CmdId;
	s32                     s32CmdExecResult;// 结果现在看的是这一位，按基站的定义，补齐不会影响这一内容
	u32                     u32Addr;//
	s32                     s32Val; /* 仅在类型为非可执行符号时有效 */
}UAGT_CMD_EXECUTE_RSP1;//cy:RSP1长度是固定的，RSP2除了u8DataArea外的长度是固定的，长度差别很大，所以可以靠长度来区分消息，因为他们的消息头没有区别

/*  关于RSP1的判断：
    RSP1和RSP2没有标志位的区别，所以从长度判断
	与李涛沟通基站关于u32MsgSize的算法，基站是采用数据部分结构体+u32TransId长度 = 24+4 =28
	但long long在32位也是8，看不着基站代码，不知道他们定义的到底是啥
{
u32                     u32CmdId;
s32                     s32CmdExecResult;
long long               u32Addr;
s32                     s32Val;
PAD位置
}

如果基站要是使用含头的结构-头长，长度就应该为40-8 =32,因为含头后，PAD补位不一样了

{
UAGENT_DATA_MSG         cmdHead;  其中是3个int，和u32CmdId合在一起了
u32                     u32CmdId;
s32                     s32CmdExecResult;
PAD位置
long long               u32Addr;
s32                     s32Val;
PAD位置
}
*/

#define MSGSIZE_RSP1_32BIT 20   // 16+4
#define MSGSIZE_RSP1_64BIT 28   // 24+4

typedef struct
{
	UAGENT_DATA_MSG         cmdHead;
	u32                     u32CmdId;
	s32                     s32CmdExecResult;
    u8                      u8Addr[8];
	s32                     s32Val; 
	u32                     pad;
}UAGT_CMD_EXECUTE_RSP1_64BIT; // 模拟基站结构，需要将u8Addr进行网络序转换，倒序拷贝到long long中即可


#define UAGT_CMD_RSP2_OK                    0
#define UAGT_CMD_RSP2_TIMEOUT              -1
/* 命令执行之后的回复信令, 该信令与REQ保持对称，u8DataArea偏移相同，以避免板卡端多余的内存拷贝操作 */ // 原注释 呵呵
typedef struct
{
	UAGENT_DATA_MSG         cmdHead;// 我填的
	u32                     u32CmdId;
	s32                     s32CmdExecResult;
	s32                     s32CmdRetVal;
	STRU_CMD_EXCUTE_PARAS   struCmdPara[32]; /* 该信令无意义，为保持与REQ相对称的结构定义而添加 */ //呵呵哒
	u32                     u32DataAreaLen;
	u8                      u8DataArea[4]; // 我改的，根据实际情况判断
}UAGT_CMD_EXECUTE_RSP2;

typedef struct
{
	UAGENT_DATA_MSG         cmdHead;// 我填的
	u32                     u32CmdId;
	s32                     s32CmdExecResult;
	s32                     s32CmdRetVal;
	STRU_CMD_EXCUTE_PARAS   struCmdPara[32]; /* 该信令无意义，为保持与REQ相对称的结构定义而添加 */ //呵呵哒
	u32                     u32DataAreaLen;
	u8                      u8DataArea[102400]; // 我改的，根据实际情况判断
}UAGT_CMD_EXECUTE_RSP2_FORMAP;



/* 复位任务请求 */
typedef struct 
{
	UAGENT_SIG_HEAD  sigHead;//我补头
	u32                     u32CmdId; /* 0xFFFFFFFE */ // 注意，这个差别在于不是全f，最后一个是e
}UAGT_CMD_TASK_RESTART_REQ;

/* 复位任务响应 */
typedef struct 
{
	UAGENT_SIG_HEAD  sigHead;// 我补头
	u32                     u32CmdId; /* 0xFFFFFFFE */ 
}UAGT_CMD_TASK_RESTART_RSP;


typedef struct
{
	UAGENT_DATA_MSG head;// 我补头
	u32 u32TransId;
	u32 u32TransAttr;
	u32 u32FileSize;
	u8  u8ServIp[16];
	u8  u8RemoteFilePath[128];
	u8  u8RemoteFileName[64];
	u8  u8LocalFileName[64];		
}UAGT_FILE_TRANS_REQ;

typedef struct
{
	UAGENT_DATA_MSG head;// 我补头
	u32 u32TransId;
	s32 s32TransResult;
}UAGT_FILE_TRANS_RSP;


// 从板卡上传
#define UAGT_FILE_TRANS_UPLOAD         0x00000001
// 向板卡下载
#define UAGT_FILE_TRANS_DOWNLOAD         0x00000000 // 这个是我补的

/* Attr: 置1表示加载该文件 */
#define UAGT_FILE_TRANS_LOADMODULE     0x00000002



/* s32TransResult: 文件传输成功 */
#define UAGT_FILE_TRANS_OK                              0
/* s32TransResult: 信令长度非法 */
#define UAGT_FILE_TRANS_REQ_MSGLEN_INVALID              -1
/* s32TransResult: 创建本地文件失败 */
#define UAGT_FILE_TRANS_CREAT_FILE_FAIL                 -2
/* s32TransResult: 建立FTP连接失败 */
#define UAGT_FILE_TRANS_FTPXFER_FAIL                    -3
/* s32TransResult: 从数据连接读取错误 */
#define UAGT_FILE_TRANS_READ_DATASOCK_ERROR             -4
/* s32TransResult: 写本地文件失败 */
#define UAGT_FILE_TRANS_WRITE_FILE_ERROR                -5
/* s32TransResult: 文件传输意外终止或发生异常 */                      
#define UAGT_FILE_TRANS_UNEXCEPT_END                    -6
/* s32TransResult: 加载该文件时发生错误 */                      
#define UAGT_FILE_TRANS_LOADMODULE_ERROR                -7
/* s32TransResult: 打开本地文件失败 */                      
#define UAGT_FILE_TRANS_OPEN_LOCALFILE_FAIL             -8
/* s32TransResult: 读取本地文件失败 */                      
#define UAGT_FILE_TRANS_READ_LOCALFILE_FAIL             -9
/* s32TransResult: 写入到数据连接错误 */                      
#define UAGT_FILE_TRANS_WRITE_DATASOCK_ERROR            -10


// 函数指针
typedef void (*TESTCASE_OUTPUT_FUNC)(u8* pu8OutputMsg, s32 s32OutputMsgType, s32 s32DebugLevel);
#define WAIT_RSP_DOWNLOAD  10*60*1000 // 原文中等10分钟
// #define WAIT_RSP_UPLOAD    5*60*1000 // 等5分钟  增加时间限制后，该值不再使用

// 日志级别
#define SHOW_LEVEL_MINOR         0 // 次要的
#define SHOW_LEVEL_MAJOR         1 // 重要的
#define SHOW_LEVEL_CRITICAL      2 // 严重的
#define SHOW_LEVEL_CATASTROPHIC  3 // 灾难性的

//辅助----------------------------------------------------
#define MY_LOG_MAX_LENGTH 1024*1024*5 //10M其实也行 
#define WAIT_RSP_TIMEOUT  30*1000// 消息的超时时间，我统一了 RSP2真的等6s不够，RSP1飞快，估计是回复的地方不一样，RSP2真的很慢



// RSP的超时时间支持用户设置
// FTP的等待时间很长

typedef enum
{
	LOGDEBUG,
	LOGINFO,
	LOGERROR
}LOGENUM;

#define CONNECTTCPSERVER_RETRY_NUMBER 10 //重连次数,我留长一点，因为发现确实有连不上的情况，一会又好了
#define CONNECTTCPSERVER_RETRY_WAITTIME 1000 // 重连等待时间：单位毫秒，用于Sleep


#define BOARD_MAX_MCU 300 
#define BOARD_SEND_MCU 260
