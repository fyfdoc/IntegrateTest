#include "StdAfx.h"
#include ".\recvpacketmodel.h"
#include "MessageFormat.h"
#include <WinSock2.h>


CRecvPacketModel::CRecvPacketModel(void)
{
	m_pClassLog = NULL;
	m_IsNothing = TRUE;
	TRACE("初始化\n");
}

CRecvPacketModel::~CRecvPacketModel(void)
{
}

int CRecvPacketModel::SetRecvBuffer(char* pBuffer,int nBufLen)
{
	CString strInfo("");
	char *pCur = pBuffer;
	int nCurLen = nBufLen; //余下的长度

	if(m_IsNothing)// 第一包
	{	
		if(pCur[0] == 0x5a) // 校验
		{
			Log(LOGDEBUG,"@收到0x5a");
			m_IsNothing = FALSE; // 开始收包
			pCur = pCur+1;
			nCurLen = nCurLen -1;
		}
		else
		{
			strInfo.Format("@程序有问题（消息长%d，还需要消息%d）\n",m_nMsgLen,m_nBuffLen);
			Log(LOGDEBUG,strInfo);
			return 0;
		}

		if(nCurLen == 0) // 只有0x5a
		{
			Log(LOGDEBUG,"@只有0x5a");
			return 0;
		}
		else
		{
			Log(LOGDEBUG,"@处理消息头");
		}
		
		if(nCurLen >= sizeof(UAGENT_MSG_HEAD))
		{
			UAGENT_MSG_HEAD *pMsg = (UAGENT_MSG_HEAD*)pCur;
			m_nMsgLen = ntohl(pMsg->u32MsgSize) + sizeof(UAGENT_MSG_HEAD);

			if(nCurLen >= m_nMsgLen)//整条消息都包含
			{
				strInfo.Format("@就一包，整条消息都包含 Data%d Msg%d",nCurLen,m_nMsgLen);
				Log(LOGDEBUG,strInfo);
				if(nCurLen>m_nMsgLen)
				{
					strInfo.Format("@下一条消息还有%d",nCurLen - m_nMsgLen);
					Log(LOGDEBUG,strInfo);
				}
				memcpy(m_Buffer,pCur,m_nMsgLen);
				m_nBuffLen = m_nMsgLen;
				return (nCurLen-m_nMsgLen); // 剩余的是下一个消息的
			}
			else //只是第一包
			{
				strInfo.Format("@只是第一包，消息没收完 Data%d Msg%d 还需要%d\n",nCurLen,m_nMsgLen,m_nMsgLen-nCurLen);
				Log(LOGDEBUG,strInfo);
				memcpy(m_Buffer,pCur,nCurLen);
				m_nBuffLen = nCurLen;
				return 0;
			}
		}
		else // 剩余内容还没有消息头长
		{
			Log(LOGDEBUG,"包不足长度");
			return 0;
		}
	}
	else // 不是第一包
	{
		// 至少0x5a已经收过
		if(0 == m_nMsgLen) // 需要收头
		{
			Log(LOGDEBUG,"@收消息头");
			UAGENT_MSG_HEAD *pMsg = (UAGENT_MSG_HEAD*)pBuffer;
			m_nMsgLen = ntohl(pMsg->u32MsgSize) + sizeof(UAGENT_MSG_HEAD);

			if(nCurLen >= m_nMsgLen)//整条消息都包含
			{
				strInfo.Format("@就一包，整条消息都包含 Data%d Msg%d ,还富裕%d",nCurLen,m_nMsgLen,nCurLen - m_nMsgLen);
				Log(LOGDEBUG,strInfo);
				memcpy(m_Buffer,pCur,m_nMsgLen);
				m_nBuffLen = m_nMsgLen;
				return (nCurLen-m_nMsgLen); // 剩余的是下一个消息的
			}
			else // 只是一部分
			{
				strInfo.Format("@只是第一包，消息没收完 Data%d Msg%d 还需要%d",nCurLen,m_nMsgLen,m_nMsgLen-nCurLen);
				Log(LOGDEBUG,strInfo);
				memcpy(m_Buffer,pCur,nCurLen);
				m_nBuffLen = nCurLen;
				return 0;

			}
		}
		else // 消息头已经收过
		{
			Log(LOGDEBUG,"@消息头已经收过");
			if(nCurLen >= GetLackLen())//已经可以补足
			{
				int nRichDataLen = nCurLen - GetLackLen();
				strInfo.Format("@消息的最后一包,还富裕%d\n",nRichDataLen);
				Log(LOGDEBUG,strInfo);
				memcpy(m_Buffer + m_nBuffLen,pCur,GetLackLen());
				m_nBuffLen = m_nMsgLen;
				//return (nCurLen - GetLackLen()); //GetLackLen是变化的，随着我赋值的改变，此处在变化 BUG_15:44解决
				return nRichDataLen;
			}
			else // 还不能补足，需要继续接收
			{
				strInfo.Format("@消息的中间一包,还差%d\n",GetLackLen()- nCurLen);
				Log(LOGDEBUG,strInfo);
				memcpy(m_Buffer + m_nBuffLen,pCur,nCurLen);
				m_nBuffLen = m_nBuffLen + nCurLen;
				return 0;
			}
		}
	}
	return 0;
}

void CRecvPacketModel::ResetModel()
{
	m_IsNothing = TRUE;
	m_nMsgLen = 0;
	m_nBuffLen = 0;
	memset(m_Buffer,0,BUFFER_DATA_RECV_LEN);
}


BOOL CRecvPacketModel::IsIntegrityMsg()
{
	if((m_nMsgLen == m_nBuffLen) && (m_nBuffLen!=0) )
	{
		return TRUE;
	}
	return FALSE;
}

int CRecvPacketModel::GetMsgLen()
{
	return m_nMsgLen;
}

int CRecvPacketModel::GetLackLen()
{
	return (m_nMsgLen - m_nBuffLen);
}


void CRecvPacketModel::Log(int n,CString strInfo)
{
	//定位结束，先注释
	//if(m_pClassLog != NULL)
	//{
	//	fprintf(m_pClassLog,strInfo);
	//	fprintf(m_pClassLog,"\n");
	//	fflush(m_pClassLog);
	//}
}