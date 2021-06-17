
local myLfs = class("myLfs")

function myLfs:ctor()
    print("create myLfs ctor")
    self.allFile = {}
    self.directory = {}
    self.entry = {}
end


function myLfs:doSomeThings(rootPath)
    local str = '<FilePathData Path="'
    local str2 = '" />'
    for entry in lfs.dir(rootPath) do
        if entry ~='.' and entry ~='..' then
            local path = rootPath.."\\"..entry
            local attr = lfs.attributes(path)
            assert(type(attr)=="table") --如果获取不到属性表则报错
            -- PrintTable(attr)
            if attr.mode == "directory" then
                -- print("Dir:",path)
                --print(path)
                testFiles(path) --自调用遍历子目录
            elseif attr.mode=="file" then
                -- print(attr.mode,path)
               -- table.insert(allFilePath,path)
               print(str..path..str2)
               
               --print(entry)
               --table.insert(allFilePath,entry)
            end
        end
    end
end

function myLfs:PrintLfsVersion()
    print(lfs._VERSION)
end

function myLfs:PrintCurrrentDir( )
    print(lfs.currentdir())
end

function myLfs:PrintDirChildren(rootPath)
    for entry in lfs.dir(rootPath) do
        if entry~='.' and entry~='..' then
            local path = rootPath.."/"..entry
            local attr = lfs.attributes(path)
            assert(type(attr)=="table") --如果获取不到属性表则报错
            if(attr.mode == "directory") then
                print("Dir:",path)
            elseif attr.mode=="file" then
                print("File:",entry)
            end
        end
    end
end

function myLfs:attributes(rootPath)
    return lfs.attributes(rootPath)
end

function myLfs:GetAllFiles(rootPath)
    for entry in lfs.dir(rootPath) do
        if entry~='.' and entry~='..' then
            local path = rootPath.."/"..entry
            local attr = lfs.attributes(path)
            assert(type(attr)=="table") --如果获取不到属性表则报错
            -- PrintTable(attr)
            if(attr.mode == "directory") then
                --print("Dir:",path)
                table_insert(self.directory,path) 
                self:GetAllFiles(path) --自调用遍历子目录
            elseif attr.mode== "file" then
                --print("File:",entry)
                table_insert(self.allFile,path)
                table_insert(self.entry,entry)
            end
        end
    end
   -- print("============= myLfs:GetAllFiles end =================")
    return self.directory,self.allFile,self.entry
end

function myLfs:clear()
    self.allFile = {}
    self.directory = {}
    self.entry = {}
end

return myLfs

--[[
     local rootPath ="D:/myCode/cocosCode/lua51"
    local myLfs = require("myLfs"):create()

    myLfs:PrintLfsVersion()
    myLfs:PrintCurrrentDir()
    myLfs:PrintDirChildren(rootPath)
    print("==================")
    local attr = myLfs:attributes(rootPath)
    log(attr)

   local dir,file = myLfs:GetAllFiles(rootPath)
    
    log(dir)
    log(file)
    myLfs:clear()
]]



  -- 打印lfs库的版本
   -- PrintLfsVersion()
    -- 打印当前目录地址
    --PrintCurrrentDir()
    -- 打印当前目录的下一层子目录地址
   -- local rootPath = lfs.currentdir()
   -- PrintDirChildren(rootPath)
 
    -- 递归打印当前目录下面所有层级的子目录并将文件地址保存到表中
   -- local allFilePath = GetAllFiles(rootPath)
   -- PrintTable(allFilePath)

   --[[
    local path = "D:\\w4\\docs_res\\trunk\\client_res\\res\\csb"
    lfs.chdir (path)
    PrintCurrrentDir()

    testFiles(path)
    ]]

    --[==[
    - lfs.chdir (path)
将当前目录改为给定的path
- lfs.currentdir ()
获取当前目录
- lfs.dir (path)
Lua遍历目录下的所有入口，每次迭代都返回值为入口名的字符串
- lfs.lock (filehandle, mode[, start[, length]])
锁定一个文件或这文件的部分内容
- lfs.mkdir (dirname)
创建一个目录
- lfs.rmdir (dirname)
移除一个已存在的目录
- lfs.setmode (file, mode)
设置文件的写入模式，mode字符串可以是binary或text
- lfs.symlinkattributes (filepath [, aname])
比lfs.attributes多了the link itself (not the file it refers to)信息，其他都和lfs.attribute一样
- lfs.touch (filepath [, atime [, mtime]])
设置上一次使用和修改文件的时间值
- lfs.unlock (filehandle[, start[, length]])
解锁文件或解锁文件的部分内容
————————————————
版权声明：本文为CSDN博主「v_xchen_v」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/v_xchen_v/article/details/78321911
]==]