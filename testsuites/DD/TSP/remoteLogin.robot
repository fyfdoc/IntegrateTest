# encoding utf-8

# @company: Datang Mobile
# @license: (c) Copyright 2018, Datang Mobile
# @author: sunshixu
# @file:    remotelinin.robot
# @desc: TSP 进程连通 测试

*** Settings ***
Resource    ../../../resources/LogInHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${host_address}    ${Community}    ${MibName}

*** Test Cases ***
# 连接设备
远端链接HSCTD_SCP主进程PID2
    Remote Login HSCTD Process    ${2}
    Disconnect UAgent Use Pid
远端链接HSCTD_SCP从进程PID3
    Remote Login HSCTD Process    ${3}
    Disconnect UAgent Use Pid
远端链接HSCTD_SCP从进程PID4
    Remote Login HSCTD Process    ${4}
    Disconnect UAgent Use Pid
远端链接HSCTD_SCP从进程PID5
    Remote Login HSCTD Process    ${5}
    Disconnect UAgent Use Pid
远端链接HBPOD_BCP主进程PID2
    Remote Login HBPOD Process    ${2}
    Disconnect UAgent Use Pid
远端链接HBPOD_BCP从进程PID3
    Remote Login HBPOD Process    ${3}
    Disconnect UAgent Use Pid
远端链接HBPOD_BCP从进程PID4
    Remote Login HBPOD Process    ${4}
    Disconnect UAgent Use Pid
远端链接HBPOD_BCP从进程PID5
    Remote Login HBPOD Process    ${5}
    Disconnect UAgent Use Pid
远端链接HBPOD_BCP从进程PID6
    Remote Login HBPOD Process    ${6}
    Disconnect UAgent Use Pid
远端链接HBPOD_BCP从进程PID7
    Remote Login HBPOD Process    ${7}
    Disconnect UAgent Use Pid
远端链接HBPOD_BCP从进程PID8
    Remote Login HBPOD Process    ${8}
    Disconnect UAgent Use Pid
远端链接HBPOD_PLP1_ARM
    Remote Login HBPOD Process    ${11}
    Disconnect UAgent Use Pid
远端链接HBPOD_PLP2_ARM
    Remote Login HBPOD Process    ${21}
    Disconnect UAgent Use Pid