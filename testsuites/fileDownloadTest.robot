# encoding utf-8
'''
文件下载测试用例
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
${FtpServerIp}    172.27.245.100
${Community}      public
#${Community}     dtm.1234
${MibName}        DTM-TD-LTE-ENODEB-ENBMIB
${host_name}			'SCTF'
${host_address}	  172.27.245.92
${pId}	          ${-1}

*** Keywords ***

*** test case ***
#~ #----------------------------------------------------------------------
# 初始化ftp服务器信息
#Init FtpServer Info
    #FtpServer Info Set    ${FtpServerIp}

#~ #----------------------------------------------------------------------

# 连接设备
Connect Device Use Pid
    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}
    
# 普通文件下载
Normol File Download
    ${rs}    File Download      ${FtpServerIp}:\/\/D:\/file_download\/lm.dtz     \/ramDisk\/lm.dtz    
    Should be equal    ${rs}    ${True}
    
# 断开连接
Disconnect Device
    Disconnect UAgent    