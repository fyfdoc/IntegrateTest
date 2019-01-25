 #encoding utf-8

'''
create by caoweidong
配置IP测试用例(IPv6)
'''

from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    ../../tranResources/tranResource.robot

Suite Setup           Open Snmp Connection And Load Private MIB
Suite TearDown    Log    do somethings for post-processing


*** Test Cases ***
IP Cfg Test
    
    Tran_env_check
    Get idxaddr
    #OSP Connect
    Cfg dst ipv6  
    Send cutovertrigger
    Mib ipstatus Should be enabled
    #Cfgip DD Should be enabled
    #Disconnect UAgent Use Pid
    


    
         
    

