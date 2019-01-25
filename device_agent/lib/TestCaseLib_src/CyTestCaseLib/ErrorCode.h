#define TESTCASE_SUCCESS 0
#define TESTCASE_FAIL -1

#define INIT_SOCKET_FAIL -1
#define INT_LOG_FAIL -2
#define INT_OTHER_FAIL -3

#define REGISTER_CONNECT_FAIL -1
#define REGISTER_IPINUSE_FAIL -2
#define REGISTER_NAMEINUSE_FAIL -2


#define EXECUTECMD_SEND_FAIL -1
#define EXECUTECMD_PARA_TOOMANY -2


/* 错误编码 */
/* 无效参数错误 */
#define ECMD_INVALID_ERROR                        -1
/* 未注册的板卡错误 */
#define ECMD_NOT_REGISTERED_ERROR                 -2
/* RSP1响应超时 */
#define ECMD_RSP1_TIMEOUT_ERROR                   -3
/* RSP1响应:符号未找到 */
#define ECMD_RSP1_NO_SYMBOL_ERROR                 -4
/* RSP1响应:符号不可执行, (此时返回该符号值) */
#define ECMD_RSP1_NONE_EXECUTE_SYMBOL_ERROR       -5
/* RSP2响应:超时 */
#define ECMD_RSP2_TIMEOUT_ERROR                   -6


/* 控制信令RSP超时 */
#define ECMD_CTRL_RSP_TIMEOUT_ERROR               -7
/* 控制信令执行失败 */
#define ECMD_CTRL_RSP_FAIL                        -8
/* UAgtCmd任务忙 */
#define ECMD_TASK_BUSY                            -9
/* 信令Buffer已满 */
#define ECMD_CMD_BUF_FULL                         -10