# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：file1_BoardLogTest.robot
*功能描述：测试板卡日志上传用例
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        morunzhang       创建文件                                      |
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
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../fileResources/BoardLogResource.robot
Suite Setup           Open Snmp Connection And Load Private MIB


*** Variables ***
${BaordlogPath}    C:\\enb_log\\boardlogdir
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB
${aom}    aom
${som}    som

*** test case ***
#~ #----------------------------------------------------------------------
Init SaveDir Test
    [Documentation]    初始化保存目录
    [Tags]
    Create folder    ${BaordlogPath}

#~ #----------------------------------------------------------------------
BoardLog Upload Test
    [Documentation]    板卡日志上传用例测试
    [Tags]
    Open And Close Capture Package Switch

    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    ${aom}    ${boardEntry}    ${16}

    :For    ${loop_slotNo}    in    @{aom_slotNo_list}
    \    Specified Board Log Upload    ${loop_slotNo}
    \    Log    ${loop_slotNo}'s board log upload is complete!

    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}

    :For    ${loop_slotNo}    in    @{som_slotNo_list}
    \    Specified Board Log Upload    ${loop_slotNo}
    \    Log    ${loop_slotNo}'s board log upload is complete!

