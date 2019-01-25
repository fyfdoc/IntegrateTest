# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：RruLogResource.robot
*功能描述：rru日志上传接口
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20         morunzhang       创建文件                                     |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##查询类关键字##                                                                    |
*A1.                                                                                 |
*##动作类关键字##                                                                    |
*B1.Rru日志上传接口                      -> RRU Log File Upload                      |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：Rru日志上传接口                                                        *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：fileTransTypeName:文件类型英文名    fileTransFTPDirectory:上传路径     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：FILE                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：RRU Log File Upload    ${rrualarm}    C:\\enb_log                      *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
RRU Log File Upload
    #           rrualarm | rruuser | rrusys | all
    [Arguments]    ${fileTransTypeName}    ${fileTransFTPDirectory}
    # 根据英文名称获取日志文件传输类型的编号
    ${fileTransTypeNo}    GetFileTransTypeIndexByName    ${fileTransTypeName}
    Log    ${fileTransTypeNo}
    # 下发日志文件上传命令
    Set Many By Name    topoRRULogFileType    ${fileTransTypeNo}    idx=${0}
    ...                 topoRRULogDestination    ${fileTransFTPDirectory}    idx=${0}
    # 获取日志文件名称的关键字，用于检查文件是否上传成功
    ${fileNameKeyword}    GetLogFileKeyNameByType    ${fileTransTypeName}
    Log    ${fileNameKeyword}
    # 检查文件是否上传成功
    ${ret}    isRRULogFileExists    ${fileTransFTPDirectory}    ${fileNameKeyword}
    [Return]    ${ret}
