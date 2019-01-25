# encoding utf-8
'''
@company: Datang Mobile
@license: (c) Copyright 2018, Datang Mobile
@author:  pengqiang
@file:    TestCaseCommandParameter.py
@time:    2018/07/31
@desc:     
'''

from ctypes import *

class TestCaseCommandParameter(Structure):
    _fields_ = [('s32ParaType', c_int), ('s32ParaVal', c_int), ('pParaBuf', POINTER(c_char))]

