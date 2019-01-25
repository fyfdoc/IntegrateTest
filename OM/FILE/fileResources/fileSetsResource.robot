# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：fileSetsResource.robot
*功能描述：文件上传配置资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        morunzhang       创建文件                                      |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##查询类关键字##                                                                    |
*A1.                                                                                 |
*##动作类关键字##                                                                    |
*B1.FtpServer Info Set                  -> 设置Ftp服务器信息，用于文件上传下载       |
*B2.Del Index2 FtpServer Info           -> 删除索引为2的Ftp服务器信息                |
*B3.Del Line By Name                    -> 删除指定的数据行                          |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py

*** Variables ***
${Mib}          DTM-TD-LTE-ENODEB-ENBMIB
${ftp_index}    ${2}    #特殊ftp server信息实例

*** Keywords ***
#***********************************************************************************
#功能     ：设置Ftp服务器信息，用于文件上传下载                                    *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：ftpServerIp:ftp服务器的Ip地址；(注：其他参数目前用不到，用到时再添加，暂时写死) *
#返回值   ：                                                                       *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
FtpServer Info Set
    [Documentation]    设置Ftp服务器信息，用于文件上传下载
    [Tags]
    [Arguments]    ${ftpServerIp}
    [Teardown]
    [Timeout]
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


#***********************************************************************************
#功能     ：删除索引为2的Ftp服务器信息                                             *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Del Index2 FtpServer Info
    # 先查询，存在的情况下才删除
    ${rs}    ${error}    Get With Error By Name    ftpServerInetAddr    idx=${ftp_index}
    Run Keyword If    ${error} == ${0}    Set By Name    ftpServerRowStatus    ${6}    idx=${ftp_index}


#***********************************************************************************
#功能     ：删除指定的数据行                                                       *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Del Line By Name
    [Arguments]    ${objName}    ${index}    ${lineIndexName}
    # 先查询，存在的情况下才删除
    ${rs}    ${error}    Get With Error By Name    ${objName}    idx=${index}
    Run Keyword If    ${error} == ${0}    Set By Name    ${lineIndexName}    ${6}    idx=${index}