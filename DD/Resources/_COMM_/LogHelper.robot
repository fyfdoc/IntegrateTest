# encoding utf-8
'''
日志文件操作资源文件
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    UAgentWrapper.robot
Library    SnmpLibrary
Library    BuiltIn
Library    ../../utils/CiUtils.py

*** Variables ***
${ftp_index}    ${2}    #特殊ftp server信息实例
${switch_on}    on
${switch_off}    off

*** Keywords ***
#~ #----------------------------------------------------------------------
# 日志文件上传方法
Log File Upload
    # 参数说明: fileTransTypeName:文件类型英文名    fileTransFTPDirectory:上传路径
    [Arguments]    ${fileTransTypeName}    ${fileTransFTPDirectory}
    # 根据英文名称获取日志文件传输类型的编号
    ${fileTransTypeNo}    GetFileTransTypeIndexByName    ${fileTransTypeName}
    Log    ${fileTransTypeNo}
    # 获取文件上传编号
    Get By Name    fileTransNextAvailableIDForOMC                         # OMC文件传输表可用编号
    ${fileTransId}    Get By Name    fileTransNextAvailableIDForOthers    # 其他文件传输表可用编号
    Log    ${fileTransId}
    # 实例存在的情况下先删除
    Del Line By Name    fileTransType    ${fileTransId}    fileTransRowStatus
    # 下发日志文件上传命令
    Set Many By Name    fileTransRowStatus    ${4}    idx=${fileTransId}                          # 行状态
    ...                 fileTransType    ${fileTransTypeNo}    idx=${fileTransId}                 # 传输文件类型
    ...                 fileTransIndicator    ${1}    idx=${fileTransId}                          # 上下载指示 1:upload|上传/2:download|下载
    ...                 fileTransNEDirectory    null    idx=${fileTransId}                        # 网元上的文件路径
    ...                 fileTransFTPDirectory    ${fileTransFTPDirectory}    idx=${fileTransId}   # FTP服务器上的文件路径
    ...                 fileTransFileName    null    idx=${fileTransId}                           # 文件名称
    # 获取日志文件名称的关键字，用于检查文件是否上传成功
    ${fileNameKeyword}    GetLogFileKeyNameByType    ${fileTransTypeName}
    Log    ${fileNameKeyword}
    # 循环检查文件是否上传成功
    :FOR    ${index}    IN RANGE    10
    \    ${rs}    IsLogFileExists    ${fileTransFTPDirectory}    ${fileNameKeyword}
    \    Exit For Loop If    ${rs}==${True}    # 存在即跳出循环
    \   Sleep    3s
    [Return]    ${rs}
#~ #----------------------------------------------------------------------
# rru 单日志上传
RRU Log File Upload
    # 参数说明: fileTransTypeName:文件类型英文名    fileTransFTPDirectory:上传路径
    #           rrualarm | rruuser | rrusys | all
    [Arguments]    ${fileTransTypeName}    ${fileTransFTPDirectory}
    # 根据英文名称获取日志文件传输类型的编号
    ${fileTransTypeNo}    GetFileTransTypeIndexByName    ${fileTransTypeName}
    Log    ${fileTransTypeNo}
    # 下发日志文件上传命令
    Set Many By Name    topoRRULogFileType    ${fileTransTypeNo}    idx=${0}
    ...                 topoRRULogDestination    ${fileTransFTPDirectory}    idx=${0}
    # 获取日志文件名称的关键字，用于检查文件是否上传成功
    ${fileNameKeyword}    GetLogFileKeyNameByType    ${fileTransTypeName}
    Log    ${fileNameKeyword}
    # 检查文件是否上传成功
    ${ret}    isRRULogFileExists    ${fileTransFTPDirectory}    ${fileNameKeyword}
    [Return]    ${ret}
#~ #----------------------------------------------------------------------
# 设置Ftp服务器信息，用于文件上传下载
FtpServer Info Set
    # 参数说明: ftpServerIp:ftp服务器的Ip地址；(注：其他参数目前用不到，用到时再添加，暂时写死)
    [Arguments]    ${ftpServerIp}
    # 先删除索引为2的数据，然后再添加
    Del Index2 FtpServer Info
    # 将IP转换为SNMP类型
    ${snmpFtpServerIp}    convert to ip address    ${ftpServerIp}
    # 设置ftp服务器信息
    Set Many By Name    ftpServerRowStatus    ${4}    idx=${ftp_index}
    ...                 ftpServerManagerType    ${4}    idx=${ftp_index}
    ...                 ftpServerInetAddrType    ${1}    idx=${ftp_index}
    ...                 ftpServerInetAddr    ${snmpFtpServerIp}    idx=${ftp_index}
    ...                 ftpServerPerformanceDirectory    C:\\LMT\\out\\filestorage\\PMDataFile\\    idx=${ftp_index}
    ...                 ftpServerAlarmDirectory    C:\\LMT\\out\\data\\AlarmFile\\TempFiles\\172.27.245.92\\    idx=${ftp_index}
    ...                 ftpServerSoftwareDirectory    null    idx=${ftp_index}
    ...                 ftpServerConfigurationDirectory    null    idx=${ftp_index}
    ...                 ftpServerLogDirectory    null    idx=${ftp_index}
    ...                 ftpServerLoginName    lmtb    idx=${ftp_index}
    ...                 ftpServerPassword    lmtb    idx=${ftp_index}

#~ #----------------------------------------------------------------------
# 删除索引为2的Ftp服务器信息
Del Index2 FtpServer Info
    # 先查询，存在的情况下才删除
    ${rs}    ${error}    Get With Error By Name    ftpServerInetAddr    idx=${ftp_index}
    Run Keyword If    ${error} == ${0}    Set By Name    ftpServerRowStatus    ${6}    idx=${ftp_index}

#~ #----------------------------------------------------------------------
# 删除指定的数据行
Del Line By Name
    [Arguments]    ${objName}    ${index}    ${lineIndexName}
    # 先查询，存在的情况下才删除
    ${rs}    ${error}    Get With Error By Name    ${objName}    idx=${index}
    Run Keyword If    ${error} == ${0}    Set By Name    ${lineIndexName}    ${6}    idx=${index}

Board Log File Upload
    # 参数说明: boardfileTransId:example(0.0.6.1)    fileTransFTPDirectory:上传路径
    [Arguments]    ${boardfileTransId}    ${fileTransFTPDirectory}
    # 返回日志类型example（'1;60;64;66;71;81'）
    ${boardfileTransTypeNo}    parse board log idx    ${boardfileTransId}
    Log    ${boardfileTransTypeNo}
    # 下发日志文件上传命令
    Set Many By Name    debugUploadRowStatus    ${4}    idx=${boardfileTransId}                                        # 行状态
    ...                                 debugUploadType    ${boardfileTransTypeNo}    idx=${boardfileTransId}                         # 传输文件类型
    ...                                 debugUploadDestination    ${fileTransFTPDirectory}    idx=${boardfileTransId}     # FTP服务器上的文件路径
    # 检查文件是否上传成功
    ${ret}    isBoardLogFileExists    ${fileTransFTPDirectory}    ${boardfileTransId}    ${boardfileTransTypeNo}
    [Return]    ${ret}

#~ #----------------------------------------------------------------------
# HSCTD 0核70号日志开关打开10s后关闭
Open And Close Capture Package Switch

    ${switchStatus}       Get Oid By Name    ${MibName}    protocolStackCapPacketSwitch
    #打开协议栈抓包开关
    Set    ${switchStatus}    ${1}
    ${Switch_Value}    ${error}    Get With Error By Name    protocolStackCapPacketSwitch
    Should be equal    ${Switch_Value}    ${switch_on}
    Sleep    10
    #关闭协议栈抓包开关
    Set    ${switchStatus}    ${0}
    ${Switch_Value}    ${error}    Get With Error By Name    protocolStackCapPacketSwitch
    Should be equal    ${Switch_Value}    ${switch_off}
    Log    Open and Close Capture Package Switch is Success! Begin to upload logs!

Specified Board Log Upload
    # 参数说明: Specified_slotNo:指定的槽位号
    [Arguments]    ${Specified_slotNo}
    @{index_list}    Get Index By SlotNo    ${Specified_slotNo}
    :For    ${loop_index}    in    @{index_list}
    \    ${rs}    Board Log File Upload    ${loop_index}    C:\\enb_log
    \    Should be equal    ${rs}    ${True}
#~ #----------------------------------------------------------------------
# 普通文件下载方法
File Download
    # 参数说明: fileTransFTPDirectory:文件路径    fileTransNEDirectory:下载路径
    [Arguments]    ${fileTransFTPDirectory}    ${fileTransNEDirectory}
    #${servTotalPath} ${ftpServerIp}://${fileTransNEDirectory}
		${execute_result}=    Execute Command by UAgent    ftp6FileGet    <200,[S;0;0;${fileTransFTPDirectory}]>    <200,[S;0;0;${fileTransNEDirectory}]>    ${0x40}
    Should be equal    ${execute_result}    ${0}
    [Return]  ${True}
#~ #----------------------------------------------------------------------

Cell Log File Upload
    # 参数说明: boardfileTransId:example(0.0.6.1)    fileTransFTPDirectory:上传路径
    [Arguments]    ${fileTransTypeName}    ${fileTransFTPDirectory}
    # 返回日志类型example（'1;60;64;66;71;81'）
    ${boardfileTransTypeNo} =   Set Variable    ${1}
    # 下发日志文件上传命令
    Set Many By Name    debugUploadRowStatus    ${4}    idx=0.0.6.0                                       # 行状态
    ...        debugUploadType    ${boardfileTransTypeNo}    idx=0.0.6.0                         # 传输文件类型
    ...            debugUploadDestination    ${fileTransFTPDirectory}    idx=0.0.6.0     # FTP服务器上的文件路径
    # 获取日志文件名称的关键字，用于检查文件是否上传成功
    ${fileNameKeyword}    Getcell_LogFileByType    ${fileTransTypeName}
    Log    ${fileNameKeyword}
    # 检查文件是否上传成功
    ${ret}    isRRULogFileExists    ${fileTransFTPDirectory}    ${fileNameKeyword}
    [Return]    ${ret}

#~ #----------------------------------------------------------------------
#NR小区日志上传封装
NRLog File Upload
    # 参数说明: boardfileTransId:example(0.0.6.1)   boardfileTransTypeNo(1,71)    fileTransFTPDirectory:上传路径
    [Arguments]    ${boardfileTransId}    ${boardfileTransTypeNo}    ${fileTransFTPDirectory}
    # 下发日志文件上传命令
    Set Many By Name    debugUploadRowStatus    ${4}    idx=${boardfileTransId}                                        # 行状态
    ...                                 debugUploadType    ${boardfileTransTypeNo}    idx=${boardfileTransId}                         # 传输文件类型
    ...                                 debugUploadDestination    ${fileTransFTPDirectory}    idx=${boardfileTransId}     # FTP服务器上的文件路径
    # 检查文件是否上传成功
    ${ret}    isBoardLogFileExists    ${fileTransFTPDirectory}    ${boardfileTransId}    ${boardfileTransTypeNo}
    [Return]    ${ret}