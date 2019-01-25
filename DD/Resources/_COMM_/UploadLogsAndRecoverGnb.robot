# encoding utf-8
'''
Upload Logs And Recover Gnb
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../../utils/CiUtils.py
Resource    LogHelper.robot
Resource    ../../../OM/OutPermission/opResources/opResource.robot
Resource    BBUStatusCheck.robot

*** Variables ***
${OSP_PATH}    C:\\Users\\admin\\Downloads\\OSP_STUDIO_X64\\OSP_STUDIO_X64\\log
${NEW_PATH}    C:\\enb_log\\osp_prints
${ENB_ResetValue}    1        #不影响下一级复位

*** Keywords ***
#~ #----------------------------------------------------------------------
Upload OSP Print Logs
    Copy Files To SpecifiedDir    ${OSP_PATH}    ${NEW_PATH}
Upload Common Logs
        ${rs}    Log File Upload    omKeyLog    C:\\enb_log\\commonLogs
        Should be equal    ${rs}    ${True}

        ${rs}    Log File Upload    debugLog    C:\\enb_log\\commonLogs
        Should be equal    ${rs}    ${True}
Reset eNB
   Set Many By Name    equipResetTrigger    ${ENB_ResetValue}
   Sleep   480
# 用例执行失败提取debug/omkey/osp log
Upload Logs And Recover Gnb
    Upload OSP Print Logs
    Upload Common Logs
    Reset eNB

    #BBU重启后的状态检查
    BBU Status Check After Restart
    #AAU重启后的状态检查
    AAU Status Check After Restart