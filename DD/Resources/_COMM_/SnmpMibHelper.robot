# encoding utf-8
'''
SNMP及MIB资源文件
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../../utils/CiUtils.py

*** Variables ***
${IP1}             172.27.245.91
${IP2}             172.27.245.92
${Comitty1}        public
${Comitty2}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#~ #----------------------------------------------------------------------
# SNMP连接及MIB加载方法
Open Snmp Connection And Load Private MIB
    [Documentation]    连接SNMP
    [Tags]    mandatory
    [Arguments]
    [Return]
    [Teardown]    Log    SNMP Connect Success!
    [Timeout]

    ${ret}    Open Snmp Connection    ${IP1}    ${Comitty1}
    log    ${ret}
    Run Keyword If    ${ret} == 1    Open Snmp Connection    ${IP2}    ${Comitty1}
    Load Mib    DTM-TD-LTE-ENODEB-ENBMIB

