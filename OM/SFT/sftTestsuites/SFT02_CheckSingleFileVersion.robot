# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：CheckSingleFileVersion.robot
*功能描述：检查升级后的小文件版本号是否一致
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-12-03      wangruixuan       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*用例记录：（记录用例测试出的问题，引用关键字遇到的异常问题等等）                    |
**                                                                                   |
**                                                                                   |
_____________________________________________________________________________________|

************************************************用例文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    BuiltIn
Library    ../../utils/FileHandler.py
Library    ../../utils/OM_SFT_ApiFile.py
Resource    ../../SFT/sftResources/CheckSingleFileVersion_Res.robot
Resource    ../../SFT/sftResources/MainAndBackUpgrade_Res.robot
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../../COMM/commResources/UAgentWrapper.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${host_name_HSCTD}    'HSCTD'
${host_address_HSCTD}    172.27.245.92
${pId}    ${2}

${PackFullPath}    E:\\wrx\\Test\\BBU1205.dtz

*** test case ***
#***************************************************************************
#注:1.修改上方的${PackFullPath}的路径来获取指定包的所有文件
#   2.重要:该用例无法对比文件版本号最后一个字符为"0"的文件！！！
#     该问题正在解决
#***************************************************************************
与文件信息表对比所有文件的文件版本号
    #获取指定包的所有文件名和文件个数
    ${subpackageNum}    newSpiltPackage    ${PackFullPath}
    delSplitedPackage    ${subpackageNum}    ${PackFullPath}
    @{AllFileName}    getFileName    ${PackFullPath}
    ${FileNum}    getFileNum    ${PackFullPath}

    #所有文件的文件版本号对比
    :FOR    ${FlagNum}    IN RANGE    ${FileNum}
    #获取文件的全路径
    \    ${FileFullPath}    GetFileATA2FullPath    ${AllFileName[${FlagNum}]}

    #获取在ATA2下的当前文件的文件版本号
    \    Connect Device By UAgent Use Pid    ${host_name_HSCTD}    ${host_address_HSCTD}    ${pId}
    \    ${FileInfo_ata2}    GetATA2Version    ${FileFullPath}
    \    Disconnect UAgent Use Pid

    \    Run Keyword If    ${FileInfo_ata2} == ${-1}
    \    ...    Log to console    查询ATA2上该文件版本失败
    \    ...    Continue For Loop
    \    ${FileVer_ata2}    SelectListItem    ${FileInfo_ata2}    ${1}

    #获取文件信息表的当前文件版本
    \    ${FileVer_Str}    Get File Version From List    ${FileFullPath}

    #单个文件版本对比
    \    Log    ${FileVer_ata2}
    \    Log    ${FileVer_Str}
    \    ${Result}    Should Be Equal For Str    ${FileVer_ata2}    ${FileVer_Str}
    \    Should be equal    ${Result}    ${True}