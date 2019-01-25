# encoding utf-8
'''
@company: Datang Mobile
@license: (c) Copyright 2018, Datang Mobile
@author:  pengqiang
@file:    CTypesHelper.py
@time:    2018/07/28
@desc:     
'''
from ctypes import *

class CTypesHelper(object):

    #convert python string to c_char_p for call C API
    def convert_string_to_cchar_p(self, convert_text):
        cchar_p = c_char_p(convert_text.encode(encoding="gb2312"))
        return cchar_p

    def convert_strings_to_cchar_p(self, convert_strings):
        convert_result = []
        for convert_str in convert_strings:
            convert_result.append(self.convert_string_to_cchar_p(convert_str))
        return convert_result

