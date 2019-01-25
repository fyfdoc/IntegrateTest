ccc #encoding utf-8

'''
create by caoweidong
配置omlink测试用例(IPv6)
'''

from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    ../../tranResources/tranResource.robot

Suite Setup           Open Snmp Connection And Load Private MIB
Suite TearDown    Log    do somethings for post-processing

 
*** Test Cases ***
omlinkipv6 Cfg Test
    
    Cfg dst ipv6omlink  
    Send cutovertrigger
    Mib omlinkstatus Should be enabled
			    