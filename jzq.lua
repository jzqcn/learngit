jzq = jzq or {}

jzq.myCount = 0
jzq.isOpenLayer = true
function jzq.init()
    print("jzq.init()")
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,1))
    jzq.myCount = jzq.myCount + 1
    if jzq.myCount ~= 1 then
        error("jzq出现致命错误")
    end

    local toplayer = ViewManager:getInstance():getLayerByTag(ViewMgrTag.DEBUG_TAG)
    layer:addTo(toplayer):setLocalZOrder(10000)
    jzq.layer = layer

    --jzq.log = Debug.log
    GlobalKeybordEvent:getInstance():add(function() jzq.refresh() end, cc.Handler.EVENT_KEYBOARD_RELEASED , cc.KeyCode.KEY_J, 0, "jzqKeybordEvent_J")
    --GlobalKeybordEvent:getInstance():add(function() Debug.info("jzq k 按钮") end, cc.Handler.EVENT_KEYBOARD_RELEASED , cc.KeyCode.KEY_K, 0, "jzqKeybordEvent_K")
    Debug.log("jzq init")
end

function jzq.refresh()
    jzq.log(" jzq.refresh() ")
    package.loaded["jzq1"] = nil
    local jzq1 = require("jzq1")
    jzq1.test()
    message("刷新页面成功")
end

function jzq.logNodeInfo(node)
    print("================  NodeInfo  ==================")
    local info = node:getBoundingBox()
    if info then
      jzq.log(info)
    else
      print("传入的不是 node")
      return
    end
    local ap = node:getAnchorPoint()
    print("AnchorPoint "..ap.x.." "..ap.y)
    local cs = node:getContentSize()
    print("ContentSize "..cs.width.." "..cs.height)
end

--打印 当前窗口信息..--by lwc
function jzq.printWinLog()
	print("当前窗口数量: "..#BaseView.winMap)
	for i,v in ipairs(BaseView.winMap) do
		if v.layout_name then
			print(string.format("第%s个窗口名字: %s", i, v.layout_name))
		end
		if v.check_class_name then
			print(string.format("第%s个窗口名字: %s", i, v.check_class_name))
		end
	end

	print("当前tips窗口数量: "..#BaseView.winTipsMap)
	for i,v in ipairs(BaseView.winTipsMap) do
		if v.layout_name then
			print(string.format("第%s个tips窗口名字: %s", i, v.layout_name))
		end
	end
end

-- 热更
function jzq.hot_fix_game()
    for key, v in pairs(package.loaded) do 
        if string.find(key, "game") ~= nil  then
            package.loaded[key] = nil
            require(key)
        end
    end
    --message("热更游戏完成")
end

function jzq.hot_fix_all()
    for key, v in pairs(package.loaded) do 
        if string.find(key, "config") ~= nil or string.find(key, "game") ~= nil or string.find(key, "common") ~= nil then
            package.loaded[key] = nil
            require(key)
        end
    end
    --message("热更游戏完成")
end

function jzq.caclWidth(allWidth,itemWidth,num)
    local ww = allWidth - itemWidth * num
      if  ww < 0 then
        print("(allWidth - itemWidth * num) < 0 无法计算 ")
      else
        local w = ww/(num+1)
        local count = 0
        for i = 1,num do
          count = count + w + itemWidth/2
          print("itemWidth "..i..": "..count)
          count = count + itemWidth/2
        end
      end
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

function jzq.log2(value)
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

function jzq.log(t)
    local valueType = type(t)
    if  valueType ~= "table" then
        local str = "nil"
        if valueType == "string" then
            str = '"' .. t .. '"'
        elseif valueType == "number" then
            str = "number: "..t
        elseif valueType == "boolean" then
            str = "boolean: "..tostring(t)
        else
            str = tostring(t) or "Unknown object!"
        end
        local what = debug.getinfo(2)
        local strPosInfo = string.format("%s\t%s line:%d",str,what.short_src, what.currentline)
        print(strPosInfo)
        return
    end

    local cart     -- a container
    local autoref  -- for self references

    local name, indent
  
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
    --return cart .. autoref
    print(cart .. autoref)
end

function jzq.getData()
end

function jzq.hello()
    local what = debug.getinfo(2)
    local strPosInfo = string.format("%s\t%s line:%d","are you ok",what.short_src, what.currentline)
    print(strPosInfo)
end
