import unittest, sys

sys.path.append('../')

from ctypes import *
from TestCaseCommandParameter import TestCaseCommandParameter
from ParameterHelper import ParameterHelper

class TestCaseCommandParameterTestCase(unittest.TestCase):
    def test_should_create_parameters_success_when_input_type_right(self):
        number_parameter = 10
        buffer_para = bytearray(b'hello')
        origin_parameters = [number_parameter, buffer_para]

        parameterHelper = ParameterHelper()

        command_parameters = parameterHelper.create_testcase_parameters(origin_parameters)
        self.assertTrue(None != command_parameters)

        #first parameter should be number parameter
        self.assertTrue(1 == command_parameters[0].s32ParaType)
        self.assertTrue(10 == command_parameters[0].s32ParaVal)
        #NULL has "false" boolean value
        self.assertFalse(bool(command_parameters[0].pParaBuf))

        #second parameter should be buffer parameter
        self.assertTrue(2 == command_parameters[1].s32ParaType)
        self.assertTrue(len(buffer_para) == command_parameters[1].s32ParaVal)
        self.assertTrue(bool(command_parameters[1].pParaBuf))

    def test_should_create_failed_when_input_type_wrong(self):
        origin_parameters = [10, 'hello']
        parameterHelper = ParameterHelper()
        try:
            command_parameters = parameterHelper.create_testcase_parameters(origin_parameters)
            self.assertTrue(False)
        except TypeError as err:
            self.assertTrue(True)

if __name__ == '__main__':
    unittest.main()

