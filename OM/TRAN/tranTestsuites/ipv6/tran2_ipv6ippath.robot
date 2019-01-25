ccc #encoding utf-8

'''
create by caoweidong
配置ippath测试用例(IPv6)
'''

from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    ../../tranResources/tranResource.robot

Suite Setup           Open Snmp Connection And Load Private MIB
Suite TearDown    Log    do somethings for post-processing

 
*** Test Cases ***
IPv6IPath Cfg Test
    
    Tran_env_check
    Cfg dst ipv6   
    Send cutovertrigger
    Cfg dst ippath
    Send cutovertrigger
    Mib ippathstatus Should be enabled
			    
    

    
         
    

