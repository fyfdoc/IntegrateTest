*** Settings ***
Resource    ../resources/UAgentWrapper.robot


*** Variables ***


*** Test Cases ***
Should Initialize Success
    Connect Device by UAgent    ${host_name}    ${host_address}
    ${execute_result}=    Execute Command by UAgent    OM_MIB_CheckInitInfo
    Should be equal    ${execute_result}    ${0}
    Disconnect UAgent


Should Initialize Failed
    Connect Device by UAgent    ${host_name}    ${host_address}
    ${execute_result}=    Execute Command by UAgent    OM_MCELL_MacParaSend    ${0}    'hello'
    Should be equal    ${execute_result}    ${0}
    Disconnect UAgent

*** Keywords ***

