from pysnmp.smi.rfc1902 import ObjectIdentity


#*** Keywords ***
#Open Snmp Connection And Load Private MIB
#   [Arguments]   ${dstIp}       ${Comitty}      ${mib}
#   Open Snmp Connection       ${dstIp}          ${Comitty}
#   Load Mib      DTM-TD-LTE-ENODEB-ENBMIB





*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Library    ../utils/FileHandler.py
Resource    ../resources/SnmpMibHelper.robot
Resource    ../resources/AAUStatusCheck.robot
Resource    ../resources/BBUStatusCheck.robot
Suite Setup           Open Snmp Connection And Load Private MIB          ${IP}         ${Comitty}       ${Mib}
#Suite Teardown    Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb

*** Variables ***
${IP}             172.27.245.91
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

${ENB_ResetValue}    1        #不影响下一级复位
${ENB_SartUpStage}   configured

${LOG_Phase}    '接入标志:'
${LOG_Oper}    '操作状态:'

*** test case ***
Reset ENB Test
  [Documentation]     Multiple times reset ENB
  [Tags]              resetENB


  :FOR    ${loop}    IN RANGE    10
  \   Set Many By Name    equipResetTrigger    ${ENB_ResetValue}
  \   Sleep   300

#  \   ${curLocalCellConfigState}  ${errCode}  Get With Error By Name    nrLocalCellConfigTrigger
#  \   Should be equal    ${curLocalCellConfigState}    add

#  \   ${curCellActiveState}    Get By Name    nrCellActiveTrigger
#  \   Should be equal    ${curCellActiveState}    active

  \   ${curCellOperationalState}    ${errNum}    Get With Error By Name    nrCellOperationalState
#  \   Log to console    ${curCellOperationalState}
#  \   Log to console    ${errNum}
#  \   Should be equal    ${curCellOperationalState}    enabled
  \    Run Keyword If    '${curCellOperationalState}' != 'enabled'    间断性检查
  \    ${curCellOperationalState}    ${errNum}    Get With Error By Name    nrCellOperationalState
  \    Should be equal    ${curCellOperationalState}    enabled

***Keyword***
间断性检查
    :FOR    ${loop}    IN RANGE    60
    \    Log to console    进入间断性检查
    \    Sleep    10
    \    ${curCellOperationalState}    ${errNum}    Get With Error By Name    nrCellOperationalState
    \    Run Keyword If    '${curCellOperationalState}' == 'enabled'    Exit For Loop