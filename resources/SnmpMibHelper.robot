# encoding utf-8
'''
SNMP及MIB资源文件
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py

*** Variables ***


*** Keywords ***
#~ #---------------------------------------------------------------------- 
# SNMP连接及MIB加载方法
Open Snmp Connection And Load Private MIB
    [Arguments]    ${dstIp}    ${Comitty}    ${mib}  
    Open Snmp Connection    ${dstIp}    ${Comitty} 
    Load Mib    DTM-TD-LTE-ENODEB-ENBMIB
