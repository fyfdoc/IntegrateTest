# encoding utf-8
'''
无对端mme测试用例
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Resource    ../resources/LogHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}

*** Variables ***
${DeviceIp}       172.27.245.92
${Community}      public
#${Community}     dtm.1234
${MibName}        DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***

*** test case ***
    
# 无对端mme下发
No Peer MME
	    Set By Name    sysS1CreateMode    noPeerMme
	    Sleep    5s
	    ${s1Status}    Get By Name    linkCommonOperationStatus 	     
	    Should be equal    ${s1Status}    enabled