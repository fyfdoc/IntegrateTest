# encoding utf-8
'''
@company: Datang Mobile
@license: (c) Copyright 2018, Datang Mobile
@author:  pengqiang
@file:    ParameterHelper.py
@time:    2018/07/28
@desc:     
'''

import sys
#from enum import Enum
from ctypes import *

from TestCaseCommandParameter import TestCaseCommandParameter

#class ParameterType(Enum):
#    NUMBER = 1
#    BUFFER = 2

#convert parameters to that test case api's foramt
class ParameterHelper(object):
    """ ParameterHelper class """
   # parameter type 
    PAR_TYPE_NUMBER = 1
    PAR_TYPE_BUFFER = 2

    #leagle input parameter types are number(int) and string
    #when input parameter type are illeagl, throw TypeError exception
    def create_testcase_parameters(self, parameters):
        created_parameters = (TestCaseCommandParameter * len(parameters))()
        parameter_number = 0; 
        for parameter in parameters:
            if int == type(parameter):
                created_parameters[parameter_number] = self.create_testcase_number_parameter(parameter)
            elif str == type(parameter):
                created_parameters[parameter_number] = self.convert_str_to_testcase_parameter(parameter)
            else:
                error_cause = "not support {0} parameter, {1}".format(type(parameter), parameter)
                raise TypeError(error_cause)
            parameter_number += 1
        return created_parameters, parameter_number

    
    def convert_str_to_testcase_parameter(self, parameter):
        converter = None
        parameter = parameter.strip()

        if parameter.endswith(']'):
            #buffer type
            converter = self.convert_str_number_array_to_testcase_buffer_parameter
        elif parameter.endswith('>'):
            #custom parameter type (parameter format: <200,[S;10;0;ABCDEF],[N;4;12;3]>)
            converter = self.convert_custom_struct_to_testcase_buffer_parameter
        elif parameter.endswith('\''):
            #string type
            parameter = parameter.strip('\'')
            converter = self.convert_str_to_testcase_buffer_parameter
        else:
            converter = self.convert_str_number_to_testcase_number_parameter

        return converter(parameter)

    # convert custom struct parameter
    def convert_custom_struct_to_testcase_buffer_parameter(self, parameter):
        # parameter format: <200,[S;10;0;ABCDEF],[N;4;12;3]>
        pointer_info = parameter.strip('<>')

        #split parameters
        parStructInfo = bytearray()
        parStructInfo = pointer_info.split(',')
        print("parStructInfo = {0}".format(parStructInfo))
        if len(parStructInfo) < 1:
            error_cause = "parameter format error :{0}".format(parameter)
            raise TypeError(error_cause)

        # buffer size
        totalBufSize = int(parStructInfo[0])
        print("totalBufSize = {0}".format(totalBufSize))
        # create buffer
        parBufArray = bytearray(totalBufSize)

        # init parameter struct
        par = TestCaseCommandParameter()
        par.s32ParaType = self.PAR_TYPE_BUFFER
        par.s32ParaVal = int(totalBufSize)
     
        # parameter values info 
        if len(parStructInfo) > 1:
            # get parameter value info  (format: [S;10;0;ABCDEF],[N;4;12;3])
            parValuesInfo = parStructInfo[1:]
            for strItem in parValuesInfo:   # format: [S;10;0;ABCDEF]
                if ((not strItem.startswith('[')) and (not strItem.endswith(']'))):
                    error_cause = "parameter value info format error :{0}".format(parameter)
                    raise TypeError(error_cause)
                # parse parameter info
                strItem = strItem.strip()
                strItem = strItem.strip('[]')
                # format: S;10;0;ABCDEF
                parInfoList = strItem.split(';')
                print("parInfoList = {0}".format(parInfoList))
                if len(parInfoList) < 4:
                    error_cause = "parameter value info size error:{0}".format(parameter)
                    raise TypeError(error_cause)
                
                # parse value info
                parType = parInfoList[0]
                parByteSize = int(parInfoList[1])
                parBufIndex = int(parInfoList[2])
                parValue = parInfoList[3]
                print("parType = {0}, parByteSize = {1}, parBufIndex = {2}, parValue = {3}" \
                    .format(parType, parByteSize, parBufIndex, parValue))
                
                # index out of range
                if parBufIndex >= totalBufSize:
                    error_cause = "parameter value buffer index is out of range: bufferIndex={0}, bufferSize={1}" \
                    .format(bufferIndex, bufferSize)
                
                if parType == 'S': # string [S;10;0;ABCDEF]
                    valBufArray = bytearray(parValue.encode(encoding='gb2312'))
                    parBufArray[parBufIndex:parBufIndex+len(valBufArray)] = valBufArray
                elif parType == 'N': # number [N;4;12;3]
                    intVal = int(parValue)
                    valBufArray = intVal.to_bytes(parByteSize, sys.byteorder)
                    parBufArray[parBufIndex:parBufIndex+len(valBufArray)] = valBufArray
                else:
                    error_cause = "parameter value type error: {0}".format(strItem)
                    raise TypeError(error_cause)

        par.pParaBuf = (c_char * totalBufSize).from_buffer(parBufArray)

        return par

    def convert_str_number_array_to_testcase_buffer_parameter(self, parameter):
        #get byte length of number
        number_byte_len = self.get_number_byte_length(parameter)

        #remove format control character
        numbers_str = parameter[1:len(parameter)]
        numbers_str = numbers_str.strip('[]')

        #split number and convert to bytes
        numbers_byte_array = bytearray()

        number_str_array = numbers_str.split(',')
        for number_str in number_str_array:
            number_str = number_str.strip()
            number = self.convert_str_to_number(number_str)
            numbers_byte_array += number.to_bytes(number_byte_len, byteorder=sys.byteorder)


        print("parameter buf len : {0}, parameter buf is {1}".format(len(numbers_byte_array), numbers_byte_array))

        return self.create_testcase_buffer_parameter(numbers_byte_array)


    def convert_str_to_testcase_buffer_parameter(self, parameter):
        strByteArray = bytearray(parameter.encode(encoding='gb2312'))
        return self.create_testcase_buffer_parameter(strByteArray)


    def convert_str_number_to_testcase_number_parameter(self, parameter):
        number = self.convert_str_to_number(parameter)
        return self.create_testcase_number_parameter(number)


    def create_testcase_number_parameter(self, parameter):
        created_number_parameter = TestCaseCommandParameter()
        created_number_parameter.s32ParaType = self.PAR_TYPE_NUMBER
        created_number_parameter.s32ParaVal = parameter
        created_number_parameter.pParaBuf = POINTER(c_char)()

        return created_number_parameter


    def create_testcase_buffer_parameter(self, parameter):
        created_buffer_parameter = TestCaseCommandParameter()
        created_buffer_parameter.s32ParaType = self.PAR_TYPE_BUFFER
        created_buffer_parameter.s32ParaVal = len(parameter)

        created_buffer_parameter.pParaBuf = (c_char * len(parameter)).from_buffer(parameter)
        return created_buffer_parameter


    def convert_str_to_number(self, str_number):
        number = None
        try:
            number = int(str_number)
        except ValueError:
            number = int(str_number, base=16)

        return number


    def get_number_byte_length(self, parameter):
        number_length = int(0)
        if parameter.startswith('I'):
            number_length = int(4)
        elif parameter.startswith('S'):
            number_length = int(2)
        elif parameter.startswith('C'):
            number_length = int(1)
        else:
            raise ValueError("unknown number type!")
        return number_length

