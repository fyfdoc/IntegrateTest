# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：BoardLogResource.robot
*功能描述：板卡日志上传接口
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        morunzhang      创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##查询类关键字##                                                                    |
*A1.                                                                                 |
*##动作类关键字##                                                                    |
*B1.板卡日志上传接口（上传全部类型日志）              -> Board Log File Upload       |
*B2.板卡日志上传接口（上传设置类型日志）              -> Board SetLog File Upload    |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py

*** Variables ***
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB
${switch_on}      on
${switch_off}     off

*** Keywords ***
#***********************************************************************************
#功能     ：板卡日志上传接口（上传全部类型日志）                                   *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：boardfileTransId:example(0.0.6.1)    fileTransFTPDirectory:上传路径    *
#返回值   ：True/False                                                             *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：Board Log File Upload    ${0.0.6.1}    C:\\enb_log                     *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Board Log File Upload
    [Arguments]    ${boardfileTransId}    ${fileTransFTPDirectory}
    # 返回日志类型example（'1;60;64;66;71;81'）
    ${boardfileTransTypeNo}    parse board log idx    ${boardfileTransId}
    Log    ${boardfileTransTypeNo}
    # 下发日志文件上传命令
    Set Many By Name    debugUploadRowStatus    ${4}    idx=${boardfileTransId}                               # 行状态
    ...                 debugUploadType    ${boardfileTransTypeNo}    idx=${boardfileTransId}                 # 传输文件类型
    ...                 debugUploadDestination    ${fileTransFTPDirectory}    idx=${boardfileTransId}         # FTP服务器上的文件路径
    # 检查文件是否上传成功
    ${ret}    isBoardLogFileExists    ${fileTransFTPDirectory}    ${boardfileTransId}    ${boardfileTransTypeNo}
    [Return]    ${ret}

#***********************************************************************************
#功能     ：板卡日志上传接口（上传设置类型日志）                                   *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：boardfileTransTypeNo:日志标号(1,71)                                    *
#返回值   ：True/False                                                             *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：morunzhang                                                             *
#调用方法 ：Board SetLog File Upload    ${0.0.1.0}    ${1,71}    C:\\enb_log       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Board SetLog File Upload
    [Arguments]    ${boardfileTransId}    ${boardfileTransTypeNo}    ${fileTransFTPDirectory}
    # 下发日志文件上传命令
    Set Many By Name    debugUploadRowStatus    ${4}    idx=${boardfileTransId}                                 # 行状态
    ...                 debugUploadType    ${boardfileTransTypeNo}    idx=${boardfileTransId}                   # 传输文件类型
    ...                 debugUploadDestination    ${fileTransFTPDirectory}    idx=${boardfileTransId}           # FTP服务器上的文件路径
    # 检查文件是否上传成功
    ${ret}    isBoardLogFileExists    ${fileTransFTPDirectory}    ${boardfileTransId}    ${boardfileTransTypeNo}
    [Return]    ${ret}


#***********************************************************************************
#功能     ：HSCTD 0核70号日志开关打开10s后关闭                                     *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：                                                                       *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：Open And Close Capture Package Switch                                  *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
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


#***********************************************************************************
#功能     ：上传指定槽位号板卡日志                                                 *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：                                                                       *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：Specified Board Log Upload    ${0.0.1}                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Specified Board Log Upload
    # 参数说明: Specified_slotNo:指定的槽位号
    [Arguments]    ${Specified_slotNo}
    @{index_list}    Get Index By SlotNo    ${Specified_slotNo}
    :For    ${loop_index}    in    @{index_list}
    \    ${rs}    Board Log File Upload    ${loop_index}    C:\\enb_log
    \    Should be equal    ${rs}    ${True}