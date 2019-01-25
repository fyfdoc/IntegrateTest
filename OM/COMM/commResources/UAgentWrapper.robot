# encoding utf-8
'''
@company: Datang Mobile
@license: (c) Copyright 2018, Datang Mobile
@author:  pengqiang
@file:    UAgentWrapper.robot
@time:    2018/07/28
@desc:    the keywords of UAgent
'''

*** Settings ***
Library      ../../../device_agent/TestCaseClient.py


*** Variables ***


*** Keywords ***
Connect Device by UAgent
    [Arguments]    ${host_name}    ${host_address}
    connect    ${host_name}    ${host_address}

Connect Device by UAgent Use Pid
    [Arguments]    ${host_name}    ${host_address}    ${pId}    ${slotNum}=${0}    ${procId}=${0}
    ${ret} =   connect_by_pid    ${host_name}    ${host_address}    ${pId}    ${slotNum}    ${procId}
    Run Keyword If    ${ret}==${-1}    Fail    超时
    ...    ELSE IF    ${ret}==${-2}    Fail    hostname或ip已使用
    Log    ${ret}
    [Return]    ${ret}

Disconnect UAgent
    disconnect

Disconnect UAgent Use Pid
    disconnect by pid

Execute Command by UAgent
    [Arguments]    ${command_name}    @{parameters}
    Log    "excute command: ${command_name}"
    ${execute_result} =    execute_command    ${command_name}    @{parameters}
    [Return]    ${execute_result}

Execute Command With Out Datas by UAgent
    [Arguments]    ${command_name}    @{parameters}
    Log    "excute command with out datas: ${command_name}"
    ${execute_result} =    execute_command_with_out_datas    ${command_name}    @{parameters}
    [Return]    ${execute_result}


File Download
    # 参数说明: fileTransFTPDirectory:文件路径    fileTransNEDirectory:下载路径
    [Arguments]    ${fileTransFTPDirectory}    ${fileTransNEDirectory}      
    #${servTotalPath} ${ftpServerIp}://${fileTransNEDirectory} 
        ${execute_result}=    Execute Command by UAgent    ftp6FileGet    <200,[S;0;0;${fileTransFTPDirectory}]>    <200,[S;0;0;${fileTransNEDirectory}]>    ${0x40}     
    Should be equal    ${execute_result}    ${0}
    [Return]  ${True}