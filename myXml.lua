-- 加载XML文件
local xfile = xml.load("test.xml")
-- 查找子节点
local item = xfile:find("item")
-- 节点不为空
if item ~= nil then
 -- 节点对应键值
 print( item.id);

 -- 修改键值
 item.id = "abc";
 print( item.id);

 -- 第一个子节点
 local field = item[1];
 print( field);
 print( field.name);
 
 -- 获得子节点数量
 print( table.getn( item));

end

-- 添加子节点
local xNewFile = xml.new("root");
-- 设置子节点键值
local child = xNewFile:append("child");
child.id = 1;
xNewFile:append("child").id = 2;

-- 添加text节点
xNewFile:append("text")[1] = 'test';

print( xNewFile);
-- 保存文件
xNewFile:save"t.xml";
————————————————
版权声明：本文为CSDN博主「yhangleo」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/yhangleo/article/details/8181811


常用函数：

xml.new(arg)
创建一个新的XML对象


xml.append(var,tag)
添加一个子节点

xml.load(filename)
加载XML文件

xml.save(var,filename)
保存XML文件

xml.eval(xmlstring)
解析XML字符串

xml.tag(var, tag)
设置或返回一个XML对象

xml.str(var, indent, tag)
以字符串形式返回XML

xml.find(var, tag, attributeKey,attributeValue)
查找子节点

xml.registerCode(decoded,encoded)
设置文件编码类型
————————————————
版权声明：本文为CSDN博主「yhangleo」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/yhangleo/article/details/8181811