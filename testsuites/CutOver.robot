# encoding utf-8
'''
压力割接
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}

*** Variables ***
${DeviceIp}    172.27.245.92
${Community}    public
# ${Community}    dtm.1234
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

*** test case ***
#~ #----------------------------------------------------------------------
压力割接
    :FOR    ${i}    in range    100
    \    割接

*** Keywords ***
# 割接
割接
    Set By Name    transCutOverTrigger    ${1}
    Sleep    60
    ${sctp_status}    Get By Name    sctpStatus
    Log    ${sctp_status}
    Should Be Equal    ${sctp_status}    ok