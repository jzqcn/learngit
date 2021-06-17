-- 唯一Id
auto_id = auto_id or 0

function autoId()
    auto_id = auto_id + 1
    return auto_id
end

-- 打印table
function printLuaTable (lua_table, indent)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        local szSuffix = ""
        local TypeV = type(v)
        if TypeV == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep(" ", indent)
        local formatting = szPrefix..k.." = "..szSuffix
        if TypeV == "table" then
            print(formatting)
            printLuaTable(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if TypeV == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end

function luaTable2Str(str, lua_table, indent)
    indent = indent or 0
    str = str or ""
    for k, v in pairs(lua_table) do
        local szSuffix = ""
        TypeV = type(v)
        if TypeV == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep(" ", indent)
        formatting = szPrefix..k.." = "..szSuffix
        if TypeV == "table" then
            str = str..formatting.."\n"
            str = luaTable2Str(str, v, indent + 1)
            str = str .. szPrefix.."}\n"
        else
            local szValue = ""
            if TypeV == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            str = str .. formatting..szValue.."\n"
        end
    end
    return str
end

-- 打印调用文件和行数
function printParent(lev)
    lev = lev or 2
    local track_info = debug.getinfo(lev, "Sln")
    local parent = string.match(track_info.short_src, '[^"]+.lua')     -- 之前调用的文件
    print(string.format("From %s:%d in function `%s`",parent or "nil",track_info.currentline,track_info.name or ""))
end

-- 把table写成文件
function writeLuaTable (file, lua_table, indent)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        TypeV = type(v)
        if TypeV == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep(" ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if TypeV == "table" then
            file:write("[Trace] " .. formatting.."\n")
            write_lua_table(file, v, indent + 1)
            file:write("[Trace] "..szPrefix.."},\n")
        else
            local szValue = ""
            if TypeV == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            file:write("[Trace] " .. formatting..szValue..",\n")
        end
    end
end

-- 拷贝table 不能直接用=来复制，否则会一起改变
function deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- 四舍五入
function mathRound( num )
    return math.floor(num + 0.5)
 end

 -- 获取整数部分
function getIntPart(x)
    local temp = math.ceil(x)
        if temp == x then
            return temp
        else
            return temp - 1
        end
    end
    
    -- 获取小数部分
    function getFloatPart(x)
        return x - getIntPart(x)
    end
    
    --[[获取小数保留n位的四舍五入
    -- @param number 小数
    -- @param n 保留位
    -- ]]
    function getRoundForNLocation(number, n)
        return (math.floor(math.pow(10, n)*number + 0.5))/(math.pow(10, n))
    end

    function Split(split_string, splitter)
        -- 以某个分隔符为标准，分割字符串
        -- @param split_string 需要分割的字符串
        -- @param splitter 分隔符
        -- @return 用分隔符分隔好的table
    
        local split_result = {}
        local search_pos_begin = 1
    
        while true do
            local find_pos_begin, find_pos_end = string.find(split_string, splitter, search_pos_begin)
            if not find_pos_begin then
                break
            end
    
            split_result[#split_result + 1] = string.sub(split_string, search_pos_begin, find_pos_begin - 1)
            search_pos_begin = find_pos_end + 1
        end
    
        if search_pos_begin <= string.len(split_string) then
            split_result[#split_result + 1] = string.sub(split_string, search_pos_begin)
        end
    
        return split_result
    end
    
    function Join(join_table, joiner)
        -- 以某个连接符为标准，返回一个table所有字段连接结果
        -- @param join_table 连接table
        -- @param joiner 连接符
        -- @param return 用连接符连接后的字符串
    
        if #join_table == 0 then
            return ""
        end
    
        local fmt = "%s"
        for i = 2, #join_table do
            fmt = fmt .. joiner .. "%s"
        end
    
        return string.format(fmt, unpack(join_table))
    end
    
    function Printf(fmt, ...)
        -- 格式化输出字符串，类似c函数printf风格
    
        print(string.format(fmt, ...))
    end

    local function getInnerRef(tbl)
        local loaded = {}
        local ref = {}
        local function _get(t)
            if loaded[t] then
                ref[t] = t
                return
            end
            loaded[t] = t
            for k, v in pairs(t) do
                if type(k) == "table" then
                    _get(k)
                elseif type(v) == "table" then
                    _get(v)
                end
            end
        end
        _get(tbl)
        return ref
    end
    
    local tableTostring = function(t, level, pre) 
        local loaded = {}
        local showAddress = getInnerRef(t)
        local insert = table.insert
        local function _tostring(t, level, pre)
            level = level and (level - 1) or 10
            if level < 0 then
                return pre .. "..."
            end
    
            pre = pre or ""
            if next(t) == nil then
                return pre .. "{}"
            end
    
            loaded[t] = t 
    
            local strs = {}
            insert(strs, pre .. "{")
            if showAddress[t] then
                insert(strs, tostring(t))
            end
            
            insert(strs, "\n")
            pre = pre .. "  "
    
            for k, v in pairs(t) do
                insert(strs, pre)
    
                if type(k) == "table" then
                    if loaded[t] then
                        insert(strs, tostring(t))
                    else
                        insert(strs, _tostring(k, level, pre))
                    end
                elseif type(k) == "number" then
                    insert(strs, "[ "..k.." ]")
                else
                    insert(strs, _G.tostring(k))
                end
    
                insert(strs, "=")
    
                if type(v) == "table" then
                    if loaded[v] then
                        insert(strs, tostring(v))
                    else
                        insert(strs, "\n")
                        insert(strs, _tostring(v, level, pre))
                    end
                elseif type(v) == "number" then
                    insert(strs, v)
                elseif type(v) == "string" then
                    insert(strs, '"' .. v .. '"')
                else
                    insert(strs, _G.tostring(v))
                end
    
                insert(strs, ",\n")
            end
    
            strs[#strs] = ","  --last ",\n"
            insert(strs, "\n" .. string.sub(pre, 1, -3) .. "}")
    
            return table.concat(strs)
        end
        return _tostring(t, level, pre)
    end
    
    -- log = function()
    --     --jzq打印函数
    --     --dump(value,"",10)
    -- end
    
    log =  function(value,skip)
        local str 
        if type(value) == "string" then
            str = '"' .. value .. '"'
        elseif type(value) == "table" then
            str = tableTostring(value)
        elseif type(value) == "number" then
            str = "number: "..value
        elseif type(value) == "boolean" then
            str = "boolean: "..tostring(value)
        else
            str = tostring(value) or "Unknown object!"
        end
        if skip == 2 then
            print(str)
        else
            local what = debug.getinfo(2)
            local strPosInfo 
            if skip == 1 then
                strPosInfo = string.format("\t%s line:%d", what.short_src, what.currentline)
            else
                strPosInfo = string.format("\t%s line:%d %s", what.short_src, what.currentline,"jzqError")
            end
            print(str..strPosInfo)
        end
        
    end

    function tableFromTencent(t, name, indent)
        local cart     -- a container
        local autoref  -- for self references
    
        local function isemptytable(t) return next(t) == nil end
    
        local function basicSerialize (o)
          local so = tostring(o)
          if type(o) == "function" then
             local info = debug.getinfo(o, "S")
             -- info.name is nil because o is not a calling level
             if info.what == "C" then
                return string.format("%q", so .. ", C function")
             else
                -- the information is defined through lines
                return string.format("%q", so .. ", defined in (" ..
                    info.linedefined .. "-" .. info.lastlinedefined ..
                    ")" .. info.source)
             end
          elseif type(o) == "number" or type(o) == "boolean" then
             return so
          else
             return string.format("%q", so)
          end
        end
    
        local function addtocart (value, name, indent, saved, field)
          indent = indent or ""
          saved = saved or {}
          field = field or name
    
          cart = cart .. indent .. field
    
          if type(value) ~= "table" then
             cart = cart .. " = " .. basicSerialize(value) .. ";\n"
          else
             if saved[value] then
                cart = cart .. " = {}; -- " .. saved[value]
                            .. " (self reference)\n"
                autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
             else
                saved[value] = name
                --if tablecount(value) == 0 then
                if isemptytable(value) then
                   cart = cart .. " = {};\n"
                else
                   cart = cart .. " = {\n"
                   for k, v in pairs(value) do
                      k = basicSerialize(k)
                      local fname = string.format("%s[%s]", name, k)
                      field = string.format("[%s]", k)
                      -- three spaces between levels
                      addtocart(v, fname, indent .. "   ", saved, field)
                   end
                   cart = cart .. indent .. "};\n"
                end
             end
          end
        end
    
        name = name or "PRINT_Table"
        if type(t) ~= "table" then
          return name .. " = " .. basicSerialize(t)
        end
        cart, autoref = "", ""
        addtocart(t, name, indent)
        return cart .. autoref
    end

    function printTable(t, name ,indent)
        local str = (tableFromTencent(t, name, indent));
        print(str);
    end
    
    --序列化并返回table
    function serializeTable(t, name, indent)
      local str = (tableFromTencent(t, name, indent))
      return str
    end


    local function getInnerRef(tbl)
        local loaded = {}
        local ref = {}
        local function _get(t)
            if loaded[t] then
                ref[t] = t
                return
            end
            loaded[t] = t
            for k, v in pairs(t) do
                if type(k) == "table" then
                    _get(k)
                elseif type(v) == "table" then
                    _get(v)
                end
            end
        end
        _get(tbl)
        return ref
      end
      
      local tableTostring = function(t, level, pre) 
        local loaded = {}
        local showAddress = getInnerRef(t)
        local insert = table.insert
        local function _tostring(t, level, pre)
            level = level and (level - 1) or 10
            if level < 0 then
                return pre .. "..."
            end
      
            pre = pre or ""
            if next(t) == nil then
                return pre .. "{}"
            end
      
            loaded[t] = t 
      
            local strs = {}
            insert(strs, pre .. "{")
            if showAddress[t] then
                insert(strs, tostring(t))
            end
            
            insert(strs, "\n")
            pre = pre .. "  "
      
            for k, v in pairs(t) do
                insert(strs, pre)
      
                if type(k) == "table" then
                    if loaded[t] then
                        insert(strs, tostring(t))
                    else
                        insert(strs, _tostring(k, level, pre))
                    end
                elseif type(k) == "number" then
                    insert(strs, "[ "..k.." ]")
                else
                    insert(strs, _G.tostring(k))
                end
      
                insert(strs, "=")
      
                if type(v) == "table" then
                    if loaded[v] then
                        insert(strs, tostring(v))
                    else
                        insert(strs, "\n")
                        insert(strs, _tostring(v, level, pre))
                    end
                elseif type(v) == "number" then
                    insert(strs, v)
                elseif type(v) == "string" then
                    insert(strs, '"' .. v .. '"')
                else
                    insert(strs, _G.tostring(v))
                end
      
                insert(strs, ",\n")
            end
      
            strs[#strs] = ","  --last ",\n"
            insert(strs, "\n" .. string.sub(pre, 1, -3) .. "}")
      
            return table.concat(strs)
        end
        return _tostring(t, level, pre)
      end
      
      function log(value)
        local str 
        if type(value) == "string" then
            str = '"' .. value .. '"'
        elseif type(value) == "table" then
            str = tableTostring(value)
        elseif type(value) == "number" then
            str = "number: "..value
        elseif type(value) == "boolean" then
            str = "boolean: "..tostring(value)
        else
            str = tostring(value) or "Unknown object!"
        end
        local what = debug.getinfo(2)
        local strPosInfo = string.format("\t%s line:%d", what.short_src, what.currentline)
        print(str..strPosInfo)
      end

      table_insert = table.insert

      table_nums = table.nums
