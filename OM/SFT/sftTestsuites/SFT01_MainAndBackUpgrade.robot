# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：MainAndBackUpgrade.robot
*功能描述：主备升级检查
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-12-01      wangruixuan       创建文件                                       |
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
Library    ../../utils/OM_SFT_ApiFile.py
Resource    ../../COMM/commResources/GnbCommands.robot
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../../OutPermission/opResources/opResource.robot
Resource    ../../SFT/sftResources/BBUupgrade_Res.robot
Resource    ../../SFT/sftResources/MainAndBackUpgrade_Res.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${ata2Path_core}    /ata2/VER/RUNNING/SW/c_plp.bin
${ata2Path_boot}    /ata2/VER/RUNNING/SW/b_plp.bin

${host_name_hsctd}    'HSCTD'
${host_address_hsctd}    172.27.245.92
${host_name_hbpod}    'HBPOD'
${host_address_hbpod}    172.27.246.7
${pId}    ${2}

*** test case ***
#*********************************************************************************
#注:1.该用例需要用到特殊版本的基带板文件。
#     此原因在于特殊的测试函数，今后的某个版本可能会升级该测试函数。
#   2.该用例可以选择拖包升级后检查，或不拖包升级直接检查。
#     默认为不拖包直接检查，如需要请将拖包升级命令放开并输入大包路径。
#*********************************************************************************
主备升级版本检查用例
    #版本升级到处理器全部可用
    @{processorIndex_list}    Get All Actual Processors Index List
    Log List    @{processorIndex_list}
    @{boardIndex_list}    Get All Actual Boards Index List
    Log List    @{boardIndex_list}

#***********************************************************************
#拖包升级命令
    #Set Upgrade Commands    E:\\wrx\\Test\\????.dtz    instantDownload
    #Log To Console    \nBBU正在进行版本下载，请等待14分钟
    #Sleep    14min
#***********************************************************************
    Get All Processors Until Enabled When No Clock
    Set No Clk Mode
    Get All Boards Until Enabled    @{boardIndex_list}
    Get All Processors Until Enabled    @{processorIndex_list}

    #连接PLP设备查寻主备可用性
    # PLP1
    Connect Device by UAgent Use Pid For PLP    ${8}

    ${StatusResult}    CheckMainBackStatus_CORE    ${0}
    Should be equal    ${StatusResult}    ${0}
    ${StatusResult}    CheckMainBackStatus_CORE    ${1}
    Should be equal    ${StatusResult}    ${0}
    ${StatusResult}    CheckMainBackStatus_BOOT    ${0}
    Should be equal    ${StatusResult}    ${0}
    ${StatusResult}    CheckMainBackStatus_BOOT    ${1}
    Should be equal    ${StatusResult}    ${0}

    Disconnect UAgent Use Pid

    # PLP2
    Connect Device by UAgent Use Pid For PLP    ${10}

    ${StatusResult}    CheckMainBackStatus_CORE    ${0}
    Should be equal    ${StatusResult}    ${0}
    ${StatusResult}    CheckMainBackStatus_CORE    ${1}
    Should be equal    ${StatusResult}    ${0}
    ${StatusResult}    CheckMainBackStatus_BOOT    ${0}
    Should be equal    ${StatusResult}    ${0}
    ${StatusResult}    CheckMainBackStatus_BOOT    ${1}
    Should be equal    ${StatusResult}    ${0}

    Disconnect UAgent Use Pid

    #查寻ata2文件版本
    Connect Device by UAgent Use Pid    ${host_name_hsctd}    ${host_address_hsctd}    ${pId}

    ${FileInfo_Core_ata2}    GetATA2Version    ${ata2Path_core}
    ${FileVer_Core_ata2}    SelectListItemNotDel    ${FileInfo_Core_ata2}    ${1}
    ${FileInfo_Boot_ata2}    GetATA2Version    ${ata2Path_boot}
    ${FileVer_Boot_ata2}    SelectListItemNotDel    ${FileInfo_Boot_ata2}    ${1}

    Disconnect UAgent Use Pid

    #查寻当前运行版本
    Connect Device by UAgent Use Pid    ${host_name_hbpod}    ${host_address_hbpod}    ${pId}

    ${FileVer_Core_Board_8_Info}    GetBoardVersion    ${204}    ${8}
    ${FileVer_Core_Board_8}    SelectListItemNotDel    ${FileVer_Core_Board_8_Info}    ${0}

    ${FileVer_Core_Board_10_Info}    GetBoardVersion    ${204}    ${10}

    ${FileVer_Boot_Board_8_Info}    GetBoardVersion    ${203}    ${8}
    ${FileVer_Boot_Board_8}    SelectListItemNotDel    ${FileVer_Boot_Board_8_Info}    ${0}

    ${FileVer_Boot_Board_10_Info}    GetBoardVersion    ${203}    ${10}

    Disconnect UAgent Use Pid

    #版本对比检查
    Run Keyword If    ${FileVer_Core_Board_8_Info} == ${FileVer_Core_Board_10_Info}
    ...    Should be equal    ${FileVer_Core_Board_8}    ${FileVer_Core_ata2}
    Run Keyword If    ${FileVer_Boot_Board_8_Info} == ${FileVer_Boot_Board_10_Info}
    ...    Should be equal    ${FileVer_Boot_Board_8}    ${FileVer_Boot_ata2}