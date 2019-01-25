# encoding utf-8
'''
@company: Datang Mobile
@license: (c) Copyright 2018, Datang Mobile
@author:  pengqiang
@file:    TestCaseClient.py
@time:    2018/07/28
@desc:     
'''
import sys
from ctypes import c_int
from ctypes import byref

from CTypesHelper import CTypesHelper
from ParameterHelper import ParameterHelper
from TestCaseLib import TestCaseLib


#TestCaseLib wrapper for robotframework
class TestCaseClient(object):
    #object scope define
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self._testcaselib = TestCaseLib().getLibrary()
        self._ctypesHelper = CTypesHelper()
        self._parameterHelper = ParameterHelper()
        self._hostName = None
        self._hostAddr = None
        self._pId = None


    # connect device not use pid
    def connect(self, host_name, host_address):
        connect_result = -1
        self._hostName, self._hostAddr = self._ctypesHelper.convert_strings_to_cchar_p([host_name, host_address])
        if 0 != self._testcaselib.TestCase_RegisterTargetProc_Ex(self._hostName, self._hostAddr):
            raise TimeoutError("connection failed!")
        else:
            return
    # connect device use pid
    def connect_by_pid(self, host_name, host_address, pId, slotNum=0, procId=0):
        connect_result = -1
        self._hostName, self._hostAddr = self._ctypesHelper.convert_strings_to_cchar_p([host_name, host_address])
        self._pId = pId
        self._slotNum = slotNum
        self._procId = procId
        ret = self._testcaselib.TestCase_RegisterTargetProc_Pid(self._hostName, self._hostAddr, self._pId, self._slotNum, self._procId)
        return ret

    def execute_command(self, command_name, *parameters):
        resultVal = c_int(-1)

        function_name = self._ctypesHelper.convert_string_to_cchar_p(command_name)

        testcaseParameters, parameter_num = self._parameterHelper.create_testcase_parameters(parameters)

        execute_result = self._testcaselib.TestCase_ExcuteCmd(self._hostName, \
                function_name, testcaseParameters, parameter_num, byref(resultVal))

        if (0 != execute_result):
            raise RuntimeError("execute command {0} failed, error no: {1}".format(command_name, execute_result))
        else:
            return resultVal.value

    def execute_command_with_disconnect_after_command(self, command_name, *parameters):
        resultVal = c_int(-1)

        function_name = self._ctypesHelper.convert_string_to_cchar_p(command_name)

        testcaseParameters, parameter_num = self._parameterHelper.create_testcase_parameters(parameters)

        execute_result = self._testcaselib.TestCase_ExcuteCmd(self._hostName, \
                function_name, testcaseParameters, parameter_num, byref(resultVal))

        if (0 != execute_result and (-6) != execute_result):
            raise RuntimeError("execute command {0} failed, error no: {1}".format(command_name, execute_result))
        else:
            return execute_result, resultVal.value

    def execute_command_with_out_datas(self, command_name, *parameters):
        resultVal = c_int(-1)
        resList = list()

        function_name = self._ctypesHelper.convert_string_to_cchar_p(command_name)

        testcaseParameters, parameter_num = self._parameterHelper.create_testcase_parameters(parameters)

        execute_result = self._testcaselib.TestCase_ExcuteCmd(self._hostName, \
                function_name, testcaseParameters, parameter_num, byref(resultVal))

        if (0 != execute_result):
            raise RuntimeError("execute command {0} failed, error no: {1}".format(command_name, execute_result))
        else:
            for item in  testcaseParameters:
                if item.s32ParaType == self._parameterHelper.PAR_TYPE_BUFFER:
                    resList.append(item.pParaBuf[:item.s32ParaVal])
            return resultVal.value, resList

    def disconnect(self):
        return self._testcaselib.TestCase_UnregisterTargetProc(self._hostName, self._hostAddr)

    def disconnect_by_pid(self):
        return self._testcaselib.TestCase_UnregisterTargetProc_Pid(self._hostName, self._hostAddr, self._pId)


