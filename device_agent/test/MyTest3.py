# encoding utf-8
'''
     
'''
import os
import sys


class MyClass:
    """ my class """
    i = 12345

    def __init__(self):
        self.i = 4567
        print('hello __init__()')

    def f(self):
        return 'hello world'


x = MyClass()

print("MyClass i = {0}".format(x.i))
print("MyClass f() = {0}".format(x.f()))


class Complex:
    def __init__(self, realpart, imagpart):
        self.r = realpart
        self.i = imagpart

c = Complex(3.0, -4.5)
print('r = {0}'.format(c.r))
print('i = {0}'.format(c.i))
