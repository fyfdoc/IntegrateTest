*** Settings ***
Resource    ../resources/UAgentWrapper.robot


*** Variables ***
${host_name}	'SCTF'
${host_address}	172.27.245.92
${pId}	${-1}
${slotNum}  ${6}
${procId}  ${6}
@{pars}	${1}
@{pars2}	${1}	${1}

*** Test Cases ***
# 连接设备
Connect Device Use Pid
    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}    ${slotNum}    ${procId}


# 断开连接
Disconnect Device
    Disconnect UAgent

*** Keywords ***

