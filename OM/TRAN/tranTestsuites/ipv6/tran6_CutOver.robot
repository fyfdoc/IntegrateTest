# encoding utf-8
'''
压力割接
'''
from pysnmp.smi.rfc1902 import ObjectIdentity


*** Keywords ***
Open Snmp Connection And Load Private MIB
   [Arguments]   ${DeviceIp}       ${Comitty}      ${MibName}
   Open Snmp Connection       ${DeviceIp}          ${Comitty}
   Load Mib      DTM-TD-LTE-ENODEB-ENBMIB
   
   
*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../../../utils/CiUtils.py
#Resource    ../../resources/SnmpMibHelper.robot
Resource    ../../tranResources/tranResource.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}

*** Variables ***
${DeviceIp}    172.27.245.92
${Community}    public
# ${Community}    dtm.1234
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

*** test case ***
#~ #----------------------------------------------------------------------
割接测试
    压力割接    10
