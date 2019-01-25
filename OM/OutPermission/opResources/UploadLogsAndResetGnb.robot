# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：UploadLogsAndResetGnb.robot
*功能描述：复位类脚本增加后处理相关资源文件：准出涉及关键字列表
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-23        yangnan1       创建文件                                        |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------------------|
*##复位类脚本后处理相关关键字##                                                      |
*A1.上传OSP日志                       -> Upload OSP Print Logs                       |
*A2.上传omKeyLog和debugLog            -> Upload Common Logs                          |
*A3.复位基站                          -> Reset eNB                                   |
*A4.以fail时间来命名文件夹            -> Create folder by time                                   |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    DateTime
#Library    ../../utils/CiUtils.py
Resource    ../../FILE/fileResources/CommonLogResource.robot

*** Variables ***
${OSP_PATH}    C:\\Users\\admin\\Downloads\\OSP_STUDIO_X64\\OSP_STUDIO_X64\\log
${OSP_LOG_BASE_PATH}    C:\\enb_log\\osp_prints
${ENB_ResetValue}    1        #不影响下一级复位
${COMM_LOG_BASE_PATH}    C:\\enb_log\\commonLogs

*** Keywords ***
#~ #----------------------------------------------------------------------
Upload OSP Print Logs
    ${folderPath}    Create folder by time    ${OSP_LOG_BASE_PATH}
    Copy Files To SpecifiedDir    ${OSP_PATH}    ${folderPath}
Upload Common Logs
        ${folderPath}    Create folder by time    ${COMM_LOG_BASE_PATH}
        ${rs}    Log File Upload    omKeyLog    ${folderPath}
        Should be equal    ${rs}    ${True}

        ${rs}    Log File Upload    debugLog    ${folderPath}
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

Create folder by time
    [arguments]    ${BASE_PATH}
    ${current_time}    Get Current Date
    ${folder_path}    Create Folder by Current Time    ${BASE_PATH}    ${current_time}
    [return]    ${folder_path}