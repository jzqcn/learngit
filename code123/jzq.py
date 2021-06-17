#!/usr/bin/env python3
# -*- coding: utf-8 -*-
def copy1() :
    with open('D:/d盘的备份/resource/jzq/game_start.lua', 'rb') as f:
        file1 = f.read()
    with open('D:/w4/w4_client/src/game_start.lua', 'wb') as f:
         f.write(file1)

    with open('D:/d盘的备份/resource/jzq/baseview.lua', 'rb') as f:
        file2 = f.read()
    with open('D:/w4/w4_client/src/base/baseview.lua', 'wb') as f:
         f.write(file2)

def copy2() :
    with open('D:/d盘的备份/resource/jzq/return/game_start.lua', 'rb') as f:
        file1 = f.read()
    with open('D:/w4/w4_client/src/game_start.lua', 'wb') as f:
         f.write(file1)

    with open('D:/d盘的备份/resource/jzq/return/baseview.lua', 'rb') as f:
        file2 = f.read()
    with open('D:/w4/w4_client/src/base/baseview.lua', 'wb') as f:
         f.write(file2)

