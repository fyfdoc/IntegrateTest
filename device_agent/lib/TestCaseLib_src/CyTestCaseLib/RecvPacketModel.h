#pragma once

#define BUFFER_DATA_RECV_LEN 1024*11 //BUG 20171123 读Eeprom异常就是因为此处原来为4096太小了，Msgsize超过时造成了异常，异常在memcpy(m_Buffer,pCur,m_nMsgLen);
                                    // 我是在真实环境中中断定位只能看到memcpy，再在代码中搜索memcpy处打断点，看到长度越界
                                    // 下发处长度限制是102400，再加上头，所以此处我用1024*11不会再超过 （理论上应该加长度判断）
                            
// 进行组包所需要的类
class CRecvPacketModel
{
public:
	CRecvPacketModel(void);
	~CRecvPacketModel(void);

	FILE *m_pClassLog;

	// 返回属于下一条消息的长度（只处理自己的0x5a,下一条的不处理，返回）
	// Set之后，如果返回的不是0，就可以DealMsg，然后调用ResetModel，再调用Set进行处理
	//          如果返回的是0，就检查消息是否完整，如果完整就可以处理了
	int SetRecvBuffer(char* pBuffer,int nBufLen);//将收到的内容放入进行处理

    void ResetModel(); //准备进行下一条处理了 


	BOOL IsIntegrityMsg(); // 是否是完整的消息，如果是就可以解析了
	int GetMsgLen();   // 获取消息长度
	int GetLackLen();  // 获取还缺少的长度


	BOOL m_IsNothing;// 是否是啥也没有
 	char m_Buffer[BUFFER_DATA_RECV_LEN];// 消息内容

private:
	int m_nMsgLen; // 消息长度(含消息头)
	int m_nBuffLen;// 现在Buffer的长度
	void Log(int n,CString strInfo);


};
