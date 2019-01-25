# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：CommonLogResource.robot
*功能描述：公共日志文件上传接口
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       | 
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20       morunzhang       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                         
-------------------------------------------------------------------------            
*##查询类关键字##                                                                     
*A1.                                                                                                      
*##动作类关键字##                                                                     
*B1.公共日志上传接口                     -> Log File Upload                             
_____________________________________________________________________________________  

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Resource   fileSetsResource.robot

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：公共日志上传接口                                                       *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：fileTransTypeName:文件类型英文名    fileTransFTPDirectory:上传路径     *
#返回值   ：True/False                                                             *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：Log File Upload    ${operationLog}                                     *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Log File Upload
    [Documentation]    公共日志上传接口
    [Tags]
    [Arguments]    ${fileTransTypeName}    ${fileTransFTPDirectory}
    [Teardown]
    [Timeout]
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