#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
sys.path.append("D:/myCode/cocosCode/python")
#print(sys.argv[0])
#print(type(sys.argv[1]))
#print(sys.path)

from code123 import jzq

if __name__=='__main__':
    if sys.argv[1] == "copy1":
        jzq.copy1()
        print("执行复制完成 copy1 ")
    elif sys.argv[1] == "copy2":
        jzq.copy2()
        print("执行还原完成 copy2 ")
    else:
        print("参数错误")
        print(sys.argv[1])


