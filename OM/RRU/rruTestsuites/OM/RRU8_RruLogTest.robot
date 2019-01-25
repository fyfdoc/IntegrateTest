# encoding utf-8
'''
日志文件测试用例
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource        ../../../FILE/fileResources/RruLogResource.robot
Resource        ../../../COMM/commResources/SnmpMibHelper.robot
Resource        ../../../FILE/fileResources/CommonLogResource.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***
${ftp_dir}          C:\\rru_log
${FtpServerIp}      172.27.245.198

*** test case ***
# #~ #----------------------------------------------------------------------
# # # 初始化ftp服务器信息
# Init FtpServer Info
#     FtpServer Info Set    ${FtpServerIp}

#~ #----------------------------------------------------------------------
# RRU日志上传
#     Sleep    30
#     ${ret_00}    RRU Log File Upload    rrualarm    ${ftp_dir}
#     Log    ${ret_00}
#     Sleep    30
#     ${ret_01}    RRU Log File Upload    rruuser    ${ftp_dir}
#     Log    ${ret_01}
#     Sleep    30
#     ${ret_02}    RRU Log File Upload    rrusys    ${ftp_dir}
#     Log    ${ret_02}

RRU告警日志上传
    Sleep    30
    RRU Log File Upload    rrualarm    ${ftp_dir}

RRU用户日志上传
    Sleep    30
    RRU Log File Upload    rruuser    ${ftp_dir}

RRU系统日志上传
    Sleep    30
    RRU Log File Upload    rrusys    ${ftp_dir}
