# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：RRU9_AAU_DD_TIME_PLING.robot
*功能描述：AAU DD时域打桩测量用例
*使用方法：
1.需要先mount PC端的时域打桩文件到AAU接口板
2.调用时域打桩开始接口函数，开始打桩
3.依次查询下行空口功率，并与定标值作比较
4.调用时域打桩停止接口函数，停止打桩
-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-14        zhaobaoxin       创建文件                                      |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*用例记录：（记录用例测试出的问题，引用关键字遇到的异常问题等等）                    |
**                                                                                   |
**                                                                                   |
_____________________________________________________________________________________|

************************************************用例文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Keywords ***

*** Settings ***
Resource        ../../rruResources/DD/ddResources.robot

*** Variables ***
${IP}             172.27.245.92
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

${AIU_address}    172.27.45.250
${ARU4_address}    172.27.45.254

#打桩测试文件名
${ifft_InData}    dlpre_ac_indata.dat
${ifft_InData}    ifft_proc_intv_ch0.am

*** test case ***
AAU_DD_TIME_PILING
    [Tags]              IR Time Delay Test
    [Documentation]     Time Pling Test

    #首先确保小区正常建立，否则打桩无意义
#    AAU Status Check After Restart

    #下载数据源到/ramDisk
    #20181105 现在的方式时在接口板mnt PC文件，然后copy到ramDisk中
    Mount File To ramDisk    ${ifft_InData}    ${AIU_address}

    #{ret}    Copy File To ramDisk
    #Log To Console    \n ${ret}

    #打开时域打桩开关
    #Osp敲命令行
    #RRU_TIME_PILING_START  ： 时域打桩，入参文件路径  ifft_proc_intv_ch0.am
    #RRU_TIME_PILING_STOP   ： 时域打桩停止
    #RRU_FREQ_PILING_START  ： 频域打桩，入参文件路径  dlpre_ac_indata.dat
    #RU_FREQ_PILING_STOP   ： 频域打桩停止
    Time Piling Start

    #开天线(循环开单根天线)
    #LMT读下行空口功率
    Open Ant and Get rruPathTxPower

    Time Piling Stop

