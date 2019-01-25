# encoding utf-8
# *************************************************************
# *** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
# *************************************************************
# *文件名称：local_003_flow_test.robot
# *功能描述：近端场景 flow 测试
# *使用方法：

# -----------------------------------------------------------------------------------
# *修改记录：                                                                       |
# *##修改日期    |    修改人    |    修改描述    |                                  |
# *2018-11-01        sunshixu         创建文件                                       |
# ----------------------------------------------------------------------------------|
# *************************************************************
# ______________________________________________________________________________________
# *用例记录：                                                                          |
# -------------------------------------------------------------------------            |
# **                                                                                   |
# _____________________________________________________________________________________|

# **************************************************************************************

*** Settings ***
Resource    ../../Resources/TSP/TspResource.robot
Resource    ../../Resources/TSP/LogInHelper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB

*** Test Cases ***

Construct & Channel Test
    Local Login HSCTD Process    ${2}
    CHANNEL TEST
    配置添加Channel_Construct
    无对端模式增加设置MAC功能_Construct

UDP FLOW TEST
    配置添加一条UDP FLOW
    查询配置的UDP FLOW
    删除配置的UDP FLOW
    查询删除的UDP FLOW

GTPU FLOW TEST
    配置添加一条GTPU FLOW
    查询配置的GTPU FLOW
    删除配置的GTPU FLOW
    查询删除的GTPU FLOW

ROUTE FLOW TEST
    配置添加一条ROUTE FLOW
    查询配置的ROUTE FLOW
    删除配置的ROUTE FLOW
    查询删除的ROUTE FLOW

SCTP FLOW TEST
    配置添加一条SCTP FLOW
    查询配置的SCTP FLOW
    删除配置的SCTP FLOW
    查询删除的SCTP FLOW

IPV6 DOWN TRAFFIC FLOW TEST
    配置添加一条IPV6 DOWN TRAFFIC FLOW
    查询配置的IPV6 DOWN TRAFFIC FLOW
    删除配置的IPV6 DOWN TRAFFIC FLOW
    查询删除的IPV6 DOWN TRAFFIC FLOW

IPV6 UP TRAFFIC FLOW TEST
    配置添加一条IPV6 UP TRAFFIC FLOW
    查询配置的IPV6 UP TRAFFIC FLOW
    删除配置的IPV6 UP TRAFFIC FLOW
    查询删除的IPV6 UP TRAFFIC FLOW

IPV6 UDP FLOW TEST
    配置添加一条IPV6 UDP FLOW
    查询配置的IPV6 UDP FLOW
    删除配置的IPV6 UDP FLOW
    查询删除的IPV6 UDP FLOW

IPV6 GTPU FLOW TEST
    配置添加一条IPV6 GTPU FLOW
    查询配置的IPV6 GTPU FLOW
    删除配置的IPV6 GTPU FLOW
    查询删除的IPV6 GTPU FLOW

IPV6 ROUTE FLOW TEST
    配置添加一条IPV6 ROUTE FLOW
    查询配置的IPV6 ROUTE FLOW
    删除配置的IPV6 ROUTE FLOW
    查询删除的IPV6 ROUTE FLOW

IPV6 SCTP FLOW TEST
    配置添加一条IPV6 SCTP FLOW
    查询配置的IPV6 SCTP FLOW
    删除配置的IPV6 SCTP FLOW
    查询删除的IPV6 SCTP FLOW

REMOTE ACCESS FLOW TEST
    配置添加一条REMOTE ACCESS FLOW
    查询配置的REMOTE ACCESS FLOW
    删除配置的REMOTE ACCESS FLOW
    查询删除的REMOTE ACCESS FLOW

REMOTE FTP CONTROL CATCH FLOW TEST
    配置添加一条REMOTE FTP CONTROL CATCH FLOW
    查询配置的REMOTE FTP CONTROL CATCH FLOW
    删除配置的REMOTE FTP CONTROL CATCH FLOW
    查询删除的REMOTE FTP CONTROL CATCH FLOW

REMOTE FTP CONTROL FLOW TEST
    配置添加一条REMOTE FTP CONTROL FLOW
    查询配置的REMOTE FTP CONTROL FLOW
    删除配置的REMOTE FTP CONTROL FLOW
    查询删除的REMOTE FTP CONTROL FLOW

REMOTE FTP DATA FLOW TEST
    配置添加一条REMOTE FTP DATA FLOW
    查询配置的REMOTE FTP DATA FLOW
    删除配置的REMOTE FTP DATA FLOW
    查询删除的REMOTE FTP DATA FLOW

NB REMOTE NB FLOW TEST
    配置添加一条NB REMOTE NB FLOW
    查询配置的NB REMOTE NB FLOW
    删除配置的NB REMOTE NB FLOW
    查询删除的NB REMOTE NB FLOW

COMP JT FLOW TEST
    配置添加一条COMP JT FLOW
    查询配置的COMP JT FLOW
    删除配置的COMP JT FLOW
    查询删除的COMP JT FLOW

DOWN TRAFFIC FLOW TEST
    配置添加一条DOWN TRAFFIC FLOW
    查询配置的DOWN TRAFFIC FLOW
    删除配置的DOWN TRAFFIC FLOW
    查询删除的DOWN TRAFFIC FLOW

DOWN GTPC FLOW TEST
    配置添加一条DOWN GTPC FLOW
    查询配置的DOWN GTPC FLOW
    删除配置的DOWN GTPC FLOW
    查询删除的DOWN GTPC FLOW

# F1 FLOW TEST
    # F1 FLOW
    # F1 FLOW
    # F1 FLOW4

UP TRAFFIC FLOW TEST
    配置添加一条UP TRAFFIC FLOW
    查询配置的UP TRAFFIC FLOW
    删除配置的UP TRAFFIC FLOW
    查询删除的UP TRAFFIC FLOW

IPV6 REMOTE ACCESS FLOW TEST
    配置添加一条IPV6 REMOTE ACCESS FLOW
    查询配置的IPV6 REMOTE ACCESS FLOW
    删除配置的IPV6 REMOTE ACCESS FLOW
    查询删除的IPV6 REMOTE ACCESS FLOW

IPV6 REMOTE FTP CONTROL CATCH FLOW TEST
    配置添加一条IPV6 REMOTE FTP CONTROL CATCH FLOW
    查询配置的IPV6 REMOTE FTP CONTROL CATCH FLOW
    删除配置的IPV6 REMOTE FTP CONTROL CATCH FLOW
    查询删除的IPV6 REMOTE FTP CONTROL CATCH FLOW

IPV6 REMOTE FTP CONTROL FLOW TEST
    配置添加一条IPV6 REMOTE FTP CONTROL FLOW
    查询配置的IPV6 REMOTE FTP CONTROL FLOW
    删除配置的IPV6 REMOTE FTP CONTROL FLOW
    查询删除的IPV6 REMOTE FTP CONTROL FLOW

IPV6 REMOTE FTP DATA FLOW TEST
    配置添加一条IPV6 REMOTE FTP DATA FLOW
    查询配置的IPV6 REMOTE FTP DATA FLOW
    删除配置的IPV6 REMOTE FTP DATA FLOW
    查询删除的IPV6 REMOTE FTP DATA FLOW

Destruct
    删除配置的channel_Destruct
    Disconnect UAgent Use Pid
