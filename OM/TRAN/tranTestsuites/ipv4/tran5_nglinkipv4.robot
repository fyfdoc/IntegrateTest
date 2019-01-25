ccc #encoding utf-8

'''
create by caoweidong
配置nglink测试用例(IPv4)
'''

from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    ../../tranResources/tranResource.robot

Suite Setup           Open Snmp Connection And Load Private MIB
Suite TearDown    Log    do somethings for post-processing

 
*** Test Cases ***
nglinkipv4 Cfg Test
    
    Tran_env_check
    Set No Clk Mode
    #Set No AMF Mode 
    Cfg dst ipv4
    Cfg dst ippath
    Cfg dst ipv4nglink  
    Send cutovertrigger
    Mib nglinkstatus Should be enabled
			    




