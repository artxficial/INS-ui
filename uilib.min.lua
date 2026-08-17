local LibName="INSUI"
local Env=getgenv()
local function WriteGlobal(key,value)
Env[key]=value
_G[key]=value
end
local function ReadGlobal(key)
local Value=Env[key]
if Value~=nil then return Value end
return _G[key]
end
local IsKeyPressed=iskeypressed
local IsMouse1Down=ismouse1pressed
local IsMouse2Down=ismouse2pressed
local IsGameActive=isrbxactive
local SetGameInput=setrobloxinput
local SetClipboard=setclipboard
local GetClipboard=getclipboard
local Base64Decode=base64decode
local Base64Encode=base64encode
local HttpRequest=request
local WriteFile=writefile
local ReadFile=readfile
local IsFile=isfile
local IsFolder=isfolder
local MakeFolder=makefolder
local ListFiles=listfiles
local DeleteFile=delfile
local Clock=os.clock
local Color3=Color3
local Vector2=Vector2
local v2=Vector2.new
local c3=Color3.fromRGB
local hsv=Color3.fromHSV
local floor,abs,min,max,sin,sqrt=math.floor,math.abs,math.min,math.max,math.sin,math.sqrt
local cos,pi=math.cos,math.pi
local remove,concat=table.remove,table.concat
local HttpService=game:GetService("HttpService")
local function JsonSafe(value,seen)
local Kind=type(value)
if Kind=="number"then
if value~=value or value==math.huge or value==-math.huge then return 0 end
return value
end
if Kind=="string"or Kind=="boolean"then return value end
if Kind~="table"then return nil end
seen=seen or{}
if seen[value]then return nil end
seen[value]=true
local Copy={}
for Key,Field in pairs(value)do
local KeyKind=type(Key)
if KeyKind=="string"or KeyKind=="number"then Copy[Key]=JsonSafe(Field,seen)end
end
seen[value]=nil
return Copy
end
local function JsonEncode(value)
return HttpService:JSONEncode(JsonSafe(value))
end
local function JsonDecode(text)
return HttpService:JSONDecode(text)
end
local InstanceId={}
WriteGlobal(LibName.."InstanceId",InstanceId)
SetGameInput(true)
local function Round(value)return floor(value+0.5)end
local function Clamp(value,low,high)
if value<low then return low end
if value>high then return high end
return value
end
local function IsTrue(v)return v==true end
local function CopyArray(src)
local out={}
if type(src)=="table"then
for i=1,#src do out[i]=src[i]end
elseif src~=nil then
out[1]=src
end
return out
end
local function ColorChanged(a,b)
if not a or not b then return a~=b end
return abs(a.R-b.R)>0.001 or abs(a.G-b.G)>0.001 or abs(a.B-b.B)>0.001
end
local function SplitCombo(str)
if type(str)=="string"then
local p=string.find(str,"+",1,true)
if p then return string.sub(str,1,p-1),string.sub(str,p+1)end
return nil,str
end
return nil,nil
end
local KEY_ALIASES={
rightshift="rshift",leftshift="lshift",
rightcontrol="rctrl",leftcontrol="lctrl",rightctrl="rctrl",leftctrl="lctrl",
rightalt="ralt",leftalt="lalt",
control="ctrl",["return"]="enter",escape="esc",del="delete",
backquote="tilde",grave="tilde",equals="plus",equal="plus",
leftbracket="lbracket",rightbracket="rbracket",backslashkey="backslash",
mousebutton3="mb3",middlemouse="mb3",mmb="mb3",m3="mb3",scrollclick="mb3",
mousebutton4="mb4",mouse4="mb4",xbutton1="mb4",m4="mb4",
mousebutton5="mb5",mouse5="mb5",xbutton2="mb5",m5="mb5",
mouse1="m1",leftmouse="m1",lmb="m1",leftclick="m1",mousebutton1="m1",mb1="m1",
mouse2="m2",rightmouse="m2",rmb="m2",rightclick="m2",mousebutton2="m2",mb2="m2",
}
local function NormalKey(v)
if v==nil then return nil end
v=string.lower(tostring(v)):gsub("%s+","")
if v==""or v=="-"or v=="none"or v=="nil"or v=="unbound"then return nil end
return KEY_ALIASES[v]or v
end
local function NormalMode(v)
if v=="Toggle"or v=="Always"then return v end
return"Hold"
end
local KEY_DISPLAY={m1="MB1",m2="MB2",mb3="MB3",mb4="MB4",mb5="MB5"}
local function KeyName(k)return KEY_DISPLAY[k]or string.upper(tostring(k))end
local function KeyLabel(v)
if v==nil or v==""then return"none"end
local mod,k=SplitCombo(v)
if mod then return KeyName(mod).."+"..KeyName(k or"")end
return KeyName(v)
end
local WHITE=c3(255,255,255)
local Theme={
bg=c3(15,15,15),
sidebar=c3(15,15,15),
white=WHITE,
text=WHITE,
sub=WHITE,
accent=WHITE,
accentA=c3(122,134,255),
accentB=c3(189,130,255),
tlRed=c3(250,93,86),
tlYellow=c3(252,190,57),
tlGreen=c3(119,174,94),
trackOff=c3(61,61,61),
trackOn=c3(87,86,86),
knobOff=c3(91,91,91),
sliderTrack=c3(87,86,86),
good=c3(119,174,94),
bad=c3(250,93,86),
unsafe=c3(252,190,57),
surface=c3(24,24,24),
surface2=c3(28,28,28),
surface3=c3(38,38,38),
border=c3(70,70,70),
}
local ThemePresets={
Indigo={c3(122,134,255),c3(189,130,255)},
NeverBlox={c3(82,122,246),c3(120,150,255)},
Lemon={c3(252,211,49),c3(240,165,25)},
Mono={WHITE,WHITE},
Sunset={c3(255,150,90),c3(255,90,140)},
Mint={c3(110,230,180),c3(90,200,255)},
Rose={c3(255,120,160),c3(200,120,255)},
Gold={c3(255,210,120),c3(255,150,80)},
Crimson={c3(255,100,100),c3(255,60,140)},
Ocean={c3(90,200,255),c3(120,140,255)},
Toxic={c3(150,255,120),c3(60,220,160)},
Lavender={c3(180,160,255),c3(220,160,255)},
Aqua={c3(80,230,230),c3(80,180,255)},
Ember={c3(255,120,60),c3(255,70,70)},
Cyber={c3(0,255,200),c3(120,100,255)},
Bubblegum={c3(255,140,220),c3(150,180,255)},
Forest={c3(120,220,120),c3(180,230,90)},
Slate={c3(150,170,200),c3(110,130,170)},
Cherry={c3(255,90,120),c3(255,150,110)},
Aurora={c3(120,255,200),c3(160,140,255)},
Sky={c3(120,200,255),c3(180,210,255)},
Magma={c3(255,80,40),c3(255,180,40)},
Grape={c3(170,110,255),c3(255,110,200)},
Steel={c3(120,200,220),c3(150,160,200)},
Peach={c3(255,180,150),c3(255,130,160)},
Neon={c3(0,240,255),c3(180,0,255)},
Waifu={c3(150,205,120),c3(195,230,130)},
}
local Layout={
RowHeight=26,
SwitchWidth=38,
SwitchHeight=20,
SwitchKnob=14,
CheckboxSize=18,
SwatchSize=16,
RowSwatchSize=14,
ChipHeight=20,
FieldHeight=24,
ButtonHeight=22,
SliderBarHeight=8,
SliderKnob=6,
ValueBoxHeight=18,
CardRadius=5,
FieldRadius=5,
ChipRadius=4,
TitleHeight=31,
TopbarHeight=42,
TabStripHeight=42,
PillHeight=30,
SubHeight=24,
RailNarrow=54,
DropRowHeight=26,
}
local Alpha={
Hairline=0.10,
Card=0.03,
CardStroke=0.06,
TabFill=0.04,
Text=0.80,
Label=0.50,
Dim=0.40,
Hover=0.70,
Field=0.05,
WindowShadow={0.10,0.07,0.05,0.03,0.015},
}
local Fonts=Drawing.Fonts
local FontSystem=Fonts.System or 0
local FontBold=Fonts.SystemBold or Fonts.System or 0
local FontUI=Fonts.UI or Fonts.System or 0
local FontMono=Fonts.Monospace or 0
local FontWidths={
[FontSystem]=0.48,[FontBold]=0.52,[FontUI]=0.50,[FontMono]=0.60,
[Fonts.Minecraft or-1]=0.55,[Fonts.Pixel or-2]=0.50,[Fonts.Fortnite or-3]=0.55,
[Fonts.ProximaSoftBold or-4]=0.53,
}
local FONT_LIST={}
do
local cand={
{"Default",FontSystem},{"Bold",FontBold},{"Proxima",Fonts.ProximaSoftBold},
{"Proggy",FontUI},{"Minecraft",Fonts.Minecraft},{"JetBrains",FontMono},
{"Pixel",Fonts.Pixel},{"Fortnite",Fonts.Fortnite},
}
for _,c in ipairs(cand)do if c[2]~=nil then FONT_LIST[#FONT_LIST+1]=c end end
end
local function FontByName(name)
for _,c in ipairs(FONT_LIST)do if c[1]==name then return c[2]end end
return FontSystem
end
local State={
alive=true,destroyed=false,open=false,rendering=false,
x=0,y=0,w=560,h=460,minimized=false,
title="uilib",subtitle="",
configName="default",
mouseX=0,mouseY=0,hasMouse=false,mouseScroll=0,
lastFrame=Clock(),dt=1/60,
inputState=nil,
drawVisible=0,
contentFade=1,
tabs={},activeTab=nil,activeIndex=1,
notifications={},
drag=nil,resizeEdge=nil,sliderDrag=nil,scrollDrag=nil,
dropdown=nil,colorpicker=nil,cpDrag=nil,focus=nil,
repeatKey=nil,repeatAt=0,
tooltipText=nil,tooltipX=0,tooltipY=0,tooltipAt=0,lastTooltipText=nil,
hoverEffects=true,tooltipsEnabled=true,
smartFps=false,checkboxStyle=false,
errorCount=0,
}
local MenuKey="p"
local KeybindItems={}
local Input,InputOrder={},{}
local function AddInput(name,id,char,shifted)
name=string.lower(tostring(name))
if not Input[name]then InputOrder[#InputOrder+1]=name end
Input[name]={id=id,held=false,click=false,released=false,char=char,shifted=shifted}
end
AddInput("m1",0x01);AddInput("m2",0x02)
AddInput("mb3",0x04);AddInput("mb4",0x05);AddInput("mb5",0x06)
AddInput("backspace",0x08);AddInput("tab",0x09);AddInput("enter",0x0D)
AddInput("shift",0x10);AddInput("ctrl",0x11);AddInput("alt",0x12)
AddInput("esc",0x1B);AddInput("space",0x20," "," ")
AddInput("pageup",0x21);AddInput("pagedown",0x22);AddInput("end",0x23);AddInput("home",0x24)
AddInput("left",0x25);AddInput("up",0x26);AddInput("right",0x27);AddInput("down",0x28)
AddInput("insert",0x2D);AddInput("delete",0x2E)
do
local shifted={")","!","@","#","$","%","^","&","*","("}
for i=0,9 do AddInput(tostring(i),0x30+i,tostring(i),shifted[i+1])end
end
for i=0,25 do local ch=string.char(97+i);AddInput(ch,0x41+i,ch,string.upper(ch))end
for i=1,12 do AddInput("f"..i,0x6F+i)end
AddInput("lshift",0xA0);AddInput("rshift",0xA1);AddInput("lctrl",0xA2);AddInput("rctrl",0xA3);AddInput("lalt",0xA4);AddInput("ralt",0xA5)
AddInput("semicolon",0xBA,";",":");AddInput("plus",0xBB,"=","+");AddInput("comma",0xBC,",","<")
AddInput("minus",0xBD,"-","_");AddInput("period",0xBE,".",">");AddInput("slash",0xBF,"/","?")
AddInput("tilde",0xC0,"`","~");AddInput("lbracket",0xDB,"[","{");AddInput("backslash",0xDC,"\\","|")
AddInput("rbracket",0xDD,"]","}");AddInput("quote",0xDE,"'","\"")
local ResetPool,HideUnused,HideAll,HideWindowDrawings,RemoveAllDrawings
local DrawRect,DrawStroke,DrawLine,DrawCircle,DrawTri,PlaceImage,DrawImage
local ResolveFont,TextWidth,TrimText,WrapText,TextTop,DrawText,DrawTextMid
do
local Pool={sq={},tx={},ln={},ci={},tr={},im={}}
local Cache={sq={},tx={},ln={},ci={},tr={},im={}}
local Used={sq=0,tx=0,ln=0,ci=0,tr=0,im=0}
local Made={sq=0,tx=0,ln=0,ci=0,tr=0,im=0}
local Kind={sq="Square",tx="Text",ln="Line",ci="Circle",tr="Triangle",im="Image"}
local seq=0
local function zord(z)
seq=seq+1
return(z or 1)*10000+(seq<10000 and seq or 9999)
end
local function take(k)
if not State.alive or State.destroyed then return nil end
local i=Used[k]+1
Used[k]=i
local list,cache=Pool[k],Cache[k]
local d,c=list[i],cache[i]
if not d then
d,c=Drawing.new(Kind[k]),{}
list[i],cache[i]=d,c
end
if i>Made[k]then Made[k]=i end
if c.vis~=true then c.vis=true;d.Visible=true end
return d,c
end
function ResetPool()
Used.sq,Used.tx,Used.ln,Used.ci,Used.tr,Used.im=0,0,0,0,0,0
seq=0
end
function HideUnused()
for k,list in pairs(Pool)do
local cache=Cache[k]
local used,made=Used[k],Made[k]
for i=used+1,made do
local d,c=list[i],cache[i]
if d and c and c.vis~=false then c.vis=false;d.Visible=false end
end
if used>made then Made[k]=used end
end
end
function HideAll()
for k,list in pairs(Pool)do
local cache=Cache[k]
for i=1,#list do
local d,c=list[i],cache[i]
if d and c and c.vis~=false then c.vis=false;d.Visible=false end
end
end
end
function RemoveAllDrawings()
for k,list in pairs(Pool)do
local cache=Cache[k]
for i=1,#list do
local d=list[i]
if d then d.Visible=false;d:Remove()end
list[i],cache[i]=nil,nil
end
end
end
function PlaceImage(img,c,x,y,w,h,z,a,vis)
if not img or not c then return end
if c.x~=x or c.y~=y then c.x,c.y=x,y;img.Position=v2(x,y)end
if c.w~=w or c.h~=h then c.w,c.h=w,h;img.Size=v2(w,h)end
if c.z~=z then c.z=z;img.ZIndex=z end
if c.a~=a then c.a=a;img.Transparency=a end
if c.vis~=vis then c.vis=vis;img.Visible=vis end
end
function DrawImage(img,x,y,w,h,z,a,corner,vis)
if not img then return end
img.Position=v2(x,y)
img.Size=v2(w,h)
if corner then img.Rounding=corner end
img.ZIndex=z
img.Transparency=a
if vis==nil then vis=a>0.01 end
img.Visible=vis
end
local function hideImg(owner,key,cacheKey)
local img=owner[key]
if not img then return end
img.Visible=false
local c=cacheKey and owner[cacheKey]
if c then c.vis=false end
end
State.hideImg=hideImg
function HideWindowDrawings()
for _,tab in ipairs(State.tabs)do
hideImg(tab,"_img","_ic")
hideImg(tab,"_imgA","_icA")
for _,sub in ipairs(tab.subs or{})do
hideImg(sub,"_img","_ic")
hideImg(sub,"_imgA","_icA")
end
for _,sec in ipairs(tab.sections)do
for _,it in ipairs(sec.items)do
hideImg(it,"_img")
hideImg(it,"_ddImg","_ddIc")
end
end
end
hideImg(State,"_gearImg")
hideImg(State,"bgImg")
hideImg(State,"avatarImg")
hideImg(State,"logoImg")
hideImg(State,"iconImg")
end
local function box(x,y,w,h,color,z,radius,alpha,filled)
if w<=0 or h<=0 then seq=seq+1;return end
local d,c=take("sq");if not d then return end
local r,g,b=color.R,color.G,color.B
local zi,a=zord(z),alpha or 1
if c.x~=x or c.y~=y then c.x,c.y=x,y;d.Position=v2(x,y)end
if c.w~=w or c.h~=h then c.w,c.h=w,h;d.Size=v2(w,h)end
if c.r~=r or c.g~=g or c.b~=b then c.r,c.g,c.b=r,g,b;d.Color=color end
if c.fill~=filled then c.fill=filled;d.Filled=filled end
local cn=(radius or 0)*(State.roundScale or 1)
if c.cn~=cn then c.cn=cn;d.Corner=cn end
if c.z~=zi then c.z=zi;d.ZIndex=zi end
if c.a~=a then c.a=a;d.Transparency=a end
end
function DrawRect(x,y,w,h,color,z,radius,alpha)
box(x,y,w,h,color,z,radius,alpha,true)
end
function DrawStroke(x,y,w,h,color,z,radius,alpha)
box(x,y,w,h,color,z,radius,alpha,false)
end
function DrawLine(x1,y1,x2,y2,color,z,thick,alpha)
local d,c=take("ln");if not d then return end
local r,g,b=color.R,color.G,color.B
local th,zi,a=thick or 1,zord(z),alpha or 1
if c.x1~=x1 or c.y1~=y1 then c.x1,c.y1=x1,y1;d.From=v2(x1,y1)end
if c.x2~=x2 or c.y2~=y2 then c.x2,c.y2=x2,y2;d.To=v2(x2,y2)end
if c.r~=r or c.g~=g or c.b~=b then c.r,c.g,c.b=r,g,b;d.Color=color end
if c.th~=th then c.th=th;d.Thickness=th end
if c.z~=zi then c.z=zi;d.ZIndex=zi end
if c.a~=a then c.a=a;d.Transparency=a end
end
function DrawCircle(x,y,radius,color,z,filled,thick,sides,alpha)
local d,c=take("ci");if not d then return end
local r,g,b=color.R,color.G,color.B
local fill,th,ns=filled~=false,thick or 1,sides or 32
local zi,a=zord(z),alpha or 1
if c.x~=x or c.y~=y then c.x,c.y=x,y;d.Position=v2(x,y)end
if c.rad~=radius then c.rad=radius;d.Radius=radius end
if c.r~=r or c.g~=g or c.b~=b then c.r,c.g,c.b=r,g,b;d.Color=color end
if c.fill~=fill then c.fill=fill;d.Filled=fill end
if c.th~=th then c.th=th;d.Thickness=th end
if c.ns~=ns then c.ns=ns;d.NumSides=ns end
if c.z~=zi then c.z=zi;d.ZIndex=zi end
if c.a~=a then c.a=a;d.Transparency=a end
end
function DrawTri(p1,p2,p3,color,z,filled,alpha)
local d,c=take("tr");if not d then return end
local r,g,b=color.R,color.G,color.B
local fill,zi,a=filled~=false,zord(z),alpha or 1
if c.ax~=p1.X or c.ay~=p1.Y then c.ax,c.ay=p1.X,p1.Y;d.PointA=p1 end
if c.bx~=p2.X or c.by~=p2.Y then c.bx,c.by=p2.X,p2.Y;d.PointB=p2 end
if c.cx~=p3.X or c.cy~=p3.Y then c.cx,c.cy=p3.X,p3.Y;d.PointC=p3 end
if c.r~=r or c.g~=g or c.b~=b then c.r,c.g,c.b=r,g,b;d.Color=color end
if c.fill~=fill then c.fill=fill;d.Filled=fill end
if c.th~=1 then c.th=1;d.Thickness=1 end
if c.z~=zi then c.z=zi;d.ZIndex=zi end
if c.a~=a then c.a=a;d.Transparency=a end
end
function ResolveFont(f)
local u=State.uiFont
if u and(f==FontSystem or f==FontBold)then return u end
return f
end
local function charW(size,font)
return(size or 13)*(FontWidths[font]or 0.48)
end
function TextWidth(value,size,font)
return#tostring(value or"")*charW(size,ResolveFont(font))
end
function TrimText(value,maxW,size,font)
value=tostring(value or"")
local fit=floor(maxW/charW(size,ResolveFont(font)))
if#value<=fit then return value end
if fit<=2 then return""end
return string.sub(value,1,fit-2)..".."
end
function WrapText(value,maxW,size,font)
value=tostring(value or"")
local fit=max(1,floor(maxW/charW(size,font)))
local lines,cur={},""
for word in string.gmatch(value,"%S+")do
local grown=(cur=="")and word or(cur.." "..word)
if#grown<=fit then
cur=grown
else
if cur~=""then lines[#lines+1]=cur end
while#word>fit do
lines[#lines+1]=string.sub(word,1,fit)
word=string.sub(word,fit+1)
end
cur=word
end
end
if cur~=""then lines[#lines+1]=cur end
if#lines==0 then lines[1]=""end
return lines
end
function TextTop(y,h,size)return floor(y+(h-(size or 13))/2+0.5)end
local function put(value,x,y,color,size,font,z,center,outline,alpha)
local d,c=take("tx");if not d then return end
local f,sz=ResolveFont(font or FontSystem),size or 13
local col=(color==WHITE)and Theme.text or color
local r,g,b=col.R,col.G,col.B
local zi,a=zord((z or 1)+10),alpha or 1
if c.txt~=value then c.txt=value;d.Text=value end
if c.r~=r or c.g~=g or c.b~=b then c.r,c.g,c.b=r,g,b;d.Color=col end
if c.f~=f then c.f=f;d.Font=f end
if c.sz~=sz then c.sz=sz;d.Size=sz end
if c.ol~=outline then c.ol=outline;d.Outline=outline end
if c.mid~=center then c.mid=center;d.Center=center end
if c.x~=x or c.y~=y then c.x,c.y=x,y;d.Position=v2(x,y)end
if c.z~=zi then c.z=zi;d.ZIndex=zi end
if c.a~=a then c.a=a;d.Transparency=a end
end
function DrawText(value,x,y,color,size,font,z,centered,outline,maxW,alpha)
value=tostring(value or"")
if maxW and value~=""then value=TrimText(value,maxW,size,font)end
if value==""then seq=seq+1;return end
if centered==true then x=x-TextWidth(value,size,font)/2 end
put(value,x,y,color,size,font,z,false,outline==true,alpha)
end
function DrawTextMid(value,cx,y,color,size,font,z,alpha)
value=tostring(value or"")
if value==""then seq=seq+1;return end
put(value,cx,y,color,size,font,z,true,false,alpha)
end
end
local function Approach(cur,tgt,speed)
if State.noAnim or State.lite or not cur then return tgt end
local dt=State.dt or 1/60
if dt<=0 then dt=1/60 end
return cur+(tgt-cur)*(1-math.exp(-(speed or 15)*dt))
end
local DrawGradient
do
local _gradCache={c1=nil,c2=nil,steps=nil,cols=nil}
function DrawGradient(x,y,w,h,c1,c2,z,alpha)
if w<=0 then return end
local steps=State.lite and 6 or 24
local C=_gradCache
if C.steps~=steps or C.c1~=c1 or C.c2~=c2 then
local cols={}
for i=1,steps do
local t=(i-0.5)/steps
cols[i]=Color3.new(c1.R+(c2.R-c1.R)*t,c1.G+(c2.G-c1.G)*t,c1.B+(c2.B-c1.B)*t)
end
C.steps,C.c1,C.c2,C.cols=steps,c1,c2,cols
end
local cols=C.cols
local prev=Round(x)
for i=1,steps do
local nx=Round(x+w*i/steps)
local sw=nx-prev;if sw<1 then sw=1 end
DrawRect(prev,y,sw,h,cols[i],z,0,alpha)
prev=nx
end
end
end
function State.fadeLine(x,y,w,color,z,alpha,rev)
if w<=6 or alpha<=0.003 then return end
local segs=State.lite and 8 or min(26,max(10,floor(w/6)))
local prev=Round(x)
for i=1,segs do
local nx=Round(x+w*i/segs)
local sw=nx-prev
if sw>=1 then
local t=(i-0.5)/segs
if not rev then t=1-t end
DrawRect(prev,y,sw,1,color,z,0,alpha*t*t)
end
prev=nx
end
end
local function LerpColor(a,b,t)
return Color3.new(a.R+(b.R-a.R)*t,a.G+(b.G-a.G)*t,a.B+(b.B-a.B)*t)
end
local function ToHsv(color)
local r,g,b=color.R,color.G,color.B
local hi,lo=max(r,g,b),min(r,g,b)
local d=hi-lo
local h,s=0,(hi>0 and d/hi or 0)
if d>0 then
if hi==r then h=((g-b)/d)%6
elseif hi==g then h=((b-r)/d)+2
else h=((r-g)/d)+4 end
h=h/6
end
return h,s,hi
end
local function ToHex(color)
local function b(v)local n=Round(Clamp(v,0,1)*255);return string.format("%02X",n)end
return"#"..b(color.R)..b(color.G)..b(color.B)
end
local function ParseHex(str)
str=string.gsub(tostring(str or""),"[^0-9a-fA-F]","")
if#str==3 then str=str:gsub("(.)","%1%1")end
if#str<6 then return nil end
local r=tonumber(string.sub(str,1,2),16)
local g=tonumber(string.sub(str,3,4),16)
local bl=tonumber(string.sub(str,5,6),16)
if not(r and g and bl)then return nil end
return c3(r,g,bl)
end
local IconData
local IconBytes={}
State._pngFromMask=function(mask,w,h,r,g,b)
local floor2,schar,sbyte,concat2,ssub=math.floor,string.char,string.byte,table.concat,string.sub
local bxor,band,rshift
if bit32 then bxor,band,rshift=bit32.bxor,bit32.band,bit32.rshift
else
bxor=function(x,y)local rr,p=0,1;for _=1,32 do local a2,b2=x%2,y%2;if a2~=b2 then rr=rr+p end;x=(x-a2)/2;y=(y-b2)/2;p=p*2 end;return rr end
band=function(x,y)local rr,p=0,1;for _=1,32 do local a2,b2=x%2,y%2;if a2==1 and b2==1 then rr=rr+p end;x=(x-a2)/2;y=(y-b2)/2;p=p*2 end;return rr end
rshift=function(x,n)return floor2(x/(2^n))end
end
local crcT=State._crcT
if not crcT then
crcT={}
for n=0,255 do local cc=n;for _=1,8 do if band(cc,1)==1 then cc=bxor(3988292384,rshift(cc,1))else cc=rshift(cc,1)end end;crcT[n]=cc end
State._crcT=crcT
end
local function crc32(str)local cc=4294967295;for i=1,#str do cc=bxor(rshift(cc,8),crcT[band(bxor(cc,sbyte(str,i)),255)])end;return bxor(cc,4294967295)end
local function u32be(n)return schar(floor2(n/16777216)%256,floor2(n/65536)%256,floor2(n/256)%256,n%256)end
local function u16le(n)return schar(n%256,floor2(n/256)%256)end
local rgb=schar(r,g,b)
local raw={}
local idx=0
for _=1,h do
raw[#raw+1]=schar(0)
local row={}
for _=1,w do idx=idx+1;row[#row+1]=rgb..schar(sbyte(mask,idx)or 0)end
raw[#raw+1]=concat2(row)
end
local rawStr=concat2(raw)
local A,B=1,0
for i=1,#rawStr do A=(A+sbyte(rawStr,i))%65521;B=(B+A)%65521 end
local adler=B*65536+A
local z={schar(120,1)}
local p,n=1,#rawStr
while p<=n do
local ch=n-p+1;if ch>65535 then ch=65535 end
local fin=(p+ch-1>=n)and 1 or 0
z[#z+1]=schar(fin)..u16le(ch)..u16le(65535-ch)..ssub(rawStr,p,p+ch-1)
p=p+ch
end
z[#z+1]=u32be(adler)
local idat=concat2(z)
local function chunk(typ,data)local body=typ..data;return u32be(#data)..body..u32be(crc32(body))end
return schar(137,80,78,71,13,10,26,10)..chunk("IHDR",u32be(w)..u32be(h)..schar(8,6,0,0,0))..chunk("IDAT",idat)..chunk("IEND","")
end
State._rebuildIcons=function()
local M=State.iconMasks;if not M or not State._pngFromMask then return end
local used={}
for _,t in ipairs(State.tabs or{})do
if t.icon then used[t.icon]=true end
if t.subs then for _,s in ipairs(t.subs)do if s.icon then used[s.icon]=true end end end
end
if State.settingsIcon then used[State.settingsIcon]=true end
local am=State._accentMid or c3(155,132,255)
local mr,mg,mb=am.R*255,am.G*255,am.B*255
local lum=0.3*mr+0.59*mg+0.11*mb
local ar=floor(Clamp(lum+(mr-lum)*1.8,0,255)+0.5)
local ag=floor(Clamp(lum+(mg-lum)*1.8,0,255)+0.5)
local ab=floor(Clamp(lum+(mb-lum)*1.8,0,255)+0.5)
local gd=State._iconGreyDone;if not gd then gd={};State._iconGreyDone=gd end
for name in pairs(used)do
local mk2=M[name]
if not mk2 and State.iconAlias then mk2=M[State.iconAlias[name]]end
if mk2 then
local raw=mk2._raw
if not raw then raw=Base64Decode(mk2.a);mk2._raw=raw end
if raw then
if not gd[name]then IconBytes[name]=State._pngFromMask(raw,mk2.w,mk2.h,188,191,199);gd[name]=true end
IconBytes[name.."#a"]=State._pngFromMask(raw,mk2.w,mk2.h,ar,ag,ab)
end
end
end
end
local Mouse,LocalPlayer,Players
Players=game:GetService("Players")
local function ScreenSize()
if State._vpW then return State._vpW,State._vpH end
local x,y=1920,1080
local Camera=workspace.CurrentCamera
x,y=Camera.ViewportSize.X,Camera.ViewportSize.Y
State._vpW,State._vpH=x,y
return x,y
end
local function ReadMouse()
if not Mouse then
LocalPlayer=Players.LocalPlayer
Mouse=LocalPlayer:GetMouse()
end
if Mouse then
State.mouseX=Mouse.X;State.mouseY=Mouse.Y;State.hasMouse=true
return Mouse.X,Mouse.Y
end
State.hasMouse=false
return nil,nil
end
local function IsMouseIn(x,y,w,h)
local mx,my=State.mouseX,State.mouseY
return State.hasMouse and mx>=x and mx<=x+w and my>=y and my<=y+h
end
local function ApplyInputState(force)
local capture=State.open and(State.minimized~=true)
if State.dialog then
capture=true
elseif capture and State.gameInput=="always"then
capture=false
elseif capture and State.gameInput==true then
local popup=State.dropdown or State.colorpicker or State.keyMenu or State.spotlightOpen
if not popup and not IsMouseIn(State.x,State.y,State.w,State.h)then
capture=false
end
end
local desired=not capture
if force or State.inputState~=desired then
State.inputState=desired
SetGameInput(desired)
end
end
local function ClampWindow()
local vw,vh=ScreenSize()
State.x=Clamp(State.x,0,max(0,vw-min(80,State.w)))
State.y=Clamp(State.y,0,max(0,vh-min(40,State.h)))
end
local function SetOpen(open)
open=IsTrue(open)
if State.open==open then return end
State.open=open
State.drag=nil;State.resizeEdge=nil;State.sliderDrag=nil
State.scrollDrag=nil;State.dropdown=nil;State.colorpicker=nil
State.cpDrag=nil;State.focus=nil;State.keyMenu=nil
ApplyInputState(false)
end
local function Invoke(cb,...)
if type(cb)~="function"then return end
local ok,r=pcall(cb,...)
if not ok then
State.notifications[#State.notifications+1]=
{title="error",description=string.lower(tostring(r)),duration=5,elapsed=0}
return
end
return r
end
local function SnapValue(raw,item)
local lo,hi,gap=item.min or 0,item.max or 100,item.step or 1
if gap<=0 then gap=1 end
local steps=Round((raw-lo)/gap)
local val=Clamp(lo+steps*gap,lo,hi)
if item.float==true then return val end
local p,s,d=1,gap,0
while d<8 and floor(s)~=s do s=s*10;p=p*10;d=d+1 end
return Round(val*p)/p
end
local function SetDropdownValue(item,value,fire)
local nv=CopyArray(value)
local changed=#nv~=#item.value
for i=1,max(#item.value,#nv)do if item.value[i]~=nv[i]then changed=true break end end
for i=#item.value,1,-1 do item.value[i]=nil end
for i=1,#nv do item.value[i]=nv[i]end
if changed then item._ddVer=(item._ddVer or 0)+1 end
if changed and fire~=false then Invoke(item.callback,item.value)end
end
local function SetItemValue(item,value,fire)
if item.type=="dropdown"then SetDropdownValue(item,value,fire);return end
if item.type=="rangeslider"then
local lo,hi
if type(value)=="table"then lo=tonumber(value[1]or value.lo);hi=tonumber(value[2]or value.hi)end
if lo and hi then
lo=SnapValue(lo,item);hi=SnapValue(hi,item)
if lo>hi then lo,hi=hi,lo end
local changed=lo~=item.valueLo or hi~=item.valueHi
item.valueLo,item.valueHi=lo,hi
if changed and fire~=false then Invoke(item.callback,item.valueLo,item.valueHi)end
end
return
end
if item.type=="colorpicker"then
local col,al=value,nil
if type(value)=="table"then col=value[1];al=tonumber(value[2])end
local ok,r=true,col and col.R
if ok and r~=nil then
local changed=ColorChanged(item.value,col)or(al~=nil and abs((item.alpha or 1)-al)>0.001)
item.value=col;if al~=nil then item.alpha=al end
if changed and fire~=false then Invoke(item.callback,item.value,item.alpha or 1)end
end
return
end
if item.type=="slider"then
value=tonumber(value)or item.value or item.min or 0
value=SnapValue(value,item)
elseif item.type=="textbox"then value=tostring(value or"")
elseif item.type=="keybind"then value=NormalKey(value)
elseif item.type=="checkbox"then value=value==true end
local changed=item.value~=value
item.value=value
if changed and fire~=false then Invoke(item.callback,value)end
end
local function IsItemLocked(item,seen)
local dep=item.dependsOn
if dep and dep.item then
seen=seen or{}
if seen[item]then return false end
seen[item]=true
if not dep.item.value or IsItemLocked(dep.item,seen)then return true end
end
return false
end
local OpenColorpicker,OpenDropdown
State._refreshChoices=function(item,force)
local fn=item.choicesFn
if type(fn)~="function"then return false end
local now=Clock()
if not force and item._refreshAt and now<item._refreshAt then return false end
item._refreshAt=now+0.4
local ok,list=pcall(fn)
if not ok or type(list)~="table"then return false end
local same=#list==#item.choices
if same then for i=1,#list do if list[i]~=item.choices[i]then same=false;break end end end
if same then return false end
item.choices=CopyArray(list)
if item.value and#item.value>0 then
local set={}
for _,c in ipairs(item.choices)do set[c]=true end
local kept,dropped={},false
for _,v in ipairs(item.value)do if set[v]then kept[#kept+1]=v else dropped=true end end
if dropped then SetDropdownValue(item,kept,true)end
end
local dd=State.dropdown
if dd and dd.item==item then
dd.choices=CopyArray(item.choices);dd._filterQ=nil;dd._filtered=nil
dd.scrollOffset=Clamp(dd.scrollOffset or 0,0,max(0,#item.choices-1))
end
return true
end
local function MakeItem(section,item)
section.items[#section.items+1]=item
item._secName=section.name
if item.default==nil then
if item.type=="slider"or item.type=="checkbox"or item.type=="textbox"then item.default=item.value
elseif item.type=="dropdown"then item.default=CopyArray(item.value)
elseif item.type=="colorpicker"then item._defColor=item.value;item._defAlpha=item.alpha
elseif item.type=="keybind"then item._defKey=item.value end
end
local handle={item=item}
function handle:Set(v)SetItemValue(item,v,true);return self end
function handle:Get()
if item.type=="rangeslider"then return item.valueLo,item.valueHi end
if item.type=="colorpicker"then return item.value,item.alpha or 1 end
return item.value
end
function handle:IsActivated()
if item.type=="keybind"then
local v=item.value
if not v or v==""or item.listening then return false end
local mod,k=SplitCombo(v)
local kIn=Input[k]
if not kIn then return false end
if mod then local mIn=Input[mod];return(mIn~=nil and mIn.held and kIn.held)==true end
return kIn.held==true
end
local kb=item.keybind
if kb and kb.callback then return kb.active==true end
return item.value==true
end
function handle:DependsOn(parent)item.dependsOn=parent;return self end
function handle:Tooltip(text)item.tooltip=tostring(text or"");return self end
function handle:SetText(t)item.label=tostring(t);if item.buttons and item.buttons[1]then item.buttons[1].label=item.label end;return self end
function handle:SetColor(c)item.color=c;return self end
function handle:SetRisk(b)item.risk=b~=false;return self end
function handle:Reset()
if item.type=="rangeslider"then
item.valueLo=item.defLo or item.min;item.valueHi=item.defHi or item.max
Invoke(item.callback,item.valueLo,item.valueHi)
elseif item.type=="colorpicker"then
if item._defColor~=nil then item.value=item._defColor;item.alpha=item._defAlpha or 1;Invoke(item.callback,item.value,item.alpha)end
elseif item.type=="dropdown"then
SetDropdownValue(item,item.default or{},true)
elseif item.default~=nil then
SetItemValue(item,item.default,true)
end
return self
end
if item.type=="checkbox"then
function handle:AddKeybind(defaultKey,mode,callback)
local kb={value=NormalKey(defaultKey),mode=NormalMode(mode),
callback=callback,listening=false,active=false}
item.keybind=kb
KeybindItems[#KeybindItems+1]=item
local kh={item=item,keybind=kb}
function kh:Set(k,m)kb.value=NormalKey(k);if m then kb.mode=NormalMode(m)end;return self end
function kh:IsActivated()if kb.callback then return kb.active==true end;return item.value==true end
function kh:Parent()return handle end
handle.keyHandle=kh
return handle
end
function handle:AddColorpicker(label,defaultColor,callback,defaultAlpha)
item.colorpicker={label=label or"color",value=defaultColor or Theme.accent,
alpha=defaultAlpha or 1,callback=callback}
return handle
end
end
if item.type=="dropdown"then
function handle:UpdateChoices(newChoices)
item.choices=CopyArray(newChoices)
if State.dropdown and State.dropdown.item==item then
State.dropdown.choices=CopyArray(newChoices)
State.dropdown._filterQ=nil;State.dropdown.scrollOffset=0
end
return self
end
function handle:AddChoice(c)
for i=1,#item.choices do if item.choices[i]==c then return self end end
item.choices[#item.choices+1]=c;return self:UpdateChoices(item.choices)
end
function handle:RemoveChoice(c)
for i=#item.choices,1,-1 do if item.choices[i]==c then remove(item.choices,i)end end
local removed=false
for i=#item.value,1,-1 do if item.value[i]==c then remove(item.value,i);removed=true end end
self:UpdateChoices(item.choices)
if removed then item._ddVer=(item._ddVer or 0)+1;Invoke(item.callback,item.value)end
return self
end
function handle:SetSearchable(b)item.searchable=b==true;return self end
function handle:SetMaxSelections(n)
item.maxSelections=tonumber(n)
if item.maxSelections and#item.value>item.maxSelections then
local nv={};for i=1,item.maxSelections do nv[i]=item.value[i]end
SetDropdownValue(item,nv,true)
end
return self
end
function handle:ClearChoices()
item.choices={}
if#item.value>0 then SetDropdownValue(item,{},true)end
return self:UpdateChoices(item.choices)
end
function handle:SetRefresh(fn)
item.choicesFn=(type(fn)=="function")and fn or nil
if item.choicesFn then State._refreshChoices(item,true)end
return self
end
function handle:Refresh()State._refreshChoices(item,true);return self end
end
if item.type=="button"then
function handle:AddButton(label,callback)
item.buttons[#item.buttons+1]={label=tostring(label or"Button"),callback=callback}
return self
end
end
if item.type=="keybind"then KeybindItems[#KeybindItems+1]=item end
return handle
end
local function MakeSection(tab,name,side,desc)
local section={name=tostring(name or"Section"),side=tostring(side or"Left"),items={},
desc=(desc~=nil and desc~="")and tostring(desc)or nil}
tab.sections[#tab.sections+1]=section
local api={_section=section}
function api:SetName(t)section.name=tostring(t);return self end
function api:Label(label,color,tooltip)
if type(color)=="string"and tooltip==nil then tooltip=color;color=nil end
local fn=type(label)=="function"and label or nil
return MakeItem(section,{type="label",labelFn=fn,label=fn and""or tostring(label or""),color=color or Theme.sub,tooltip=tooltip})
end
function api:Info(text,color)
return MakeItem(section,{type="info",label=tostring(text or""),color=color or Theme.sub})
end
function api:Divider(label)
return MakeItem(section,{type="divider",label=label and tostring(label)or nil})
end
function api:Button(label,callback,tooltip)
return MakeItem(section,{type="button",label=tostring(label or"Button"),callback=callback,tooltip=tooltip,buttons={{label=tostring(label or"Button"),callback=callback}}})
end
function api:Toggle(label,default,callback,tooltip)
return MakeItem(section,{type="checkbox",label=tostring(label or"Toggle"),value=default==true,callback=callback,tooltip=tooltip})
end
api.Checkbox=api.Toggle
function api:Slider(label,default,step,minV,maxV,suffix,callback,tooltip)
local item={type="slider",label=tostring(label or"Slider"),
min=tonumber(minV)or 0,max=tonumber(maxV)or 100,step=tonumber(step)or 1,
value=tonumber(default)or tonumber(minV)or 0,suffix=suffix or"",callback=callback,tooltip=tooltip}
item.value=SnapValue(item.value,item)
return MakeItem(section,item)
end
function api:RangeSlider(label,defLo,defHi,step,minV,maxV,suffix,callback,tooltip)
local item={type="rangeslider",label=tostring(label or"Range"),
min=tonumber(minV)or 0,max=tonumber(maxV)or 100,step=tonumber(step)or 1,
valueLo=tonumber(defLo)or tonumber(minV)or 0,
valueHi=tonumber(defHi)or tonumber(maxV)or 100,
suffix=suffix or"",callback=callback,tooltip=tooltip}
item.valueLo=SnapValue(item.valueLo,item)
item.valueHi=SnapValue(item.valueHi,item)
if item.valueLo>item.valueHi then item.valueLo,item.valueHi=item.valueHi,item.valueLo end
item.defLo,item.defHi=item.valueLo,item.valueHi
return MakeItem(section,item)
end
function api:Dropdown(label,default,choices,multi,callback,tooltip,searchable,maxSelections)
local fn=(type(choices)=="function")and choices or nil
local initial=choices
if fn then local ok,r=pcall(fn);initial=(ok and type(r)=="table")and r or{}end
return MakeItem(section,{type="dropdown",label=tostring(label or"Dropdown"),value=CopyArray(default),choices=CopyArray(initial),choicesFn=fn,multi=multi==true,searchable=searchable==true,maxSelections=tonumber(maxSelections),callback=callback,tooltip=tooltip})
end
function api:Colorpicker(label,default,callback,defaultAlpha)
return MakeItem(section,{type="colorpicker",label=tostring(label or"Color"),value=default or Theme.accent,alpha=defaultAlpha or 1,callback=callback})
end
function api:Textbox(label,default,callback,tooltip)
return MakeItem(section,{type="textbox",label=tostring(label or"Textbox"),value=tostring(default or""),callback=callback,tooltip=tooltip})
end
function api:Keybind(label,default,callback,tooltip)
return MakeItem(section,{type="keybind",label=tostring(label or"Keybind"),value=NormalKey(default),listening=false,callback=callback,tooltip=tooltip})
end
function api:Image(data,height,width)
return MakeItem(section,{type="image",imageData=data,imgHeight=tonumber(height)or 80,imgWidth=tonumber(width)})
end
return api
end
local ui={}
ui.__index=ui
function ui.Notify(a,b,c,d,e)
local title,desc,dur,typ
if type(a)=="table"then title,desc,dur,typ=b,c,d,e
else title,desc,dur,typ=a,b,c,d end
State.notifications[#State.notifications+1]={
title=string.lower(tostring(title or"notification")),
description=string.lower(tostring(desc or"")),
duration=tonumber(dur)or State.notifyDur or 5,elapsed=0,
ntype=typ and string.lower(tostring(typ))or nil}
end
function ui:Dialog(opts)
opts=opts or{}
State.dialog={
title=tostring(opts.title or"Confirm"),
text=tostring(opts.text or""),
confirm=tostring(opts.confirm or"Confirm"),
cancel=tostring(opts.cancel or"Cancel"),
onConfirm=opts.onConfirm,onCancel=opts.onCancel,
}
return self
end
function ui:SetAccent(a,b)
b=b or a
if a~=nil then Theme.accentA=a;State.baseAccentA=a end
if b~=nil then Theme.accentB=b;State.baseAccentB=b end
if State._c1pick then State._c1pick.item.value=Theme.accentA end
if State._c2pick then State._c2pick.item.value=Theme.accentB end
return self
end
function ui:SetTheme(overrides)
if type(overrides)=="table"then
local a,b=overrides.accent,overrides.accent
if overrides.accentA~=nil then a=overrides.accentA end
if overrides.accentB~=nil then b=overrides.accentB end
for k,v in pairs(overrides)do if Theme[k]~=nil and k~="accent"and k~="accentA"and k~="accentB"then Theme[k]=v end end
if a or b then ui:SetAccent(a or Theme.accentA,b or Theme.accentB)end
end
return self
end
function ui:SetOpacity(v)
v=tonumber(v)
if v then if v>1 then v=v/100 end;State.menuOpacity=Clamp(v,0.4,1)end
return self
end
function ui:SetPerformance(on)
State.lite=on==true
return self
end
function ui:IsPerformance()return State.lite==true end
function ui:SetRounding(v)
v=tonumber(v)
if v then if v>2.5 then v=v/100 end;State.roundScale=Clamp(v,0,2.5)end
return self
end
function ui:GetRounding()return State.roundScale or 1 end
function ui:SetRowLines(on)State.rowLines=on==true;return self end
function ui:SetCheckboxStyle(on)State.checkboxStyle=on==true;return self end
function ui:IsCheckboxStyle()return State.checkboxStyle==true end
function ui:SetKeybindOverlay(on)State.hotkeyEnabled=on~=false;return self end
function ui:SetAutoSave(on)State.autoSave=on==true;return self end
function ui:SetMenuKey(key)
if type(key)=="number"or(type(key)=="string"and tonumber(key))then
local vk=tonumber(key)
for name,inp in pairs(Input)do if inp.id==vk then key=name break end end
end
local nk=NormalKey(key)
if nk and Input[nk]then MenuKey=nk end
return self
end
function ui:IsOpen()return State.open==true end
function ui:SetOpen(b)SetOpen(b==true);return self end
function ui:OpenColorpicker(h)
local item=(type(h)=="table"and h.item)or h
if item and item.type=="colorpicker"then OpenColorpicker(State.x+80,State.y+80,item)end
return self
end
function ui:OpenSpotlight(open)
State.spotlightOpen=open~=false
if State.spotlightOpen then State.spotlight={query="",sel=1};State.focus=nil end
return self
end
function ui:SetGameInput(on)State.gameInput=(on=="always")and"always"or(on~=false);return self end
function ui:OpenSettings()
if State.settingsTab and State.activeTab~=State.settingsTab then
State._prevTab=State.activeTab;State._prevIndex=State.activeIndex
State.activeTab=State.settingsTab;State.activeIndex=State.settingsIndex or#State.tabs
State.contentFade=0
end
return self
end
function ui:SetTitle(t)State.title=tostring(t or"uilib");return self end
function ui:SetSize(w,h)
if tonumber(w)then State.w=max(80,tonumber(w));State.wTarget=State.w end
if tonumber(h)then State.h=max(80,tonumber(h));State.hTarget=State.h end
return self
end
function ui:SetPos(x,y)
if tonumber(x)then State.x=tonumber(x)end
if tonumber(y)then State.y=tonumber(y)end
return self
end
ui.SetPosition=ui.SetPos
function ui:Center()
local vw,vh=ScreenSize()
State.x=floor(vw/2-State.w/2)
State.y=floor(vh/2-State.h/2)
return self
end
function ui:Category(name)
State._curCategory=(name~=nil and tostring(name)~="")and tostring(name)or nil
return self
end
function ui:Tab(name,icon)
local tab={name=tostring(name or("Tab "..(#State.tabs+1))),icon=icon,category=State._curCategory,subs={},sections={},scrollY=0,targetScrollY=0,maxScroll=0}
State.tabs[#State.tabs+1]=tab
if not State.activeTab then State.activeTab=tab;State.activeIndex=#State.tabs end
local tabApi={_tab=tab}
function tabApi:Section(secName,side,desc)return MakeSection(tab,secName,side,desc)end
function tabApi:Sub(subName,subIcon)
local sub={name=tostring(subName or("Sub "..(#tab.subs+1))),icon=subIcon,parent=tab,sections={},scrollY=0,targetScrollY=0,maxScroll=0}
tab.subs[#tab.subs+1]=sub
local subApi={_tab=sub}
function subApi:Section(sn,sd,de)return MakeSection(sub,sn,sd,de)end
return subApi
end
return tabApi
end
function ui:CreateBox(opts)
opts=type(opts)=="table"and opts or{}
State.boxes=State.boxes or{}
local box={title=tostring(opts.title or"Box"),lines={},visible=opts.visible~=false,alive=true,
x=(opts.position and opts.position.X)or opts.x or 20,
y=(opts.position and opts.position.Y)or opts.y or 140,width=opts.width or opts.w}
State.boxes[#State.boxes+1]=box
local api={_box=box}
function api:Text(value,color)
local ln={value=value,color=color};box.lines[#box.lines+1]=ln
return{Set=function(_,t)ln.value=t end,SetColor=function(_,c)ln.color=c end}
end
api.Label=api.Text
function api:Stat(value,color)
local ln={kind="stat",value=value,color=color}
box.lines[#box.lines+1]=ln
return{Set=function(_,t)ln.value=t end,SetColor=function(_,c)ln.color=c end}
end
function api:Bar(value,color)
local ln={kind="bar",value=value,color=color}
box.lines[#box.lines+1]=ln
return{Set=function(_,v)ln.value=v end,SetColor=function(_,c)ln.color=c end}
end
function api:SetVisible(b)box.visible=b~=false;return self end
function api:Toggle()box.visible=not box.visible;return self end
function api:SetTitle(t)box.title=tostring(t);return self end
function api:Clear()box.lines={};return self end
function api:Remove()
box.alive=false
for i,b in ipairs(State.boxes)do if b==box then remove(State.boxes,i)break end end
end
return api
end
local function SplitPath(s)local p={};for part in string.gmatch(s,"[^%.]+")do p[#p+1]=part end return p end
function ui:GetValue(path)
local p=SplitPath(tostring(path));if#p<3 then return nil end
for _,t in ipairs(State.tabs)do if t.name==p[1]then
for _,s in ipairs(t.sections)do if s.name==p[2]then
for _,it in ipairs(s.items)do if it.label==p[3]then
if it.type=="rangeslider"then return it.valueLo,it.valueHi end
if it.type=="colorpicker"then return it.value,it.alpha or 1 end
return it.value
end end
end end
end end
return nil
end
function ui:SetValue(path,value)
local p=SplitPath(tostring(path));if#p<3 then return self end
for _,t in ipairs(State.tabs)do if t.name==p[1]then
for _,s in ipairs(t.sections)do if s.name==p[2]then
for _,it in ipairs(s.items)do if it.label==p[3]then SetItemValue(it,value,true);return self end end
end end
end end
return self
end
local function UpdateInput()
State.mouseScroll=0
local active=true
active=IsGameActive()
for _,name in ipairs(InputOrder)do local inp=Input[name];inp.click=false;inp.released=false end
local m1=active and IsMouse1Down()or false
local m2=active and IsMouse2Down()or false
Input.m1.click=m1 and not Input.m1.held;Input.m1.released=(not m1)and Input.m1.held;Input.m1.held=m1
Input.m2.click=m2 and not Input.m2.held;Input.m2.released=(not m2)and Input.m2.held;Input.m2.held=m2
local pollAll=State.focus~=nil or State.spotlightOpen or State.dialog~=nil or State.kbCapture~=nil or(State.colorpicker~=nil and State.colorpicker.hexInput~=nil)
if not pollAll then
for _,item in ipairs(KeybindItems)do
if(item.keybind and item.keybind.listening)or(item.type=="keybind"and item.listening)then pollAll=true;break end
end
end
if pollAll then
for _,name in ipairs(InputOrder)do
if name~="m1"and name~="m2"then
local inp=Input[name]
local down=active and IsKeyPressed(inp.id)or false
inp.click=down and not inp.held;inp.released=(not down)and inp.held;inp.held=down
end
end
else
local keys={}
keys[MenuKey]=true
keys.ctrl=true;keys.lctrl=true;keys.rctrl=true;keys.space=true;keys.esc=true
if State.open then
keys.left=true;keys.right=true;keys.up=true;keys.down=true;keys.pageup=true;keys.pagedown=true
end
for _,item in ipairs(KeybindItems)do
local kb=item.keybind
if kb and kb.value then
if kb._pcSrc~=kb.value then kb._pcSrc=kb.value;kb._pcMod,kb._pcKey=SplitCombo(kb.value)end
if kb._pcMod then keys[kb._pcMod]=true end
if kb._pcKey then keys[kb._pcKey]=true end
elseif item.type=="keybind"and item.value and item.value~=""then
if item._pcSrc~=item.value then item._pcSrc=item.value;item._pcMod,item._pcKey=SplitCombo(item.value)end
if item._pcMod then keys[item._pcMod]=true end
if item._pcKey then keys[item._pcKey]=true end
end
end
for name in pairs(keys)do
local inp=Input[name]
if inp and name~="m1"and name~="m2"then
local down=active and IsKeyPressed(inp.id)or false
inp.click=down and not inp.held;inp.released=(not down)and inp.held;inp.held=down
end
end
end
end
local function ShiftHeld()return Input.shift.held or Input.lshift.held or Input.rshift.held end
local function CtrlHeld()return Input.ctrl.held or Input.lctrl.held or Input.rctrl.held end
local function KeyRepeats(name)
local inp=Input[name]
if not inp then return false end
if inp.click then State.repeatKey=name;State.repeatAt=(Clock())+0.4;return true end
if inp.held and State.repeatKey==name and(Clock())>=State.repeatAt then
State.repeatAt=(Clock())+0.035;return true
end
return false
end
local function EditText(obj,field,numeric,hexOnly)
local value=obj[field]or""
obj.caret=Clamp(obj.caret or#value,0,#value)
local caret=obj.caret
local selA=obj.selA
local hasSel=selA~=nil and selA~=caret
local selLo=hasSel and min(selA,caret)or caret
local selHi=hasSel and max(selA,caret)or caret
local changed=false
local sh=ShiftHeld()
local function deleteSel()
value=string.sub(value,1,selLo)..string.sub(value,selHi+1)
caret=selLo;selA=nil;hasSel=false;changed=true
end
local function done()obj.caret=Clamp(caret,0,#value);obj.selA=selA;obj[field]=value;return changed end
if CtrlHeld()then
if Input.a.click then selA=0;caret=#value;Input.a.click=false
elseif Input.c.click then if hasSel then SetClipboard(string.sub(value,selLo+1,selHi))end;Input.c.click=false
elseif Input.x.click then if hasSel then SetClipboard(string.sub(value,selLo+1,selHi));deleteSel()end;Input.x.click=false
elseif Input.v.click then
Input.v.click=false
local clip=GetClipboard()
if type(clip)=="string"and clip~=""then
if numeric then clip=clip:gsub("[^0-9%.%-]","")elseif hexOnly then clip=clip:gsub("[^0-9a-fA-F]","")end
if hasSel then deleteSel()end
value=string.sub(value,1,caret)..clip..string.sub(value,caret+1);caret=caret+#clip;changed=true
end
end
return done()
end
if Input.left.click or Input.right.click or Input.home.click or Input["end"].click then
local nc=caret
if Input.left.click then nc=(hasSel and not sh)and selLo or max(0,caret-1)end
if Input.right.click then nc=(hasSel and not sh)and selHi or min(#value,caret+1)end
if Input.home.click then nc=0 end
if Input["end"].click then nc=#value end
if sh then selA=selA or caret else selA=nil end
caret=nc
Input.left.click=false;Input.right.click=false;Input.home.click=false;Input["end"].click=false
return done()
end
if Input.delete.click then
if hasSel then deleteSel()elseif caret<#value then value=string.sub(value,1,caret)..string.sub(value,caret+2);selA=nil;changed=true end
Input.delete.click=false
end
if KeyRepeats("backspace")then
if hasSel then deleteSel()elseif caret>0 then value=string.sub(value,1,caret-1)..string.sub(value,caret+1);caret=caret-1;selA=nil;changed=true end
end
if not changed then
for _,name in ipairs(InputOrder)do
local inp=Input[name]
if inp.char then
local doIt=inp.click or(inp.held and State.repeatKey==name and(Clock())>=State.repeatAt)
if doIt then
local ch=(sh and inp.shifted)or inp.char
if numeric and not ch:match("[0-9%.%-]")then ch=""elseif hexOnly and not ch:match("[0-9a-fA-F]")then ch=""end
if ch~=""then if hasSel then deleteSel()end;value=string.sub(value,1,caret)..ch..string.sub(value,caret+1);caret=caret+1;selA=nil;changed=true end
if inp.click then State.repeatKey=name;State.repeatAt=(Clock())+0.4;inp.click=false
else State.repeatAt=(Clock())+0.035 end
break
end
end
end
end
return done()
end
local EDIT_FONT=FontUI
local EDIT_MULT=FontWidths[FontUI]or 0.50
local function EditCharWidth(size)return(size or 13)*EDIT_MULT end
local function CaretAtX(obj,value,mouseX)
local cw=obj._ecw or EditCharWidth(13)
return Clamp((obj._es or 0)+floor((mouseX-(obj._ex or 0))/cw+0.5),0,#tostring(value or""))
end
local function DrawEditable(obj,value,fx,yText,size,color,alpha,z,hxW,focused,caretIdx,selA)
value=tostring(value or"")
local cw=EditCharWidth(size)
local n=#value
caretIdx=Clamp(caretIdx or n,0,n)
local cap=max(1,floor(hxW/cw))
local scroll=0
if focused and caretIdx>cap then scroll=caretIdx-cap end
obj._ecw=cw;obj._ex=fx;obj._es=scroll
local last=min(n,scroll+cap)
local hasSel=focused and selA and selA~=caretIdx
local vis=string.sub(value,scroll+1,last)
for i=1,#vis do
DrawText(string.sub(vis,i,i),fx+(i-1)*cw,yText,color,size,EDIT_FONT,z,false,false,nil,alpha)
end
if focused and not hasSel and(((Clock())%1)<0.55)then
DrawRect(fx+Clamp(caretIdx-scroll,0,#vis)*cw,yText,1,size,color,z,0,alpha)
end
if hasSel then
local lo,hi=min(selA,caretIdx),max(selA,caretIdx)
local vlo=Clamp(lo-scroll,0,#vis)
local vhi=Clamp(hi-scroll,0,#vis)
DrawRect(fx+vlo*cw,yText-1,max(1,(vhi-vlo)*cw),size+4,State._accentMid,z,3,(vhi>vlo)and(0.45*alpha)or 0)
end
end
local function RunTextInput()
local item=State.focus
if not item then return end
if item==State.dropdown and item.searchable then
if Input.enter.click or Input.esc.click then State.focus=nil;Input.enter.click=false;Input.esc.click=false;return end
if EditText(item,"searchQuery",false)then item.scrollOffset=0 end
return
end
if type(item)~="table"or(item.type~="textbox"and item.type~="slider")then return end
if Input.enter.click or Input.esc.click then
if item.type=="slider"and item.directValue then
if Input.enter.click then SetItemValue(item,tonumber(item.directValue)or item.value,true)end
item.directValue=nil
end
State.focus=nil;item.selA=nil
Input.enter.click=false;Input.esc.click=false
return
end
if item.type=="textbox"then
if EditText(item,"value",false)then Invoke(item.callback,item.value)end
else
EditText(item,"directValue",true)
end
end
local function RunKeybinds()
if State.focus then return end
for _,item in ipairs(KeybindItems)do
local kb=item.keybind
if kb and kb.value and not kb.listening and not IsItemLocked(item)then
if kb._pcSrc~=kb.value then kb._pcSrc=kb.value;kb._pcMod,kb._pcKey=SplitCombo(kb.value)end
local mod,k=kb._pcMod,kb._pcKey
local kIn=Input[k]
local mIn=mod and Input[mod]or nil
if kIn then
if kb.callback then
local act=kb.active or false
if mod and not mIn then
elseif kb.mode=="Always"then
act=true
elseif kb.mode=="Toggle"then
local fire=mod and(mIn.held and kIn.click)or(not mod and kIn.click)
if fire then act=not kb.active end
else
act=(mod and(mIn.held and kIn.held))or(not mod and kIn.held)or false
end
if act~=kb.active then kb.active=act;Invoke(kb.callback,act)end
else
if mod and not mIn then
elseif kb.mode=="Always"then
SetItemValue(item,true,true)
elseif kb.mode=="Toggle"then
local fire=mod and(mIn.held and kIn.click)or(not mod and kIn.click)
if fire then SetItemValue(item,not item.value,true)end
else
SetItemValue(item,(mod and(mIn.held and kIn.held))or(not mod and kIn.held)or false,true)
end
end
end
end
end
end
State._captureKeybind=function()
local target,kb
for _,item in ipairs(KeybindItems)do
if item.type=="keybind"and item.listening then target=item;break end
if item.keybind and item.keybind.listening then target=item;kb=item.keybind;break end
end
if not target then return false end
for _,name in ipairs(InputOrder)do
local inp=Input[name]
if inp.click then
if kb then
if name=="esc"then kb.value=nil else kb.value=name end
kb.listening=false
else
if name~="esc"then target.value=name;Invoke(target.callback,target.value)end
target.listening=false;State.kbCapture=nil
end
inp.click=false
Input.m1.click=false;Input.m2.click=false
break
end
end
return true
end
function OpenDropdown(x,y,w,item)
State._refreshChoices(item,true)
local rowH=Layout.DropRowHeight
local searchable=item.searchable==true
local headerH=searchable and 30 or 0
local visible=min(#item.choices,8)
local h=max(rowH,visible*rowH)+8+headerH
local vw,vh=ScreenSize()
x=Clamp(x,8,max(8,vw-w-8));y=Clamp(y,8,max(8,vh-h-8))
State.dropdown={item=item,choices=CopyArray(item.choices),
x=x,y=y,w=w,h=h,rowH=rowH,multi=item.multi,scrollOffset=0,anim=0,
searchable=searchable,headerH=headerH,searchQuery=""}
State.colorpicker=nil
if searchable then State.focus=State.dropdown end
end
function OpenColorpicker(x,y,picker)
local w,h=250,240
local vw,vh=ScreenSize()
x=Clamp(x,8,max(8,vw-w-8));y=Clamp(y,8,max(8,vh-h-8))
local hh,ss,vv=ToHsv(picker.value)
State.colorpicker={picker=picker,x=x,y=y,w=w,h=h,hue=hh,sat=ss,val=vv,
alpha=picker.alpha or 1,anim=0,fmt="HEX"}
State.dropdown=nil
end
local DrawDropdown
do
local PRESS=0.3
local CTX_W,CTX_PAD,CTX_ROW=110,4,24
local CTX={
{title="Select All",apply=function(dd)
local item=dd.item
local nv,cap={},item.maxSelections
for _,c in ipairs(dd.choices)do
if cap and#nv>=cap then break end
nv[#nv+1]=c
end
SetDropdownValue(item,nv,true)
end},
{title="Clear All",apply=function(dd)SetDropdownValue(dd.item,{},true)end},
}
local CTX_H=CTX_PAD+#CTX*CTX_ROW
local function settle(cur,want,speed,eps)
local v=Approach(cur,want,speed)
if abs(v-want)<eps then return want end
return v
end
local function filtered(dd)
local q=dd.searchQuery
if not dd.searchable or q==""then return dd.choices end
if dd._filterQ~=q or dd._filterList~=dd.choices then
dd._filterQ,dd._filterList=q,dd.choices
local needle,out=string.lower(q),{}
for _,c in ipairs(dd.choices)do
if string.find(string.lower(tostring(c)),needle,1,true)then out[#out+1]=c end
end
dd._filtered=out
end
return dd._filtered
end
local function drawSearch(dd,L,click)
local bx,by,bw,bh=L.x+6,L.y+5,L.w-12,22
local focused=State.focus==dd
local q=dd.searchQuery
local a=L.a
DrawRect(bx,by,bw,bh,WHITE,202,6,Alpha.Field*a)
DrawStroke(bx,by,bw,bh,WHITE,203,6,(focused and 0.4 or Alpha.Hairline)*a)
if q==""and not focused then
DrawText("search...",bx+8,TextTop(by,bh,13),WHITE,13,FontSystem,204,false,false,bw-16,0.3*a)
else
DrawEditable(dd,q,bx+8,TextTop(by,bh,13),13,WHITE,Alpha.Dim*a,204,bw-18,focused,dd.caret,dd.selA)
end
if click and IsMouseIn(bx,by,bw,bh)then
State.focus=dd
dd.caret=CaretAtX(dd,q,State.mouseX)
dd.selA=dd.caret
State.textDrag=dd
click=false
end
if Input.m1.held and State.textDrag==dd then dd.caret=CaretAtX(dd,q,State.mouseX)end
return click
end
local function pick(dd,choice)
local item=dd.item
if not dd.multi then
SetDropdownValue(item,{choice},true)
dd.closing=true
State.focus=nil
return
end
local nv=CopyArray(item.value)
for i=1,#nv do
if nv[i]==choice then
remove(nv,i)
SetDropdownValue(item,nv,true)
return
end
end
if not item.maxSelections or#nv<item.maxSelections then nv[#nv+1]=choice end
SetDropdownValue(item,nv,true)
end
local function drawRows(dd,L,click)
local list,x,w,top,rowH,a=L.list,L.x,L.w,L.top,L.rowH,L.a
local rowW=L.bar and(w-18)or(w-8)
local rh=rowH-2
local areaH=L.maxRows*rowH
local bottom=top+areaH
local now=Clock()
local acc=State._accentMid
local rx=x+4
dd._sy=settle(dd._sy or dd.scrollOffset,dd.scrollOffset,16,0.004)
local sy=dd._sy
local marks=dd._marks
if not marks then marks={};dd._marks=marks end
for k in pairs(marks)do marks[k]=nil end
for _,v in ipairs(dd.item.value)do marks[v]=true end
local first=floor(sy)
for ai=first,first+L.maxRows do
local choice=ai>=0 and list[ai+1]
if choice then
local ry0=top+(ai-sy)*rowH
if ry0+rowH>top and ry0<bottom then
local edge=Clamp((ry0+rowH-top)/rowH,0,1)*Clamp((bottom-ry0)/rowH,0,1)
local casc=Clamp((a-(ai-first)*0.07)/0.4,0,1)
local ra=casc*edge
local ry=ry0+(1-casc)*12
local sel=marks[choice]==true
local hov=ry0>=top-2 and ry0+rowH<=bottom+2 and IsMouseIn(rx,ry,rowW,rh)
local held=dd._pressRow==ai and dd._pressT and dd._pressT>now
if held then DrawRect(rx,ry,rowW,rh,acc,202,6,0.45*((dd._pressT-now)/PRESS)*ra)end
if sel then DrawRect(rx,ry,rowW,rh,WHITE,202,6,0.05*ra)end
if hov then DrawRect(rx,ry,rowW,rh,acc,202,6,0.16*ra)end
DrawText(choice,x+12,TextTop(ry,rh,13),WHITE,13,FontSystem,203,false,false,w-42,((hov or sel)and Alpha.Text or Alpha.Label)*ra)
if sel then
local ckx,cky=rx+rowW-14,ry+rh/2+1
DrawLine(ckx,cky,ckx+3,cky+3,WHITE,204,1.5,Alpha.Text*ra)
DrawLine(ckx+3,cky+3,ckx+8,cky-4,WHITE,204,1.5,Alpha.Text*ra)
end
if click and hov and not dd.closing then
dd._pressRow,dd._pressT=ai,now+PRESS
pick(dd,choice)
click=false
end
end
end
end
return click
end
local function drawScrollbar(dd,L,click)
if dd._sbDrag and not Input.m1.held then dd._sbDrag=nil end
if not L.bar then return click end
local list,a=L.list,L.a
local maxOff=#list-L.maxRows
local trackY,trackH=L.top+1,L.maxRows*L.rowH-4
local sbX=L.x+L.w-6
local thumbH=max(22,trackH*L.maxRows/#list)
local frac=dd.scrollOffset/maxOff
local onBar=IsMouseIn(sbX-6,trackY,12,trackH)
dd._sbY=settle(dd._sbY or 0,trackY+(trackH-thumbH)*frac,18,0.1)
dd._sbHf=settle(dd._sbHf or 0,(onBar or dd._sbDrag)and 1 or 0,14,0.004)
local hf=dd._sbHf
local col=LerpColor(Theme.accentA,Theme.accentB,frac)
DrawRect(sbX,trackY,3,trackH,WHITE,204,2,0.05*a)
DrawRect(sbX-1.5,dd._sbY-2,7,thumbH+4,col,205,3.5,0.18*hf*a)
DrawRect(sbX,dd._sbY,4,thumbH,LerpColor(WHITE,col,0.75),205,2,(0.25+0.45*hf)*a)
if click and onBar then dd._sbDrag=true;click=false end
if dd._sbDrag and Input.m1.held then
dd.scrollOffset=floor(Clamp((State.mouseY-trackY-thumbH/2)/max(1,trackH-thumbH),0,1)*maxOff+0.5)
end
return click
end
local function drawCtx(dd,L,click)
local cx,cy,a=dd.ctx.x,dd.ctx.y,L.a
DrawRect(cx,cy,CTX_W,CTX_H,Theme.bg,206,6,0.98*a)
DrawStroke(cx,cy,CTX_W,CTX_H,WHITE,207,6,Alpha.CardStroke*a)
for i,entry in ipairs(CTX)do
local oy=cy+CTX_PAD+(i-1)*CTX_ROW
local ow=CTX_W-6
local hov=IsMouseIn(cx+3,oy,ow,22)
if hov then DrawRect(cx+3,oy,ow,22,WHITE,207,5,0.05*a)end
DrawText(entry.title,cx+10,TextTop(oy,22,12),WHITE,12,FontSystem,208,false,false,CTX_W-16,Alpha.Label*a)
if click and hov then
entry.apply(dd)
dd.ctx=nil
click=false
end
end
if click and not IsMouseIn(cx-4,cy-4,CTX_W+8,CTX_H+8)then dd.ctx=nil;click=false end
return click
end
function DrawDropdown(click,rightClick)
local dd=State.dropdown
if not dd then return click,rightClick end
dd.anim=Approach(dd.anim or 0,dd.closing and 0 or 1,9)
if dd.closing and dd.anim<0.02 then
if State.focus==dd then State.focus=nil end
State.dropdown=nil
return click,rightClick
end
if not dd.closing then State._refreshChoices(dd.item,false)end
local a=dd.anim
local headerH=dd.headerH or 0
local list=filtered(dd)
local L={
list=list,
x=dd.x,
y=dd.y-(1-a)*6,
w=dd.w,
h=dd.h,
a=a,
rowH=dd.rowH,
maxRows=max(1,floor((dd.h-8-headerH)/dd.rowH)),
}
L.top=L.y+4+headerH
L.bar=#list>L.maxRows
local hov=IsMouseIn(L.x-4,L.y-4,L.w+8,L.h+8)
if hov and State.mouseScroll~=0 then
dd.scrollOffset=dd.scrollOffset-(State.mouseScroll>0 and 1 or-1)
State.mouseScroll=0
end
dd.scrollOffset=Clamp(dd.scrollOffset,0,max(0,#list-L.maxRows))
DrawRect(L.x-3,L.y-3,L.w+6,L.h+6,c3(0,0,0),199,11,0.28*a)
DrawRect(L.x,L.y,L.w,L.h,LerpColor(Theme.bg,WHITE,0.03),200,8,0.98*a)
if dd.searchable then click=drawSearch(dd,L,click)end
click=drawRows(dd,L,click)
click=drawScrollbar(dd,L,click)
if dd.multi and rightClick and hov then
local vw,vh=ScreenSize()
dd.ctx={
x=Clamp(State.mouseX,8,max(8,vw-CTX_W-8)),
y=Clamp(State.mouseY,8,max(8,vh-CTX_H-8)),
}
rightClick=false
end
if dd.ctx then click=drawCtx(dd,L,click)end
if click and not hov and not dd.ctx and not dd.closing then
dd.closing=true
State.focus=nil
click=false
end
return click,rightClick
end
end
local DrawColorpicker
do
local PAD,BOX_H,SLIDER_H,INFO_H=12,128,10,22
local function pushChange(cp)
local now=hsv(cp.hue,cp.sat,cp.val)
cp.picker.value=now
cp.picker.alpha=cp.alpha
Invoke(cp.picker.callback,now,cp.alpha)
end
local function dragBars(cp,held,boxX,boxY,boxW,hueY,alphaY)
if not held then State.cpDrag=nil;return end
local moved=false
if State.cpDrag=="sv"or IsMouseIn(boxX,boxY,boxW,BOX_H)then
State.cpDrag="sv"
cp.sat=Clamp((State.mouseX-boxX)/boxW,0,1)
cp.val=Clamp(1-(State.mouseY-boxY)/BOX_H,0,1)
moved=true
elseif State.cpDrag=="hue"or IsMouseIn(boxX-4,hueY-4,boxW+8,SLIDER_H+8)then
State.cpDrag="hue"
cp.hue=Clamp((State.mouseX-boxX)/boxW,0,1)
moved=true
elseif State.cpDrag=="alpha"or IsMouseIn(boxX-4,alphaY-4,boxW+8,SLIDER_H+8)then
State.cpDrag="alpha"
cp.alpha=Clamp((State.mouseX-boxX)/boxW,0,1)
moved=true
end
if moved then
local now=hsv(cp.hue,cp.sat,cp.val)
if ColorChanged(cp.picker.value,now)or abs((cp.picker.alpha or 1)-cp.alpha)>0.001 then
pushChange(cp)
end
end
end
local function drawSV(cp,cache,boxX,boxY,boxW,a,cur,pure)
local cols=Clamp(floor(boxW),40,170)
if not cache.sv or cache.svHue~=cp.hue or cache.svN~=cols then
cache.svHue,cache.svN=cp.hue,cols
local ramp={}
for i=0,cols-1 do ramp[i]=LerpColor(WHITE,pure,i/(cols-1))end
cache.sv=ramp
end
for i=0,cols-1 do
local x0=Round(boxX+boxW*i/cols)
local x1=Round(boxX+boxW*(i+1)/cols)
if x1>x0 then DrawRect(x0,boxY,x1-x0,BOX_H,cache.sv[i],212,0,a)end
end
local rows=Clamp(floor(BOX_H),40,150)
for j=1,rows-1 do
local y0=Round(boxY+BOX_H*j/rows)
local y1=Round(boxY+BOX_H*(j+1)/rows)
if y1>y0 then DrawRect(boxX,y0,boxW,y1-y0,c3(0,0,0),213,0,(j/(rows-1))*0.92*a)end
end
DrawStroke(boxX,boxY,boxW,BOX_H,c3(0,0,0),214,4,0.25*a)
local hx,hy=boxX+cp.sat*boxW,boxY+(1-cp.val)*BOX_H
DrawCircle(hx,hy,7.5,c3(0,0,0),214,false,2,26,0.45*a)
DrawCircle(hx,hy,7,WHITE,215,false,2.4,26,a)
DrawCircle(hx,hy,4.5,cur,216,true,1,26,a)
end
local function drawHue(cp,cache,boxX,boxW,hueY,segs,a,pure)
if not cache.hueBar or cache.hueBarN~=segs then
cache.hueBarN=segs
local ramp={}
for i=0,segs-1 do ramp[i]=hsv(i/(segs-1),1,1)end
cache.hueBar=ramp
end
local inset=SLIDER_H/2
DrawRect(boxX,hueY,boxW,SLIDER_H,cache.hueBar[0],213,SLIDER_H/2,a)
for i=0,segs-1 do
local x0=Round(boxX+inset+(boxW-2*inset)*i/segs)
local x1=Round(boxX+inset+(boxW-2*inset)*(i+1)/segs)
if x1>x0 then DrawRect(x0,hueY,x1-x0,SLIDER_H,cache.hueBar[i],214,0,a)end
end
local hx=boxX+cp.hue*boxW
DrawCircle(hx,hueY+SLIDER_H/2,7,c3(0,0,0),214,false,2,24,0.3*a)
DrawCircle(hx,hueY+SLIDER_H/2,6.5,WHITE,215,true,1,24,a)
DrawCircle(hx,hueY+SLIDER_H/2,4.5,pure,216,true,1,24,a)
end
local function drawAlpha(cp,boxX,boxW,alphaY,segs,a,cur)
DrawRect(boxX,alphaY,boxW,SLIDER_H,c3(70,70,70),213,SLIDER_H/2,a)
for i=0,segs-1 do
local x0=Round(boxX+boxW*i/segs)
local x1=Round(boxX+boxW*(i+1)/segs)
local corner=(i==0 or i==segs-1)and SLIDER_H/2 or 0
if x1>x0 then DrawRect(x0,alphaY,x1-x0,SLIDER_H,cur,214,corner,(i/(segs-1))*a)end
end
local hx=boxX+cp.alpha*boxW
DrawCircle(hx,alphaY+SLIDER_H/2,7,c3(0,0,0),214,false,2,24,0.3*a)
DrawCircle(hx,alphaY+SLIDER_H/2,6.5,WHITE,215,true,1,24,a)
DrawCircle(hx,alphaY+SLIDER_H/2,4.5,cur,216,true,1,24,a*(0.4+0.6*cp.alpha))
end
local function applyEdit(cp)
if cp.fmt=="RGB"then
local r,g,b=string.match(cp.hexInput or"","(%d+)%D+(%d+)%D+(%d+)")
if r then
local col=c3(Clamp(tonumber(r),0,255),Clamp(tonumber(g),0,255),Clamp(tonumber(b),0,255))
cp.hue,cp.sat,cp.val=ToHsv(col)
pushChange(cp)
end
else
local digits=string.gsub(tostring(cp.hexInput or""),"[^0-9a-fA-F]","")
local col=ParseHex(cp.hexInput)
if col then
cp.hue,cp.sat,cp.val=ToHsv(col)
if#digits>=8 then
local alpha=tonumber(string.sub(digits,7,8),16)
if alpha then cp.alpha=alpha/255 end
end
pushChange(cp)
end
end
cp.hexInput=nil
end
local function drawInfo(cp,x,y,boxX,boxW,iy,dh,a,cur,held,click)
DrawRect(boxX,iy,22,INFO_H,c3(50,50,50),213,7,a)
DrawRect(boxX,iy,22,INFO_H,cur,214,7,a*cp.alpha)
DrawStroke(boxX,iy,22,INFO_H,WHITE,214,7,Alpha.Hairline*a)
local fmX,fmW=boxX+28,40
local fmHov=IsMouseIn(fmX,iy,fmW,INFO_H)
DrawRect(fmX,iy,fmW,INFO_H,WHITE,213,5,(fmHov and 0.09 or Alpha.Field)*a)
DrawText(cp.fmt,fmX+7,TextTop(iy,INFO_H,11),WHITE,11,FontBold,214,false,false,nil,Alpha.Text*a)
local vx,vy=fmX+fmW-11,iy+INFO_H/2-1
DrawLine(vx,vy,vx+3,vy+3,WHITE,214,1.2,Alpha.Dim*a)
DrawLine(vx+3,vy+3,vx+6,vy,WHITE,214,1.2,Alpha.Dim*a)
if click and fmHov then
cp.fmt=(cp.fmt=="HEX")and"RGB"or"HEX"
cp.hexInput=nil
if State.focus==cp then State.focus=nil end
click=false
end
local editing=cp.hexInput~=nil
local opW=42
local hxX=fmX+fmW+8
local hxW=(boxX+boxW)-opW-4-hxX
local curHex=ToHex(cur)..((cp.alpha or 1)<0.999 and string.format("%02X",Round(Clamp(cp.alpha,0,1)*255))or"")
local str
if editing then
str=(cp.fmt=="RGB")and cp.hexInput or("#"..cp.hexInput)
elseif cp.fmt=="RGB"then
str=string.format("%d, %d, %d",Round(cur.R*255),Round(cur.G*255),Round(cur.B*255))
else
str=curHex
end
local hxHov=IsMouseIn(hxX,iy,hxW,INFO_H)
DrawRect(hxX,iy,hxW,INFO_H,WHITE,213,5,(editing and 0.10 or(hxHov and 0.06 or Alpha.Field))*a)
if editing then
DrawEditable(cp,cp.hexInput,hxX+8,TextTop(iy,INFO_H,12),12,WHITE,Alpha.Text*a,214,hxW-16,true,cp.caret,cp.selA)
else
DrawText(str,hxX+8,TextTop(iy,INFO_H,12),WHITE,12,FontMono,214,false,false,hxW-14,Alpha.Text*a)
end
DrawText(Round(cp.alpha*100).."%",boxX+boxW-opW+4,TextTop(iy,INFO_H,12),WHITE,12,FontSystem,214,false,false,opW-6,Alpha.Label*a)
if click and hxHov and not editing then
if cp.fmt=="RGB"then
cp.hexInput=string.format("%d, %d, %d",Round(cur.R*255),Round(cur.G*255),Round(cur.B*255))
else
cp.hexInput=string.sub(string.gsub(curHex,"#",""),1,8)
end
cp.caret,cp.selA=#cp.hexInput,0
cp._ex,cp._ecw,cp._es=hxX+8,EditCharWidth(12),0
State.cpHexDrag=true
State.focus=cp
click=false
elseif editing then
if Input.enter.click then
applyEdit(cp)
State.focus=nil
Input.enter.click=false
elseif Input.esc.click then
cp.hexInput=nil
State.focus=nil
Input.esc.click=false
elseif click and not IsMouseIn(x-4,y-4,cp.w+8,dh+8)then
applyEdit(cp)
State.focus=nil
else
EditText(cp,"hexInput",false,cp.fmt~="RGB")
end
end
if cp.hexInput~=nil and Input.m1.held and State.cpHexDrag then
cp.caret=CaretAtX(cp,cp.hexInput,State.mouseX)
end
if not held then State.cpHexDrag=nil end
return click
end
function DrawColorpicker(click,held)
local cp=State.colorpicker
if not cp then return click end
local cache=State._cpCache
if not cache then cache={};State._cpCache=cache end
cp.anim=Approach(cp.anim or 0,1,22)
local a=cp.anim
local boxW=cp.w-PAD*2
local dh=PAD+BOX_H+14+SLIDER_H+14+SLIDER_H+14+INFO_H+PAD
local _,vh=ScreenSize()
cp.y=Clamp(cp.y,8,max(8,vh-dh-8))
local x=cp.x
local y=cp.y+(1-a)*-6
DrawRect(x-3,y-3,cp.w+6,dh+6,c3(0,0,0),209,12,0.30*a)
DrawRect(x,y,cp.w,dh,Theme.bg,210,9,0.98*a)
DrawStroke(x,y,cp.w,dh,WHITE,211,9,Alpha.CardStroke*a)
local boxX,boxY=x+PAD,y+PAD
local hueY=boxY+BOX_H+14
local alphaY=hueY+SLIDER_H+14
local segs=Clamp(floor(boxW),40,170)
if cp.hexInput==nil then dragBars(cp,held,boxX,boxY,boxW,hueY,alphaY)end
if not held then State.cpDrag=nil end
local cur=hsv(cp.hue,cp.sat,cp.val)
local pure=hsv(cp.hue,1,1)
drawSV(cp,cache,boxX,boxY,boxW,a,cur,pure)
drawHue(cp,cache,boxX,boxW,hueY,segs,a,pure)
drawAlpha(cp,boxX,boxW,alphaY,segs,a,cur)
click=drawInfo(cp,x,y,boxX,boxW,alphaY+SLIDER_H+14,dh,a,cur,held,click)
if click and not IsMouseIn(x-4,y-4,cp.w+8,dh+8)then
State.colorpicker=nil
if State.focus==cp then State.focus=nil end
click=false
end
return click
end
end
local KEY_MODES={"Hold","Toggle","Always"}
local function DrawKeyMenu(click)
local km=State.keyMenu
if not km then return click end
km.anim=Approach(km.anim or 0,1,22)
local a=km.anim
local w,rowH=96,24
local h=#KEY_MODES*rowH+8
local vw,vh=ScreenSize()
local x=Clamp(km.x,8,max(8,vw-w-8))
local y=Clamp(km.y,8,max(8,vh-h-8))+(1-a)*-6
DrawRect(x,y,w,h,Theme.bg,250,8,0.97*a)
DrawStroke(x,y,w,h,WHITE,251,8,Alpha.CardStroke*a)
for i,mode in ipairs(KEY_MODES)do
local ry=y+4+(i-1)*rowH
local sel=km.kb.mode==mode
local hov=IsMouseIn(x+4,ry,w-8,rowH-2)
DrawRect(x+4,ry,w-8,rowH-2,WHITE,252,6,((hov or sel)and(sel and 0.06 or 0.04)or 0)*a)
DrawText(mode,x+12,TextTop(ry,rowH-2,13),WHITE,13,FontSystem,253,false,false,w-20,(sel and Alpha.Text or Alpha.Label)*a)
if click and hov then km.kb.mode=mode;State.keyMenu=nil;click=false end
end
if click and not IsMouseIn(x-4,y-4,w+8,h+8)then State.keyMenu=nil;click=false end
return click
end
local function DrawKeyOverlay(click,held)
if State.hotkeyEnabled==false then return click end
if not State._winReady then return click end
local rows={}
for _,item in ipairs(KeybindItems)do
local kb=item.keybind
local on=kb and kb.value and kb.value~=""and item.value==true
item._hkA=Approach(item._hkA or 0,on and 1 or 0,16)
if item._hkA>0.02 then
local lbl=item.label or""
local low=string.lower(lbl)
if(low=="enabled"or low=="enable"or low=="active"or low=="on")and item._secName and item._secName~=""then lbl=item._secName end
rows[#rows+1]={label=lbl,key=(kb and kb.value)and KeyLabel(kb.value)or"",ra=item._hkA}
end
end
local rowsH=0
for _,r in ipairs(rows)do rowsH=rowsH+r.ra end
State.hkFade=Approach(State.hkFade or 0,1,14)
local a=State.hkFade
if a<0.02 then return click end
local w,rowH=180,20
local h=30+(#rows==0 and 0 or rowsH*rowH)+6
State.hkPos=State.hkPos or{x=18,y=90}
if held and State.hkDrag then
State.hkDrag.tx=State.mouseX-State.hkDrag.ox
State.hkDrag.ty=State.mouseY-State.hkDrag.oy
end
if State.hkDrag and State.hkDrag.tx then
State.hkPos.x=Approach(State.hkPos.x,State.hkDrag.tx,28)
State.hkPos.y=Approach(State.hkPos.y,State.hkDrag.ty,28)
end
local hvw,hvh=ScreenSize()
State.hkPos.x=Clamp(State.hkPos.x,0,max(0,hvw-w))
State.hkPos.y=Clamp(State.hkPos.y,0,max(0,hvh-h))
local x,y=State.hkPos.x,State.hkPos.y
DrawRect(x,y,w,h,Theme.bg,150,8,0.92*a)
DrawStroke(x,y,w,h,WHITE,151,8,Alpha.CardStroke*a)
DrawText("keybinds",x+12,y+9,WHITE,12,FontBold,152,false,false,w-24,Alpha.Text*a)
DrawGradient(x+10,y+26,w-20,2,Theme.accentA,Theme.accentB,152,0.9*a)
local yc=y+30
for _,r in ipairs(rows)do
local rA=r.ra*a
local slide=(1-r.ra)*12
local ry=yc
DrawCircle(x+14+slide,ry+rowH/2,2.5,Theme.accentA,152,true,1,10,rA)
DrawText(r.label,x+22+slide,TextTop(ry,rowH,12),WHITE,12,FontSystem,152,false,false,w-92,Alpha.Text*rA)
local kt=r.key
local ktw=max(18,TextWidth(kt,11,FontMono)+12)
local kx=x+w-10-ktw+slide
DrawRect(kx,ry+2,ktw,rowH-4,WHITE,152,4,Alpha.Field*rA)
DrawTextMid(kt,kx+ktw/2,ry+rowH/2,WHITE,11,FontMono,153,Alpha.Text*rA)
yc=yc+rowH*r.ra
end
if click and not State.hkDrag and IsMouseIn(x,y,w,28)then
State.hkDrag={ox=State.mouseX-x,oy=State.mouseY-y};click=false
end
return click
end
local function FuzzyScore(q,lab)
local ql,ll=#q,#lab
if ql==0 then return 0 end
local qi,li,first,prev,gaps=1,1,nil,0,0
while qi<=ql and li<=ll do
if string.sub(q,qi,qi)==string.sub(lab,li,li)then
if not first then first=li elseif li-prev>1 then gaps=gaps+1 end
prev=li;qi=qi+1
end
li=li+1
end
if qi<=ql then return nil end
local wordStart=(first==1 or string.sub(lab,first-1,first-1)==" ")and-1 or 0
return(first-1)+gaps*4+wordStart
end
local function SearchResults(q)
q=string.lower(q or"")
local out={}
for ti,tab in ipairs(State.tabs)do
for _,sec in ipairs(tab.sections)do
for _,item in ipairs(sec.items)do
if item.label and item.type~="divider"and item.type~="label"then
local score=(q=="")and 0 or FuzzyScore(q,string.lower(item.label))
if score then
out[#out+1]={tab=tab,ti=ti,item=item,label=item.label,
sub=tab.name.."  >  "..sec.name,type=item.type,score=score}
end
end
end
end
end
table.sort(out,function(a,b)if a.score~=b.score then return a.score<b.score end return a.label<b.label end)
return out
end
local function JumpToResult(r)
if not r then return end
if State.activeTab~=r.tab then State.activeTab=r.tab;State.activeIndex=r.ti;State.contentFade=0 end
State.minimized=false
SetOpen(true)
r.item._flash=(Clock())+1.3
State._spotScrollTo=r.item
State.spotlightOpen=false
end
local function DrawSearch(click)
local sp=State.spotlight
if not sp then sp={query="",sel=1};State.spotlight=sp end
State.spotlightFade=Approach(State.spotlightFade or 0,State.spotlightOpen and 1 or 0,16)
local a=State.spotlightFade
if a<0.02 then return click end
if State.spotlightOpen then
if Input.esc.click then State.spotlightOpen=false;Input.esc.click=false end
if EditText(sp,"query",false)then sp.sel=1 end
end
if sp.query~=sp._resQ then sp._resQ=sp.query;sp._results=SearchResults(sp.query)end
local results=sp._results
sp.sel=Clamp(sp.sel or 1,1,max(1,#results))
if State.spotlightOpen then
if Input.down.click then sp.sel=min(#results,sp.sel+1);Input.down.click=false end
if Input.up.click then sp.sel=max(1,sp.sel-1);Input.up.click=false end
if Input.enter.click then JumpToResult(results[sp.sel]);Input.enter.click=false;return click end
end
local vw,vh=ScreenSize()
local W,rowH,maxRows=470,34,7
local shown=min(#results,maxRows)
local H=50+(shown>0 and(shown*rowH+8)or 30)
local X,Y=floor((vw-W)/2),floor(vh*0.16)
DrawRect(0,0,vw,vh,c3(0,0,0),398,0,0.4*a)
DrawRect(X,Y,W,H,Theme.bg,400,12,0.97*a)
DrawStroke(X,Y,W,H,WHITE,401,12,Alpha.CardStroke*a)
DrawCircle(X+24,Y+21,6,WHITE,402,false,1.5,16,Alpha.Label*a)
DrawLine(X+28,Y+25,X+33,Y+30,WHITE,402,1.5,Alpha.Label*a)
DrawGradient(X+14,Y+46,W-28,2,Theme.accentA,Theme.accentB,402,0.7*a)
local qx=X+44
if sp.query==""and not State.spotlightOpen then
DrawText("Search widgets...",qx,TextTop(Y,46,15),WHITE,15,FontSystem,402,false,false,W-60,0.3*a)
else
DrawEditable(sp,sp.query,qx,TextTop(Y,46,15),15,WHITE,Alpha.Text*a,402,W-60,State.spotlightOpen,sp.caret,sp.selA)
end
if State.spotlightOpen then
if click and IsMouseIn(X+36,Y,W-50,46)then
sp.caret=CaretAtX(sp,sp.query,State.mouseX);sp.selA=sp.caret
State.spTextDrag=true;click=false
end
if Input.m1.held and State.spTextDrag then sp.caret=CaretAtX(sp,sp.query,State.mouseX)end
end
if#results==0 then
DrawText("no matches",X+18,Y+62,WHITE,13,FontSystem,402,false,false,W-36,Alpha.Dim*a)
end
local accentMid=State._accentMid
local maxOff=max(0,#results-maxRows)
sp._off=Clamp(sp._off or 0,0,maxOff)
if sp.sel-1<sp._off then sp._off=sp.sel-1 end
if sp.sel-1>sp._off+maxRows-1 then sp._off=sp.sel-maxRows end
sp._off=Clamp(sp._off,0,maxOff)
sp._sy=Approach(sp._sy or sp._off,sp._off,16)
local sy=sp._sy
local areaTop,areaH=Y+50,maxRows*rowH
local scrollable=#results>maxRows
local rowW=scrollable and(W-24)or(W-16)
local mouseMoved=State.mouseX~=sp._mx or State.mouseY~=sp._my
sp._mx,sp._my=State.mouseX,State.mouseY
for off=0,maxRows do
local ai=floor(sy)+off
local r=(ai>=0)and results[ai+1]or nil
if r then
local ry=areaTop+(ai-sy)*rowH
if ry+rowH>areaTop and ry<areaTop+areaH then
local edgeA=Clamp((ry+rowH-areaTop)/rowH,0,1)*Clamp((areaTop+areaH-ry)/rowH,0,1)
local ra=a*edgeA
local inside=ry>=areaTop-2 and ry+rowH<=areaTop+areaH+2
local hov=inside and IsMouseIn(X+8,ry,rowW,rowH)
if hov and mouseMoved and not sp._sbDrag then sp.sel=ai+1 end
local selOn=(ai+1==sp.sel)
DrawRect(X+8,ry+1,rowW,rowH-2,accentMid,401,8,(selOn and 0.1 or 0)*ra)
DrawRect(X+8,ry+1,3,rowH-2,accentMid,402,1.5,(selOn and 0.9 or 0)*ra)
DrawText(r.label,X+18,ry+6,WHITE,14,FontBold,402,false,false,W-150,Alpha.Text*ra)
DrawText(r.sub,X+18,ry+19,WHITE,11,FontSystem,402,false,false,W-150,Alpha.Dim*ra)
DrawText(r.type,X+rowW-4-TextWidth(r.type,11,FontSystem),TextTop(ry,rowH,11),WHITE,11,FontSystem,402,false,false,nil,Alpha.Dim*ra)
if inside and click and hov then JumpToResult(r);click=false end
end
end
end
if sp._sbDrag and not Input.m1.held then sp._sbDrag=nil end
if maxOff>0 then
local sbX=X+W-7
local thumbH=max(22,areaH*maxRows/#results)
local sfr=sp._off/maxOff
local thumbY=areaTop+(areaH-thumbH)*sfr
DrawRect(sbX,areaTop,3,areaH,WHITE,403,2,0.05*a)
local sbHot=IsMouseIn(sbX-6,areaTop,12,areaH)or sp._sbDrag
sp._sbHf=Approach(sp._sbHf or 0,sbHot and 1 or 0,14)
if abs(sp._sbHf-(sbHot and 1 or 0))<0.004 then sp._sbHf=sbHot and 1 or 0 end
local sCol=LerpColor(Theme.accentA,Theme.accentB,sfr)
DrawRect(sbX-1.5,thumbY-2,7,thumbH+4,sCol,404,3.5,0.18*sp._sbHf*a)
DrawRect(sbX,thumbY,4,thumbH,LerpColor(WHITE,sCol,0.75),404,2,(0.25+0.45*sp._sbHf)*a)
if click and IsMouseIn(sbX-6,areaTop,12,areaH)then sp._sbDrag=true;click=false end
if sp._sbDrag and Input.m1.held then
local frac=Clamp((State.mouseY-areaTop-thumbH/2)/max(1,areaH-thumbH),0,1)
sp._off=Clamp(Round(frac*maxOff),0,maxOff)
sp.sel=Clamp(sp.sel,sp._off+1,sp._off+maxRows)
end
end
if click and not IsMouseIn(X,Y,W,H)then State.spotlightOpen=false;click=false end
return click
end
local function DrawBoxes(click,held)
local boxes=State.boxes
if not boxes or#boxes==0 then return click end
local interactive=State.open
for _,box in ipairs(boxes)do
if box.visible~=false and box.alive~=false then
local accentMid=State._accentMid
local lines={}
local maxW=TextWidth(box.title or"Box",12,FontBold)+30
for _,ln in ipairs(box.lines)do
local kind=ln.kind or"text"
if kind=="stat"then
local v=ln.value;if type(v)=="function"then local ok,r=pcall(v);v=ok and r or""end
v=tostring(v==nil and""or v)
if v~=""then
local lbl,val=v:match("^(.-)%s+|%s+(.+)$")
if not lbl then lbl,val=v:match("^(.-):%s+(.+)$")end
if not lbl then lbl,val="",v end
lines[#lines+1]={kind="stat",label=lbl,text=val,color=ln.color}
maxW=max(maxW,TextWidth(lbl,12,FontSystem)+TextWidth(val,12,FontMono)+70)
end
elseif kind=="bar"then
local v=ln.value;if type(v)=="function"then local ok,r=pcall(v);v=ok and r or nil end
if v~=nil then
local nv=tonumber(v)or 0
local pct=(nv>0 and nv<=1)and nv*100 or nv
lines[#lines+1]={kind="bar",pct=Clamp(pct,0,100),color=ln.color}
maxW=max(maxW,170)
end
else
local t=ln.value;if type(t)=="function"then local ok,r=pcall(t);t=ok and r or""end
t=tostring(t==nil and""or t)
lines[#lines+1]={kind="text",text=t,color=ln.color}
maxW=max(maxW,TextWidth(t,12,FontSystem)+24)
end
end
local titleH,lineH=26,18
local w=box.width or max(140,maxW)
local h=titleH+#lines*lineH+(#lines>0 and 8 or 4)
box.x=box.x or 20;box.y=box.y or 140
if box._drag and not held then box._drag=nil end
if interactive and held and box._drag then
box._drag.tx=State.mouseX-box._drag.ox;box._drag.ty=State.mouseY-box._drag.oy
end
if box._drag and box._drag.tx then
box.x=Approach(box.x,box._drag.tx,28);box.y=Approach(box.y,box._drag.ty,28)
end
local x,y=box.x,box.y
DrawRect(x,y,w,h,Theme.bg,160,8,0.92)
DrawStroke(x,y,w,h,WHITE,161,8,Alpha.CardStroke)
DrawCircle(x+15,y+titleH/2,2.5,Theme.accentA,162,true,1,10,1)
DrawText(box.title or"Box",x+24,TextTop(y,titleH,12),WHITE,12,FontBold,162,false,false,w-34,Alpha.Text)
DrawGradient(x+10,y+titleH-1,w-20,1.5,Theme.accentA,Theme.accentB,162,0.7)
for i,ln in ipairs(lines)do
local ry=y+titleH+5+(i-1)*lineH
if ln.kind=="stat"then
local up=string.upper(ln.text)
local ready=up:find("READY")or up:find("FARMING")or up:find("GO",1,true)
local idle=up:find("PAUSED")or up:find("WAIT")or up:find("IDLE")or up:find("OFF",1,true)or up:find("SOON")or up=="--"or up:match("^%d+:%d")
local dotCol=ready and accentMid or(idle and c3(120,122,130)or c3(195,197,205))
local dotA=ready and(0.5+0.42*sin((Clock())*5))or(idle and 0.7 or 0.85)
DrawCircle(x+16,ry+7,3,dotCol,163,true,1,12,dotA)
DrawText(ln.label,x+28,ry,WHITE,12,FontSystem,162,false,false,w-110,Alpha.Label)
DrawText(ln.text,x+w-12-TextWidth(ln.text,12,FontMono),ry,ln.color or WHITE,12,FontMono,162,false,false,nil,ready and Alpha.Text or Alpha.Label)
elseif ln.kind=="bar"then
DrawRect(x+14,ry+5,w-28,6,WHITE,162,3,Alpha.Field)
if ln.pct>0 then DrawRect(x+14,ry+5,max(6,(w-28)*ln.pct/100),6,Theme.accentA,163,3,0.95)end
else
DrawText(ln.text,x+14,ry,ln.color or WHITE,12,FontSystem,162,false,false,w-24,Alpha.Label)
end
end
if interactive and click and not box._drag and IsMouseIn(x,y,w,titleH)then
box._drag={ox=State.mouseX-x,oy=State.mouseY-y};click=false
end
end
end
return click
end
local function DrawMenuBars(cx,cy,sz,color,alpha,z)
local lw,lh,sp=sz*0.62,sz*0.1375,sz*0.275
local lx=cx-lw/2
DrawRect(lx,cy-sp-lh/2,lw,lh,color,z,lh/2,alpha)
DrawRect(lx,cy-lh/2,lw,lh,color,z,lh/2,alpha)
DrawRect(lx,cy+sp-lh/2,lw,lh,color,z,lh/2,alpha)
end
local function DrawBubble(click,held)
State.minA=Approach(State.minA or 0,State.minimized and 1 or 0,11)
local a=State.minA*State.drawVisible
if a<0.02 then return click end
State.minPos=State.minPos or{x=24,y=24}
local d=State.minBubbleDrag
if d then
if held then
d.tx=State.mouseX-d.ox;d.ty=State.mouseY-d.oy
if math.abs(State.mouseX-d.downX)+math.abs(State.mouseY-d.downY)>4 then d.moved=true end
State.minPos.x=Approach(State.minPos.x,d.tx,28)
State.minPos.y=Approach(State.minPos.y,d.ty,28)
local bvw,bvh=ScreenSize()
State.minPos.x=Clamp(State.minPos.x,0,max(0,bvw-42))
State.minPos.y=Clamp(State.minPos.y,0,max(0,bvh-42))
else
if not d.moved then
State.x=State.minPos.x
State.y=State.minPos.y
ClampWindow()
State.minimized=false
end
State.minBubbleDrag=nil
end
end
local dv=State.drawVisible
local t=State.minA
local et=t*t*(3-2*t)
local bs=42
local wx,wy,ww,wh=State.x,State.y,State.w,State.h
local bx,by=State.minPos.x,State.minPos.y
local rx=wx+(bx-wx)*et
local ry=wy+(by-wy)*et
local rw=ww+(bs-ww)*et
local rh=wh+(bs-wh)*et
local rad=10+et
local cx,cy=rx+rw/2,ry+rh/2
local accentMid=State._accentMid
local settled=State.minA>0.9
local hov=settled and IsMouseIn(rx,ry,rw,rh)
State._minHov=Approach(State._minHov or 0,hov and 1 or 0,12)
local hh=State._minHov
for i=1,3 do local o=i*3;DrawRect(rx-o,ry-o+2,rw+o*2,rh+o*2,c3(0,0,0),199,rad+o,(0.10-i*0.025)*et*dv)end
DrawRect(rx-3,ry-3,rw+6,rh+6,accentMid,200,rad+2,0.25*hh*dv)
DrawRect(rx,ry,rw,rh,LerpColor(Theme.bg,accentMid,et),201,rad,(0.96-0.04*et)*dv)
DrawRect(rx,ry,rw,rh*0.5,LerpColor(accentMid,WHITE,0.14),202,rad,0.22*et*dv)
DrawStroke(rx,ry,rw,rh,WHITE,203,rad,(0.16+0.14*et+0.35*hh)*dv)
if et>0.4 then
local bubA=Clamp((et-0.4)/0.6,0,1)*dv
if State.iconImg then
local ls=rw-8 State.iconImg.Position=v2(cx-ls/2,cy-ls/2);State.iconImg.Size=v2(ls,ls)pcall(function()State.iconImg.Rounding=rad end)State.iconImg.ZIndex=2049999;State.iconImg.Transparency=bubA;State.iconImg.Visible=bubA>0.01
else
DrawMenuBars(cx,cy,rh,c3(36,38,50),bubA,204)
end
end
if settled and click and hov and not State.minBubbleDrag then
State.minBubbleDrag={ox=State.mouseX-rx,oy=State.mouseY-ry,downX=State.mouseX,downY=State.mouseY,moved=false}
click=false
end
return click
end
local function DrawBar(x1,y1,x2,y2,thick,color,z,alpha)
local dx,dy=x2-x1,y2-y1
local len=sqrt(dx*dx+dy*dy)
if len<0.001 then return end
local px,py=-dy/len*thick/2,dx/len*thick/2
local p1,p2=v2(x1+px,y1+py),v2(x1-px,y1-py)
local p3,p4=v2(x2-px,y2-py),v2(x2+px,y2+py)
DrawTri(p1,p2,p3,color,z,true,alpha)
DrawTri(p1,p3,p4,color,z,true,alpha)
end
local function ItemHeight(item)
local t=item.type
if t=="slider"or t=="rangeslider"then return 38
elseif t=="dropdown"then return State.dropdownInline and 26 or 44
elseif t=="textbox"then return 44
elseif t=="checkbox"then return 30
elseif t=="colorpicker"then return 26
elseif t=="label"then return max(18,(item.cachedLineCount or 1)*16+2)
elseif t=="info"then return max(16,(item.cachedLineCount or 1)*15+2)
elseif t=="button"then return 26
elseif t=="keybind"then return 30
elseif t=="image"then return(item.imgHeight or 80)+6
elseif t=="divider"then return 18
end
return 28
end
local function WantTooltip(text,x,y)
if not text or text==""then return end
State.tooltipText=text
State.tooltipX=x;State.tooltipY=y
if State.lastTooltipText~=text then State.tooltipAt=Clock()end
end
local DrawWidget
do
local W={}
local function wrapBlock(item,rowX,rowY,rowW,size,step,alpha,trans)
local f=ResolveFont(FontSystem)
if item._wrapW~=rowW or item._wrapTxt~=item.label or item._wrapF~=f then
item._wrapW,item._wrapTxt,item._wrapF=rowW,item.label,f
local all={}
for seg in(item.label.."\n"):gmatch("(.-)\n")do
if seg==""then
all[#all+1]=""
else
for _,ln in ipairs(WrapText(seg,rowW,size,f))do all[#all+1]=ln end
end
end
item._wrapLines=all
item.cachedLineCount=max(1,#all)
end
local col,a=item.color or WHITE,alpha*trans
local lines=item._wrapLines
for i=1,#lines do
DrawText(lines[i],rowX,rowY+(i-1)*step,col,size,FontSystem,31,false,false,nil,a)
end
end
local function swatch(x,y,sz,radius,color,alpha,hov,trans)
DrawRect(x,y,sz,sz,c3(40,40,40),30,radius,trans)
DrawRect(x,y,sz,sz,color,31,radius,trans*(alpha or 1))
DrawStroke(x,y,sz,sz,WHITE,32,radius,(hov and 0.4 or Alpha.Hairline)*trans)
end
local function chipW(kb,minW,pad)
return max(minW,TextWidth(kb.listening and"..."or KeyLabel(kb.value),13,FontMono)+pad)
end
local function keyChip(kb,x,rowY,w,radius,trans,hov,plain)
local y=rowY+3
if kb.listening then
DrawRect(x-1,rowY+2,w+2,22,Theme.accentB,30,radius+1,0.18*trans)
DrawRect(x,y,w,20,State._accentMid,31,radius,0.6*trans)
DrawStroke(x,y,w,20,Theme.accentB,32,radius,0.85*trans)
else
DrawRect(x,y,w,20,WHITE,31,radius,(Alpha.Field+0.05*kb._hov)*trans)
DrawStroke(x,y,w,20,Theme.accentA,32,radius,0.45*kb._hov*trans)
if plain then
DrawStroke(x,y,w,20,WHITE,32,radius,Alpha.Hairline*trans)
else
local mode=NormalMode(kb.mode)
local col=(mode=="Always"and Theme.accentB)or(mode=="Toggle"and Theme.accentA)or WHITE
DrawStroke(x,y,w,20,col,32,radius,(mode=="Hold"and Alpha.Hairline or 0.55)*trans)
end
end
local a=kb.listening and Alpha.Text or(hov and Alpha.Hover or Alpha.Dim)
DrawTextMid(kb.listening and"..."or KeyLabel(kb.value),x+w/2+0.37,rowY+13,WHITE,13,FontMono,33,a*trans)
end
function W.label(item,rowX,rowY,rowW,trans)
if item.labelFn then
local ok,v=pcall(item.labelFn)
if ok and v~=nil then item.label=tostring(v)end
end
wrapBlock(item,rowX,rowY,rowW,13,16,0.7,trans)
end
function W.info(item,rowX,rowY,rowW,trans)
wrapBlock(item,rowX,rowY,rowW,12,15,Alpha.Dim,trans)
end
function W.divider(item,rowX,rowY,rowW,trans)
local gc=LerpColor(Theme.accentA,Theme.accentB,0.5)
local y=rowY+8
if item.label then
local cx=rowX+rowW/2
local half=TextWidth(item.label,12,FontSystem)/2+8
State.fadeLine(rowX,y,(cx-half)-rowX,gc,30,0.45*trans,true)
DrawTextMid(item.label,cx,y,WHITE,12,FontSystem,31,Alpha.Dim*trans)
State.fadeLine(cx+half,y,(rowX+rowW)-(cx+half),gc,30,0.45*trans)
else
local half=rowW/2
State.fadeLine(rowX,y,half,gc,30,0.40*trans,true)
State.fadeLine(rowX+half,y,half,gc,30,0.40*trans)
end
end
function W.button(item,rowX,rowY,rowW,trans,click,rightClick,interact)
local btns=item.buttons or{{label=item.label,callback=item.callback}}
local n,gap,bh=#btns,8,22
local bw=(rowW-gap*(n-1))/n
local col=item.color or WHITE
for i,b in ipairs(btns)do
local bx=rowX+(i-1)*(bw+gap)
local hov=interact and IsMouseIn(bx,rowY,bw,bh)
b._hf=Approach(b._hf or 0,hov and 1 or 0,16)
local hf=b._hf
DrawRect(bx,rowY,bw,bh,WHITE,30,5,(Alpha.Field+0.06*hf)*trans)
DrawStroke(bx,rowY,bw,bh,WHITE,31,5,(Alpha.Hairline+0.22*hf)*trans)
DrawTextMid(b.label,bx+bw/2,rowY+bh/2,col,13,FontSystem,32,(Alpha.Label+(Alpha.Hover-Alpha.Label)*hf)*trans)
if item.tooltip and i==1 and hov then WantTooltip(item.tooltip,State.mouseX,State.mouseY)end
if click and hov then Invoke(b.callback);click=false end
end
return click,rightClick
end
local function drawCheck(item,rowX,rowY,rowW,trans,interact,onCol,on)
local bs=Layout.CheckboxSize
local px,py=rowX+rowW-bs,rowY+4
local cx,cy=px+bs/2,py+bs/2
local hov=(interact and IsMouseIn(px,py,bs,bs))or false
local hv1=hov and 1 or 0
local pr1=(hov and Input.m1.held)and 1 or 0
item.animState=Approach(item.animState or on,on,item.value and 13 or 15)
item.cbG=Approach(item.cbG or on,on,34)
item.cbHv=Approach(item.cbHv or 0,hv1,12)
item.cbPr=Approach(item.cbPr or 0,pr1,22)
if item.cbLast==nil then item.cbLast=item.value end
if item.value~=item.cbLast then item.cbFl=1;item.cbLast=item.value end
item.cbFl=Approach(item.cbFl or 0,0,22)
if abs(item.animState-on)<0.0005 then item.animState=on end
if abs(item.cbG-on)<0.0005 then item.cbG=on end
if abs(item.cbHv-hv1)<0.002 then item.cbHv=hv1 end
if abs(item.cbPr-pr1)<0.002 then item.cbPr=pr1 end
if item.cbFl<0.002 then item.cbFl=0 end
local u,g,fl=item.animState,item.cbG,item.cbFl
local shape=u*u*(3-2*u)+1.70658*u*u*u*(1-u)*g*on
local sc=min(1,shape)
local ov=Clamp((shape-1)/0.1,0,1)
local mo=4*u*(1-u)
local str=0.24*mo*mo*(2*g-1)
local s=(2+10*shape)*(1-0.06*item.cbPr)
local wF=min(s*(1+str),15.2)
local hF=min(s*(1-0.85*str),15.2)
local rr=min(min(wF,hF)/2,3+2*(1-sc))
local hE=max(mo,ov)
local hw=min(wF*(1+0.1*hE),15.4)
local hh=min(hF*(1+0.1*hE),15.4)
local deepCol=LerpColor(onCol,Theme.bg,0.5)
local hotCol=LerpColor(onCol,WHITE,0.55)
local fa=min(1,shape*3)
local fw,fh=wF*(0.36+0.6*fl),hF*(0.36+0.6*fl)
local mx=max(wF,hF)
local fs=min(17,mx+3.6*(1-ov))
DrawRect(px,py,bs,bs,LerpColor(Theme.trackOff,deepCol,0.55*sc),30,5,(0.5+0.12*item.cbHv)*trans)
DrawRect(cx-hw/2,cy-hh/2,hw,hh,LerpColor(onCol,WHITE,0.35),31,min(min(hw,hh)/2,rr+1.2),0.3*hE*fa*trans)
DrawRect(cx-wF/2,cy-hF/2,wF,hF,LerpColor(LerpColor(deepCol,onCol,min(1,shape*1.25)),hotCol,min(1,0.55*fl+0.35*mo)),32,rr,fa*trans)
DrawRect(cx-fw/2,cy-fh/2,fw,fh,WHITE,33,min(fw,fh)/2*(1-0.45*fl),0.78*fl*fl*trans)
DrawStroke(px+(bs-fs)/2,py+(bs-fs)/2,fs,fs,hotCol,34,min(fs/2,rr+(fs-mx)/2),0.5*ov*trans)
DrawStroke(px,py,bs,bs,LerpColor(WHITE,onCol,min(1,0.9*sc+0.35*fl)),35,5,(Alpha.Hairline+0.5*max(sc,item.cbHv))*trans)
return px
end
local function drawSwitch(item,rowX,rowY,rowW,trans,onCol,on)
local pw,ph=Layout.SwitchWidth,Layout.SwitchHeight
local px,py=rowX+rowW-pw,rowY+3
item.animState=Approach(item.animState or on,on,16)
DrawRect(px,py,pw,ph,LerpColor(Theme.trackOff,onCol,item.animState),30,6,trans)
DrawRect(px+3+(pw-20)*item.animState,py+3,14,14,WHITE,32,4,trans)
return px
end
function W.checkbox(item,rowX,rowY,rowW,trans,click,rightClick,interact)
local onCol=item.risk and(Theme.unsafe or c3(255,190,70))or State._accentMid
local on=item.value and 1 or 0
local px=State.checkboxStyle and drawCheck(item,rowX,rowY,rowW,trans,interact,onCol,on)
or drawSwitch(item,rowX,rowY,rowW,trans,onCol,on)
local rightX=px-8
local onColor,onKey=false,false
local mx,my=State.mouseX,State.mouseY
local cp=item.colorpicker
if cp then
rightX=rightX-14
onColor=interact and IsMouseIn(rightX,rowY+6,14,14)
swatch(rightX,rowY+6,14,5,cp.value,cp.alpha,onColor,trans)
rightX=rightX-8
if click and onColor then OpenColorpicker(mx+12,my-80,cp);click=false end
end
local kb=item.keybind
if kb then
local w=chipW(kb,28,14)
rightX=rightX-w
onKey=interact and IsMouseIn(rightX,rowY+3,w,20)
kb._hov=Approach(kb._hov or 0,(onKey or kb.listening)and 1 or 0,14)
keyChip(kb,rightX,rowY,w,5,trans,onKey,false)
rightX=rightX-8
if onKey and not kb.listening then
WantTooltip("click rebind (any key / mouse)  \194\183  right-click mode",mx,my)
end
if click and onKey then kb.listening=true;click=false;Input.m1.click=false end
if rightClick and onKey and not kb.listening then
State.keyMenu={kb=kb,x=mx,y=my,anim=0}
State.dropdown=nil
State.colorpicker=nil
rightClick=false
end
end
DrawText(item.label,rowX,TextTop(rowY,26,13),WHITE,13,FontSystem,31,false,false,rightX-rowX-4,Alpha.Label*trans)
local onRow=interact and IsMouseIn(rowX,rowY,rowW,26)
if item.tooltip and onRow then WantTooltip(item.tooltip,mx,my)end
if click and onRow and not onColor and not onKey then
SetItemValue(item,not item.value,true)
click=false
end
return click,rightClick
end
function W.keybind(item,rowX,rowY,rowW,trans,click,rightClick,interact)
local w=chipW(item,40,16)
local kx=rowX+rowW-w
local hov=interact and IsMouseIn(kx,rowY+3,w,20)
item._hov=Approach(item._hov or 0,(hov or item.listening)and 1 or 0,14)
DrawText(item.label,rowX,TextTop(rowY,26,13),WHITE,13,FontSystem,31,false,false,kx-rowX-6,Alpha.Label*trans)
keyChip(item,kx,rowY,w,4,trans,hov,true)
if item.tooltip and interact and IsMouseIn(rowX,rowY,rowW,26)then
WantTooltip(item.tooltip,State.mouseX,State.mouseY)
end
if click and hov then
item.listening=true
State.kbCapture=item
click=false
Input.m1.click=false
end
return click,rightClick
end
function W.image(item,rowX,rowY,rowW,trans)
local ih=item.imgHeight or 80
local iw=min(item.imgWidth or rowW,rowW)
local ix=rowX+(rowW-iw)/2
if not item.imageData then
DrawRect(ix,rowY,iw,ih,WHITE,30,6,Alpha.Field*trans)
DrawStroke(ix,rowY,iw,ih,WHITE,31,6,Alpha.Hairline*trans)
return
end
if not item._img then
item._img=Drawing.new("Image")
item._img.Data=item.imageData
end
DrawImage(item._img,ix,rowY,iw,ih,329999,trans,item.rounding or 6)
end
function W.colorpicker(item,rowX,rowY,rowW,trans,click,rightClick,interact)
DrawText(item.label,rowX,TextTop(rowY,24,13),WHITE,13,FontSystem,31,false,false,rowW-24,Alpha.Label*trans)
local sx,sy=rowX+rowW-Layout.SwatchSize,rowY+5
local hov=interact and IsMouseIn(sx,sy,16,16)
swatch(sx,sy,16,6,item.value,item.alpha,hov,trans)
if click and hov then
OpenColorpicker(State.mouseX+12,State.mouseY-80,item)
click=false
end
return click,rightClick
end
function W.slider(item,rowX,rowY,rowW,trans,click,rightClick,interact)
DrawText(item.label,rowX,TextTop(rowY,16,13),WHITE,13,FontSystem,31,false,false,rowW-60,Alpha.Label*trans)
if item._dispVal~=item.value then
item._dispVal=item.value
local v=item.value
local s=(v==floor(v))and tostring(floor(v))or(string.format("%.8f",v):gsub("0+$",""):gsub("%.$",""))
item._dispStr=s..(item.suffix~=""and(" "..item.suffix)or"")
end
local focused=State.focus==item
local disp=focused and(item.directValue or"")or item._dispStr
local vbW=max(40,(focused and(#disp*EditCharWidth(12))or TextWidth(disp,12,FontSystem))+16)
local vbX=rowX+rowW-vbW
local vbTop=TextTop(rowY,18,12)
local mx=State.mouseX
DrawRect(vbX,rowY,vbW,18,WHITE,30,3,Alpha.Field*trans)
DrawStroke(vbX,rowY,vbW,18,WHITE,31,3,(focused and 0.4 or Alpha.Hairline)*trans)
if focused then
DrawEditable(item,item.directValue or"",vbX+7,vbTop,12,WHITE,Alpha.Text*trans,32,vbW-12,true,item.caret,item.selA)
else
DrawText(disp,vbX+vbW/2,vbTop,WHITE,12,FontSystem,32,true,false,vbW-8,Alpha.Dim*trans)
end
if click and interact and IsMouseIn(vbX,rowY,vbW,18)then
if State.focus~=item then item.directValue=tostring(item.value)end
State.focus=item
item._ex,item._ecw,item._es=vbX+7,EditCharWidth(12),0
item.caret=CaretAtX(item,item.directValue or"",mx)
item.selA=item.caret
State.textDrag=item
item._dragDownX=mx
click=false
end
if Input.m1.held and State.textDrag==item and abs(mx-(item._dragDownX or mx))>3 then
item.caret=CaretAtX(item,item.directValue or"",mx)
end
local sy=rowY+26
local frac=(item.max~=item.min)and Clamp((item.value-item.min)/(item.max-item.min),0,1)or 0
item._fillFrac=Approach(item._fillFrac or frac,frac,20)
local f=item._fillFrac
local knobX=rowX+rowW*f
local onKnob=interact and IsMouseIn(knobX-9,sy-5,18,18)
DrawRect(rowX,sy,rowW,8,Theme.sliderTrack,30,4,trans)
if f>0.001 then DrawRect(rowX,sy,max(8,rowW*f),8,LerpColor(Theme.accentA,Theme.accentB,f),31,4,trans)end
item.animatedRadius=Approach(item.animatedRadius or 6,(onKnob or State.sliderDrag==item)and 9 or 6,16)
DrawCircle(knobX,sy+4,item.animatedRadius,WHITE,32,true,1,24,trans)
local onBar=interact and IsMouseIn(rowX-4,sy-8,rowW+8,16)
if click and onBar and not IsMouseIn(vbX,rowY,vbW,18)then
State.sliderDrag=item
click=false
end
if rightClick and onBar and item.default~=nil then
SetItemValue(item,item.default,true)
rightClick=false
end
if Input.m1.held and State.sliderDrag==item then
local sn=SnapValue(item.min+(item.max-item.min)*Clamp((mx-rowX)/rowW,0,1),item)
if sn~=item.value then item.value=sn;Invoke(item.callback,sn)end
end
return click,rightClick
end
function W.rangeslider(item,rowX,rowY,rowW,trans,click,rightClick,interact)
DrawText(item.label,rowX,TextTop(rowY,16,13),WHITE,13,FontSystem,31,false,false,rowW-90,Alpha.Label*trans)
if item._rsLo~=item.valueLo or item._rsHi~=item.valueHi or item._rsSuf~=item.suffix then
item._rsLo,item._rsHi,item._rsSuf=item.valueLo,item.valueHi,item.suffix
item._rsDisp=tostring(item.valueLo).." - "..tostring(item.valueHi)..(item.suffix~=""and(" "..item.suffix)or"")
end
local disp=item._rsDisp
local vbW=max(54,TextWidth(disp,12,FontSystem)+16)
local vbX=rowX+rowW-vbW
DrawRect(vbX,rowY,vbW,18,WHITE,30,3,Alpha.Field*trans)
DrawStroke(vbX,rowY,vbW,18,WHITE,31,3,Alpha.Hairline*trans)
DrawText(disp,vbX+vbW/2,TextTop(rowY,18,12),WHITE,12,FontSystem,32,true,false,vbW-8,Alpha.Dim*trans)
local sy=rowY+26
local span=(item.max~=item.min)and(item.max-item.min)or 1
item._fLo=Approach(item._fLo or 0,Clamp((item.valueLo-item.min)/span,0,1),20)
item._fHi=Approach(item._fHi or 1,Clamp((item.valueHi-item.min)/span,0,1),20)
local xLo,xHi=rowX+rowW*item._fLo,rowX+rowW*item._fHi
local dragging=State.sliderDrag==item
local hovLo=interact and IsMouseIn(xLo-9,sy-5,18,18)
local hovHi=interact and IsMouseIn(xHi-9,sy-5,18,18)
DrawRect(rowX,sy,rowW,8,Theme.sliderTrack,30,4,trans)
if xHi-xLo>0.5 then
DrawRect(xLo,sy,max(8,xHi-xLo),8,LerpColor(Theme.accentA,Theme.accentB,(item._fLo+item._fHi)/2),31,4,trans)
end
item._rLo=Approach(item._rLo or 6,(hovLo or(dragging and item._drag=="lo"))and 9 or 6,16)
item._rHi=Approach(item._rHi or 6,(hovHi or(dragging and item._drag=="hi"))and 9 or 6,16)
DrawCircle(xLo,sy+4,item._rLo,WHITE,32,true,1,24,trans)
DrawCircle(xHi,sy+4,item._rHi,WHITE,32,true,1,24,trans)
local mx=State.mouseX
local onBar=interact and IsMouseIn(rowX-4,sy-8,rowW+8,16)
if click and onBar and not IsMouseIn(vbX,rowY,vbW,18)then
item._drag=(mx<(xLo+xHi)/2)and"lo"or"hi"
State.sliderDrag=item
click=false
end
if rightClick and onBar then
item.valueLo=item.defLo or item.min
item.valueHi=item.defHi or item.max
Invoke(item.callback,item.valueLo,item.valueHi)
rightClick=false
end
if Input.m1.held and dragging then
local sn=SnapValue(item.min+span*Clamp((mx-rowX)/rowW,0,1),item)
if item._drag=="lo"then
if sn>item.valueHi then sn=item.valueHi end
if sn~=item.valueLo then item.valueLo=sn;Invoke(item.callback,item.valueLo,item.valueHi)end
else
if sn<item.valueLo then sn=item.valueLo end
if sn~=item.valueHi then item.valueHi=sn;Invoke(item.callback,item.valueLo,item.valueHi)end
end
end
return click,rightClick
end
function W.dropdown(item,rowX,rowY,rowW,trans,click,rightClick,interact)
local inline=State.dropdownInline==true
local boxW=inline and max(110,floor(rowW*0.5))or rowW
local boxX=inline and(rowX+rowW-boxW)or rowX
local boxY=inline and rowY or(rowY+20)
if inline then
DrawText(item.label,rowX,TextTop(rowY,24,13),WHITE,13,FontSystem,31,false,false,boxX-rowX-8,Alpha.Label*trans)
else
DrawText(item.label,rowX,TextTop(rowY,16,13),WHITE,13,FontSystem,31,false,false,rowW,Alpha.Label*trans)
end
if item._ddDisp==nil or item._ddDispVer~=item._ddVer then
item._ddDispVer=item._ddVer
item._ddDisp=item.multi and(#item.value>0 and concat(item.value,", ")or"none")or(item.value[1]or"none")
end
local hov=interact and IsMouseIn(boxX,boxY,boxW,24)
DrawRect(boxX,boxY,boxW,24,WHITE,30,5,(Alpha.Field+0.02+(hov and 0.03 or 0))*trans)
DrawText(item._ddDisp,boxX+10,TextTop(boxY,24,13),WHITE,13,FontSystem,32,false,false,boxW-18,Alpha.Dim*trans)
if item._ddImg then PlaceImage(item._ddImg,item._ddIc,boxX+boxW-20,boxY+5,14,14,32,0,false)end
if item.tooltip and hov then WantTooltip(item.tooltip,State.mouseX,State.mouseY)end
if click and hov then
local dd=State.dropdown
if dd and dd.item==item and not dd.closing then
dd.closing=true
else
OpenDropdown(boxX,boxY+26,boxW,item)
end
click=false
end
return click,rightClick
end
function W.textbox(item,rowX,rowY,rowW,trans,click,rightClick,interact)
DrawText(item.label,rowX,TextTop(rowY,16,13),WHITE,13,FontSystem,31,false,false,rowW,Alpha.Label*trans)
local boxY=rowY+20
local top=TextTop(boxY,24,13)
local focused=State.focus==item
local hov=interact and IsMouseIn(rowX,boxY,rowW,24)
local val=item.value or""
local mx=State.mouseX
DrawRect(rowX,boxY,rowW,24,WHITE,30,4,Alpha.Field*trans)
DrawStroke(rowX,boxY,rowW,24,WHITE,31,4,(focused and 0.45 or(hov and 0.2 or Alpha.Hairline))*trans)
if val==""and not focused then
DrawText(item.label,rowX+10,top,WHITE,13,FontSystem,32,false,false,rowW-20,0.3*trans)
elseif focused then
DrawEditable(item,val,rowX+10,top,13,WHITE,Alpha.Text*trans,32,rowW-18,true,item.caret,item.selA)
else
DrawText(val,rowX+10,top,WHITE,13,FontSystem,32,false,false,rowW-18,Alpha.Text*trans)
end
if click and hov then
State.focus=item
item.caret=CaretAtX(item,val,mx)
item.selA=item.caret
State.textDrag=item
item._dragDownX=mx
click=false
end
if Input.m1.held and State.textDrag==item and abs(mx-(item._dragDownX or mx))>3 then
item.caret=CaretAtX(item,val,mx)
end
return click,rightClick
end
function DrawWidget(item,rowX,rowY,rowW,trans,click,rightClick,popupBlocking)
local draw=W[item.type]
if not draw then return click,rightClick end
local c,r=draw(item,rowX,rowY,rowW,trans,click,rightClick,(trans>0.5)and not popupBlocking)
if c==nil then return click,rightClick end
return c,r
end
end
local HEADER_H=17
local function SectionTitleHeight(s)
if not(s.name and s.name~="")then return 0 end
return HEADER_H+((s.desc and s.desc~="")and 13 or 0)
end
local DrawSectionCard
do
local function hideRowImg(it)
if it._img then it._img.Visible=false end
if it._ddImg then
it._ddImg.Visible=false
if it._ddIc then it._ddIc.vis=false end
end
end
local function drawTitle(section,colX,sy,colW,headerH,cf,click,popupBlocking,clipTop,clipBottom)
local a=cf*Clamp((sy+headerH-clipTop)/headerH,0,1)*Clamp((clipBottom-sy)/headerH,0,1)
if a<=0.01 then return click end
local acc=State._accentMid
if section._nameU~=section.name then
section._nameU=section.name
section._nameUpper=string.upper(section.name)
end
DrawText(section._nameUpper,colX+4,sy+2,acc,11,FontBold,31,false,false,colW-22,(section.collapsed and 0.55 or 0.85)*a)
if section.desc then
DrawText(section.desc,colX+4,sy+15,WHITE,10,FontSystem,31,false,false,colW-22,Alpha.Dim*0.72*a)
end
local lw=min(TextWidth(section._nameUpper,11,FontBold),colW-40)
local fx1=colX+4+lw+10
State.fadeLine(fx1,sy+8,(colX+colW-6)-fx1,acc,31,(section.collapsed and 0.18 or 0.30)*a)
if click and not popupBlocking and IsMouseIn(colX,sy,colW,headerH)then
section.collapsed=not section.collapsed
click=false
end
return click
end
local function drawCard(section,colX,drawY,colW,drawH,cf,popupBlocking)
local hov=(not popupBlocking)and IsMouseIn(colX,drawY,colW,drawH)
section._hovA=Approach(section._hovA or 0,(hov and State.hoverEffects~=false)and 1 or 0,6)
DrawRect(colX,drawY,colW,drawH,LerpColor(WHITE,c3(150,153,161),0.40),28,5,Alpha.Card*2.1*cf)
local ha=section._hovA*cf*(State.glowMul or 1)
local acc=State._accentMid
if not State.lite then
DrawStroke(colX-2,drawY-2,colW+4,drawH+4,acc,32,7,0.05*ha)
DrawStroke(colX-1,drawY-1,colW+2,drawH+2,acc,32,6,0.11*ha)
end
DrawStroke(colX,drawY,colW,drawH,acc,33,5,0.34*ha)
end
function DrawSectionCard(section,colX,sy,colW,secH,clipTop,clipBottom,click,rightClick,popupBlocking)
local stag=min((section._si or 1)-1,6)*0.06
local cf=Clamp((State.contentFade-stag)/(1-stag),0,1)*State.drawVisible
local headerH=SectionTitleHeight(section)
if headerH>0 then
click=drawTitle(section,colX,sy,colW,headerH,cf,click,popupBlocking,clipTop,clipBottom)
end
if(section._cA or 0)>0.98 then
for _,it in ipairs(section.items)do hideRowImg(it)end
return click,rightClick
end
local cardTop=sy+headerH
local drawY=max(cardTop,clipTop)
local drawH=min(sy+secH,clipBottom)-drawY
drawCard(section,colX,drawY,colW,drawH,cf,popupBlocking)
local rowX,rowW=colX+20,colW-38
local rowY=cardTop+11
local gap=State.rowLines and 4 or 6
local cardBottom=min(clipBottom,sy+secH)
local n=#section.items
for i,item in ipairs(section.items)do
local ih=ItemHeight(item)
if rowY+ih<clipTop-2 or rowY>cardBottom+2 then
hideRowImg(item)
else
local clipF=1
if rowY<clipTop then clipF=Clamp(1-(clipTop-rowY)/(ih*0.5),0,1)end
if rowY+ih>cardBottom then
clipF=min(clipF,Clamp(1-(rowY+ih-cardBottom)/(ih*0.5),0,1))
end
local trans=(IsItemLocked(item)and 0.4 or 1)*cf*clipF
click,rightClick=DrawWidget(item,rowX,rowY,rowW,trans,click,rightClick,popupBlocking)
local now=Clock()
local fa=(item._flash and item._flash>now)
and(0.35+0.5*Clamp(0.5+0.5*sin(now*9),0,1))or 0
DrawStroke(rowX-4,rowY-4,rowW+8,ih+8,State._accentMid,33,7,fa*trans)
if State.rowLines and i<n then
local ly=rowY+ih+gap/2
if ly>clipTop and ly<cardBottom then
DrawLine(colX+14,ly,colX+colW-14,lineY,WHITE,31,1,0.12*cf*clipF)
end
end
end
rowY=rowY+ih+(i<n and gap or 0)
end
return click,rightClick
end
end
local function SectionHeight(section)
section._cA=Approach(section._cA or(section.collapsed and 1 or 0),section.collapsed and 1 or 0,10)
local hdr=SectionTitleHeight(section)
local full=hdr+11+8
local n=#section.items
for i,item in ipairs(section.items)do full=full+ItemHeight(item)+(i<n and(State.rowLines and 4 or 6)or 0)end
return full+((hdr+6)-full)*section._cA
end
local DrawSections
do
local function contentHeight(tab,contH)
local leftEnd,rightEnd=0,0
for _,s in ipairs(tab.sections)do
s._h=SectionHeight(s)
if s.side=="Full"then
leftEnd=max(leftEnd,rightEnd)+s._h+10
rightEnd=leftEnd
elseif s.side=="Right"then
rightEnd=rightEnd+s._h+10
else
leftEnd=leftEnd+s._h+10
end
end
local total=max(leftEnd,rightEnd)
tab.maxScroll=max(0,total-contH)
return total
end
local function scrollInput(tab,px,contY,pw,contH,popupBlocking)
local maxScroll=tab.maxScroll
if State.mouseScroll~=0 and not popupBlocking and IsMouseIn(State.x,State.y,State.w,State.h)then
tab.targetScrollY=Clamp(tab.targetScrollY-(State.mouseScroll>0 and 1 or-1)*42,0,maxScroll)
end
if maxScroll>0 and not popupBlocking and not State.focus and not State.spotlightOpen and IsMouseIn(px,contY,pw,contH)then
local page=contH*0.8
if Input.up.click then tab.targetScrollY=max(0,tab.targetScrollY-60)end
if Input.down.click then tab.targetScrollY=min(maxScroll,tab.targetScrollY+60)end
if Input.pageup.click then tab.targetScrollY=max(0,tab.targetScrollY-page)end
if Input.pagedown.click then tab.targetScrollY=min(maxScroll,tab.targetScrollY+page)end
end
tab.targetScrollY=Clamp(tab.targetScrollY,0,maxScroll)
tab.scrollY=Approach(tab.scrollY,tab.targetScrollY,15)
if abs(tab.scrollY-tab.targetScrollY)<0.1 then tab.scrollY=tab.targetScrollY end
end
local function scrollTo(tab,sec,want,ty,sy0)
local acc,n=SectionTitleHeight(sec)+14,#sec.items
local gap=State.rowLines and 4 or 6
for i,it in ipairs(sec.items)do
if it==want then
tab.targetScrollY=Clamp((ty-sy0)+acc-40,0,tab.maxScroll)
return true
end
acc=acc+ItemHeight(it)+(i<n and gap or 0)
end
return false
end
local function drawBar(tab,px,contY,pw,contH,total,click,popupBlocking)
local va=State.contentFade*State.drawVisible
local trackX=px+pw+4
local barH=max(34,(contH/total)*contH)
local frac=tab.scrollY/tab.maxScroll
local barY=contY+frac*(contH-barH)
local dragging=State.scrollDrag and State.scrollDrag.tab==tab
local hov=IsMouseIn(trackX-7,barY,18,barH)or dragging
local gt=hov and 1 or Clamp(abs(tab.targetScrollY-tab.scrollY)/30,0,1)
tab._sbGlow=Approach(tab._sbGlow or 0,gt,12)
if abs(tab._sbGlow-gt)<0.004 then tab._sbGlow=gt end
local glow=tab._sbGlow
local barCol=LerpColor(Theme.accentA,Theme.accentB,frac)
local bw=4.5+glow
local bx=trackX+2-bw/2
DrawRect(trackX+0.5,contY,3,contH,WHITE,34,1.5,(0.05+0.05*glow)*va)
DrawRect(bx-2,barY-3,bw+4,barH+6,barCol,35,(bw+4)/2,0.16*glow*va)
DrawRect(bx,barY,bw,barH,barCol,36,bw/2,(0.55+0.45*glow)*va)
if click and not popupBlocking and IsMouseIn(trackX-7,contY,18,contH)then
local grab=IsMouseIn(trackX-7,barY,18,barH)and(State.mouseY-barY)or(barH/2)
State.scrollDrag={tab=tab,grab=grab}
click=false
end
if Input.m1.held and dragging then
local denom=max(1,contH-barH)
tab.targetScrollY=Clamp((State.mouseY-contY-State.scrollDrag.grab)/denom,0,1)*tab.maxScroll
end
return click
end
local function dragBody(tab,px,contY,pw,contH,click,popupBlocking)
if tab.maxScroll>0 and click and not popupBlocking and IsMouseIn(px,contY,pw,contH)and not State.scrollDrag then
State.contentDrag={tab=tab,my=State.mouseY,start=tab.targetScrollY}
tab._kv=0
click=false
end
local dt=State.dt or 1/60
if dt<=0 then dt=1/60 end
local drag=State.contentDrag
if Input.m1.held and drag and drag.tab==tab then
local nt=Clamp(drag.start-(State.mouseY-drag.my),0,tab.maxScroll)
tab._kv=(tab._kv or 0)*0.72+((nt-tab.targetScrollY)/dt)*0.28
tab.targetScrollY=nt
elseif(tab._kv or 0)~=0 and not State.scrollDrag then
tab.targetScrollY=Clamp(tab.targetScrollY+tab._kv*dt,0,tab.maxScroll)
tab._kv=tab._kv*math.exp(-5*dt)
if abs(tab._kv)<4 or tab.targetScrollY<=0 or tab.targetScrollY>=tab.maxScroll then tab._kv=0 end
end
return click
end
function DrawSections(tab,click,rightClick,px,contY,pw,contH)
local popupBlocking=State.dropdown~=nil or State.colorpicker~=nil
or State.keyMenu~=nil or State.dialog~=nil
local colW=floor((pw-10)/2)
local want=State._spotScrollTo
State._spotScrollTo=nil
local total=contentHeight(tab,contH)
scrollInput(tab,px,contY,pw,contH,popupBlocking)
local sy0=contY-tab.scrollY+(1-State.contentFade)*12
local clipTop,clipBottom=contY,contY+contH
local leftY,rightY=sy0,sy0
for i,sec in ipairs(tab.sections)do
sec._si=i
local sx,sy,sw
if sec.side=="Full"then
sy=max(leftY,rightY)
sx,sw=px,pw
leftY=sy+sec._h+10
rightY=leftY
elseif sec.side=="Right"then
sx,sy,sw=px+colW+10,rightY,colW
rightY=rightY+sec._h+10
else
sx,sy,sw=px,leftY,colW
leftY=leftY+sec._h+10
end
if want and scrollTo(tab,sec,want,sy,sy0)then want=nil end
click,rightClick=DrawSectionCard(sec,sx,sy,sw,sec._h,clipTop,clipBottom,click,rightClick,popupBlocking)
end
if tab.maxScroll>0 then
click=drawBar(tab,px,contY,pw,contH,total,click,popupBlocking)
elseif State.scrollDrag and State.scrollDrag.tab==tab then
State.scrollDrag=nil
end
return dragBody(tab,px,contY,pw,contH,click,popupBlocking),rightClick
end
end
local FX_LIST={"Off","Snow","Matrix","Rain"}
local FX_COUNT={Snow=48,Rain=80}
local MATRIX_GLYPHS="01ABCDEFGHJKLMNPRSTUVXYZ#$%&@"
local function FxGlyph()local i=1+floor(math.random()*#MATRIX_GLYPHS);return string.sub(MATRIX_GLYPHS,i,i)end
local function FxSpawn(name,rw)
local arr={}
local lite=State.lite and 0.55 or 1
if name=="Matrix"then
local cols=max(6,floor(rw/18*lite))
for i=1,cols do
local trail=6+floor(math.random()*6)
local g={};for k=1,trail do g[k]=FxGlyph()end
arr[i]={col=(i-0.5)/cols,y=math.random()*1.4-0.4,v=0.25+math.random()*0.55,trail=trail,g=g}
end
return arr
end
local n=max(6,floor((FX_COUNT[name]or 80)*lite))
for i=1,n do
arr[i]={x=math.random(),y=math.random(),ph=math.random()*6.2832,sp=0.3+math.random()*0.9,
sz=1+math.random()*2.2,a=0.35+math.random()*0.6,
depth=math.random(),
swayAmp=0.005+math.random()*0.018,fl=1.6+math.random()*1.8}
end
return arr
end
local function DrawBackgroundFx(x,y,w,h,titleH,v)
local name=State.bgEffect
if not name or name=="Off"then State._fx=nil;State._fxName=nil;return end
if v<=0.02 then return end
local rx,ry=x+2,y+titleH+2
local rw,rh=w-4,h-titleH-4
if rw<=12 or rh<=12 then return end
if State._fxName~=name or not State._fx then State._fx=FxSpawn(name,rw);State._fxName=name end
local p=State._fx
local t=Clock()
local dt=State.dt or 1/60;if dt>0.1 then dt=0.1 end
local A=v
local fxc=State.bgEffectColor
if name=="Snow"then local wind=sin(t*0.13)*0.5+sin(t*0.31+1.3)*0.22+sin(t*0.07)*0.3 for i=1,#p do local q=p[i]local d=q.depth q.y=q.y+(0.035+d*0.11)*dt if q.y>1.04 then q.y=-0.04;q.x=math.random()end local sway=sin(t*q.sp+q.ph)*q.swayAmp+sin(t*q.sp*q.fl+q.ph)*q.swayAmp*0.45 local ax=rx+(q.x+sway+wind*(0.012+d*0.03))*rw local ay=ry+q.y*rh local r=2+d*4.5 local col=fxc or LerpColor(c3(215,228,255),c3(255,255,255),d)local edge=Clamp((ay-ry-r)/6,0,1)*Clamp((ry+rh-ay-r*1.4)/8,0,1)local al=(0.3+d*0.5)*(0.85+0.15*sin(t*2+q.ph))*A*edge local rot=t*q.sp*0.3+q.ph if d>0.55 then DrawCircle(ax,ay,r*1.4,col,12,true,1,12,al*0.08)end for s=0,2 do local an=rot+s*1.0472 local ux,uy=cos(an)*r,sin(an)*r DrawLine(ax-ux,ay-uy,ax+ux,ay+uy,col,13,1,al)end DrawCircle(ax,ay,max(1,r*0.28),col,13,true,1,8,al)end elseif name=="Rain"then local by=ry+rh for i=1,#p do local q=p[i]q.y=q.y+(0.85+q.sz*0.25)*dt if q.y>1.06 then q.y=-0.05;q.x=math.random()end local ax=rx+q.x*rw local topy=ry+q.y*rh local len=6+q.sz*5 local c0=max(topy,ry)local c1=min(topy+len,by)local aa=q.a*A*0.5 if c1<=c0 then c1=c0;aa=0 end DrawLine(ax+(c0-topy)/len*2.5,c0,ax+(c1-topy)/len*2.5,c1,fxc or c3(170,200,255),12,1,aa)end elseif name=="Matrix"then local gh=14 for i=1,#p do local q=p[i]q.y=q.y+q.v*dt if q.y*rh-q.trail*gh>rh then q.y=-math.random()*0.3;for k=1,q.trail do q.g[k]=FxGlyph()end end local cx=rx+q.col*rw for k=1,q.trail do local ay=ry+q.y*rh-(k-1)*gh local fade=1-(k-1)/q.trail local vis=Clamp((ay-ry+2)/4,0,1)*Clamp((ry+rh-ay-gh+2)/4,0,1)local col=(k==1)and(fxc and LerpColor(fxc,WHITE,0.35)or c3(205,255,215))or(fxc and LerpColor(c3(0,0,0),fxc,0.3+0.5*fade)or c3(40+60*fade,200,80+40*fade))DrawText(q.g[k]or"0",cx,ay,col,13,FontSystem,12,false,false,nil,fade*A*0.9*vis)end if sin(t*3+q.col*30)>0.985 then q.g[1]=FxGlyph()end end end
end
local DrawWindow
do
local IDLE=c3(150,153,161)
local ICON=c3(188,191,199)
local CAT=c3(120,122,132)
local function syncView()
if State.activeSub and State.activeSub.parent~=State.activeTab then State.activeSub=nil end
local view=State.activeSub or State.activeTab
if view==State._tabSeen then return end
State.dropdown=nil
State.colorpicker=nil
State.keyMenu=nil
State.focus=nil
local hide=State.hideImg for _,tab in ipairs(State.tabs)do for _,sec in ipairs(tab.sections)do for _,it in ipairs(sec.items)do hide(it,"_img")hide(it,"_ddImg","_ddIc")end end for _,sub in ipairs(tab.subs or{})do for _,sec in ipairs(sub.sections)do for _,it in ipairs(sec.items)do hide(it,"_img")hide(it,"_ddImg","_ddIc")end end end end
State._tabSeen=view
end
local function applyDrag(held)
local drag=State.drag
if held and drag then
drag.tx=State.mouseX-drag.ox
drag.ty=State.mouseY-drag.oy
end
if not(drag and drag.tx)then return end
local oldX,oldY=State.x,State.y
State.x=Approach(oldX,drag.tx,28)
State.y=Approach(oldY,drag.ty,28)
ClampWindow()
local dx,dy=State.x-oldX,State.y-oldY
if dx==0 and dy==0 then return end
local dd,cp,km=State.dropdown,State.colorpicker,State.keyMenu
if dd and dd.x then dd.x=dd.x+dx;dd.y=dd.y+dy end
if cp and cp.x then cp.x=cp.x+dx;cp.y=cp.y+dy end
if km and km.x then km.x=km.x+dx;km.y=km.y+dy end
end
local function applyResize(held)
local edge=State.resizeEdge
if not(held and edge)then return end
local rs=State.resizeStart
if edge=="r"or edge=="br"then State.wTarget=max(420,rs.w+(State.mouseX-rs.mx))end
if edge=="b"or edge=="br"then State.hTarget=max(300,rs.h+(State.mouseY-rs.my))end
end
local function layout()
State.wTarget=State.wTarget or State.w
State.hTarget=State.hTarget or State.h
State.w=Approach(State.w,State.wTarget,16)
State.h=Approach(State.h,State.hTarget,16)
local v=State.drawVisible
local S={
v=v,titleH=31,m=6,stripH=42,
x=State.x,y=State.y+(1-v)*14,w=State.w,h=State.h,
accent=State._accentMid,
}
S.side=State.tabLayout~="top"
S.topH=S.side and 42 or S.titleH
S.noPopup=not State.dropdown and not State.colorpicker and not State.keyMenu and not State.spotlightOpen
local swC,swE=54,max(126,floor(S.w*0.23))
local swPrev=swC+(swE-swC)*(State._sbX or 0)
local hov=S.side and S.noPopup and IsMouseIn(S.x,S.y,swPrev,S.h)
local want=hov and 1 or 0
State._sbX=Approach(State._sbX or 0,want,10)
if abs(State._sbX-want)<0.003 then State._sbX=want end
S.expand=(State.lite or State.sidebarPinned or not S.side)and 1 or State._sbX
S.sw=S.side and(swC+(swE-swC)*S.expand)or 0
S.tlY=S.y+S.topH/2
return S
end
local function drawFrame(S)
local x,y,w,h,v,topH=S.x,S.y,S.w,S.h,S.v,S.topH
if not State.lite then
local sh=Alpha.WindowShadow
for i=1,#sh do
local o=i*4
DrawRect(x-o,y-o+6,w+o*2,h+o*2,c3(0,0,0),9,16,sh[i]*v)
end
end
DrawRect(x,y,w,h,Theme.bg,10,8,(State.menuOpacity or 0.98)*v)
local bg=State.bgImg
if bg then
local paneH=h-topH
local frac=State.bgImgWFrac
local bw=frac and(frac*w)or(paneH*0.6)
local bh=frac and((State.bgImgHFrac or 1)*paneH)or paneH
DrawImage(bg,x+(w-bw)/2,y+topH+(paneH-bh)/2,bw,bh,119999,(State.bgImgAlpha or 0.12)*v,nil,v>0.01)
end
State._winRect={x=x,y=y,w=w,h=h,th=topH,v=v}
DrawStroke(x,y,w,h,WHITE,12,8,Alpha.Hairline*v)
if S.side then
local sw=S.sw
DrawRect(x+sw,y+topH,w-sw,h-topH,WHITE,11,7,0.045*v)
if State.activeTab then
local view=State.activeSub or State.activeTab
DrawText(view.name,x+sw+16,TextTop(y,topH,15),WHITE,15,FontBold,13,false,false,max(2,(w-sw)-272),Alpha.Text*v)
end
else
DrawRect(x+1,y+S.titleH,w-2,4,S.accent,11,0,0.035*v)
DrawGradient(x+1,y+S.titleH-1.4,w-2,1.4,Theme.accentA,Theme.accentB,12,0.55*v)
end
local sweep=x-46+(w+92)*v
local sa=4*v*(1-v)
local b1,b2=max(x+2,sweep),min(x+w-2,sweep+30)
DrawRect(b1,y+2,b2-b1,topH-3,WHITE,12,6,0.09*sa)
local s1,s2=max(x+2,sweep-18),min(x+w-2,sweep)
DrawRect(s1,y+2,s2-s1,topH-3,S.accent,12,6,0.06*sa)
end
local function drawGem(S)
local bsz,v=16,S.v
local gx=S.side and(S.x+29)or(S.x+20)
local gy=S.side and(S.y+22)or S.tlY
local lsz=bsz+6
local logo,icon=State.logoImg,State.iconImg
if icon and(not S.side or not logo)then
DrawImage(icon,gx-lsz/2,gy-lsz/2,lsz,lsz,169999,v,5)
elseif logo and not S.side then
DrawImage(logo,gx-lsz/2,gy-lsz/2,lsz,lsz,169999,v,5)
elseif not S.side then
DrawRect(gx-bsz/2,gy-bsz/2,bsz,bsz,S.accent,14,2.5,0.95*v)
DrawMenuBars(gx,gy,bsz,c3(36,38,50),v,15)
end
end
local function ctrlBtn(S,cxp,kind)
local gx,gy=Round(cxp),Round(S.tlY)
local bs=20
local bx,by=gx-bs/2,gy-bs/2
local hov=IsMouseIn(bx,by,bs,bs)
local key="_ctl_"..kind
local want=hov and 1 or 0
State[key]=Approach(State[key]or 0,want,14)
if abs(State[key]-want)<0.004 then State[key]=want end
local hf=State[key]
local col=LerpColor(WHITE,S.accent,hf)
local aa=(0.5+0.45*hf)*S.v
DrawRect(bx,by,bs,bs,S.accent,13,6,0.14*hf*S.v)
DrawStroke(bx,by,bs,bs,S.accent,14,6,0.55*hf*S.v)
if kind=="close"then
DrawBar(gx-4,gy-4,gx+4,gy+4,1.8,col,16,aa)
DrawBar(gx+4,gy-4,gx-4,gy+4,1.8,col,16,aa)
elseif kind=="search"then
DrawCircle(gx-1,gy-1,3.2,col,16,false,1.5,18,aa)
DrawBar(gx+1.3,gy+1.3,gx+4.2,gy+4.2,1.7,col,16,aa)
else
DrawBar(gx-4,gy,gx+4,gy,1.8,col,15,aa)
end
return hov
end
local function openSearch()
State.spotlightOpen=true
State.spotlight={query="",sel=1}
State.focus=nil
end
local function drawSearch(S,click)
local style=State.searchStyle or"bar"
local mx,my=State.mouseX,State.mouseY
if style=="icon"then
local hov=ctrlBtn(S,S.x+S.w-71,"search")
if hov then WantTooltip("Search  \194\183  Ctrl+Space",mx,my)end
if hov and click and S.noPopup then openSearch();click=false end
elseif style=="bar"then
local v,tlY=S.v,S.tlY
local bw=floor(min(190,max(100,(S.side and(S.w-S.sw)or S.w)*0.28)))
local bx,by=S.x+S.w-66-bw,tlY-9
local hov=IsMouseIn(bx,by,bw,18)
local want=hov and 1 or 0
State._sbHov=Approach(State._sbHov or 0,want,12)
if abs(State._sbHov-want)<0.004 then State._sbHov=want end
local sh=State._sbHov
local ia=(0.7+0.3*sh)*v
DrawRect(bx,by,bw,18,WHITE,13,9,(Alpha.Field+0.04*sh)*v)
DrawStroke(bx,by,bw,18,S.accent,14,9,(0.12+0.4*sh)*v)
DrawCircle(bx+10,tlY-1,3,S.accent,15,false,1.3,18,ia)
DrawBar(bx+11.8,tlY+1.2,bx+14.4,tlY+3.8,1.4,S.accent,15,ia)
DrawText("Search",bx+20,TextTop(by,18,12),WHITE,12,FontSystem,15,false,false,bw-26,(Alpha.Dim+0.12*sh)*v)
if hov then WantTooltip("Ctrl+Space",mx,my)end
if click and hov and S.noPopup then openSearch();click=false end
end
return click
end
local function drawBar(S,click)
local x,y,w=S.x,S.y,S.w
if ctrlBtn(S,x+w-21,"close")and click and S.noPopup then
SetOpen(false)
click=false
end
if ctrlBtn(S,x+w-46,"min")and click and S.noPopup then
State.minimized=not State.minimized
if State.minimized then
State.minPos={x=x+6,y=y+4}
State.dropdown=nil
State.colorpicker=nil
State.keyMenu=nil
State.focus=nil
end
click=false
end
local hov=S.side and(IsMouseIn(x+S.sw,y,w-S.sw,S.topH)or IsMouseIn(x,y,S.sw,42))or IsMouseIn(x,y,w,S.titleH)
if click and S.noPopup and not State.drag and not State.resizeEdge and hov then
State.drag={ox=State.mouseX-x,oy=State.mouseY-y}
click=false
end
return click
end
local function tabIcon(o,x,y,sz,z,a,bright)
local name=o.icon
local base,acc=IconBytes[name],IconBytes[name.."#a"]
if base and acc then
if not o._img then
o._ic={}
o._img=Drawing.new("Image")
o._img.Data=base
end
if not o._imgA then
o._icA={}
o._imgA=Drawing.new("Image")
o._imgA.Data=acc
o._icaKey=State._iconAccentKey
end
if o._imgA and o._icaKey~=State._iconAccentKey then
o._icaKey=State._iconAccentKey
o._imgA.Data=acc
end
local ab=a*bright
PlaceImage(o._img,o._ic,x,y,sz,sz,z,a,a>0.01)
PlaceImage(o._imgA,o._icA,x,y,sz,sz,z+1,ab,ab>0.01)
elseif base then
if not o._img then
o._ic={}
o._img=Drawing.new("Image")
o._img.Data=base
end
PlaceImage(o._img,o._ic,x,y,sz,sz,z+1,a,a>0.01)
end
end
local function drawHeader(S)
local x,y,v,expand=S.x,S.y,S.v,S.expand
local edge=x+S.sw-14
local hdrX=x+16
local logo=State.logoImg
if logo then
local lsz=State.logoSize or 30
local lcy=y+22+((State.subtitle~=""and 30 or 18)-22)*expand
DrawImage(logo,hdrX-4*(1-expand),lcy-lsz/2,lsz,lsz,629999,v,lsz*0.22)
if State.iconImg then State.iconImg.Visible=false end
hdrX=hdrX+lsz+9
elseif State.iconImg then
hdrX=x+44
else
local mono=string.upper(string.sub(State.title or"",1,1))
if mono~=""then
local msz=26
local mcx=x+16+msz/2-4*(1-expand)
local mcy=y+22+((State.subtitle~=""and 30 or 18)-22)*expand
DrawRect(mcx-msz/2,mcy-msz/2,msz,msz,State._accentMid,61,7,0.16*v)
DrawStroke(mcx-msz/2,mcy-msz/2,msz,msz,WHITE,61,7,Alpha.CardStroke*v)
DrawTextMid(mono,mcx,mcy,State._accentMid,15,FontBold,62,Alpha.Text*v)
hdrX=x+16+msz+9
end
end
local twMax=max(2,edge-hdrX)
local tsz=16
local fullW=TextWidth(State.title,tsz,FontBold)
if fullW>twMax then tsz=max(11,floor(tsz*twMax/fullW))end
local tTop,tA=y+20-floor(tsz/2),Alpha.Text*v*expand
DrawText(State.title,hdrX,tTop+1,c3(0,0,0),tsz,FontBold,60,false,false,twMax,0.28*tA)
DrawText(State.title,hdrX,tTop,State._accentMid,tsz,FontBold,61,false,false,twMax,tA)
local infoBottom=y+34
if State.subtitle~=""then
DrawText(State.subtitle,hdrX,y+34,WHITE,11,FontSystem,61,false,false,max(2,edge-hdrX),Alpha.Dim*v*expand)
infoBottom=y+50
end
DrawGradient(x+12,infoBottom,S.sw-24,1,Theme.accentA,Theme.accentB,61,0.3*v*expand)
return infoBottom
end
local function drawSubs(S,tab,top,navPx,navPw,et,click)
local subH,subR=24,6
local nSubs=#tab.subs
local stagger=min(0.10,0.7/max(1,nSubs-1))
local denom=max(0.001,1-(nSubs-1)*stagger)
local sx,spw=navPx+14,navPw-14
local navAcc,v,expand=State._accentMid,S.v,S.expand
local pill=LerpColor(WHITE,navAcc,0.35)
for j,sub in ipairs(tab.subs)do
local rv=Clamp((et-(j-1)*stagger)/denom,0,1)
rv=rv*rv*(3-2*rv)*expand
local sy=top+(j-1)*(subH+4)-3*(1-rv)
local live=rv>0.5 and et>0.5
local sActive=State.activeSub==sub
local sHov=live and IsMouseIn(sx,sy,spw,subH)and S.noPopup and State.hoverEffects~=false
local saf=Approach(sub._af or 0,sActive and 1 or 0,12)
if abs(saf-(sActive and 1 or 0))<0.004 then saf=sActive and 1 or 0 end
sub._af=saf
local shf=Approach(sub._hf or 0,sHov and 1 or 0,18)
if abs(shf-(sHov and 1 or 0))<0.004 then shf=sHov and 1 or 0 end
sub._hf=shf
local bright=saf+(1-saf)*0.35*shf
local iconCol=LerpColor(ICON,navAcc,bright)
DrawRect(sx,sy,spw,subH,pill,62,subR,(0.05*saf+0.04*shf*(1-saf))*rv*v)
local lblX=sx+20
if sub.icon then
local sia=rv*(0.7+0.3*bright)*v
tabIcon(sub,sx+9,sy+(subH-14)/2,14,629998,sia,bright)
lblX=sx+28
else
DrawCircle(sx+11,sy+subH/2,2,iconCol,63,true,1,12,rv*(0.5+0.5*saf)*v)
end
DrawText(sub.name,lblX,TextTop(sy,subH,12),LerpColor(IDLE,WHITE,bright),12,FontSystem,63,false,false,spw-(lblX-sx)-6,(0.86+0.14*saf)*rv*v*expand)
if click and live and IsMouseIn(sx,sy,spw,subH)and S.noPopup then
State.activeTab=tab
State.activeSub=sub
tab._lastSub=sub
State.contentFade=0
click=false
end
end
return click
end
local function drawNav(S,click,infoBottom)
local x,v,expand=S.x,S.v,S.expand
local navPx,navPw=x+12,S.sw-24
local pillH,navR=30,7
local navAcc=State._accentMid
local pill=LerpColor(WHITE,navAcc,0.35)
local edge=x+S.sw-18
local ty=floor((S.y+50)+((infoBottom+12)-(S.y+50))*expand)
local prevCat=nil
for i,tab in ipairs(State.tabs)do
if not tab.hidden then
if tab.category and tab.category~=prevCat then
ty=ty+(prevCat==nil and 6 or 12)*expand
DrawText(string.upper(tab.category),navPx+2,ty,CAT,11,FontBold,61,false,false,navPw-4,0.42*v*expand)
ty=ty+4+16*expand
prevCat=tab.category
end
local nSubs=#tab.subs
local branch=State.activeTab==tab
local leaf=branch and nSubs==0
local inPill=IsMouseIn(navPx,ty,navPw,pillH)and S.noPopup
local hov=inPill and State.hoverEffects~=false
local af=Approach(tab._af or 0,leaf and 1 or 0,12)
if abs(af-(leaf and 1 or 0))<0.004 then af=leaf and 1 or 0 end
tab._af=af
local bf=Approach(tab._bf or 0,branch and 1 or 0,16)
if abs(bf-(branch and 1 or 0))<0.004 then bf=branch and 1 or 0 end
tab._bf=bf
local hf=Approach(tab._hf or 0,hov and 1 or 0,18)
if abs(hf-(hov and 1 or 0))<0.004 then hf=hov and 1 or 0 end
tab._hf=hf
local et=Approach(tab._exp or 0,branch and 1 or 0,branch and 14 or 17)
if abs(et-(branch and 1 or 0))<0.004 then et=branch and 1 or 0 end
tab._exp=et
tab._flash=Approach(tab._flash or 0,0,5)
if tab._flash<0.004 then tab._flash=0 end
local bright=af+(1-af)*0.5*hf
local iconBright=(nSubs>0)and max(0.5*hf,tab._flash)or bright
local slide=1.5*hf*(1-af)
local top=TextTop(ty,pillH,13)
DrawRect(navPx,ty,navPw,pillH,pill,61,navR,(0.055*af+0.05*hf*(1-af))*v)
local lblX=navPx+13
if tab.icon then
local ia=(0.7+0.3*iconBright)*v
local iconCol=LerpColor(ICON,navAcc,iconBright)
tabIcon(tab,navPx+10-3*(1-expand)+slide,ty+(pillH-16)/2,16,629998,ia,iconBright)
lblX=navPx+34
end
local maxW=max(2,edge-lblX)
DrawText(tab.name,lblX+1,top+1,c3(0,0,0),13,FontBold,62,false,false,maxW,0.22*af*v)
DrawText(tab.name,lblX+slide,top,LerpColor(IDLE,WHITE,bright),13,FontBold,63,false,false,maxW,(0.90+0.10*af)*v*expand)
if click and inPill then
State.activeTab=tab
State.activeIndex=i
State.contentFade=0
tab._flash=1
if nSubs>0 then
local pick=tab._lastSub
local ok=false
if pick then
for _,s in ipairs(tab.subs)do if s==pick then ok=true;break end end
end
State.activeSub=ok and pick or tab.subs[1]
tab._lastSub=State.activeSub
else
State.activeSub=nil
end
click=false
end
local adv=pillH
if nSubs>0 then
click=drawSubs(S,tab,ty+pillH+4,navPx,navPw,et,click)
adv=adv+et*expand*(4+nSubs*28)
end
ty=ty+adv+(2+4*expand)
end
end
return click
end
local function drawGear(S,click,gcx,gcy,bs,isz,zFill,zImg,scale,stroke)
local hov=scale>0.5 and IsMouseIn(gcx-bs/2,gcy-bs/2,bs,bs)
local active=State.activeTab==State.settingsTab
local v=S.v
local ga=(active and Alpha.Hover or(hov and Alpha.Label or Alpha.Dim))*v*scale
local gf=Approach(State._gearAf or 0,(active or hov)and 1 or 0,13)
State._gearAf=gf
local bx,by=gcx-bs/2,gcy-bs/2
DrawRect(bx,by,bs,bs,WHITE,zFill,8,Alpha.TabFill*(active and 1 or 0.6)*gf*v*scale)
if stroke then DrawStroke(bx,by,bs,bs,WHITE,zFill,8,Alpha.CardStroke*gf*v*scale)end
local gi=State.settingsIcon or"cog"
if IconBytes[gi]then
if not State._gearImg then
State._gearImg=Drawing.new("Image")
State._gearImg.Data=IconBytes[gi]
end
DrawImage(State._gearImg,gcx-isz/2,gcy-isz/2,isz,isz,zImg,ga)
end
if click and hov and S.noPopup then
if active then
State.activeTab=State._prevTab or State.tabs[1]
State.activeIndex=State._prevIndex or 1
else
State._prevTab,State._prevIndex=State.activeTab,State.activeIndex
State.activeTab=State.settingsTab
State.activeIndex=State.settingsIndex or#State.tabs
end
State.contentFade=0
click=false
end
return click
end
local function drawUserCard(S,click)
if not State._plResolved and LocalPlayer then
local name,disp="player","player"
name=tostring(LocalPlayer.Name)
disp=LocalPlayer.DisplayName~=""and tostring(LocalPlayer.DisplayName)or name
State._plDisp=disp
State._plInitial=string.upper(string.sub(disp,1,1))
State._plHandle="@"..name
State._plResolved=true
end
local x,v,expand,sw=S.x,S.v,S.expand,S.sw
local uy=S.y+S.h-46
local half=(sw-28)/2
local ua=Alpha.Hairline*1.8*v*expand
State.fadeLine(x+14,uy-10,half,WHITE,61,ua,true)
State.fadeLine(x+14+half,uy-10,half,WHITE,61,ua)
local acx,acy=x+29,uy+16
if State.avatarImg then
DrawImage(State.avatarImg,acx-14,acy-14,28,28,629999,v,14)
DrawCircle(acx,acy,14,WHITE,63,false,1,28,Alpha.Hairline*v)
else
DrawCircle(acx,acy,14,State._accentMid,61,true,1,28,0.18*v)
DrawCircle(acx,acy,14,WHITE,62,false,1,28,Alpha.Hairline*v)
local letter=State._plInitial or"P"
DrawText(letter,acx-TextWidth(letter,13,FontBold)/2,acy-7,WHITE,13,FontBold,62,false,false,nil,Alpha.Text*v)
end
local maxW=max(2,sw-100)
DrawText(State._plDisp or"player",x+50,uy+6,WHITE,12,FontBold,62,false,false,maxW,Alpha.Text*v*expand)
DrawText(State._plHandle or"@player",x+50,uy+22,WHITE,11,FontSystem,62,false,false,maxW,Alpha.Dim*v*expand)
if State.settingsTab then click=drawGear(S,click,x+sw-26,acy,30,20,61,629999,expand,true)end
return click
end
local function drawTopStrip(S,click)
local x,y,w,v=S.x,S.y,S.w,S.v
local yStrip=y+S.titleH
local sMid=yStrip+S.stripH/2
local rightEdge=x+w-14
if State.settingsTab then
local gcx=x+w-26
click=drawGear(S,click,gcx,sMid,28,18,13,169999,1,false)
rightEdge=gcx-22
end
local acx,acy=rightEdge-13,sMid
if State.avatarImg then
DrawImage(State.avatarImg,acx-11,acy-11,22,22,169999,v,11)
DrawCircle(acx,acy,11,WHITE,17,false,1,24,Alpha.Hairline*v)
else
local letter=State._plInitial or string.upper(string.sub((LocalPlayer and LocalPlayer.Name)or"P",1,1))
DrawCircle(acx,acy,11,State._accentMid,13,true,1,24,0.18*v)
DrawCircle(acx,acy,11,WHITE,14,false,1,24,Alpha.Hairline*v)
DrawText(letter,acx-TextWidth(letter,12,FontBold)/2,acy-6,WHITE,12,FontBold,15,false,false,nil,Alpha.Text*v)
end
local tx=x+14
for i,tab in ipairs(State.tabs)do
if not tab.hidden then
local active=State.activeTab==tab
local pw0=(tab.icon and 22 or 0)+TextWidth(tab.name,14,FontBold)+24
local ph=26
local pyy=sMid-ph/2
local inPill=IsMouseIn(tx,pyy,pw0,ph)
local hov=inPill and State.hoverEffects~=false
local af=Approach(tab._af or 0,active and 1 or 0,13)
tab._af=af
local la=(active and Alpha.Hover or(hov and Alpha.Label or Alpha.Dim))*v
DrawRect(tx,pyy,pw0,ph,WHITE,13,7,Alpha.TabFill*af*v)
DrawStroke(tx,pyy,pw0,ph,WHITE,14,7,Alpha.CardStroke*af*v)
DrawRect(tx+pw0/2-8*af,yStrip+S.stripH-3,max(1,16*af),2,S.accent,15,1,0.95*af*v)
DrawRect(tx,pyy,pw0,ph,WHITE,13,7,((hov and not active)and 0.07 or 0)*v)
local lblX=tx+12
if tab.icon then
tabIcon(tab,tx+10,sMid-8,16,169998,la,af)
lblX=tx+30
end
DrawText(tab.name,lblX,TextTop(pyy,ph,14),active and S.accent or WHITE,14,FontBold,15,false,false,pw0,la)
if click and inPill and S.noPopup then
if State.activeTab~=tab then
State.activeTab=tab
State.activeIndex=i
State.contentFade=0
end
click=false
end
tx=tx+pw0+6
end
end
DrawLine(x,yStrip+S.stripH,x+w,yStrip+S.stripH,WHITE,12,1,Alpha.Hairline*v)
return click
end
local function drawGrip(S,click)
local x,y,w,h,v=S.x,S.y,S.w,S.h,S.v
local rx,by=x+w-5,y+h-5
DrawLine(x+w-14,by,rx,y+h-14,WHITE,13,1,Alpha.Dim*v)
DrawLine(x+w-11,by,rx,y+h-11,WHITE,13,1,Alpha.Dim*v)
DrawLine(x+w-8,by,rx,y+h-8,WHITE,13,1,Alpha.Dim*v)
if click and S.noPopup and not State.drag and not State.resizeEdge then
local m=S.m
local corner=IsMouseIn(x+w-22,y+h-22,24,24)
local right=IsMouseIn(x+w-m,y,m+2,h)
local bottom=IsMouseIn(x,y+h-m,w,m+2)
local edge=(corner or(right and bottom))and"br"or(right and"r")or(bottom and"b")or nil
if edge then
State.resizeEdge=edge
State.resizeStart={w=w,h=h,mx=State.mouseX,my=State.mouseY}
click=false
end
end
return click
end
function DrawWindow(click,held,rightClick)
syncView()
applyDrag(held)
applyResize(held)
local S=layout()
drawFrame(S)
drawGem(S)
click=drawSearch(S,click)
click=drawBar(S,click)
local px,contY,pw
if S.side then
click=drawNav(S,click,drawHeader(S))
click=drawUserCard(S,click)
contY=S.y+S.topH+10
px=S.x+S.sw+12
pw=(S.w-S.sw)-30
else
click=drawTopStrip(S,click)
contY=S.y+S.titleH+S.stripH+8
px=S.x+14
pw=S.w-34
end
click=drawGrip(S,click)
State.contentFade=Approach(State.contentFade,1,12)
if State.contentFade>0.997 then State.contentFade=1 end
if State.activeTab then
click,rightClick=DrawSections(State.activeSub or State.activeTab,click,rightClick,px,contY,pw,(S.y+S.h)-contY-10)
end
return click,held,rightClick
end
end
local function DrawNotifications()
local notes=State.notifications
while#notes>10 do remove(notes,1)end
local vw,vh=ScreenSize()
local width=292
local stackY=vh-16
local i=1
while i<=#notes do
local n=notes[i]
n.elapsed=n.elapsed+(State.dt or 1/60)
if n.elapsed>=n.duration then remove(notes,i)
else
local descLines=WrapText(n.description or"",width-40,12,FontSystem)
if#descLines==0 then descLines={""}end
if#descLines>4 then local t4={};for li=1,4 do t4[li]=descLines[li]end;descLines=t4 end
local height=24+#descLines*15+14
stackY=stackY-height
n.targetX=vw-width-16
n.targetY=stackY
n.currentX=Approach(n.currentX or vw,n.targetX,12)
n.currentY=Approach(n.currentY or n.targetY,n.targetY,12)
local fade=1
if n.elapsed<0.25 then fade=n.elapsed/0.25
elseif n.duration-n.elapsed<0.35 then fade=(n.duration-n.elapsed)/0.35 end
local nx,ny=n.currentX,n.currentY
local typ=n.ntype or(n.title=="error"and"error")or nil
local tc=(typ=="success"and c3(95,210,135))or(typ=="warning"and c3(255,190,70))
or(typ=="error"and Theme.bad)or State._accentMid
DrawRect(nx+2,ny+3,width,height,c3(0,0,0),299,12,0.16*fade)
DrawRect(nx,ny,width,height,Theme.bg,300,12,0.97*fade)
DrawStroke(nx,ny,width,height,WHITE,301,12,0.1*fade)
DrawCircle(nx+17,ny+16,3.5,tc,302,true,1,16,fade)
DrawText(n.title,nx+29,ny+9,typ and tc or WHITE,13,FontBold,302,false,false,width-42,(typ and 1 or Alpha.Text)*fade)
for li=1,#descLines do
DrawText(descLines[li],nx+29,ny+26+(li-1)*15,WHITE,12,FontSystem,302,false,false,width-40,Alpha.Label*fade)
end
local frac=Clamp(1-n.elapsed/n.duration,0,1)
local trackX,trackW,trackY=nx+29,width-45,ny+height-9
DrawRect(trackX,trackY,trackW,2,WHITE,302,1,0.12*fade)
local barW=trackW*frac
local barA=0.95*fade*Clamp(barW,0,1)
if typ then DrawRect(trackX,trackY,max(1,barW),2,tc,303,1,barA)
else DrawGradient(trackX,trackY,max(1,barW),2,Theme.accentA,Theme.accentB,303,barA)end
stackY=stackY-8
i=i+1
end
end
end
local function DrawTooltip()
if not State.tooltipsEnabled then return end
local text=State.tooltipText
if not text or text==""then return end
if(Clock())-(State.tooltipAt or 0)<0.35 then return end
if State._ttText~=text then State._ttText=text;State._ttLines=WrapText(text,240,12,FontUI)end
local lines=State._ttLines
local maxW=0
for _,l in ipairs(lines)do maxW=max(maxW,TextWidth(l,12,FontUI))end
local width=floor(maxW*1.04)+14
local hgt=7+15*#lines
local vw,vh=ScreenSize()
local x=Clamp(State.tooltipX+12,8,vw-width-8)
local yy=Clamp(State.tooltipY+18,8,vh-hgt-4)
DrawRect(x,yy,width,hgt,Theme.bg,320,6,0.96)
DrawStroke(x,yy,width,hgt,WHITE,321,6,Alpha.CardStroke)
for i,l in ipairs(lines)do DrawText(l,x+8,yy+4+(i-1)*15,WHITE,12,FontUI,322,false,false,nil,Alpha.Text)end
end
local CFG_LEGACY=IsFolder("INSui_configs")and"INSui_configs"or(LibName.."_configs")
local function SafeFolder(s)
s=tostring(s or""):gsub("[^%w%-_ ]"," "):gsub("%s+"," "):gsub("^ +",""):gsub(" +$","")
return s
end
local function ConfigDir()return State.cfgFolder or CFG_LEGACY end
local function EnsureFolder()
local Dir=ConfigDir()
if not IsFolder(Dir)then MakeFolder(Dir)end
end
local function PackConfig()
local data={
flags={},keybinds={},colors={},
uiFont=State.uiFontName,layout=State.tabLayout,search=State.searchStyle,
}
for _,tab in ipairs(State.tabs)do
for _,section in ipairs(tab.sections)do
for _,item in ipairs(section.items)do
local key=tab.name.."."..section.name.."."..item.label
local saveable=not item.noSave and item.type~="button"
if saveable and item.type=="rangeslider"then
data.flags[key]={item.valueLo,item.valueHi}
elseif saveable and item.value~=nil then
if item.type=="colorpicker"then
data.flags[key]={item.value.R,item.value.G,item.value.B,item.alpha or 1}
elseif item.type=="dropdown"then
data.flags[key]=CopyArray(item.value)
else
data.flags[key]=item.value
end
if item.colorpicker and item.colorpicker.value then
local swatch=item.colorpicker.value
data.colors[key]={swatch.R,swatch.G,swatch.B,item.colorpicker.alpha or 1}
end
end
if saveable and(item.type=="rangeslider"or item.value~=nil)and item.keybind then
data.keybinds[key]={item.keybind.value,item.keybind.mode}
end
end
end
end
local accentA=State.baseAccentA or Theme.accentA
local accentB=State.baseAccentB or Theme.accentB
local fx=State.bgEffectColor
data.settings={
accentA={accentA.R,accentA.G,accentA.B},
accentB={accentB.R,accentB.G,accentB.B},
bg={Theme.bg.R,Theme.bg.G,Theme.bg.B},
txt={Theme.text.R,Theme.text.G,Theme.text.B},
rainbow=State.rainbow==true,
rainbowSpeed=State.rainbowSpeed,
menuOpacity=State.menuOpacity,
noAnim=State.noAnim==true,
notifyDur=State.notifyDur,
hoverEffects=State.hoverEffects~=false,
checkboxStyle=State.checkboxStyle==true,
hotkeyEnabled=State.hotkeyEnabled~=false,
menuKey=MenuKey,
w=State.w,
h=State.h,
glowMul=State.glowMul,
cardStrk=Alpha.CardStroke,
hairline=Alpha.Hairline,
cardFill=Alpha.Card,
lite=State.lite==true,
roundScale=State.roundScale,
smartFps=State.smartFps~=false,
sidebarPinned=State.sidebarPinned==true,
dropdownInline=State.dropdownInline==true,
bgImg=State.bgImgUrl,
bgImgA=State.bgImgAlpha,
bgFx=State.bgEffect,
bgFxColor=fx and{fx.R,fx.G,fx.B}or nil,
logo=State.logoSrc,
icon=State.iconSrc,
}
return data
end
function ui:SaveConfig(name)
name=tostring(name or State.configName or"default")
local enc=JsonEncode(PackConfig())
if not enc then return self end
EnsureFolder()
WriteFile(ConfigDir().."/"..name..".json",enc)
return self
end
local function ApplyConfig(data)
if not data then return end
State._loadingConfig=true
if data.uiFont then ui:SetFont(data.uiFont)end
if data.layout then State.tabLayout=data.layout end
if data.search then State.searchStyle=data.search end
for _,tab in ipairs(State.tabs)do
for _,sec in ipairs(tab.sections)do
for _,item in ipairs(sec.items)do
if item.type=="rangeslider"and item.label and not item.noSave then
local key=tab.name.."."..sec.name.."."..item.label
local fv=data.flags and data.flags[key]
if type(fv)=="table"then
local lo,hi=tonumber(fv[1]),tonumber(fv[2])
if lo and hi then
item.valueLo=SnapValue(lo,item);item.valueHi=SnapValue(hi,item)
if item.valueLo>item.valueHi then item.valueLo,item.valueHi=item.valueHi,item.valueLo end
Invoke(item.callback,item.valueLo,item.valueHi)
end
end
local kb=data.keybinds and data.keybinds[key]
if kb and item.keybind then item.keybind.value=kb[1];item.keybind.mode=NormalMode(kb[2])end
elseif item.value~=nil and item.label and item.type~="button"and not item.noSave then
local key=tab.name.."."..sec.name.."."..item.label
local fv=data.flags and data.flags[key]
if fv~=nil then
if item.type=="colorpicker"and type(fv)=="table"then
item.value=c3((fv[1]or 1)*255,(fv[2]or 1)*255,(fv[3]or 1)*255)
item.alpha=fv[4]or 1;Invoke(item.callback,item.value,item.alpha)
elseif item.type=="dropdown"then SetDropdownValue(item,fv,true)
else SetItemValue(item,fv,true)end
end
local kb=data.keybinds and data.keybinds[key]
if kb and item.keybind then item.keybind.value=kb[1];item.keybind.mode=NormalMode(kb[2])end
local cpv=data.colors and data.colors[key]
if cpv and item.colorpicker then
item.colorpicker.value=c3((cpv[1]or 1)*255,(cpv[2]or 1)*255,(cpv[3]or 1)*255)
item.colorpicker.alpha=cpv[4]or 1
Invoke(item.colorpicker.callback,item.colorpicker.value,item.colorpicker.alpha)
end
end
end
end
end
local s=data.settings
if s then
if s.accentA and s.accentB then
local a=c3((s.accentA[1]or 0)*255,(s.accentA[2]or 0)*255,(s.accentA[3]or 0)*255)
local b=c3((s.accentB[1]or 0)*255,(s.accentB[2]or 0)*255,(s.accentB[3]or 0)*255)
State.baseAccentA=a;State.baseAccentB=b
if not s.rainbow then Theme.accentA=a;Theme.accentB=b end
end
if s.rainbow~=nil then State.rainbow=s.rainbow==true end
if s.rainbowSpeed then State.rainbowSpeed=s.rainbowSpeed end
if s.menuOpacity then State.menuOpacity=s.menuOpacity end
if s.noAnim~=nil then State.noAnim=s.noAnim==true end
if s.notifyDur then State.notifyDur=s.notifyDur end
if s.hoverEffects~=nil then State.hoverEffects=s.hoverEffects~=false end
if s.checkboxStyle~=nil then State.checkboxStyle=s.checkboxStyle==true end
if s.hotkeyEnabled~=nil then State.hotkeyEnabled=s.hotkeyEnabled~=false end
if s.menuKey then ui:SetMenuKey(s.menuKey)end
if tonumber(s.w)and tonumber(s.h)then ui:SetSize(s.w,s.h)end
if s.bg then Theme.bg=c3((s.bg[1]or 0)*255,(s.bg[2]or 0)*255,(s.bg[3]or 0)*255);Theme.sidebar=Theme.bg end
if s.txt then Theme.text=c3((s.txt[1]or 1)*255,(s.txt[2]or 1)*255,(s.txt[3]or 1)*255)end
if s.glowMul then State.glowMul=s.glowMul end
if s.cardStrk then Alpha.CardStroke=s.cardStrk end
if s.hairline then Alpha.Hairline=s.hairline end
if s.cardFill then Alpha.Card=s.cardFill end
if s.lite~=nil then State.lite=s.lite==true end
if s.roundScale then State.roundScale=Clamp(tonumber(s.roundScale)or 1,0,2.5)end
if s.smartFps~=nil then State.smartFps=s.smartFps==true end
if s.sidebarPinned~=nil then State.sidebarPinned=s.sidebarPinned==true end
if s.dropdownInline~=nil then State.dropdownInline=s.dropdownInline==true end
if s.bgImg then ui:SetBackgroundImage(s.bgImg,s.bgImgA)elseif not State.bgImg then ui:SetBackgroundImage(nil)end
ui:SetBackgroundEffect(s.bgFx)
if s.bgFxColor then State.bgEffectColor=c3((s.bgFxColor[1]or 1)*255,(s.bgFxColor[2]or 1)*255,(s.bgFxColor[3]or 1)*255)end
if s.logo then ui:SetLogo(s.logo)end
if s.icon then ui:SetIcon(s.icon)end
end
if State.settingsTab then
local mirror={
["Performance mode"]=State.lite==true,["Smart FPS"]=State.smartFps~=false,
["Animations"]=State.noAnim~=true,["Hover effects"]=State.hoverEffects~=false,
["Keybind overlay"]=State.hotkeyEnabled~=false,["Collapse sidebar"]=not State.sidebarPinned,
["Inline dropdowns"]=State.dropdownInline==true,["Rainbow"]=State.rainbow==true,
["Checkbox style"]=State.checkboxStyle==true,
}
for _,sec in ipairs(State.settingsTab.sections or{})do
for _,it in ipairs(sec.items or{})do
if it.type=="checkbox"and mirror[it.label]~=nil then it.value=mirror[it.label]end
end
end
end
State._loadingConfig=nil
end
function ui:LoadConfig(name)
name=tostring(name or State.configName or"default")
State._lastLoadOk=false
local path=ConfigDir().."/"..name..".json"
if not(IsFile and IsFile(path)and ReadFile)then return self end
local raw=ReadFile(path)
local data=raw and JsonDecode(raw)
if type(data)~="table"then return self end
pcall(ApplyConfig,data)
State._loadingConfig=nil
State._lastLoadOk=true
return self
end
local function AutoloadFile()return ConfigDir().."/_autoload.json"end
local function ReadPrefs()
local f=AutoloadFile()
if not(IsFile and IsFile(f)and ReadFile)then return{}end
local raw=IsFile(f)and ReadFile(f)
local t=raw and JsonDecode(raw);return(type(t)=="table")and t or{}
end
local function ReadAutoload(base)local t=ReadPrefs();return base and t[tostring(base)]end
local function WriteAutoload(base,name)
if not base then return end
local t=ReadPrefs();t[tostring(base)]=name
EnsureFolder()
WriteFile(AutoloadFile(),JsonEncode(t))
end
local function ReadAutoSave(base)local t=ReadPrefs();local v=base and t["autosave:"..tostring(base)];if v==nil then return nil end;return v==true end
local function WriteAutoSave(base,on)
if not base then return end
local t=ReadPrefs();t["autosave:"..tostring(base)]=on==true
EnsureFolder()
WriteFile(AutoloadFile(),JsonEncode(t))
end
function ui:ExportConfig()
local enc=JsonEncode(PackConfig())
if not enc or not Base64Encode then return nil end
local code=Base64Encode(enc)
return(ok and code)and("INScfg_"..code)or nil
end
function ui:ImportConfig(code)
code=tostring(code or"")
local b=string.match(code,"^INScfg_(.+)$")or code
if not Base64Decode or b==""then return self end
local json=Base64Decode(b)
if ok and type(json)=="string"then
pcall(ApplyConfig,JsonDecode(json))
State._loadingConfig=nil
end
return self
end
function ui:ListConfigs()
local out={}
for _,f in ipairs(ListFiles(ConfigDir()))do local n=string.match(f,"([^/\\]+)%.json$")if n and n:sub(1,1)~="_"then out[#out+1]=n end end
return out
end
function ui:DeleteConfig(name)
name=tostring(name or"")
if name~=""then DeleteFile(ConfigDir().."/"..name..".json")end
return self
end
function ui:SetBackgroundEffect(name)
local valid=false
if name then for _,e in ipairs(FX_LIST)do if e==name then valid=true;break end end end
State.bgEffect=(valid and name~="Off")and name or nil
return self
end
function ui:BackgroundEffects()return FX_LIST end
function ui:SetBackgroundEffectColor(c)State.bgEffectColor=c;return self end
function State.imgBytes(target,legacy)
local function isImageBytes(b)
if type(b)~="string"or#b<24 then return false end
local a,c=string.byte(b,1,2)
return(a==0x89 and c==0x50)or(a==0xFF and c==0xD8)or(a==0x47 and c==0x49)
end
local b
if IsFile(target)then b=ReadFile(target)end
if isImageBytes(b)then return b end
local h=5381
for i=1,#target do h=(h*33+string.byte(target,i))%2147483648 end
local cache=LibName.."_img_"..string.format("%08x",h)..".dat"
b=IsFile(cache)and ReadFile(cache)or nil
if isImageBytes(b)then return b end
legacy=legacy or("INSui_img_"..string.format("%08x",h)..".dat")
if legacy then
b=IsFile(legacy)and ReadFile(legacy)or nil
if isImageBytes(b)then WriteFile(cache,b);return b end
end
b=game:HttpGet(target)
if isImageBytes(b)then WriteFile(cache,b);return b end
return nil
end
function ui:SetBackgroundImage(url,alpha,wFrac,hFrac)
State.bgImgAlpha=alpha or State.bgImgAlpha or 0.5
State.bgImgWFrac=tonumber(wFrac)
State.bgImgHFrac=tonumber(hFrac)
if State.bgImg then State.bgImg.Visible=false;State.bgImg:Remove();State.bgImg=nil end
if url~=nil and url~=""then
local s=tostring(url)
local s1,s2=string.byte(s,1,2)
if#s>24 and((s1==0x89 and s2==0x50)or(s1==0xFF and s2==0xD8))then
State.bgImgUrl=nil
local img=Drawing.new("Image");img.Data=s;img.Visible=false;State.bgImg=img
return self
end
end
State.bgImgUrl=(url~=nil and url~="")and tostring(url)or nil
local target=State.bgImgUrl
if not target then return self end
task.spawn(function()local b=State.imgBytes(target,LibName.."_bg_"..tostring(#target)..".dat")if b and#b>12 then local b1,b2=string.byte(b,1,2)if(b1==0x89 and b2==0x50)or(b1==0xFF and b2==0xD8)then if State.bgImgUrl==target then local img=Drawing.new("Image");img.Data=b;State.bgImg=img end end end end)
return self
end
function ui:SetLogo(src)
if State.logoImg then State.logoImg.Visible=false;State.logoImg:Remove();State.logoImg=nil end
if src==nil or src==""then State.logoSrc=nil;return self end
local target=tostring(src)
local s1,s2=string.byte(target,1,2)
if#target>24 and((s1==0x89 and s2==0x50)or(s1==0xFF and s2==0xD8))then
State.logoSrc=nil
local img=Drawing.new("Image");img.Data=target;img.Visible=false;State.logoImg=img
return self
end
State.logoSrc=target
task.spawn(function()local b=State.imgBytes(target,LibName.."_logo_"..tostring(#target)..".dat")if b and#b>12 then local b1,b2=string.byte(b,1,2)if(b1==0x89 and b2==0x50)or(b1==0xFF and b2==0xD8)then if State.logoSrc==target then local img=Drawing.new("Image");img.Data=b;img.Visible=false;State.logoImg=img end end end end)
return self
end
function ui:SetIcon(src)
if State.iconImg then State.iconImg.Visible=false;State.iconImg:Remove();State.iconImg=nil end
if src==nil or src==""then State.iconSrc=nil;return self end
local target=tostring(src)
local s1,s2=string.byte(target,1,2)
if#target>24 and((s1==0x89 and s2==0x50)or(s1==0xFF and s2==0xD8))then
State.iconSrc=nil
local img=Drawing.new("Image");img.Data=target;img.Visible=false;State.iconImg=img
return self
end
State.iconSrc=target
task.spawn(function()local b=State.imgBytes(target,LibName.."_icon_"..tostring(#target)..".dat")if b and#b>12 then local b1,b2=string.byte(b,1,2)if(b1==0x89 and b2==0x50)or(b1==0xFF and b2==0xD8)then if State.iconSrc==target then local img=Drawing.new("Image");img.Data=b;img.Visible=false;State.iconImg=img end end end end)
return self
end
local WAIFU_BG="https://raw.githubusercontent.com/nvqren/Matcha-Waifu/refs/heads/main/waifu.png"
local function ApplyThemeExtras(name)
if name=="Waifu"then
Theme.bg=c3(15,19,13);Theme.sidebar=Theme.bg
ui:SetBackgroundImage(WAIFU_BG,0.12)
elseif name=="NeverBlox"then
Theme.bg=c3(15,16,21);Theme.sidebar=c3(12,13,17)
ui:SetBackgroundImage(nil)
elseif name=="Lemon"then
Theme.bg=c3(18,17,13);Theme.sidebar=c3(18,17,13)
ui:SetBackgroundImage(nil)
else
Theme.bg=c3(15,15,15);Theme.sidebar=Theme.bg
ui:SetBackgroundImage(nil)
end
end
function ui:ApplyThemePreset(name)
local p=ThemePresets[name]
if p then Theme.accentA=p[1];Theme.accentB=p[2];ApplyThemeExtras(name)end
return self
end
function ui:ThemePresets()
local out={}
for k in pairs(ThemePresets)do out[#out+1]=k end
table.sort(out)
return out
end
function ui:FontChoices()
local out={}
for _,c in ipairs(FONT_LIST)do out[#out+1]=c[1]end
return out
end
function ui:SetFont(name)
if type(name)~="string"then
for _,c in ipairs(FONT_LIST)do if c[2]==name then name=c[1];break end end
end
State.uiFont=FontByName(name)
State.uiFontName=type(name)=="string"and name or"Default"
return self
end
function ui:SetLayout(mode)
State.tabLayout=(mode=="Top"or mode=="top")and"top"or"side"
return self
end
local function Teardown()
if State.destroyed then return end
State.destroyed=true
State.open=false
State.dropdown=nil;State.colorpicker=nil;State.focus=nil
SetGameInput(true);State.inputState=true
RemoveAllDrawings()
for _,t in ipairs(State.tabs)do
if t._img then t._img:Remove();t._img=nil end
for _,sec in ipairs(t.sections)do
for _,it in ipairs(sec.items)do
if it._img then it._img:Remove();it._img=nil end
end
end
end
if State._gearImg then State._gearImg:Remove();State._gearImg=nil end
if State.bgImg then State.bgImg:Remove();State.bgImg=nil end
if State.avatarImg then State.avatarImg:Remove();State.avatarImg=nil end
if State.logoImg then State.logoImg:Remove();State.logoImg=nil end
if State.iconImg then State.iconImg:Remove();State.iconImg=nil end
end
function ui:Destroy()
State.alive=false;State.open=false
if not State.rendering then Teardown()end
end
ui.Unload=ui.Destroy
local function AnyListening()
if State.kbCapture or State.spotlightOpen then return true end
if State.colorpicker and State.colorpicker.hexInput then return true end
for _,it in ipairs(KeybindItems)do if it.keybind and it.keybind.listening then return true end end
return false
end
local function UpdateRainbow()
if not State.rainbow then return end
local t=(Clock())*(State.rainbowSpeed or 0.3)*0.3
Theme.accentA=hsv(t%1,0.65,1)
Theme.accentB=hsv((t+0.12)%1,0.72,1)
end
local function DrawDialog(click)
local d=State.dialog
State._dlgA=Approach(State._dlgA or 0,d and 1 or 0,18)
local a=State._dlgA
if a<0.01 then return click end
local vw,vh=ScreenSize()
DrawRect(0,0,vw,vh,c3(0,0,0),450,0,0.5*a)
if not d then return click end
local dw=344
local lines=WrapText(d.text or"",dw-44,13,FontSystem)
if#lines==0 then lines={""}end
local dh=92+#lines*18
local dx=floor(vw/2-dw/2)
local dy=floor(vh/2-dh/2)-floor((1-a)*12)
local accentMid=State._accentMid
DrawRect(dx+3,dy+6,dw,dh,c3(0,0,0),451,12,0.3*a)
DrawRect(dx,dy,dw,dh,Theme.bg,452,12,0.99*a)
DrawStroke(dx-1,dy-1,dw+2,dh+2,accentMid,453,13,0.10*a)
DrawStroke(dx,dy,dw,dh,WHITE,453,12,0.22*a)
DrawText(d.title,dx+22,dy+18,accentMid,16,FontBold,454,false,false,dw-44,a)
for i=1,#lines do
DrawText(lines[i],dx+22,dy+48+(i-1)*18,WHITE,13,FontSystem,454,false,false,dw-44,Alpha.Label*a)
end
local bh,gap=30,10
local by=dy+dh-bh-16
local bw=(dw-44-gap)/2
local cancelX=dx+22
local confirmX=cancelX+bw+gap
local cancHov=IsMouseIn(cancelX,by,bw,bh)
local confHov=IsMouseIn(confirmX,by,bw,bh)
DrawStroke(cancelX,by,bw,bh,WHITE,454,6,(cancHov and 0.4 or Alpha.Hairline)*a)
DrawTextMid(d.cancel,cancelX+bw/2,by+bh/2,WHITE,13,FontBold,455,(cancHov and Alpha.Text or Alpha.Dim)*a)
DrawRect(confirmX,by,bw,bh,accentMid,454,6,(confHov and 0.32 or 0.2)*a)
DrawStroke(confirmX,by,bw,bh,accentMid,455,6,(confHov and 0.95 or 0.6)*a)
DrawTextMid(d.confirm,confirmX+bw/2,by+bh/2,accentMid,13,FontBold,455,a)
if a>0.5 then
if Input.esc.click then State.dialog=nil;if d.onCancel then pcall(d.onCancel)end;Input.esc.click=false;return false end
if click then
if IsMouseIn(confirmX,by,bw,bh)then State.dialog=nil;if d.onConfirm then pcall(d.onConfirm)end;return false end
if IsMouseIn(cancelX,by,bw,bh)or not IsMouseIn(dx,dy,dw,dh)then State.dialog=nil;if d.onCancel then pcall(d.onCancel)end;return false end
end
end
return false
end
local Step
do
local function openSpot()
State.spotlightOpen=not State.spotlightOpen
if State.spotlightOpen then
State.spotlight={query="",sel=1}
State.focus=nil
end
end
local function hitMenuKey()
if State.minimized then
State.minimized=false
if State.minPos then
State.x,State.y=State.minPos.x,State.minPos.y
ClampWindow()
end
SetOpen(true)
else
SetOpen(not State.open)
end
end
local function refreshIcons()
if not State._rebuildIcons then return end
local accent=State._accentMid
local key=floor(Round(accent.R*255)/8)*65536
+floor(Round(accent.G*255)/8)*256
+floor(Round(accent.B*255)/8)
local sig=#(State.tabs or{})
for _,tab in ipairs(State.tabs or{})do
if tab.subs then sig=sig+#tab.subs*97 end
end
if State.settingsTab then sig=sig+991 end
local tabsChanged=State._iconSig~=sig
if not tabsChanged and State._iconAccentKey==key then return end
local now=Clock()
if tabsChanged or not State._iconGenT or(now-State._iconGenT)>=0.13 then
State._iconAccentKey=key
State._iconSig=sig
State._iconGenT=now
State._rebuildIcons()
end
end
local function arrowTabs()
local live=State.open and not State.spotlightOpen and not State.focus
and not State.dropdown and not State.colorpicker and#State.tabs>0
if not live then return end
local function jump(Step)
local i=State.activeIndex
repeat i=i+Step until i<1 or i>#State.tabs or not State.tabs[i].hidden
if i>=1 and i<=#State.tabs then
State.activeIndex=i
State.activeTab=State.tabs[i]
State.contentFade=0
end
end
if Input.left.click then jump(-1)end
if Input.right.click then jump(1)end
end
local function releaseDrags()
State.drag=nil
State.resizeEdge=nil
State.sliderDrag=nil
State.scrollDrag=nil
State.cpDrag=nil
State.hkDrag=nil
State.contentDrag=nil
State.textDrag=nil
State.spTextDrag=nil
if State.dropdown then State.dropdown._sbDrag=nil end
if State.spotlight then State.spotlight._sbDrag=nil end
end
function Step()
ResetPool()
State.tooltipText=nil
State._vpW=nil
local now=Clock()
State.dt=Clamp(now-State.lastFrame,0,0.05)
State.lastFrame=now
ReadMouse()
UpdateInput()
State.drawVisible=Approach(State.drawVisible,State.open and 1 or 0,12)
if State.drawVisible>0.997 then State.drawVisible=1
elseif State.drawVisible<0.003 then State.drawVisible=0 end
if(Input.lctrl.held or Input.rctrl.held or Input.ctrl.held)and Input.space.click then
openSpot()
Input.space.click=false
end
local mk=Input[MenuKey]
if mk and mk.click and not State.focus and not AnyListening()then hitMenuKey()end
RunTextInput()
if not State.spotlightOpen then RunKeybinds()end
State._captureKeybind()
UpdateRainbow()
State._accentMid=LerpColor(Theme.accentA,Theme.accentB,0.5)
refreshIcons()
arrowTabs()
if Input.m1.released then releaseDrags()end
local click,held,rightClick=Input.m1.click,Input.m1.held,Input.m2.click
if State.drawVisible<0.01 and not State.open then
HideWindowDrawings()
click=DrawBoxes(click,held)
click=DrawKeyOverlay(click,held)
click=DrawSearch(click)
DrawNotifications()
DrawDialog(click)
HideUnused()
return
end
ClampWindow()
local wasSpot=State.spotlightOpen
local spotClick,dlgClick=click,click
if wasSpot or State.dialog then
click,rightClick,held=false,false,false
end
click=DrawKeyOverlay(click,held)
click=DrawBoxes(click,held)
local mA=State.minA or 0
if mA<0.06 then
click,held,rightClick=DrawWindow(click,held,rightClick)
click,rightClick=DrawDropdown(click,rightClick)
click=DrawColorpicker(click,held)
click=DrawKeyMenu(click)
DrawTooltip()
State.lastTooltipText=State.tooltipText
if click and State.focus then State.focus=nil end
else
HideWindowDrawings()
end
ApplyInputState(false)
click=DrawBubble(click,held)
mA=State.minA or 0
if mA>0.06 and mA<0.9 then click=false end
click=DrawSearch(wasSpot and spotClick or false)
DrawNotifications()
DrawDialog(dlgClick)
if not State.lite and mA<0.06 then
local r=State._winRect
if r then DrawBackgroundFx(r.x,r.y,r.w,r.h,r.th,r.v)end
end
HideUnused()
end
end
local function SafeStep()
if ReadGlobal(LibName.."InstanceId")~=InstanceId then State.alive=false end
if not State.alive then
Teardown()
return
end
State.rendering=true
local ok,err=pcall(Step)
State.rendering=false
if not ok then
ui:Notify("error",tostring(err),6)
State.errorCount=State.errorCount+1
SetGameInput(true);State.inputState=true
HideAll()
if State.errorCount>=3 then State.alive=false;Teardown()end
else
State.errorCount=0
end
end
local function FrameDelay()
local full=State.lite and(1/60)or(1/144)
if State.smartFps==false then return full end
local mx,my=State.mouseX or 0,State.mouseY or 0
local moved=mx~=(State._lastMX or-1)or my~=(State._lastMY or-1)
State._lastMX,State._lastMY=mx,my
if moved
or(Input.m1 and Input.m1.held)or(Input.m2 and Input.m2.held)
or State.drag or State.resizeEdge or State.scrollDrag
or State.dropdown or State.colorpicker or State.focus
or State.kbCapture or State.spotlightOpen then
State._lastAct=Clock()
end
local dv,mA,cf=State.drawVisible or 0,State.minA or 0,State.contentFade or 1
local animating=(dv>0.01 and dv<0.99)or(mA>0.01 and mA<0.99)or(cf<0.99)
or(State.rainbow and State.open)
if animating then return full end
if State.open and((Clock())-(State._lastAct or 0))<0.5 then return full end
return 1/30
end
task.spawn(function()while State.alive do if State._winReady and not State._didAutoload and ReadGlobal(LibName.."InstanceId")==InstanceId then local ic=0 for _,t in ipairs(State.tabs)do for _,sc in ipairs(t.sections)do ic=ic+#sc.items end end local settled=(ic>0 and ic==State._setupCount)State._setupCount=ic State._setupFrames=(State._setupFrames or 0)+1 if settled or State._setupFrames>40 then State._didAutoload=true local asPref=ReadAutoSave(State._baseConfigName)if asPref~=nil then State.autoSave=asPref end local pref=ReadAutoload(State._baseConfigName)if pref then State.configName=pref pcall(function()ui:LoadConfig(State.configName)end)if State._lastLoadOk then pcall(function()ui:Notify("config","auto-loaded: "..tostring(pref),4,"info")end)end end pcall(function()State._lastCfgEnc=JsonEncode(PackConfig())end)end end SafeStep()if State.alive and State._didAutoload and State.autoSave and((Clock())-(State._autoSaveT or 0))>1.2 then State._autoSaveT=Clock()pcall(function()local enc=JsonEncode(PackConfig())if enc and enc~=State._lastCfgEnc then local p=ConfigDir().."/"..tostring(State.configName or"default")..".json"if WriteFile and(State.configName==State._baseConfigName or(IsFile and IsFile(p)))then EnsureFolder();WriteFile(p,enc);State._lastCfgEnc=enc end end end)end if State.alive then task.wait(FrameDelay())end end Teardown()end)
local BuildSettingsTab
do
local function themeSection(tab)
local th=tab:Section("Theme","Left")
State.baseAccentA=State.baseAccentA or Theme.accentA
State.baseAccentB=State.baseAccentB or Theme.accentB
if not State.defaultTheme then
State.defaultTheme={
accentA=Theme.accentA,accentB=Theme.accentB,
bg=Theme.bg,text=Theme.text,sidebar=Theme.sidebar,
}
end
local choices={"Default"}
for _,name in ipairs(ui:ThemePresets())do choices[#choices+1]=name end
local presetDrop,c1pick,c2pick
local function applyAccents(a,b)
State.baseAccentA,State.baseAccentB=a,b
if not State.rainbow then Theme.accentA,Theme.accentB=a,b end
end
local function markCustom()
if presetDrop and not State._loadingConfig then presetDrop:Set({"Custom"})end
end
presetDrop=th:Dropdown("Preset",{"Default"},choices,false,function(v)local name=v[1]if name=="Default"then local d=State.defaultTheme applyAccents(d.accentA,d.accentB)Theme.bg,Theme.text,Theme.sidebar=d.bg,d.text,d.sidebar if c1pick then c1pick.item.value=d.accentA end if c2pick then c2pick.item.value=d.accentB end elseif name and name~="Custom"then local preset=ThemePresets[name]if preset then applyAccents(preset[1],preset[2])ApplyThemeExtras(name)if c1pick then c1pick.item.value=preset[1]end if c2pick then c2pick.item.value=preset[2]end end end end,"Default = the look this script ships with; pick a preset, or a colour below for Custom",true)
c1pick=th:Colorpicker("Color 1",Theme.accentA,function(c)applyAccents(c,State.baseAccentB)markCustom()end)
c2pick=th:Colorpicker("Color 2",Theme.accentB,function(c)applyAccents(State.baseAccentA,c)markCustom()end)
State._c1pick,State._c2pick=c1pick,c2pick
th:Toggle("Rainbow",State.rainbow==true,function(on)if on then State.baseAccentA=State.baseAccentA or Theme.accentA State.baseAccentB=State.baseAccentB or Theme.accentB else Theme.accentA=State.baseAccentA or Theme.accentA Theme.accentB=State.baseAccentB or Theme.accentB end State.rainbow=on end)
th:Slider("Rainbow speed",30,1,5,200,"%",function(v)State.rainbowSpeed=v/100 end)
end
local function appearanceSection(tab)
local apr=tab:Section("Appearance","Left")
apr:Colorpicker("Background",Theme.bg,function(c)Theme.bg=c;Theme.sidebar=c end,1)
apr:Colorpicker("Text color",Theme.text,function(c)Theme.text=c end,1)
apr:Slider("Card glow",100,5,0,200,"%",function(v)State.glowMul=v/100 end,"strength of the accent glow when you hover a section card")
apr:Dropdown("Background FX",{State.bgEffect or"Off"},FX_LIST,false,function(v)State.bgEffect=(v[1]and v[1]~="Off")and v[1]or nil end,"decorative particles behind the menu (off by default)")
apr:Colorpicker("FX colour",c3(255,255,255),function(c)State.bgEffectColor=c end,1)
:Tooltip("recolour the background particles; untouched = each effect's own colour")
apr:Slider("Border",6,1,0,30,"",function(v)Alpha.CardStroke=v/100 Alpha.Hairline=v/100*1.6 end,"how visible the card / control outlines are")
apr:Slider("Frost",3,1,0,12,"",function(v)Alpha.Card=v/100 end,"how milky the card fills are")
apr:Slider("Corner radius",Round((State.roundScale or 1)*100),5,0,250,"%",function(v)State.roundScale=Clamp((tonumber(v)or 100)/100,0,2.5)end,"roundness of every corner; 100% = default, 0% = sharp")
apr:Toggle("Performance mode",State.lite==true,function(on)State.lite=on end,"lite rendering for weak PCs: 60fps, no shadow / outer glow / animations, sidebar stays open")
apr:Toggle("Smart FPS",State.smartFps~=false,function(on)State.smartFps=on end,"drop to ~30fps when idle / minimized / closed and jump to full speed on activity, frees the CPU for the game")
end
local function interfaceSection(tab)
local ifa=tab:Section("Interface","Right")
ifa:Keybind("Menu key",MenuKey,function(k)ui:SetMenuKey(k)ui:Notify("menu key","set to "..string.upper(k),2)end,"the key that opens / closes this menu")
ifa:Toggle("Keybind overlay",State.hotkeyEnabled~=false,function(on)State.hotkeyEnabled=on end)
ifa:Toggle("Hover effects",State.hoverEffects~=false,function(on)State.hoverEffects=on end)
ifa:Toggle("Checkbox style",State.checkboxStyle==true,function(on)State.checkboxStyle=on end,"Draw every toggle as a filling checkbox instead of a switch")
ifa:Toggle("Collapse sidebar",not State.sidebarPinned,function(on)State.sidebarPinned=not on end,"on = the sidebar shrinks to an icon rail and expands on hover; off = it always stays open")
ifa:Toggle("Inline dropdowns",State.dropdownInline==true,function(on)State.dropdownInline=on end,"put the dropdown box on the same row as its label instead of below it")
ifa:Dropdown("Tab layout",{State.tabLayout=="top"and"Top"or"Sidebar"},{"Sidebar","Top"},false,function(v)if v[1]then ui:SetLayout(v[1]=="Top"and"top"or"side")end end,"tabs on the left rail or across the top")
local style=State.searchStyle or"bar"
ifa:Dropdown("Search",{style:sub(1,1):upper()..style:sub(2)},{"Bar","Icon","Off"},false,function(v)if v[1]then State.searchStyle=string.lower(v[1])end end,"titlebar search: a bar, just an icon, or hidden (Ctrl+Space always works)")
ifa:Dropdown("Font",{State.uiFontName or"Default"},ui:FontChoices(),false,function(v)if v[1]then ui:SetFont(v[1])ui:Notify("ui","font: "..v[1],2)end end,"UI font, Matcha built-ins only (custom web fonts can't be loaded into Drawing)",true)
ifa:Slider("Menu opacity",98,1,40,100,"%",function(v)State.menuOpacity=v/100 end)
ifa:Toggle("Animations",State.noAnim~=true,function(on)State.noAnim=not on end)
ifa:Slider("Notify time",5,1,1,15,"s",function(v)State.notifyDur=v end)
end
local function configSection(tab)
local cf=tab:Section("Configs","Right")
local nameBox=cf:Textbox("Name",State.configName or"default",function(t)State.configName=(t~=""and t)or"default"end)
nameBox.item.noSave=true
local saved,autoDrop
local function autoChoices()
local list={"Off"}
for _,name in ipairs(ui:ListConfigs())do list[#list+1]=name end
return list
end
local function refresh()
if saved then saved:UpdateChoices(ui:ListConfigs())end
if autoDrop then autoDrop:UpdateChoices(autoChoices())end
end
local function saveNow()
ui:SaveConfig(State.configName)
refresh()
ui:Notify("config","saved: "..tostring(State.configName),4,"success")
end
local function loadNow()
local name=State.configName
for _,existing in ipairs(ui:ListConfigs())do
if existing==name then
ui:LoadConfig(name)
ui:Notify("config","loaded: "..tostring(name),3)
return
end
end
ui:Notify("config","no config named "..tostring(name),3,"warning")
end
local function deleteNow()
ui:DeleteConfig(State.configName)
if saved then saved:Set({})end
refresh()
ui:Notify("config","deleted",3,"warning")
end
cf:Button("Save",saveNow):AddButton("Load",loadNow):AddButton("Delete",deleteNow)
saved=cf:Dropdown("Config",{},ui:ListConfigs(),false,function(v)if v[1]then State.configName=v[1]nameBox:Set(v[1])end end,"pick a saved config, then Load or Delete it",true)
saved.item.noSave=true
local pref=ReadAutoSave(State._baseConfigName)
if pref~=nil then State.autoSave=pref end
local autoSave=cf:Toggle("Auto-save",State.autoSave==true,function(on)ui:SetAutoSave(on)WriteAutoSave(State._baseConfigName,on)ui:Notify("config",on and"auto-save on"or"auto-save off",2)end,"save changes to the current config automatically as you change things; off = nothing is written until you press Save")
autoSave.item.noSave=true
autoDrop=cf:Dropdown("Auto-load",{ReadAutoload(State._baseConfigName)or"Off"},autoChoices(),false,function(v)local pick=v[1]if pick and pick~="Off"then WriteAutoload(State._baseConfigName,pick)ui:Notify("config","auto-load: "..pick,3)else WriteAutoload(State._baseConfigName,nil)ui:Notify("config","auto-load off",2)end end,"load a config every launch (Off = none); separate from Auto-save",true)
autoDrop.item.noSave=true
end
local function systemSection(tab)
local sys=tab:Section("System","Right")
sys:Button("Re-center window",function()ui:Center()ui:Notify("ui","re-centered",2)end)
sys:Button("Minimize",function()State.minimized=not State.minimized if State.minimized then State.minPos={x=State.x+6,y=State.y+4}State.dropdown=nil State.colorpicker=nil State.keyMenu=nil State.focus=nil end end)
end
function BuildSettingsTab(win,icon)
local tab=win:Tab("Settings",icon or"cog")
tab._tab.hidden=true
if State.activeTab==tab._tab then State.activeTab=nil end
State.settingsTab=tab._tab
State.settingsIcon=icon or"cog"
State.settingsIndex=#State.tabs
themeSection(tab)
appearanceSection(tab)
interfaceSection(tab)
configSection(tab)
systemSection(tab)
return tab
end
end
local function StripGlyphs(s)
s=tostring(s or"")
if s==""then return s end
local ok,out=pcall(function()local parts={}for _,cp in utf8.codes(s)do if cp<0x2190 and not(cp>=0x200B and cp<=0x200F)then parts[#parts+1]=utf8.char(cp)end end return table.concat(parts)end)
if not ok then out=(s:gsub("[\240-\244][\128-\191]*",""))end
return(out:gsub("%s+$",""):gsub("^%s+",""))
end
do
local function fetchGameName()
local Name=getgamename()
if type(Name)~="string"or Name==""then
Name=game.Name
if Name=="Game"or Name=="Ugc"then return end
end
State.subtitle=StripGlyphs(Name)
end
local function pickConfigFolder(config)
if config.configFolder and SafeFolder(config.configFolder)~=""then
State.cfgFolder=SafeFolder(config.configFolder)
return
end
local folder=SafeFolder(State.title)
if folder==""or folder=="uilib"then return end
State.cfgFolder=LibName.."_"..folder
local old="INSui_"..folder
if not IsFolder(State.cfgFolder)and IsFolder(old)then State.cfgFolder=old end
end
local function applyOptions(config)
if config.menuKey then ui:SetMenuKey(config.menuKey)end
if config.gameInput~=nil then ui:SetGameInput(config.gameInput)end
if config.logo then ui:SetLogo(config.logo)end
if config.logoSize then State.logoSize=Clamp(tonumber(config.logoSize)or 30,16,96)end
if config.icon then ui:SetIcon(config.icon)end
if config.opacity then ui:SetOpacity(config.opacity)end
if config.rounding~=nil then ui:SetRounding(config.rounding)end
if config.rowLines~=nil then ui:SetRowLines(config.rowLines)end
if config.checkboxStyle~=nil then ui:SetCheckboxStyle(config.checkboxStyle)end
if config.smartFps~=nil then State.smartFps=config.smartFps==true end
if config.keybindOverlay~=nil then State.hotkeyEnabled=config.keybindOverlay~=false end
if config.theme then ui:SetTheme(config.theme)end
if config.accent~=nil or config.accentA~=nil or config.accentB~=nil then
ui:SetAccent(config.accentA or config.accent,config.accentB or config.accent)
end
if config.font then ui:SetFont(config.font)end
if config.backgroundEffect then ui:SetBackgroundEffect(config.backgroundEffect)end
if config.backgroundEffectColor then ui:SetBackgroundEffectColor(config.backgroundEffectColor)end
if config.autoSave then ui:SetAutoSave(true)end
end
local function isImageBytes(bytes)
if not bytes or#bytes<12 then return false end
local a,b,c,d=string.byte(bytes,1,4)
return(a==0x89 and b==0x50 and c==0x4E and d==0x47)or(a==0xFF and b==0xD8)
end
local function useAvatar(bytes)
if not isImageBytes(bytes)then return false end
local Img=Drawing.new("Image")
Img.Data=bytes
Img.Visible=false
State.avatarImg=Img
return true
end
local function resolveUserId()
local Player=game:GetService("Players").LocalPlayer
for _=1,30 do
if Player.UserId~=0 then return Player.UserId end
task.wait(0.12)
end
local Body='{"usernames":["'..tostring(Player.Name)..'"],"excludeBannedUsers":false}'
local Reply=HttpRequest({Url="https://users.roblox.com/v1/usernames/users",Method="POST",Body=Body,Headers={["Content-Type"]="application/json"},})
local Text=Reply and(Reply.Body or Reply.body)
local Id=Text and string.match(Text,'"id":%s*(%d+)')
return Id and tonumber(Id)
end
local function fetchAvatar()
local Uid=resolveUserId()
if not Uid then return end
local Cache=LibName.."_av_"..tostring(Uid)..".dat"
if IsFile(Cache)and useAvatar(ReadFile(Cache))then return end
local Endpoints={
"https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..Uid.."&size=150x150&format=Png&isCircular=false",
"https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="..Uid.."&size=150x150&format=Png&isCircular=false",
"https://thumbnails.roblox.com/v1/users/avatar-bust?userIds="..Uid.."&size=150x150&format=Png&isCircular=false",
}
for _=1,5 do
for _,Endpoint in ipairs(Endpoints)do
local Meta=game:HttpGet(Endpoint)
local Url=string.match(Meta,'"imageUrl":"([^"]+)"')
if Url and Url~=""then
local Bytes=game:HttpGet((Url:gsub("\/","/")))
if useAvatar(Bytes)then
WriteFile(Cache,Bytes)
return
end
end
end
task.wait(0.7)
end
end
function ui:CreateWindow(config)
config=type(config)=="table"and config or{}
State.title=StripGlyphs(config.title or"uilib")
if config.subtitle=="auto"then
State.subtitle=""
task.spawn(fetchGameName)
else
State.subtitle=StripGlyphs(config.subtitle or"")
end
pickConfigFolder(config)
if config.size then
State.w,State.h=config.size.X,config.size.Y
State.wTarget,State.hTarget=State.w,State.h
end
if config.configName then State.configName=tostring(config.configName)end
State._baseConfigName=State.configName
local vw,vh=ScreenSize()
State.x=config.position and config.position.X or floor(vw/2-State.w/2)
State.y=config.position and config.position.Y or floor(vh/2-State.h/2)
applyOptions(config)
local win=setmetatable({},{__index=ui})
function win:Tab(name,icon)return ui:Tab(name,icon)end
function win:AddSettingsTab(icon)
if State.settingsApi then return State.settingsApi end
State.settingsApi=BuildSettingsTab(win,icon)
return State.settingsApi
end
function win:GetSettingsTab()return State.settingsApi end
function win:SettingsSection(name,side,desc)
return win:AddSettingsTab():Section(name,side or"Right",desc)
end
function win:SetLogo(src)return ui:SetLogo(src)end
function win:SetIcon(src)return ui:SetIcon(src)end
function win:SetOpacity(v)return ui:SetOpacity(v)end
function win:SaveConfig(n)return ui:SaveConfig(n)end
function win:LoadConfig(n)return ui:LoadConfig(n)end
function win:autoloadConfig(n)ui:LoadConfig(n or State.configName);return self end
task.spawn(fetchAvatar)
ApplyInputState(true)
State.open=(config.startOpen~=false)
State._autoSaveT=Clock()
State._winReady=true
return win
end
end
IconData={["target"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAB0klEQVR4nO2Y8VHCUAzGv3r8ryPgBLIBZQPdACZQJ8ANdANlAtmAMgF0A0bQCWoezWGtpMlL4ax3/d29612bl/eRvqR5DNBxBug4vcC2dF7ghfSgKIopjU0hM4UR9iWxafKVSA7p8gqFhICBoMJgdkfulvWbUgTvobOGHYvt/NhNKYLVX/xJ44nG9sfEJMkQAblMa7dG7Pey4jPxCHykeS84A7TMA12eD2KOCLRk8RbnQ/Xd18G2nEQg7aWw4ccoN34gvLo1banW20MSOENZB9dN2UrCrlBu8qnw/A1lkn0cex58k00oQWNe87cNnLC4Fb6jJhGiOJFEalzATyg9mjiwjbtMuSLIe26DOK4pijtE4o1ginhu4cCbxZZXW2cIB/+3H1Tw1LcdHHgjmCGeJRy4IshfiEXElIUng/drwQkX6ozGjWKa00hPWqgrZ4iVNJEXTNEcyYUmLqzRdMaxNKwTrXsm8yHKOldtFpbaa+Uu+xAEb8OqwkLO0nX3DWtbLGXG81mzkmoGlgjOOWnqx86Yc3FIiHHtVgrD+VvK4iBGq28ZiZzAJm4FPVo5+RtZBYaS8Q6FP/vrgw3DGSGHzAx2mmxzSdxeCzpOXwfb0gtsyxfbX+Kilrt4bgAAAABJRU5ErkJggg==",["crosshair"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAADMklEQVR4nM1Y/3XaMBA+8vi/bBB3gqQT1J0AMkHoBJAJSicITFAzAXSCOBM0TFBnA5iA3odPRIiTLBvxXr/39Kwn63Sfdbofcp/+c/QpIfb7/T2evV7vjRLhhhKByY358QdN+kmQjCBjbPVHlAhJTWxhQInQowvAphzyA+cul6chtuWGc1jiyWfyN3VEa4JMCiQmVJs0ixSruBXcFkx2Sy3QiiCTw9l6pnhiLipuT0xyHSsQTZDJgdhUebXjthbllYxl0vBBnxSZOZN8olQEmdwvOvVS4JXbjBWVDbI55nH76rwqWPY7XUqQFcypPnMG2LFxGzPJOtjNgk53FGdySl0JyqIrOiWXd80UkmlKh+RD6GN7gcXgrcgMWQpyAZIVty8+7w5lkimdeuvYRw5KuU1wVqVNTF52IWuMraGMdOer5/tesIK/9EHwlRfOlTnY5Wc6dyCDguqwslVkS/pwnIrnfNYWuPGQG9Hp7s1IJ/cSIEfy7kXmuphb/Ux0xhGkOm0Z7DyhZO7Mo8Bac3dQHGPnzIsmmFv9Mw+T8/VI8XhkmUwZX3t0HnFjKcUiMAfMdmfNqRS5nNpDM2Fl9e+MfnAxg30hhx0pSEeljMWY1kWmjNnOg3OaSz9nTht4/LXqwWQ4mFhiE/Ii6jbkWPvwZopcl2BdKWO2d+9ENzg8mJh73EEeKEjM7MSoTFm4pPbQ0llm9d+0WOvz4tLqD92X8nVLiseSZSplfOjReYSPoG3CgZRMLpCeNtSMDSmpTNYceHSGCUoQfbeGfihz4IE5hXcS73JPIWCv+e6raEK5eOYs4i2LJAgjzpnwg91Ye8yqlXE/ee6MWhIciKJbGcIufEtUbiEZGPPCUvetyy0RsM/OoTjwlVEdyQHT0E0v+GdBTLqgc5Ijak9upJBbNF0dGn99yJ1h6ZBcSc7Mm+QxR/L7ik7JLZvuIwf9FAnl8mQA84SunQNFZhFDrhVBIQmFIHpL3QCHmF7l4m4g3o2vH1M8URArqL6wb6kFLv15ZGJfLk9zU0PiRzgqqc6x0TuWlKANp8BQL1ldcK16sJUZQ0j5h7Xw9C9CMhMD1/iJnpTgNfAPyQ1XINTuz3oAAAAASUVORK5CYII=",["swords"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAADGUlEQVR4nM1YsW4TQRAdO1FEFQIlTSwRatJScWlRivwBxx84X5D4C7C/ALuFJgWijVMhKpI+COcHgNAQIUXOG9/a3tubm9293EV+0mh1d7Mzb3d2ZndvnVYc67TiKBCcTqdbaF4KuletVmtCNQA+Omi2hU8X8PHHftFyOh6jOaJy9GHgkO5H7j2arqLSg49jcgmamftNfgxh4B1VAHx8QJMGqD6Zz2TberlLYUiNoyhEkMtxaVM1RJGMJJeDjyCvtz3ISPgWRFIhNzK21TXtKzPnWAtjtGM44ue3VCRJZWtSI4c+qdEhDb4ZXBAyBoNn0lSElBRyrg8JdhZ30PwUdHJZC71hiVFXjyvClkZOmeFiFpsiPBCUczMUMZPXVI3cwC7WuRDjQzfEeSDJA8iVIdoLJDcyHJacBKWYMAbpOba9iWNDTJLQMDaYOEsupKDumQxJHBdqmWlgJtXEiSbYAMnSxCn1T4FoMnE0BB8W6g43bwyQI0hCml+KRB0zSdmGcErLhDlE3z7FEDQHWD79diAnMDCokeR/yIb1fIZ+iaCnnmb6lvEEznbnzjmMIacbRW/DeZ5QCbQ12BGcR681RW+OC1LuKBrBE6ru3K1/HyG3gt4lJHFvcjYa30kgnyCfBV//IM80cl6CNZHkmVtz3v2FbPvIMUJ3kkvhU2i414R3m5RVCC+8BA2JnZLPTHJRvwISwu3rvXS5fxa49s3DxI54lCn5sTiiczlC842KpYTDuin0HVJ2s1v4tUPvEuTqnpjHX5CngkEO945E0NxrvlPxSDVLCMrXVhu2rzFs7c0/tC1yHYsckUyOR/eC8neXnjXiVCDHA5plq7IEbF+JieQM7gyyo8ckw730zIzY4TAb/6nVh4twoc4pGc+4hn4pQV4/XyGPnE4cguchZQE2eFfgc98E0pX6mMH9oGKUbiCv0OdcJGg6vyG5sJaeOGJhBuGWGd609+Hji/2yUGaMwj5lo7Hhnb174EYiN+NT1sOEe0zZmjyDHISEOAQmxLzXv6bs+J/YYQ0iaBuri1gV29En6ofGyv/lvwPj/9coBGLaTwAAAABJRU5ErkJggg==",["user"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABjUlEQVR4nO2W7U3DQAyG36AOUCYgTABskA2ACegIYZNugJgA2KAbQCboMQHpBMFuXLWq2vuw0yg/7pGstLmL7tF92TNMnBkmTha0kgWtDCbYdV1Jjxv5+1sUhcMAXMEIiT1RrOknx0pize+4DUYKGCCBN3osAt2WNJuvUKKeQZKrEZZjaumrQjWDNOAc/ZLOIz9pKW5pJlskop1B3luxcpC+qv2oPcUl0imhQCt4j3Q036iX+AfpaL5Rz+Bogup7kE6ywz5zhGjoBI+6xAyfyk1EP+6zgBK1IM0IL1kFvyS3VdJXhSkXy8AlBaey5qCpkXelRW47BiZOLlitmASlSL3DPkvsnrt9t4KxeE3egyT1iP6KqRCfXx162U+S/UICUYJSXr1Q1FAm/QMcxZLiPab8CgqSHC/bxwBixziK59A15BUUuW9clgefZEjwD2mFqYaWBK/PNZ7NJDJ7l5Zj5jLWSXzXzBhywbEmf1H7igWHuHLKykbGOknokJQY/no5xvkyTa5mrGRBK1nQyj9JfnKIuCLRswAAAABJRU5ErkJggg==",["eye"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACl0lEQVR4nO1Y4XXaQAyW8/K/bFB3gpIJYiYoTFAyQdMJ4k7QMEHMBIEJ4k6QMAF0A5iA6sOye3F8J9nOy+OHv/cUBSzpPutsScclnTku6cwxEOyLgWBfvAvB4/E4ZvWp9vUhiqIX6omIOkAIfWNJRELIRdZdCLciyMS+s7plGVM3gOA9E11aHUwEmVjC6jd1J1YHiP5korlmqBJkcg+s5mTDX9GfjfYZk7wJGVz4LjCxEcsz6eSwXZOoQCyCG5/ItRDmWANr+QwiHzlWTxTeUmRrqj348kKtKJxVxMBN7kkjaCS3YUmaAnpIImbO8pVakmwi+MhqSmFcuZljn5jVHUvsLLZgm51jgxt+VuKu2GfmJchBQOxRCfKLg6SOz5zVg8f2hm0zxxZ+dxTGjH1WbwjKNmxZRkqAL2VmpPw8KfaTspxIpreK/V7WOG21+xbfGsht3G0THw2VjfhuFPvRKx/8aZG9P7xIUn5gvyMZIGWn9MlZXSsuVRYvHNYauY9ExedEUFK/pvbQtstqU8eyfJTcZ/De4Hhdq/oWn8pGfLXtBbLyn4qgvGkLg/PU8cko3M6Wbpkhvb4CC3eIqNdB3CGKbKgt7ago1HvHL6WiZ5d+aINZrV4iNgp1HIgNv7Ebu6mToOLn9HZCdtE4hUido1opKq9pU9GBivb5qrf7hgVLW1JHpRbkgKumwaNx3BJD9MQD+YFRaSvdxEcsgQ3pmZv5pqLgwCqZzCg8hQB4ZnIqnl8AfgkZOhPLPDSyWSZqLJKy/KD3BSpGqo1s5kOTZDOl4jTXB2sh9mIxbn3slDcVzRw1zXr2OJUdKl6sHbVAp3NxCdn+hP5P37HonWhkKbdO3k3oRfAjMPx41BcDwb4YCPbF2RP8B6CM/vT50VvlAAAAAElFTkSuQmCC",["monitor"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABL0lEQVR4nO2YgQ2CMBBFr8YBdANGcAN1Ah3BDcQJ1AnUDVzBCcQN3EDZgA3wH7aJIhDhYsHkXnIpVggv9Lhw7VPH6VPH+S/BNE0nGGaIEbXDFXEyxkRuwrgDyIUYdtQNVpDc80EmCLkAw426xRCSiVvioOCEC/llnPvNaRaVvSTT1zzwgc3/c36+V3Syb7mqe2odlKKCUlRQigpKUUEpKihFBaWooJTCD1Z83Q7IM7Yv+qDsCZ5xAXdVd/JDgAiL/nCCSW6eG5YjtUvmlC0x+gFumH13cVWcrNNbDs4RB0RM7RFbh4WbMCSkrF20iNtXrYNSGi2xrZNrer7tAyrfDeNET+y45b0W8iTINXJJ9ThAMKx5jdclrv30mKaCGzt+u9EZIfbUAHGZ+TVaZqQ8AFdjQ0+y/ANkAAAAAElFTkSuQmCC",["palette"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACqUlEQVR4nO2Y/3XaMBDHv/D4v2UC3AmSDeJOEDoBZoKECUInCJkgsAGZIGaCwgRVJyhMQO/C+SGrkixLcZrXl89794z1i69POunsAd45A7xz/n+Bx+Pxii653GZyVXLdkm16vd4ekfQQAYmaiKgx2eeALiXZmmzVVmwrgSQsp8sdzh5rC4tbkD2ECg0SSMLYS/dkBV4HRfaNRG6bGjYKFHHPZJd4feYk8ruvgVegiPuJsHUWy4xELlyVfVeF5rkuxTH39F+Fq7Lv6wj/tM7IhmRfyJ4s9U9SN5S2Ph5JZGarsE6xROsz3PB2UWjt2cu84EdS9IvsUo9UarOky8QzZkntv5qFLg/ewU+p34gQpRUpyzZSwk9ODzFGk0BZDzkaBjP6sAdHWtFIypx9HBRoEhg40IQE3LAIWTuPOB9zkN8v60ra3MA/vRXX5oP9tQapwW90H7k+eANfVzc1D0pw2MQdyDZkO6Szk7EOjvrazmFOcW7pwANxROZk3HmKeKY8Bo8lQg5NHfpoZkEDquqGfi8R58md9K3GUTglDiY1D5r5YGbpoCxlMfndPrCslkCEeLAWfRK1F2jPheW0uLa0U/rNwFcp8AbKpwpHFgfQLeKinPv8oLF4WtlzvCnnlnYlPAJd5IhPUnVY5NxTv9HXO2NOcYl/y61ZUBNI6ksEhH5HzGwZti1I1nh7Vq6k1SawxNvBszXVUzcTVz5Y0uUK3cH54hKnQ8C7p8YmrKHwsaiMsn3I21yF86UpIAMOYZjyVYHxnSQc8qnZyxyJhLx2KrJPiP0DAgn0Gwbn6cmQ4EnX21oojcmCiMzJVojAPLraEpLNvIiUvYpfCzcI5wGJxH5+K3D+/OZan/wg49QoTlrAjOyZnAVzQGU4pVJbPXtOIVlg13x8RE/lD10o3SFAI/ONAAAAAElFTkSuQmCC",["settings"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACVElEQVR4nO2Y7VHDMAyG33D8ByYg3aBMQJgANiBMQJmAMAF0gnYD2gloJ2g7QdMNYIIiEfWucWXHTvp1PZ47Xe4ix1ZkW5J9jiPnHEfOaRu4XC4v6fFK0rY0mZK8RVH0jZpEaAAZOKDHfUWzIRn4gJo0neLrLbWx0tSDS5925MHa45yhJrL+tt7W5Kyi45Tki6RHYm6EkHX1YPTblj6579T1YeQwjg2aGK9HJH0ZMHThD0RSksTQ3dAqmCLQwC+lo10xIgPvNIU6xWQceyfB/khkzA02PCgLmqc2xn7JyYst86XmwQ72bxwTk3My82XJg+K9OUloWBij2Dz5ajAUm+EWYXBKbK2nRtNAbedW8UQd9jWFrCvWXcCf0o4uTbEouvDnxWac9LcKK750zXCjhhnPP19QZzE88CgqfkhS+aESapiRhjzdM9j5gD99h47HaGvGMdZURx/kKCK/jSn8yR26gYylcvQVtdWDtG5iuNdNG/7EDt29jKXiSnWTCiOe4c+jQ/cX2mypbsNAavhOj09UB2uO/J2KNqufrap8eKxPGbvENgJ1hxZ512FcD2GZqbW+abRUx8qQyM+MoKe6BGFwPIytqQ6FkRmKo+Qh4CNqtv7CVm5xjGt0GquBmpk2Nom4t3Lx7wB1TFfJP0J4uVSXMTkm0RSuU532R1z3PZEMEc5Qvh0rutT2kfNALUdClpzkY70UEl0PfpRqRglnq8q97yzZUBNJT3PP5ld1L5BO9+pDWHi0maEBTQ2cbqmNlaZTzEE9g/sCMzvYBeY++L9Eb8ov04vnmGZXJSUAAAAASUVORK5CYII=",["sliders"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABa0lEQVR4nO2YgU3DMBBFf1AG6AhhgnYDnA0YgU5AR4ENGIENaDdIN/AGwAThrBgpRL7Qsy8mVH6S5TiJ7eudfT9ujZVTY+UUA1NZvYE3yEDf9w/9wBuEVMiAs2zUbKuqOl7Ydf0hDnqQfvCOqkcqDeI4k5cOo/HGHuyofEzet1SeqU83HYjzoFsrG8Qzt3R2zH1D5XZ6s46YYCmCc3IGGiouRA3i6GaenREO8VPo5bKLU8mSqIm9r08S7znEIfZqYNykNNkLFkZkIBlnMKSgoTOBhfmfXzMzSsImb+rj0sQWcVgwSsJJ3TsuUJJxiKnPkao7xGNpuOtXEudVLoxz6vEbFhpKUnZxAJGSeBU4+eYeGVALkU9N3+FvQykjBk0tdptq48sBSmiuwYa5TkKqJD+gMLbMo63wiGlRlCSdrGeST8iUxWLpM8kkxO7L2UABzTRjmesktBP1q2/eayXqv9gMIsofmKkUA1P5Am/6eNUAfuXtAAAAAElFTkSuQmCC",["shield"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABkUlEQVR4nO2Y7VHDMAyG3/T6n45gJqAjtBPABrgTMAKwQdggbEA3CBvABJQJIBME6aL8AeIvJbnc1c+dLpdasd9KbiN5jYWzxsI5H4Ft2xq6XMvtsSiKE0aggAIStUEnypLtfg2/sJHQZyhIEkjCdnS5Jbsh23jcv9GJfSKxb4gkWKCkkEVZMoM0TmQlIraAV6BE6x5/U6ilj2rtcnIKJHH8be8wLY8k8mFocFCgpPQD83A5lPKV4yGD+TBDA/lNoiUL1JIFaskCtWSBWlzvYq7zvjCHCGJobOV4iAvNT0yPcw1XscDUmJ7aNbh4gSEVNaf6AtPQ0FZy9jS+CDIVpqPyOYRE0NCFu7Gxo9iQbX3NkzeCMkGJ8SlDOruYtpOjeIVxeCdx2xDHkD3YY9GlRUsjcwURLFBOBSz02JgThpgIskhutg9I5yBzhK+JBGg/8v6pEf7L5rTuUs5moiLYIwsZsmOAO/uYFHFMkkCGiwkyPt3ak73+48Kf7dlHCo+0dTAS8odu5bZaxAHmHOSSX8sPoqdhh7W2pFsAAAAASUVORK5CYII=",["folder"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAA5UlEQVR4nO3Y0Q2CMBSF4VPDAG6gIzCCIziCbgAbuIFxAt1AN8ARcBM3wNuEGNqQiD2Q3of7JaSh4eEnTYBSQLkCylkgywJZo4Fd121l2GCal3PujYW4eELiKhnOmM7HnSTyggUEgRK3k6FBmptEHjGzVXS+R7qD3OAVM4sDS3B8ZKq7HOWvwJz86jUSuR5Oagr0fFw1nND4HAyWWWNgsMT2qmNZIMsCWRbIskCWBbIskKU+MP6ibpFf0BAHPpBf0BAEyr72KUONfOq+4cuNXdXvrNgt6L/asV8oDsrZY4ZlgSz1gR+92GNIRtdWlgAAAABJRU5ErkJggg==",["code"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABW0lEQVR4nO2X0XHCMAyGZR/vpRukG3QD0g06QtigI3QTugnpBG0nKCOQCVyJ6sGAQyQL5/Lg787nxOff+jBHHFawcFawcKqglSpopQpaqYJWPCgJITTYNqCEMpQFJSpBLPCM3Re2Hq/3ihzN7SnLa4hx0om8MBVa89DgnFsLsyG6PWJ7wey3JCvawYQc8QZyttE1rbGX7uSk4IjcFnfgA4Tw3CxJX1rOKunnkLNI+rnkciX9nHI5ki4h+ItdA4XkLmp12O2ioQPWeornpL7iS2n1qaFgM1E7KfiKbYjuO/ykO7gzvGYXDQ1c+4wrQX7Ct1BQckSuTZ0uyV9xSUmN3KhgKUmt3E3Be0vmyE0KTki+gxCe24FS7lQfhPBDtMf2wENHLPAozIYcOUL8wprYyR+Q8wkZcqe6oIRf2xss0itilGvh/6Q4KGJ6wbmpfzutVEErVdBKFbSyeME/RofOMy1Qvr4AAAAASUVORK5CYII=",["zap"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABnUlEQVR4nO2Y4U3DMBSEL6j/YQQzAdmAsAEjsAHdgG7QjACTECaATgCdAJggPLcOMiZW+/yuUn7kkyyndpOcznkXKwtMnAUmzizQyuQFnuEE9H3fSvuUdgEjFciIqFq61/DzsqqqDxg4hcBn6ZrdxQUYoT6DIu4WQZywAQF2kayj4y8QoAkU91bSuWioAwGKwFCt98nwpBxspaWR8gYC5ipLYiXGHDEehsDfWPlzYULEeExLnMRKDCViPNZncJ0ZF+39dWZuI+YeXUDFyxBi5QF6bkRgd+yfiwSGWHnH/8o9xIuIazQnlC7xCnpxw3kq1A6Kew5797Q8iXt3UFIicDRWDvAtrS7JRdUSh1BuoKctDW2Vg6E46sy0f91djYxvsXev6N2scjDcpBub88GXOW1ZKm53T5DICFTHSgpru+UyU0sYYW233MiYjxXzloslMC0cHytm9zwsgelbpbUURgylSOQZ7KQbdi9bEedAguXgeXRMWdoBloNDxJhjJcXsYBIxVPc8jCX2xeCr9pERKyn0bzNs5g+YVmaBVn4A2WB+p41hgdoAAAAASUVORK5CYII=",["box"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABOElEQVR4nO2X7Q2CMBRFb43/cQMZgQ3sCDqBjuBIOoGO0BEcQTfQCfA2oNZa1ORhK0lP0vRTe/KARxnjzxnjzxmmYF3XS1aapUQcjixGKbX1J5Q/QLkdqznSsKfkwh0YuR3KrZFOzjJvHe74l7hy2heWA+Jg9y2c9h1fsHTaB4ZbIwKMmmE1CzjkNCNm0IIF740Z4lB0TfiCBo+btWr7sTFu5ylRM2IlmtRSIA02tVXMHsfbwFOibic00qFdOYsKrWIkaySAci8+Oc1IyYJSRpCxVR+wayBA9BSHnrq+/08UQe6r+1jzjj7yoPkwr/EloQjmRC0lC0rJglKyoJTBHhYuiE9wzy5Bg/iY0GDXq65sfzBFHE4IfDBZOo9LlJywWqF52U/wG85oArGh3Dm04KvzXEpympFyBbWzVjAPa8AQAAAAAElFTkSuQmCC",["home"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABV0lEQVR4nO2XjW3CMBCFnysGYIRuUEagE1TdIN2go3QD2KDtBAkb0E2yQfosXVRo/s65AyLhTzoZcTb5dHEOZ4WFs8LCyYJW7kuwaZqXOIYQvuHEA5yg3I7DVwz57EKAEcqsOXwytv9SFeOV1axhwCQociVjMzDlyHi2SM6+xZSLUmNykFwpc2cxq4IncmvlkljBWMkjEkmuIOW2SJODzC1lbRJJgrxAgXS5llaySFmkFpQf9mgfuxRJ1R6UvlbAlz335NvUpMkKXkguUmga+mAFRxqwNxVGGnqvoKIBezPY0Du3+AZywF9D73SHvj34iOvKtWzk2md0BGO3DyfwqwMuxyGc0/mnySdqKx6CP4z3gdwH4wkGPARr7p2qL8Gn0nRYjeQ9aCULWsmCVlzaDOYzuVZz5N8b8mM5TV595I8njb4XpXrqVdKyVi14S/JTbCULWlm84C907Xp979DbtQAAAABJRU5ErkJggg==",["star"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAB2UlEQVR4nO2Y0XHCMAyGlR7vpRMQJmg6Qc0E7QiMACMwQVeADcoE0AlaJiCdoHQC+usqrhRsx7INl4d8dz4H25F/ZEV20qOW06OW0wlMpROYyg1lYr/fVyhbKRVloqBMQNQKlZGf66IoRpSBLALFY+8nzQ8Q+UGJ5FriSWCbmmQPwnt9VF+Wrh3KEF7cUQI5PDh2tPc9fcHk8OAWVenoruHBISWQ5EGIeya3OKaUMdEEeRCTlKgGh0npTxRP3pTz+El+Pbo+xOQmJD4Lj6gXyvQkNsAi5xA7tXVaBUKcQbWi62LNm64Y5IHfdD14rtrWYRUosWHoOiJ5DuOKR+dTLO4uUTZ0Odh25dsSvWnmyJNvlB+2yZ6rfYMa8yCLRDG4XFA+FmwzJM0EJ2oYG6OaUjozsRU2LylBCuKk+0RxLCFOtbPEHPnvKZ6BcrzOg56jlYY7zRFMe1gwlI7RDG69QG0MNp1cDjvPbYKNf2g9+OjpW8rklVzH2DgjWKCccGx8oow4ffCuIIVTyUj6NLbiBdJ57PByctItUdang6WNvTkLsOUkOM3IqZo3dY4vXsJJ0z56cu+cfpeX/1gVem/MTlLFvpDLC36tyYPZPn1ciu7zWyqdwFRaL/AH0duIDzY4li8AAAAASUVORK5CYII=",["skull"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAADMElEQVR4nM1Y63HbMAyGe/kfdYIyE8SeoMoEcSaoO0HdCeoNKk9geYI6E0SeoPYEVSeoM4EL2NAdDYIvWZfLd4ejCILgxzeoG3jnuIF3jkEJHo/HgtLRaHSAgTCCnmAyX1BKlIJTGw3KgdN1X9LZBJGYweQHypSJpYDI1ShLJNpCBrIIIrmfmMzhOlRI8nuqcRJBns4XlDEMgwblKWXaowQTyK1RWpQdnKeSULC9gfM61UD2DzGSo57kXlEqOE/XIcHHnOUWMknGCNbgjsBflCk63UEG0Bd1slFI0g6fQS5BdvhbqPcoZd8jg0ezQbkXRRNfh0MEaWpLob7LPSYUvwaTP0LdoN8Hzf6Dx8kMXHLLa8kR2MdSqEtu04FKEFxytCkWMBwW7DPU5gk+gp9Fvh70fj37qiNtnuAQ5DVihLqB4dGIvOmCDRvaCJZSgT3edN/UAZQVbSKWFXfqAordtwhBtW0t3DIiv7UbBXcHEqZYNuk2kcfutBHQZkIZmmbMk297aulo29iVtBEMHcALj74QZT67MZIKBRtO2xrB0GYw1vcWrNEVZdJub+Wn4IfTdkpE/cmjv4U0kN3RU3YPEaSMoOFrj9Ba+jFcBhGt51u1Y59FpG39qsPKtBbs3p0udF78VCZHjw7dsdgkQTslENmj3gnpfAd1LfKPdEYxAXJCMWC3Btc2OULMjs+7x0ibZ1+akh38E2rvhW7V6UYk+EjyBCIftTrqCLLhs1DTOVaBH9RoxfICfnKVQu7Z16FQuGVAX0dP9s3CtjNMVsLuK9rVwo6OmF/C7mL9JhMMONx1t4FlR4GtXOAt2t0l2DkdtuHbJCdwRTn0r4rpWNEZRSfrHkLkCEGC2OMS3LNKW4fLRF0t8gW34UWffzNOSISjMOez07CqleuvL1LexTTF2nORgtglJIBDrRkoz1f0UYTqBqeYUSs6aqiKTQ+TI5sK9HVaxeqnEFzAZTRio4Q4fDbkM0ow598M7Tb5bmgg/hwowSVJV990kH8zNpBoA57HTQa2SKxMNU6ZYhstXI9NjnHuCBrQr79UqCFVCH3/sC5AvylC2CC56KaQ6P2P+q3wH/rMb9XrhmAmAAAAAElFTkSuQmCC",["gauge"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACWElEQVR4nO2Y7VECMRCG9xj/qx1cB9KBZwVgBaYDsQK1AulArECsQKxAqYCjA6gA3+VyM3u5JCQXYPjBO7OTIyG5J7ubD7igE9cFnbjOgKk6A6ZqL4CbzeYKxY1RvcyyrKREZdRBGmgAG8IK2JXjqyvYDDaFfQF4RYcE1GCPsJEHyiWGuwPkX0yn4BADjr31Bsupm3hCPMb+AQH3jkJZmpawsX7pqvaO9nSfqvAzVJ2fU4rUzhA74L5gL6Hhwhj59mXGouGJ7MrLHsXBrWH3GHQYk0sMJuEYDBaULj0P3MiA43DmeFF0mIxxCxS/sHXIJDPHIDmKhahizxWxK9AYk/PymaodYI6x+iH9XIvkzficCleg4HTJdZUK7duzDMYzG4qq165wIte+BVxjPLSrTaVFvZi8gFSFoBaHdkzd4Aqqck2Ox6F9Mb6qdJkb33UCDsTzJPZ4cnjNhJEqxfMt+QD1rOURNqE4uILaXqvlShW5K/TNMJselI3riI3Y5zWWLbRbWbatggIBYxYGr9CRp12RXz9kZ0i/D1pWvanXlC3KBCwoXr5rlzO0oTJDXFK8Sk+bong1JpwMqC8BT5amp4jQXpKDwQyxHLC1J7kEkDFykfvWuThF3Sykr7g72hialwXLJeE+9fayS/qm/imqruXh0AixDtdcVCk6vJR4npsnl+2om4jngT4dDiK9RcmjtXXuZ5ZOnBMlNRP3GOKTq7VltTyoXdzpBpMo6zudP5rgyQmKBzqOPuAYZWvw/qrTqzqnw2rl2y87/fVxTJ3/fkvVGTBVJw/4D7296lpNRhmNAAAAAElFTkSuQmCC",["wrench"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACDklEQVR4nM2Yj3WCMBCHD58DdIPGCaoT1BF0guIG7QS1G9QJpBvYDewGdgJwg3YC+zsJNCAlCVyw33t5eUIgH5c/HozpnzN2bXg6nW5Q3RmHjlEUZRSYqO2klnpAeURRDU0ylARlA9kvCsCo7aTudEbNcqSPr1FSPMwzBSByaYTOE8ojaYPbPUlG00mQ8ZDcQXBJQoxcG6LTGNWbQ9MFHmZNQjhHsMAxkue5K7HKR0bHryix7QLHSPLqj0mAMoKQSylflStIJLYL0f5A1X2xTob7TKgnI92Zot+tZOsSSb7Mcl7p+/aiGGJVO94qiXNbVFOyo6gnbau4UVLLxTQQtm2mIjm0HBPpjhWqtKXdQdcuw2oy6bvVmKs4Q3VLcnC2o6gn5hDvSJaUBDAjqKRuapAgiivqQRlBPVdeSJZYL6zOXPwX44Z7VPckS+dINm0zC5R3kqVzJC8EOdlEYUke7m+So5OkyzvJmvKoNm1BR137bE9ew+2TUSuq/rdytpLph9hTe2ZTx1nSO2FtIqSkc8rfhn5JmqN8elzmNCdFBJlQkmKCTAhJUUFGWlJckJGUFFnFf9FxdS/xgGVmFVSQ6SB5gOCs+BFckPGVhGDpFWQONnTYZU6eGUSQ8ZCsZFKDDLGJZbg5e5qaL1qDRbDAiOSmduqDj9ffAgePYB1EdE75ym386Hl1QRvOX/mvxQ+3BNohn7iytgAAAABJRU5ErkJggg==",["bell"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABY0lEQVR4nO2YgY3CMAxFf08McGzQm+B6G+Q2uNugK3QCYAIYgQ1ggzICG9ANYINiwEgIUWrXrlRQnmRVtCE8OQl1MsLAGWHgREErH3CirutAUXIEOJHAARJK6bK7u/2VJEkFI14ZzIX31HjNwU/hPTWmIaahneCSqbShSUWxpKGeoSOdBEkso8sKzWL3VBT/JLqFErUgy5XQD+GB4lcrqRIkuZPUabV2nV8VxQ9JHqRf0K7iKWyTP+U+xIgzyNnbw4exNIuaDObwI5c21AgG+BGkDTV/1N/wQ9yXZg7WcITmoOi3Yz1oJQpaiYJWoqAV0auOCwVXpH22CnJHJfwpJZJPBW/kMvhzrszbJNsymKMfuSsZWkqvl1/FS1xK/IB+2FBRs3jWwOXoo0/MQ8zb0HnD46LLXvgWcwYbDo6ujDVbzEeYD4/4BKt48Kiwyp37hxN8JvjHH9ckt4ED779I+mbwgkd0cGLR5PM1UwAAAABJRU5ErkJggg==",["lock"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABq0lEQVR4nO2Y0VHDMAyGFa7vlA3SDWCChAnoCkwA2YANChuwQckEaSYAJmg2ACYIEiiHG+IktpRcHvzd6eyodu8/WZYTr2DhrECJuq4vsTnnx68oit5AgQgEoKg1Nndo92jr1s8V2jPaE4r9BE+8BXLEig5hbUjctW9EvQSyuFdw48pH5Bk4wstatNw5/EbpB+qzz6TgudMKhP/5douatmiHxkF98mE3M8atea4TzkuMUfiAP4E5C+kbf8Am4ccKx2/AAacIcu6Z0XscMe3B6Mf8H6NxXeKTHDKX1UbHGKc8VCvUUxEEShkUiEmdYnOD1t4g9FsB7uxwHp0uVLTzoTyOBsRR3drBtGQo0loNrAJRXIzNEebhwvZC0VdmYpgPa20Mu1hKEChFW2DJbQJK+LwPdvGOtsFSkZJRn31itATSC2vVPHB/CwpoCCxNcQ3sK0HI4jeJRgQTPhZPYJ94s2jl4N4Uyf09KKC1xHSWHvkDiUhBCe0cTEGZcNRJCQKl9AmsYD6st17WOshHVQbTk/VdcA5eHvFnJx38TncqI6CovYg+O5dA2MVSvgHw8nfpPNSjVwAAAABJRU5ErkJggg==",["search"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACM0lEQVR4nO2Y7VHCQBCGN47/pQOvA+nAUIF0YKwArEA6ECogVKBUYKxArIDYAVYQd8lmWDK55G5DMD94Z3Zycx+5h9u9uw3X0HNdQ891AWyr3gNe+XTOssygTdDe0LbZQVReoj3CiRW4dMKJB/iYoM0cuu/QpkEQrOAEagREuCE+lmhD8FOM9oygO2ihWkCG+0AblJrWaBu0lNsM2hjtttQvQcARdAHIbiW4YQmM3JdaxhBkjHYjqhfYfwodAM4hj7tCK5woggbxD0vQ7kT1CMcmoFBQM8kWDq5d4wRjcBTtdshDoFhJtattx0wEx3Hn5SIOgbmoChnaWzbAUJTXtphr0Lzmnc6yAcr42YBCfLx8iyoDCtmuOiPKKkCWPAMHoJDLXWzgNFIB2lz8I8oG9JIHdwoK2QClWx9AIb6FjKhKQCEb4LsoG74hfCWPpl/tQV0JiC+L6aWiasmHt5Owb4QPmXrFoFRdPihXYH8vuxy2DPcqquiHzkApKyCvoszpKKa+EOClajUp5ihphTw1k+1Rm5SrKd2iiSge7yuaaSMVExuw7/YiLXvSgLpm1OXMpknk1ghy1xa3EoGOfCGdvkk4n6Ns5BOawRZoBsfQyqeibZ/8+my2/dzgKd4oIU9IVrh6w1Cyb1Vu6LWS3oC+agvp9dmpEUOEcJzZOLu7c0BSG8izAJK0kGcDJNVAhrYxZwUkWSCtSXHnu9gmdusY8i++1Nbv3wBddfl/sK0ugG3Ve8A/XTrc2FB3eyMAAAAASUVORK5CYII=",["flame"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACOklEQVR4nO1Y7XHCMAxVewxAN8gGZYOGCWCDhgkoE8AIMEFhgtIJgA1ggsIEhQnSZ6pwic8fcuLc8YN3pwuxZPkhWY6SDt05OnTneBBsimeKgDzPE8gA0qXIaEwQpKa4/EDWkC+KjCeqCY7WJ2RYcQhQRNTagyql9B+tHrWMYIIgp0htINH3mwlBe5Aj5yTHNtEgJsh7TqXVF7nMMn8MeadAhKRYFYRkz01B5Be1smBilWLCfYrLBPqzwJesiuE040VCcYQkhvElCI5IAC9BjoA652IXxQIkP3xGkj2onLRRsWNOtxPOCLYYvQJbRLHvMvBFUG3sNs+71BdFCcEQrFhCkLmUvhTnJMcI6VryvIzkVX/GvBeb0hrBwCfCjZwC/xYdI0DXtZYrxQnJUCFXIJBkYlM07Qcr5FQjwc3EFYEkjWjS8vdBYFvclLoc9Vvp9sQkeSvXeRLVjuDIQq7LsjFEcuLwZ30u16niHRZMLeT0RW+RZNstLm+a3QU21rPWF8GDYWxWWrDoVEwLXHXai9TMYLclB3wE59r9pZxaXtDVgvWoRIrnXjSbNTUguNYc7jX9gPzQbco+TtSEIDeVM4dJQn64bGa+xtVbxXCg0ryzqE/kx8Ey/m064HVIj5khk3nVxpeCuXoKlQ9FOiMBRAQ5DSnkhKosdzhzskeIWHcrNJ6r/mgqfScRH9RweGSSPQNxU4u1MhDp4r4nJXddgyKBz7uC/D6EhAtRv6O0gccHzKZ4EGyKuyf4B8e71RBt5IsJAAAAAElFTkSuQmCC",["snowflake"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACRElEQVR4nO2Y7XHCMAyGlRz/YQQ2gA0aRugETScoG+BOUDpBwwTtBoQNGIERYAIqFftwjL/kuG1+8N754jS29FROZJkRDFwjGLgGD1hCJp3P5wm2N9kmkEk5Iyiwvch+gW0JGcSOIEbnCVtleTR39NW8iuYCUyxAdCDw0mDbYv+DMY/GbmmutBEtbgT1yNQxkHJM7bARFBdQYDtp915IC9xJ2ogW6yMpimIv378W2xiukBAJV5EN4PiEBKHzuQEZUhIcqfRArLB9SpiOpKMKusvNhiPb0sfKNblwwNV4Ue/WEdvC5QD8kfTCweXLVkn9Ecd9meNcETxofTKwTYgkB450tNiwA6LRFi+bHpBcuI30GQcoHddMSB1mz4SrwSFvHuRAhpQCFwTMBZkK9+PfMEQG6JO3Oa+Me3qp9WWcawC+Z0ot3IrmvCL40QW4hmvJ9F96R8CluhliRd1JNyagkFfbEj8Y95RKzGUcRzxT2sGtWmxr/Q9Re3HMxo9jWrj+Ezt8VmnPbDtOg2OeIaDgV5yjKnEk86h6svxtuL6QZQ44uYQz7U8zxrbohXRVMxVcEmssnJmESdwqaGHbj10RnPaEA+AXGDYb7q9Ynr7IuEiA0xWKpIBLcSGAA+gTAy4IGVLKwd268UM38e4gUxXEPbhHVyW5SrWUc3EQTskBKYAhLqD+DsXVc7eQrPeQe3AXuEQH7B5cZwjHPErGDXan2G+AIXa55XFAkVHFQmuZ10KCcv8+SKKUsoZMSsqDf6n7j+h99Q0A3W3gZBxT3QAAAABJRU5ErkJggg==",["bot"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAB3UlEQVR4nO2Yj1HCMBTGv3oOABt0A+sEhgkYAUbQCcQJxA1wBCYoTiBMIEwAG+B7NZUUSJrk0cqd/d29Sy/Nn++SvLzX3uLKucWV8z8E7vf7HhUjskxXLcnekyTZQUgCISSOReVkvaNXLG5AIpcQIBJI4lIqPnEqroRF3pPINSK5gYwJ7OKg300gQLqCW7gFMjtawT4iqXUSEqGoGOLgACZ14oo2NEZ+pp7P5pzEL1ydkxpxj1S8olmeSOTU9tIqUDvAF9qhb7uSXE6Soj0y24su1Em5eoGVM8gxleyZjJ0jR3vkPKeeu3J1JaY4LSrzHPRDlw8XalfC9+Og9GpzBacB4ngAxcbPF2hnkmktBcUKBt55nEaNzQrqP8NPuhXTzkZxN5YrmMKf3YXrbBS7GZPNDM2DrJ+HgnZOEqPzNqDfGodzwvE6FbY7R7HFphfP4H8+mub3/B5fMwuyO/wtKzJ1cs3oCkX2QrZB+2z03MrMbFzploI9mqyOB3LhsTsDW+Ia+00yDfmk1G1niCBWoEI4vqGuQmw2M6Jt4+3yXUXeYt8wWkGSbkVNGEqXsEpxCQwJ7FKsc1m9WP/0maN55q4fTHXXzJjsDc1Elo0ee+xqJP791jSdF0vpBEr5BitApEHVmA2+AAAAAElFTkSuQmCC",["ghost"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACkElEQVR4nO2Y0XHbMAyGoV7eqw2iTlB3gjITxBtEmaDqBKknqDdwNEHSCeJuIE9QZ4NqAheowDsaBiWQ8uXy4P8ORwsEyU80RYG6gneuK5ihw+FQYXGLRuVCVHdoe7RfRVHsIVMFZAjB7rD4AQOYRQS7RtAWEpUEiGBLLH6CHUxqj/YdQZ+tDT5YAxHuAYsnyIcDbvvEfZlkmkHscINFPRKyg2F2ugCE1uTnkTaPOJP3MBdwBK6HYR3SQH8jbUtuS3EfIQOymIBrYFhzUrTYmxgY6KBrtDulmtbkGlIBeQv5o1TdY4ePkKGRG/4U24rGHpKN4lvlwpF4plbGsYY2mhPv1GHxIty04S7hDML+aZu5Fe4b7H8rY2MzWCu+Bs6nxjhmFPCruG7nvK6kuK92Ysz/OgHE6af9qxJu886fINlnxWMfSUsWSumQrybeNvyW0U7sg7G4rWVsDXAB06JXnuPfNdqX1DiCxRvQxt6GDm0NyrvYhRe8P7qwU/ZBRtxuYmxTsnD09/EC7wNXrz1AxrjJN5E5mxFyaL/Z3BniosrKqHEmOsuA1rgxzUr530IXwLm6AM7VBXCuLoBzlXJwp3ztgY8DWn2J9o2tjMQ47qMCo0wzyIkknVFKvj46zzIQ1ftUrUbfTZj/ifN1Q/VgkGUGr0O4AGATgQP+/eJnUjn8+zbXMCHLDFYRf80J5wL0JNdDdqAfiEpQ8r8cwDHVE/UxeLNS88HeUG+JMSsFkNLzCk6Pi+HAji0G0XIfOzDKCkgdOnoq0Wo4hey5vguSVAlJp7qan2wHRkgNcBuD8w6GXDHEq4cL6j3kK8esuI2vj0F24jr6babBYgnDR0nzZ7ZUBZ/lKrRn7TNc1kf0t9Q/g8sRu4EGCmsAAAAASUVORK5CYII=",["gamepad"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAB9ElEQVR4nO2Y0U3DMBCGL1XfKRtkg4YJCBPACGEC6ATtBnQD2glaJiBs0E4AnYAyQfhPMVJwzva1idI85JcsV/b5/OXqs52MqecaU881ADbVANhUA2BTqQCLopigukeJUVJqphzlC+UtiqJjyDgKGQDuAdUryoTaFcM9AnLrMxr5OgGXodpQ+3BkfG7MHE45I4iBKap36kY3iORO6vBFcE7daeHq8EWwILdmKPzEoQj/VCbn+spliAiKLGMHXEp+7eAv9z9DCQW7pfHJ1YvLkOdkn6QBpHI7aVuTc/pPAfyo/D4KbQnV/8K5WSo8+RP5xeO3WsDEbkD4U18bOHJUt5YJgy1Jp1hqdAHWwg2AakLMeFuw2qYU1prKk+RZsI+lAWLmFOHVf2eSJJglFe0xJjH+Y1SfVv8R/df2oC4vC6GH0SWJYothTU+MHivBED7Tef/MJANpq5EiqDl3tQvfVhbor80tHXUJXU61uaUIxnQ5xXZD7wFr2wwW6jfp1iFfBHakk3TKSKptNRKgJjsZLnXd4QSfDJiTAtK+1UhJsqcW4cykbJuasT4d7AYJcNkm3J+UkAu7YSQ4WlF5Zto6nAtX8e2DXJu5/48hh8yJwiWmMhlWmtdEjcxrbGb8s+9cuqx6Afui4dNHUw2ATTUANlXvAX8Bo1qeTaQi0oIAAAAASUVORK5CYII=",["brain"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACNUlEQVR4nO2Y7XWCMBSGLz0dwE5Q3IANxAlqJyhOYDcoG2gn0E6gTlDdQDegE1QnoO+tUXNiQhJCrT94zrkHIZfwcj8CeE83zj3dOK3AUG5e4B01QFmWCWwM+4R9l2d4fwp7oppEFAAunGLzBksd3AtYHkXRB3lQWyDEsbCc/FnAhhC6c3GuJZDThk1G9dnA+i4ivWsQ4nIKE8cksLmLo5dAbgY61JyRSAK7VfWWipttTiAYW8a3yn5h8R9BZKfKwVmgiF6qGRrC+rB32EAZm4jj7NOF7ZVxFvdKFTg3CQTyxUbK4TUymZIjIqVqiRSYo2s6xyfFiebYhC5FDGBzXobU9EFIrpkjrkqzj8BHzbGxSP1JHB26k7c5bCqNdVi4Ye6EQgSKC8eaIT4mRzFTxuWaTOmyRq1YBUJcTFIkNMyk3xtl7EsZ25MnLhHktJhqhB9ZM2mfo7mks7hTxOBX0CHiuqfHrpZA0blJhUsq7/CjCzYQ63QMUyPKc6k3u9f42QWK4h9RNS/HJsG2Z5pH6lJdqSyoAuM6KCad0fmOewbXQmxj2JIjKM2RSaI4Srps8EvDinwFqvDbp4Mbp/hBOke3uMtYF/qmBTIr6beu5o5wRyeieYz8hUBXniFuYXNq5JvEE46ckzjm2l91a1hmS6uMTwS3FMZvQ/iIY3wETugfcBYoHmn84hkaSS9Cv4t9Otvr5fZI+99MKNcUWFANQhfqoaMfvxvWWgWCmuQatDUYSiswlB+dk9tKqmoWqQAAAABJRU5ErkJggg==",["map"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABdElEQVR4nO2YgW2DMBBFz1UGyAZlg3aDuhOUDcoI3aTtBnQDmKB0g3SCphuQCci3OBTLCdjhsIQiP+kLCV2OFycSPm9o5Wxo5SRBKbcn2HVdhssLkvOtCqmVUnuKgAopsqQK5HGkbIeUyBdkW08/jcsrkiGm9hOfaegaQTTZcpNiQmqMik4r23K/jPov+cZiLs+XJNWInBH6RrY0Tc0P9cmaPtpT9wNBHSpYBTyY0FDxSpv/Y4E8kQDT7+zepUI8tKMZDflnHGQf6EqiCzo9MupFTe5pZr9ogkv1S28SKUlQShKUkgSlJEEpSVBKEpSyesE7EoBt3h/yzpvTKIg2rA7D2Hk2I0s2rEsK2jR0km0D+5na3L05JmhWwzf01HwNGTtzT80B0RDcUaCgpn4udvlHPpDSGsiHsTMPkHX5pX6ly7HTiKmpTFN/CmAE9tykoQlYtqDpsXOQqkLOc4KmsjlYM7J9yBQkZRNNcCnSm0RKEpRyBNDskPpwhwuvAAAAAElFTkSuQmCC",["cog"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACVElEQVR4nO2Y7VHDMAyG33D8ByYg3aBMQJgANiBMQJmAMAF0gnYD2gloJ2g7QdMNYIIiEfWucWXHTvp1PZ47Xe4ix1ZkW5J9jiPnHEfOaRu4XC4v6fFK0rY0mZK8RVH0jZpEaAAZOKDHfUWzIRn4gJo0neLrLbWx0tSDS5925MHa45yhJrL+tt7W5Kyi45Tki6RHYm6EkHX1YPTblj6579T1YeQwjg2aGK9HJH0ZMHThD0RSksTQ3dAqmCLQwC+lo10xIgPvNIU6xWQceyfB/khkzA02PCgLmqc2xn7JyYst86XmwQ72bxwTk3My82XJg+K9OUloWBij2Dz5ajAUm+EWYXBKbK2nRtNAbedW8UQd9jWFrCvWXcCf0o4uTbEouvDnxWac9LcKK750zXCjhhnPP19QZzE88CgqfkhS+aESapiRhjzdM9j5gD99h47HaGvGMdZURx/kKCK/jSn8yR26gYylcvQVtdWDtG5iuNdNG/7EDt29jKXiSnWTCiOe4c+jQ/cX2mypbsNAavhOj09UB2uO/J2KNqufrap8eKxPGbvENgJ1hxZ512FcD2GZqbW+abRUx8qQyM+MoKe6BGFwPIytqQ6FkRmKo+Qh4CNqtv7CVm5xjGt0GquBmpk2Nom4t3Lx7wB1TFfJP0J4uVSXMTkm0RSuU532R1z3PZEMEc5Qvh0rutT2kfNALUdClpzkY70UEl0PfpRqRglnq8q97yzZUBNJT3PP5ld1L5BO9+pDWHi0maEBTQ2cbqmNlaZTzEE9g/sCMzvYBeY++L9Eb8ov04vnmGZXJSUAAAAASUVORK5CYII=",["rocket"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAC00lEQVR4nO2Y0XHbMAyGoZzfmw2qTlBngrATVN1AnqDdoMoEcSeoO4GcCSxP0GSCKhMkmcDFb4EuS5MURcm+POS/wykmIfIzSIJwZvTKNaNXrjfAsTo74G63u+aHEjP1zLbIsuzZbDwLIEPl/PjKVrJdBlxfxOegkwIyGGBu7UkDyu2GkwEyXMGPnxSOWK8uaGIhamwAq2kkHDRpBGVJN2xzmkjREeTJFduG7UmetwKk+wH1ZyRcYzdERZAnL6nbT1qK7UGnBIFD5FxLupXnNSUAZn1vOOBI4ObSD6jfdHwCH9gK9mvFD/1rto+eqR7Z1x4jvMQeOOSqwoDbOODIhIPk74L8WrkaLwbCQZUxcUXuPbc14SzIrcP/xQc4GwiHpV2Kj6LudphCS9cXgjIHXE7daXTpEw/UiB98cvLrgz2pZ2xEL7fvYC3XEufk1taAKykMB9UCZMLVDr/CBwe5IoiNv2L7bHXtoyf9iELsLdHIUzn6fvCY3yggb5qRb1xRd/LueSAl7Wj7TuN1SFVJgFoSsUsjn/XtvSg4NhVaWooFtMWALT/eU7qCh8JWSjVTyCQpio6c1uAIQnL3NmzvBrw2GA5Kqgd5knvqTmVsJG9wIIziIrpO7LuLdYmlVUulHAuJqF2xb2WMiRuqorGAkk429H/+AlwtfSHIR+p+oc3FZ5+22FD1lDSgZsw8cErgQvrCk6/FX+9JLCGKiZU1HvImEvJhadknav/7CtZgdheV1NV3OpJH+0q+KJY0t7ruKFK+q+6JIuSLgoAhasrz6qHo6JMrggUlSpYav4NVwG0RCwe5ABXFybVMLdtV4J2FvT/75DrFMT9uoKXdIHlu7fEfDLcf0/wwYP/dmLnNGiOn46I0CQ6yI9iXn36RlXhtSdVzNwXcfjzzg0SwpX93LBJuI7aOvUdlHEVdHdnSCPnSzFwGH3Sxn0JJ1cw59fYv4LH6C0Y4RyJu4KXxAAAAAElFTkSuQmCC",["swirl"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAADKElEQVR4nO1Y63EaMRDe8/h/7AoiKjCpwOrA1wGkgpAO0gF2B1ABuAKOCsJVwFFBcAVkN1o5e4sex2MIk/E3s3PiJO190j604hauHLdw5bh6gjddBu12u28oY5Q7uDCyO4ikhvh45p89lBIuiC4mloSubwcRD6K9Cg1g0z8kdNRFUWzhCCQJ4ocNPox4Vam+Abgd7kMGOJ4ejZIKZYPkm9i8AtJKLT4W4tU9P8coQzgfGnBkKyQ7lR05E1vRfgO3m0T43L5owC14iJtyjyR9UGbTjBFtstFP2CdHK/6K8qVgUJvfvUb0vrHkvpk1cYWPx0g3fXyU8h/WYcClqSfVRYtowFmJhPx4q3XmCK5BrYjxXZqhC1DXCJzvehCZXi66cwR30IEcDqPV0077aKZ0tMRxqwzJFxwzgmMIcm77pV6/osJSjUlF9ATcgrZizhza5u6l3CQVJKHcNlLkFpBON9S3UGf4KDAGjiGoMVUrJTPrRSxZJPrw9ywH1iGjWwfP0QQr32CfG4i+GpypLAm4oqIW/QOOZo+5aPfPRVA6vFV9ZSs1uLauesqILn9iwUkEVUTKVS9DTs7vpLlNRFcS/0dFTWC/85A78Kj8y4+nd/IUaiK6jiaozSCVVqpvJklye6bGdA4MiShBTq4yEkvRR+Sn6oNrJEY5j3LjGtokdIoq4VSCDLnqJ2VKSri1Gm9hP8JraCd4A5ncdwjBifr9fo7yDlto76QG9VlVEIz1IOyvYgqSxQIBVzyBdlIOFQsG2qU/ucBcp59AseAJFqcQpHO0QfkkXlPN9gIHgO7WII48gQ3qMrF5N0qJQZmxs9NFnXyFCFo175nHGcgT+6MzQo7QpOYXStkE2ub08D50F+ibs9T+hOA8R9fQEsIRS+W+twhF+BAi0CfJKkIwRMzjnUS4vt0jZqF9U2xSE1omZuenyw5F3wbOC/JZA84acsFValKu5Des1PLTy2foBsqBZP6Jj2jUSbstT5lkRZ0sFngiSRXqT5VJidxmRXuTuxWeVM2kEmwCqTN9D/+i3JKnSpUbnE3U5wYn/h8oTZe79cUJHoqPP9FPxW+r/Eb9R3QXOAAAAABJRU5ErkJggg==",["globe"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAC1ElEQVR4nO1Y0XHbMAx99uU/3qDqBPEGoSdoOoHlCepOUHeCeoM4EzidIMoEdieou4E9gQtE0BWiSYqk7Fyul3eHI0WBxBMFQISu8MZxhTeO/5/g8Xi8pcbIZSHtTtpqMBg8owcGyACRmlJzh5rYqEN9T1KRPBLZByQiiSARM9T8IBkjDxXJdyJaxU6IIkjEeJeYWInzYEXylYjuuxQ7CRK5gpo18neN8YfkgzW2JZl0kRwiTI53btOTHIhEQc2M5KCGec3fYiOdoEx8QncQdOEnapIr1FH+S917sREiGdrBPsHQgHds0Vzw6yThNXU0j8WWE04flGh9Qhp4Zxp/4pZ9bOnzMbLB92/U0MQV3T6COX43SUkf8lp3JNcyxEl9YusNHRNL9H+1nZCdXaghI7ZbcPngHV4JRHKJOgU1MLaOi+At8tCZdD1Yqf4n+2bLBxOCww6IFe3GIzJANtmdNmqo5cv2acaoPqeIOck9TjFPCYgQaJ0tkWRbTbAw4aq5H8qDW0muM1weW9VvJW2bYGFd4xVJOjkMY2Y4SPLnKRYl0rAPEdwhnmQs7hP1gwQ1buyBC75ubStIsFL9kaSAFs5NUmzowNh6CUrq0Gc2AwfOTFJ/uQ52+nK9Yq3wBR4IyXNgqvonyd5FUCsVGVF4Ai5NRcbWeIl2Wqnsub7jlj6rsdN+dJ3rHGe6GFQkn1H73Qb//O+ZbBhb2RfFc9XnBdYevSXSYWTeGu3gWLiUvVUd7c4Kbf/gA8HMoVeifqDUndR4oLVLJBLkp6ssw95SkfRZN+eoxicj4ysNvIlaJhi4S0VvdCfiECIXJMiQiQVOS8UlkWSi31zJPBK8ZtFVuKf8+mDHngbU2NAIceCycx7z6yP2NLMXJ+aqy/c7LYYcz2UfLmPIvdhGBiRyDerP1HWHOvsZJ/8q5+uTRVBD6pjmg1/I8A5SvPctDXoTvDTef6L3xV9GTCZ/TsXbRAAAAABJRU5ErkJggg==",["leaf"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAB+ElEQVR4nO2Y7VHCQBCG3zj+xw6MHUgFxgrECgwVSAfSAVAB0gEdCBUYKiB2oBXgrrnMRGXva8OEH3lmdi6wB/Nkj/sglzhzLnHm9IJaekEtJxM8HA53ji4fSZKUjj5IoMSIZBS3FKlpfSko7kn0U+oQJUhSGTVPFCOKK+goSHAoJYMESYyrM0NVsTa5kYb7Ap6QHIu9o305JpUSXpOE5JbU5OgApyDJzdGRHGMVJLmcmmd0iChIcjw7Z+gYWwWn0C8hao7OYlM9zdB+oSWkZWaEeLYUe4Qh7iSSYIZwuGqPFAOEbXegRbqQcpJgijB25jMPCJRzIQm6TiJNVqgqPkHcermzJb23OoEVDU+OqmoviKOwJSVBn1n4I2dm/BLxlLakJGi9K1TDMjHX3KaIZ21LSoIlZLi6Iz5ktrFe2mYwIwna7mraOLtx9TS7zdrVQTywUnV48Rz8eXtLcpnJs9heKTiMrSAzP/Je3rjWHve3LjnGeuSnKpXUXJuX9ZJS596gO10PfQRd62DeuJ7WFySXQie38JFjrIL0JRtqxqiGo2ykNNsZj8TEt7NzJ6Eve8X/002s4K+fiQ9eW92RP9YZwuC1cxwqx8TuxWlA3wX3NyMRTPSjD5ooPOwcqYl6tvOBtaTYUKxtjzV8UD+bOTX980EtvaCWb5ZAfzhWHlKuAAAAAElFTkSuQmCC",["sprout"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACU0lEQVR4nO1Y7VEjMQxVbvhPOrilg6MClgouHcRXwUEFhApIBwkdQAUsFYRUQKgAqCA8sQoojkxW68Dkx74Zjb9k7YtkyZ4c0J7jgPYcHcFcdARz0RHMxS9yYrlc9iF3kEA/ADdBQQmZgOQFfTPcBHu93guaaxmOvJ6UCAwhRRP9th4cqz57sty2QYhN0H2GTCGBGqBHLYGPLdD8liH3j8W7lm5AcwXpy9QcUqb0Ndp6kHGj+gUlPCJem7QhR5kEH6Lxf7LJBTX1yuOm5Bg5dXARje/1AOTOaNOrY5B7IAdan0EhsVTDI3x8IfMFmhl9hpXxhPWCnNjVTXK/IicY0To5xphaYFcEPxKGywmaYbR+S3VpcSMnSRinVGdlpeaC6j+xDrw78CSGhnkGxQuPVIepgrBx9tJt/CHW1XMYs95fqr0WLH2qPVxC/lBdoljnyPoRySSBoQrNibE0hVxGZ07v4+SYYz1E8wUavruDsY3PcGnZS4ZYNpxTXbs0AmT2xR38apDjGjmjTXJs+zxF7p0HbQGMcxgqyKGxPIXxf5F+HPK4WGty5ba62KgOeknuihyjURaLoUFiOVjhTtwkKwya3iium0RlaAwO6bFOHOjys6pv6HIlSP3YDXjrYEjMM5FRNDd32jDhIhi9pmMMpcatMDV0rr0Fu81NcvPFmg5d5dxrYu0MSrbekX12mmDtfMEee+vQsZ/1T3UCxR48yyBHxl7X20/2Bz0RE6woDyeUj0oPNsqMhLm1FxGeKsPWS1wfs17UP4Huz6NcdARzsfcE3wBmmutmpDlXvgAAAABJRU5ErkJggg==",["layers"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACeElEQVR4nO1Y7VHjQAx9Yfh/dHDu4Hwd+DoIFeB0kKvgQgUHFcSpAKggoYJABYQOoIKghxXwbLzfDsOPvBmNnaxWel7tSrJP8c1xim+OI8FcnGAgbLfbC5GlygUGwgiZEDJncrkRqYyhlcj5aDR6QQayCAq5Ui5LkTOLygYtyQckIjnEQq6Wyxp2ckRBHdVNQjRBhlRkLrfziGlzztHtEIWoEIuDAu1+K5EGhpoh34ROCF5BITdGG9JUctC5a7UVhCCCYvAf2pWLDlEP3k+92vTCGWJHChkKK3hSkXUFNYUwpBUOhwptyK3bxrqCMukJbZr4CjzIKv7uG3DV4uwqEwGrL9ch4Ul7xuFBH7Vt0EpQyxP3xj0Ohzv6cJVCZ5rh6RKp5PYSw+NSbI99zUTwPtPk2oj8QB5eRUhsFaKcUupuRX4hDY9oyW1CJ5x4CJXdAq+GK5EF4rGQ+WWXnDYeZRJBmXiFNlE/yX3VIcl9WcvtBGFgSCc6p2ufW4a5dq2+euFK1Fvjr6k4uTZ0+PQM+U+LGaaQsXlKtQ7PunqiU/QZcIX42vh9JYZvjJC7UtFeCtGQLg1yRAMLfM1Cjf3GlA4nPatC3XrnUMYbY5wPwsaj6PzN8E9N3WCCHcNmGJm7/roMGzZq7D9ob/hNePtBSxgZZrbw/+EmZns98FaQD/+IgDibycVsNOnkj1kRHK8HrCAzBCK6Y7FUFJI731UH1eGqdTvwqAqSTFAJFOivKI1ea+P/6AqyQ3LPp+mGCdb3mWNhJukYDPHpo0b/O7I3hYRgkK5ZU1GDz5DzxE9zPnnsMGhbr3sTKXvNhq9870jC8QtrLo4Ec/EGlwgYKQZtG6AAAAAASUVORK5CYII=",["grid"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABhUlEQVR4nO2Y4U3DMBCFX1D/0xHCBu0EdAPaDdIJYAQ2gE4AG9BOAEyQMEHaDdIJwhkuUhTunLMsVUHyJ1l27frdUxzbp8wwcWaYOMlgLJM3eKUNtG1bUClbPzWVJypzYf6cx+oRDRej0HxkmjmqXmBnn2XZZqDxTtUKdjaksYfRYEnVAmEsKUDF893cMmw6Kpq/HHZq72CoOcdcaVsRY6ZdHEsyGEsyGIt2k5xxeU5Sp2bwFYHidMh+dD+4fUIYe6lTM/hI5QAbzsha6F/DbvLAMf+Q+WbxleW9FfpPTtFYwU/TXZGiPibO/z5meImvff+h5fkc0biFn3PwEnMC+gZbPnfEby5XDTQWrJEbNNwO3pJGA6PBZ6ruYedI4jcDjdpormNHGg/DTu2YuUMYeX+3cjtHGGJM7R3McXlyqTMlC7Ekg7Ekg7Fo5+AXwmmUthUxpi8fDOHQv+q4bc0nvTFFg/yNZIvxJ+kS0h2VQhgreGwsaXUxxO8yP14wcdIujiUZjOUbzPq5rgR8AucAAAAASUVORK5CYII=",["crown"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACnElEQVR4nO2Y7VHcMBCG1wz/CRVEVBBTAb4KoANIBeEq4FJBnAruOuCoIE4FuXRgKgAqcN6NFpB10kq2GeaGuXdmR9bX6rG+7UPacR3SjuvjA3ZdZxCcwz7BjCS3sEfYXVEULU1QQSMFsBsEVw5UTBvYGqDfaYQGAwLsAsEPSoP5amFzgK6HVBoECDgGu45k//biZ5FyNSDnlKlsQMAtyQ6pD1XDGjT66JXnOVmRfSEfdoXyX+mtANHYAsGNk/TEsLnDJdNiBTtyknm461TdJCCcVwh+UR+ugvMNDRD8lAga6kPO4KehiYAMV9EEOA/yj5PEU2Om1TlIOKwcOFY9Fo4ldd3tppI2aBQg9RfFPdkFERXPVZmvmmrxFWpjS0WiwQeyJwTrJ3rgWinL5R4keuyvaq8sQ36TaIuyJ7GyB4oT48CxUiv2IvIckuvLyMsFpQ2x8eKtX4B7ohMhunSylt2rQtPC91XSCMCeIod+o9f6v+qbTF9BZQOGJBv1qYD44oVQhTZzbUh9ZQPGtgPZOlaBrLWyJUWH1FcUMLDDa07PA2lnSvky0daLUj145zxfKuUM2WGeiT2R/kKXkTZoKKA7f0pl1+ebieGekN4wkrYl8VFG2thSzlncIvgsUX4+1TbhhC9eHHwWG0m6hy+j1clZJAvn2cBuabxuqb+/LlIVcu+DPAzuQuDVOcvtSek5vhW5Q8sfVKkTJxvQPWefxXB16mNIPq74DPf3vuOcFxxy5e+UbO5h7tVW4oZsb0V7CHBZbb8V4GDlAu5/fUzVHnCq9oBTtfOAk27Ujv7C+IfQidhc0iZryEbNx9KRB7Uie3NuI3UM2dPkCvbFyUreYsYA8tHFZ+pGg1LqG7KwFWyR+4di9B/W99LOL5J/34H4Fqzbn6kAAAAASUVORK5CYII=",["users"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAB+ElEQVR4nO2X8VHCMBTGXz3+FzeoE8gGlAnUCcQJhAmkEygb4AQeE1g2qBNYJ6BMgN9rE6/WtHltwOO8/O5yKU2+vI80SV8HdOIM6MTxBl3xBl3xBl3pZHC/31+jGqmSorwEQZBZNCGqu4omhWZNQgJJJwQZonpFiQzNCwSMG3SP3G5oSlBuocvpQAbfGsxp5gj2XNPMUD21aBJoJuRqEIFuqJy9NnIEu6jptqiGFt0EuqStwxnZiQR9hjD03U9d28yJxpZskpCOR2jrIJnBlGTkDddtZLYOkjUYovqwdNtgLUU1Hf+xK4vu0nZMWWdQDRC3dNmhzAz3p6qtidhmjpE8Yja5QDU3BHxHidCeGjR8L1J9qvAYczWmPTZ1pLJbc5OxBg2/RYpdbTtW6nQ2+Nf8u2RhXLu1kzxm9YjP9W9oNiRk0DIorxnOXiJVwoZ+XLHJhMr3a1OmstYmlSbTGm5rShwCQ8AQFWchU+oHB+LEYVkNqmYxocpM1liR4egJauYe1OCHIKMypUor4y+o/PNtzKBZUt2gUNwVnsGJNqmWzVagi/U5GXQU9uHHaxCxElRjge6Cl4h+k4zoeEjMmCg8+a86V7RBaf7Wh0/qR+GpMMi7DIv3Hpf8/SFJ1aVk9PvY4sAbi7GV3vk+WXDFG3TFG3TFG3TlCxeAq5+TynB6AAAAAElFTkSuQmCC",["compass"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACwElEQVR4nO2Y7VHjMBCG33j4f5QgKiAdoFRwuQrwVXBcBWcqOHdwSQWBCmIquFABpgNSQdjFm8GWZWtlOzMMwzOz41jRx2t5tVr5DB+cM3xwPr/Aw+FwRRcrt0aupVyL2Wz2gBHMMAASdU2XJSph54HqL2QF2R2JXSOSKIEkzNLlL9kcwyjIbklooW2gEkjCeJZYWIppWJH9JqEvoYpBgSTO0GWD4bPWxY5sERLZK1Bm7glhPxsKi7voE5l0/SHitjidOEjfWxnLS9LTeMxi6OOe7LZ2P5exvHgFympNMS0cYvh1LtF+8FTGbOH1Qar8H9PM3h7Vis1JWCl9G1R+7cJBfeEWJh5x6QTiWBi/RkOD3hzFCVlHGytj9wtEtUMM5ZnspwjL3NUps3fd0966Bb69+ArxPKJ6jatAvZvA/9/dgoYPiqNuEccPEnYXqhQRUxf1rdB9xRZxPGrECTx7mpja8P8E48iPP2iG5mQbscYgMnu/oKPxEK4PGuh5dnwuw7sPsevUF9sS+h3J1G/GJKxZRN0/EXUbK98VWELH3rNiM99viW0GenoFasndAhLM6ZMvhsbMHtMQ6C6SAmF4l8gV9Xj2WLBBHLv6TUOgxJ99f3usQkkmn1nIOOZtEMfePQ74wkyBfvIOUec1YSvEzxzTiqmJplKNtbPxH4Wxn40RdqRwC7rSLfaDS89fF07axME3xTRZ9wP1bd3Crp3Et6nfszgWRvYP1Yxpty8Nma/QK1Ac1T1k73gbE2EppmXddVbuPNXJ/smNLnFaOFWzXZFBc+wsyb7hNHBIM4OOnYw0NKiecmq4TxOKqcF0SzqwaPvkGLgvq/n0ocoHuSOylH7yqWvM5zRuyxlzqhH3NjYGIBmKRZUchPyT/YyDf6E4s7QYJLCOnGM4g+YFZaS4RJWV7GI+tfkYLfDUfH1EH8sr/Sj18Q217OUAAAAASUVORK5CYII=",["magnet"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAADMUlEQVR4nM2YTbLSQBDH/6HYS3kBcwPBvRoPoOLWjXgC8Aa8Ezw9gXmLV2+LegDAAyjvAJbhAoonwO6kg5PJfGWCpf+qLmA+f/R0TweG+M81xBl1PB7H9PKcLBVTtSHbkW2TJDkgUAl6iqBG9DInmxmgbFqRXRDozjewFyDBMdiSbIQ45WRvXB6NAhSvXaLyWl8VZC9s3uwMKHBrsrFj2BZVvNWeyVAd/z3L+INAbtAH0AO3J1vSJrljPs9bkL2CGfKJ7slgQA8cx9FbBIrWylAlyh2tqyCbqDE5QIAccL9QHU0wHEuOMiW71bq4rbGW14MeuCzkqvCsXaDtyUm97uBfwbHkKKeGruVpDOxwnHFfyO6iA5xSTTJpqqvHCva9cmiJQ+MTK6B47lsEnOvi5ti6MF3K8qW+as0c26uBBW5tgGNtHXDvBcJWVRZQjk6VrLnXmsuwGljgbJfwMwExwc3g15zGTi19BVyAgRWCNVMhHXAfyN4Z2jOYtdE+lyehPm7ZsvUz2VO0IU/v0dYVHVvZLuPmSp/PAQ0NZZEFHFeJKctgP9ITnMhWf3Wlpsb6iKc2OP4gG17BrwacHL++9gZhgIUKqOs7tKANgDTBzbQx/MVzfaLE/2M4APWrg497LRMba8GsmwA4Fj/tFIZ2U2aXF3siC9pqIoPzI9DBsemO+icBcHpsQpnDJ5YqTXsaW34uPSi3e4bqCFTVnrRteqPBXUfALdGOv7x+k2iDGWiDtifh25Tmcqka+8Zp+3G7fvGzk9K6JDaSRLI2Q9uTPrjrCDgef2noWjgfWAMgTdn60jL26IDjwjAyrJ03eGBbuVqEi3+d/gw8Ux+bAmtwTnNeB8Dd0rjWKQT9JqFFU/166PCAcIJ0waEqDIcoQF2W4GbVF7npV9tHskdd4PoA/oQ5fmbSn1sg0QWOFfSrToNLXXCswNrthYsCtJSq+3pZFMhP6AGHGEBlA1Wt2i0J8dAw90coHCs2Bm0Vp6zdqEqXKVsZ7gHB7RGo6L/fPJApOmYrzg3I6lC7o+BYsTFYKrB2R8OxegGyPJC94Mr1cSZJBi/x56lm1fVfL5POBvi39Bveg5lLAuPIgwAAAABJRU5ErkJggg==",["footprints"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAADOklEQVR4nM1YwW4TMRB9qXqslHDjgNTtEQmJ/AHLFzR/0PAFpF/QzRfQfgHpFyQfgMT2yAE1EYgrmwM3pCYSBziFGTKLNuOx10m6VZ802p2x134ee8ZeH+KR4zCm0mq1SulxStIV04JkSnLdarUKNIgWwsSY0JgkCVR7QyRHaAgHvgIi16fHR4TJMd5L3UZgelA8d4t4FOTFEzQAnwfHHvsNyZBkruxJU150gkQ6SpR5RpKSlxZS55IeBUm7UidBA7A8eKH0JSrkGPI+UfW6qIEsnd0JUgM9uJ4YVMlVUCi9A5vUGcl3khWpt6s17kg4uBJsQ5DQV/pynxTCJOgxgjvojvTFxC+wBUHthRH8SJW+UOQGcAdsIZOBmNAEXyq9gB9tpU+V/hbx6MuAHNR5cGp9RI1xPb3gF5Vyay1fk7wmOcc6XWm8s9bkQaXRbSKsZ9iqUZ2qsjmt5T5JTnJJkgphjYGXIH1keiuS4EwdGvRgdUri/vpwPXkms+MS9CDx2F8pPUcYC489U3oZ3f+hCc6Uniq9XF/bRDvgyZE85UafvRDBXOnaU4xU6UtjeRRKD63vSaCslmBiRNZpRAeF0o/hh6674RR9WLAChcO/tD+Fuy4tgrqdfwP1nL4dGwdKub22jMJv9HiOeDzRe7VE4p2qd84pBm5/KdYH4ypOysFYUfwH8Sisg4TYnBSCSFQ9bRGcIR4/AmXOcUznuNKOACyChdJLb9zAzWcfgGiCDGsHSpW+4fm6RM3gXSKV7SnauzJN8wiCwaQfQ3AfaC9ukJH9X097XlViftzbnvcYjLB57OoQqS/0/Cn6M/2B7C4IEdQ5jBd3GYHdmrq6syl9+4tejyrmF4FPnPYsgoVhGyGyQQPsrSPE4bc2OGtQ9tUr1OMq8l7mM+LxSRt8QZIhHLEzuEclH74qvcD6538IO6VtwCTIOwFJF+4tAr8PuczzKxoDPl1nLHDTkINgFEsjWbkD7EFqZ0TdD94zsWPPu4mmEzUjVzofvcYscI9uum74AvM+IMujQH2S5zugRM9W4x6UDrOIquYd0ENMMeSgOgxUGfrugBqf4irkcMAnmlRMOckk9E/+oAR3wV9uaCeGF/zxowAAAABJRU5ErkJggg==",["sword"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACD0lEQVR4nM2YvU4CQRSF76Ix2hC1tJHEB1ALY6zE1thayxsoT6A+AfgExtaKwtiKla30FthYGrQyJgbPkVlchmF2F2YGTnIy7M4d+LjztzvzMuOalxnXVAC73W4JxbqhqhVFUSd5I5LAAlwNxZkl5BKQF/FFUEDAXaOoZAhdiTNZkEDKAUdtxR+CjMGccAPynkEL3A18AFdt7b1m0AaHMVZRMdbv8AaYBU7pRCzyMouzwlni+rPYeQYdwF0lF2unGXQAp3e/uwz6gKOcAPqCoyYG9AlHTQToG44aGzAEHDUWYCg4qpACUobP1QNmcDgqssDxobKmLrlwcmM/DQmXBthEsZ+49Q0vSEA4ytbFbe06OBxly+Ayiia8OSLEOxw1MoNqwy7DL4bqH/hWPMP9caQFqEy+wUt6FXwEH/uCE8n4NKMgX+GiVsVMzhmaOIGjsi7UXG6Khvte4ahUwJxvZE7hqEiDYVfG7wh862LmKoZ2nzKcUa6TuwB8Fo+AD9KbudQ7vGpoQ3DuMqaJw5m/Dci2OFIhAVdKwMkoOHahWoLWZHgJYg9UxKH6gOpff1hiB8aXgtyBW1pcUxxK72KeiTzBi1ocu3sj0o7GVBtmrQ6X4AZi6uILUP3gIYo7Q13V9Y9n0dBWB4h76e0QX1pVR6Yg416sIPfkf0w+wg2ZgjLtxaaxF0rBj4DzauZP+X8B4icUfKgAlRsAAAAASUVORK5CYII=",["sparkles"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACRUlEQVR4nN1Y0XHCMAxVev0vTFDYACYoTFA2IJ2gdAJgAugGZgLYoDABdALoBMAE9AmUKwTbiY2P5PrudDrbwnnIlmT7kUqORyo5HqhAHA6HSpZNYQRBrga1hR7Y7CIqCCCmoLqQXRRFVZNdIR6Upe1Ks4J2bLK9O0GQaUFNU90j9Hd19ndbYhDoQPUhDYvZDjLGkg+TjnsSnEG95jSvgiST9VtifKwBWYo0cv4shrBnfiw2E0g9Icfw8iBIfUG1pDnHhG1ygKSW/lnXAhJjnk3a1pmgeGyZ6m5i8hU5APNsoJ6l2cbv5zo7nyXu5ezLghL9bSLHcPKgZP+1YbiuWyLLXJwLFQt+NzPZuXqw5zl2BQ4ESMdG7mhHOSH/mL1nKvAceRcRGAKZHuRlhYzITo5kbM22shWCILIQ42h9p1P+8oGCfLpGdxpXBIUYe6xFYTCHfPgS1RHkHJe3OuTFCgSb5AHdkb9K4eFd83VBwqeOBYXDsYyRJ7KChHNbl/zAhX8cPEjSkJTBRGPIU4b5nk7RO3apKja4JuoNmUkyudrdE3UC+bCymKjQ5BiutXjsOXYFXhHIVK4CRjgRlH010QxNPPYc7+vknmL+Jjki4IF1S3+1PdyBVYic58mFB7k+XR48+qZnEN87CXtRSTPOQ1AIJIePmsFMQYbn2+V/Xjs9oSi7hHIuHd587bwF8vQxgLycdTOxHoiptH0hr1uay9ebjhyjDM9ve5AzXiWKfGEdiLZWoMI8yODUk1W/CyWYB6V/5f8F0Ifq/euDgPsAAAAASUVORK5CYII=",["waypoints"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABm0lEQVR4nO2Xj02DQBTGPwwD1AnEDdhAuoEj4ASmE+gIOkHpBnWC4gStE5RuYCfA76U0UXIHx/0hJPJLXmjgAb/ewXtHjIkTY+L8D8G6rhfcPDMyxeGKsYmiqIQFERxp5PaMpCd1aSN5A3dS9MsJj7BgzGcwhQXzW+zKLOiKD0HTh7+EBU51kDVQ5PYGqSdGyjr4jYFYj2Ajt2vtXjEOivSDjZxgNYKa7rGixBs8M3gEGzkZueTX7k0IOSHuEEm4uVMcyvH3xfigXI5AKKeYctI314xF9+n4YmS2z5cJOsEjzBYAtyHlBJ1gDZOTCQIztzpXJi/otKJuamJQdIJnmHGk5EtIUZ1gATNE7BUBRbVlgjfLcfnQ0d30QbFPaqK0vPd2fezoTMKJ+RWGCPbBG2a4jF6vaPNn1x2Xk/wn5m7hS3CgaI7+zlRR8L6901sn6BE1QtWZfHy4Xy9eMjL+XDI+4Qlvgld8iwZv9s3U70xyVVMcXFBwWR15n2INZ9ucsQQL25xRpljo6ExSK7ec3UJ13miCtswLVld+AHRchUekLW3kAAAAAElFTkSuQmCC",["bug"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAACCklEQVR4nO2Y7W3CMBCG31T8Lxs0GzRMQNiADcgIHaFMUDYo3YANAhPQbhA2gAnSO3EWSRQ7/ogrVPFIVlL7XL/4fOeDCe6cCe6ch8BQ/qfAuq4zfiZJ8h3DvskTHKHFlvQ4cqP3Dwv7z4b9Eo44CyTyxvubCOhFxgrNXCsSOCLu2lN7bnTvqLH7MvlbvTd37MICXd3sLNAg0oSXOCYkiutIti18g6SkNnWYxralT5A4uZgWSHGNSBdxTc7UZuTqynZCMiBohXYUptJCqKQptiT4S2esFSiBcMTfMNMF0N1fdUMuLnDNZXzm5gbTE9puY1JqLxp7Tju8Y3wm2cU7+AhsQmJrg7iMFjl37Kciolck2Vut7XPVdam64kQA91UIZAyBc9qtvNspfXMEMnQGOSHniMuednuhG9TuoOxAjvjkfR5QmFxc4RptsbnAcFaHXJzidnOUBlO+CbadvoLayjBHubUyXX1jpJkfWiDTzOE089o3ZptmxrhJas8xK4wCxcUq0XJe66tiMintd2IDsStwq7C7nGmOSkEnLxePUFrZYizBTFGcIr44yBqpblArkD7Rnh4HxOcga/XrgAOSUEuEsTAJ6uJ0F8s/XsOftYs4xrlYoAXe4SdyLXPd1oMn8g1tA31RquB6sXDdOYW3QIUILdCuujm4OH1sfIUpggXG5vEDZigPgaH8Av23voLBXVgfAAAAAElFTkSuQmCC",["activity"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABc0lEQVR4nO2X7U3DMBCGL1EH6AgdoSOEDboBzgawASN0g5YN2KAwQWECwgZ0gvCecKWrib8jnB9+pFNk5y59ZDvXdkULZ0ULpwrmUgVzqYK5VMFcWirMOI5rxHn85cm831BhWA6X7XXcAHm/6BZD7kBCDryZOcUEtZwSUx+InZlXZIshp3A5iKkLYoPd/TZz/30FLXLdlByTvIL89uFyj/jCw18Ca/i8nY3pO9S/2mqSVlDLnUgfcIyP+JCe/HInY7p3yTHRK2jKCaySuuYTsRbTj8jfk4eoRu2QY5R+M201Uu45RC5K0CJ3Ib+kWcNyigIJEnTIdYjeJjnRiLnXPVAE3jPoksNKvOscRbetgxkQG7qVs7aTJMEQOZGrJiRlzRY1A0XSziHHYO5If7db1gyUQDuHnEdy56rx0cwlZzyDv/QVYu9rxCmCLNdRotzcTAmOYlhUjpk6g9czVFyOKf6T30f925lLFcylCuZSBXNZvOAPi9mzvQ09WC4AAAAASUVORK5CYII="}
State.iconMasks=State.iconMasks or{}
State.iconAlias={['home']='house',['settings']='gear',['cog']='gear',['user']='person',['users']='two-people',['people']='two-people',['sliders']='three-sliders-horizontal',['shield']='shield-check',['zap']='lightning-bolt',['lightning']='lightning-bolt',['box']='gift-box',['globe']='globe-simplified',['world']='globe-simplified',['layers']='two-stacked-squares',['gauge']='speedometer',['speed']='speedometer',['map']='location-pin-map',['fire']='flame',['lock']='lock-closed',['notification']='bell',['gamepad']='controller',['search']='magnifying-glass',['target']='crosshairs',['crosshair']='crosshairs',['swords']='sword',['edit']='pencil',['trash']='trash-can',['delete']='trash-can',['book']='book-closed',['menu']='three-bars-horizontal',['cart']='shopping-cart',['mail']='envelope',['email']='envelope',['mic']='microphone',['volume']='speaker',['sound']='speaker',['close']='x',['info']='circle-i',['question']='circle-question',['warning']='triangle-exclamation',['alert']='triangle-exclamation',['time']='Clock',['camera']='photo-camera',['hash']='hashtag',['monitor']='code',['plus']='plus-small',['minus']='minus-small',['play']='play-small',['pause']='pause-small',['stop']='stop-small'}
State.iconMasks['house']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAACAAAAAAAAAAAAAAAAAAAAAAAEAAZ7fggABAAAAAAAAAAAAAAAAAAAAQMAL8v//88zAAICAAAAAAAAAAAAAAADAABq9f/6+v/3bwAAAwAAAAAAAAAAAQQAF6v///z///z//68ZAAQBAAAAAAACAQBJ4f/7/v/////++//kTQAAAwAAAAAABIn///v///////////z//40GAAAAAAAwxf/9/f/////////////9/f/INAAAAADn//v///////////////////v/7QAAAAAmpv/8/////////////////P+rJwAAAAAAmP/7/////fv7+/v9////+/+eAAAAAAACnP/7////////////////+/+iAgAAAAAAm//7//3/zI2Pj43J//3/+/+hAAAAAAAAm//7//v/WAAAAABQ//z/+/+hAAAAAAAAm//7//v/YAUJCQVZ//z/+/+hAAAAAAAAmv36//v/XgAEBABX//z/+v2gAAAAAAAAoP/8/fj7WQAAAABS+/n9/P+nAAAAAAAASuP7////9+fo6Of2/////ORPAAAAAAAAAAklP1RmeYWJiYV5ZlU/JgoAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['gear']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAgECCMPv7roEAgECAwAAAAAAAAAAAAEAAAUAR/////86AAUAAAEAAAAAAAABAQBKHwAOu/37+/6xCgAjSQABAAAAAAACAI3/9L7e//7///7/2sD2/4EAAwAAAAAAW//6/////v37+/3+////+/9QAAAAAAAAtv77/vz9/P/////9/fz++/+pAAAAAAAAN/z9///9/9iWmNv//f/+/vgtAAAAAAADAKv//P3/kQcAAAma//37/54ABAAAAAADALb/+f/IAAAFBQAA0v/5/6kABAAAAAAAb/n9+v9wAQUAAAUAff/6/fZoAAAAAAC5////+/9lAgQAAAQCcv/7////rwAAAAD//P7//P+qAAYDBAUAt//8//78/AAAAADc/vr8//39VgAAAABg//3//Pr+0AAAAACQ/////v7+/5xRU6D//v7+////ggAAAAAJNlay//3///////////3/qVM0BwAAAAAAAAAG1v79/vv7+/v//f/NAQAAAAAAAAABAgYAu/78//3///3//P6uAAYCAQAAAAAAAAAB4v/6/f/3+P/9+v/XAQEAAAAAAAAAAAIBg/f//6gbHrH///V7AAIAAAAAAAAAAAABADGjnAAAAAOjoC0AAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['person']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAfO/EfzwKAAAAAAAAAAAAAAAAAAAAAQAL6/////3dcgECAAAAAAAAAAAAAAAAAwA8//39/P7/8woAAQAAAAAAAAAAAAAABAB9//v///z9wwEBAAAAAAAAAAAAAAAAAgC+/vz///v/ggAEAAAAAAAAAAAAAAABAAry//v7/fz+QQADAAAAAAAAAAAAAAAAAgKF7v/////zDgABAAAAAAAAAAAAAAAAAAMAGU+QzfGGAwUAAAAAAAAAAAAAAAAAAgAAAAAAAAMAAAACAAAAAAAAAAAAAAACADmTp6qsqKOokzkAAgAAAAAAAAAAAAMAWf7///////////5ZAAMAAAAAAAAAAQEL6f/5+/v7+/v7+f/pCwEBAAAAAAAAAwA4//3///////////3/OAADAAAAAAAABABr/vv///////////v+bAAEAAAAAAAAAwCi//v///////////v/owADAAAAAAAAAQHU//3///////////3/1AEBAAAAAAACAB/1/v7///////////7+9R8AAgAAAAADAEL//vz9/v/////+/fz+/0IAAwAAAAABAQ2i/f/////////////9og0BAQAAAAAAAAAAOo3F5fb+/vblxY06AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['two-people']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAABAAAAAAAAAAEAAAAAAAAAAwBQ1bd3OQcAAgBrv8aDDQABAAAAAAAAAgDQ/////9kpAJr/////xgkCAQAAAAACABz2/fv7+v9cIf/7/P34/2MABAAAAAAEAFf//P///v0dWfz7///7/JoABAAAAAAEAJ/99/z8/t8AR//6/v/5/34ABAAAAAAEAHT////+/6QACc///v7/8R8BAgAAAAAAAQBBhsX1+EQAAB+7/f/SPQACAAAAAAAAAAMAAAAJDwADAQAAEBYAAAQAAAAAAAAAAQApaHVrTxEAAhNUaWpkKwABAAAAAAACAIH5/////+FEAMH/////+oUAAgAAAAAAZf/++/v7+v/2GF39+Pv7/v9pAAAAAAAF2P38//////n/hAP2//7//P3bBgAAAAAs+v////////z+ygDI//z////7LwAAAABk//3///////7/9gaJ//v///z/aQAAAACh//z////////9/zRG//z///z/pwAAAADj/Pr9/f7+/fz3/X0P/P79/fr86AAAAADG/////////////2IZ////////zAAAAAANYKXM3+jn3MOURwBz5+XgzKZjDgAAAAAAAAAAChEQBwAAAAEOEBEKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['eye']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgMAAAAAAAAAAAMCAAAAAAAAAAAAAAADAAAVTXeNjXdNFQAAAwAAAAAAAAAAAAMAHZft////////7ZcdAAMAAAAAAAAAAwBK6f///Pr4+Pr8///pSgADAAAAAAADAEr9//v+/P/////8/vv//UoAAwAAAAABHvH+/P/9/+y/vev//v/8//EeAQAAAAAAqf/7//3/fw8AABSJ//3/+/+pAAAAAAA1/f3//P+BPMRxAwAAjP/8//39NQAAAACe//z+/+wI2v/6DAIDDez//vz/ngAAAADr//78/74AeOiSAgICALz//P7/6wAAAADt//78/7oAAA8AAAACALr//P7/7QAAAACj//z+/+kKBAABAAIDCun//vz/owAAAAA6/v3//P+EAAEDAwAAhP/8//3+OgAAAAAAsP/7//3/fg0AAA1+//3/+/+wAAAAAAABI/X+/f/+/+OysuP//v/9/vUjAQAAAAADAFP///v+/P/////8/vv//1MAAwAAAAAAAwBT7////Pn4+Pn8///vUwADAAAAAAAAAAMAJKP0////////9KMkAAMAAAAAAAAAAAADAAAdWIOamoNYHQAAAwAAAAAAAAAAAAAAAgMAAAAAAAAAAAMCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['folder']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAA+jI+Pj4+Pij8AAwAAAAAAAAAAAAAAAAD4//////////9PAAYDAwMDAwMDAwAAAAD/+/v7+/v7+v3zMAAAAAAAAAAAAAAAAAD+//////////3/6K6wrq6urq2rVwAAAAD////////////+/////////////wAAAAD//////////////vz8/Pz8/Pz7/wAAAAD//////////////////////////gAAAAD//////////////////////////wAAAAD//////////////////////////wAAAAD//////////////////////////wAAAAD//////////////////////////wAAAAD//////////////////////////wAAAAD//////////////////////////wAAAAD//////////////////////////wAAAAD+/////////////////////////gAAAAD/+/v7+/v7+/v7+/v7+/v7+/v7/wAAAAD9/////////////////////////QAAAABJmpydnZ2dnZ2dnZ2dnZ2dnZyaSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['code']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQQAAAAAAgMAAQQBAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAIAEVoKAAIANkwAEVsJAAIAAAAAAAAAAwARxv86AAQA2fsATf+3CQACAAAAAAADABHF/44FBAAZ/LsACJ7/twkAAgAAAAAAEMb/kAABBABO/3cAAwCg/7cIAAAAAAARxP+RAAMBBACO/zoABAIAof+1CQAAAADS/4gABAEAAQDS9QwAAQEDAJr/vgAAAADT/4oABAEBABj9vAACAAEDAZv/vwAAAAARxP+TAAMFAE3/eAAEAQIAo/+1CQAAAAAAEMX/kgAEAI3/OwAEAACh/7cIAAAAAAADABDE/5AFAM/0DAADCZ//tgkAAgAAAAAAAwAQxf82A//CAAYAT/+2CQACAAAAAAAAAAIAEFgKAFIsAAIAEFkJAAIAAAAAAAAAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAQQAAAMCAAAAAQQBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['three-sliders-horizontal']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQEBAQEBAQEBAgABKx8AAAEBAAAAAAAAAAAAAAAAAAAAADPL+PGaCAAAAAAAAAAABAMEBAQEBAUFEuP//v//iQMHAAAAAADb9PP09PT09PT0+P/9//78//P0zgAAAACKoqChoaKioaKgrv/8/fz96J+jgQAAAAAAAAAAAAAAAAAAAL//////XQAAAAAAAAAEBAQEAA4UAAAGAxWk5NhtAAYEBAAAAAADAwQDhOLqqRcCBAAADQUAAwICAwAAAAAAAAB8/////78AAAAAAAAAAAAAAAAAAACux8X3/P3+/P/MxcbGx8fGxsXHowAAAAC91tX7/P7+/P/b1tbW1tbW1tXWsgAAAAAAAACH///+/8oAAAAAAAAAAAAAAAAAAAACAgMHmfH3viEBAwAAAAAAAwEBAgAAAAAEBAQDABwkAAAGAw6Q08VcAAYEBAAAAAAAAAAAAAAAAAAAALj/////VwAAAAAAAACKoqChoaKjoaKgrf/7/fv96J+jgQAAAADb9PP09PT09PT0+f/9//78//P0zgAAAAAABAMEBAQEBAUEE+j//Pz/jgMHAAAAAAAAAAAAAAAAAAAAAD/c//ytDAAAAAAAAAABAQEBAQEBAQEBAgAORDUAAAEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['shield-check']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQQAAAADPpLk45E9AwAAAAQBAAAAAAAAAAACOIXQ/v/////+z4Q3AgAAAAAAAAABEITU//////z+/vz/////04MQAQAAAAAAhf///vv9/////////fv+//+FAAAAAAAAnvv5///////////++/7/+fueAAAAAAAAmf/7//////////7/////+/+YAAAAAAAAlf/7/////////v//iNj/+f+VAAAAAAAAjv/7//77/v/9/f9WAML/+P+OAAAAAAAAgv/7//////z+/1cAqv/9+/+CAAAAAAAAbv/5/99i5v/9VwCo//z/+/9uAAAAAAAAUv/6/t4FJNtZAKf/+v///P9SAAAAAAAALv///f/UDwEAo//6/////v8sAAAAAAAACOP//vz/0y6i//r////9/+EHAAAAAAAEAJj/+//9/////f/////7/5YABAAAAAADACv9/P7//f/9//////78/CoAAgAAAAAAAwCH//n///////////n/hQADAAAAAAAAAQMCrf/7/f/////9+/+sAgMBAAAAAAAAAAEBA5j///z+/vz//5gDAQEAAAAAAAAAAAABAQBV2P/////YVQABAQAAAAAAAAAAAAAAAQMADnvp6XsOAAMBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['lightning-bolt']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABABa7KcFAgAAAAAAAAAAAAAAAAAAAAADADL0//8kAAIAAAAAAAAAAAAAAAAAAAIBE+D//f0oAAIAAAAAAAAAAAAAAAAAAQQAuf/7//4nAAIAAAAAAAAAAAAAAAAABACM//v+//4nAAIAAAAAAAAAAAAAAAAEAFv/+//+//4qAgIAAAAAAAAAAAAAAAMAMff8/v/+//4aAAMEAwAAAAAAAAAAAgAS3f/9/////v5wIAAAAAEAAAAAAAAAAgS3//z/////////98aGPAABAAAAAAAEAGn/9v3+///////8/////1IAAwAAAAAEAF3//////P///////v32/2oABAAAAAAAAQBKldP+//////////z/vQYCAQAAAAAAAAAAAAMsfv7+/////f/hFQACAAAAAAAAAAADBAEAHP/////+/Pk3AAMAAAAAAAAAAAAAAAMCLf/////7/2IABAAAAAAAAAAAAAAAAAIAKv////v/kgAEAAAAAAAAAAAAAAAAAAIAKv//+//AAgMBAAAAAAAAAAAAAAAAAAIAKv79/+QXAQIAAAAAAAAAAAAAAAAAAAIAKP//9zgAAwAAAAAAAAAAAAAAAAAAAAEBCLj3YwAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['gift-box']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAbKtZaqxaAAEAAAAAAAAAAAACBAQEBgB2//f///f/WAAHBAQEAQAAAAAAAAAAAAHa0gDmuwDvuAEAAAAAAAAAAAAga29xUgCd/63v4LH/ewBgcW9pGQAAAADg////+RkRoP////+QBy3/////0QAAAAD/+/v4/7cAaP+Vq/9LANH9+Pv79wAAAAD//v/9/uYAWIUAAJBDBPj+/v/+9QAAAADz//////9uAABbSgAAiP//////5QAAAAAeIyAhICElAAA2LQAAJyEhISAkHAAAAAAAPklISEhIUlMAC1NRR0hIR0k3AAAAAABG//////////8mSP//////////KQAAAABL/fv8/Pz8+/wiQfz5/Pz8/Pz7LgAAAABK//7//////v8iQv/8///////8LQAAAABK//7//////v8iQv/8///////8LQAAAABK//7//////v8iQv/8///////8LQAAAABK//7//////v8iQv/8///////8LQAAAABJ/v7//////v8iQv/8///////6LQAAAABN//39/Pz8+/wiQfz5/Pz8/f7/LgAAAAAc3P////////8kRf/////////IDQAAAAAAFkpieYyapKsXLayimIp2X0YOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['star']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQmRkQgBAQAAAAAAAAAAAAAAAAAAAAAEAGT//2IABAAAAAAAAAAAAAAAAAAAAAACAMD9/b4AAgAAAAAAAAAAAAAAAAAAAAIAIfj+/vggAAIAAAAAAAAAAAACBAQEBAgDcP/7+/9uAwgEBAQEAgAAAAAAAAAAAAAAxP/8/P/EAAAAAAAAAAAAAAAncXR1dnSC+v/////6gnR2dXRxJwAAAADo////////////////////////6AAAAADk//f7+/v7////////+/v7+/f/5AAAAAAmxf/8/v/////////////+/P/FJgAAAAAABpf//////////////////5cGAAAAAAACAABi8v3+/////////v3yYgAAAgAAAAAAAQQAR//9/////////f9IAAQBAAAAAAAAAAQDXP/8/////////P9cAwQAAAAAAAAAAAMAsf/7//78/P7/+/+yAAMAAAAAAAAAAQAQ7f/+/f/////9/v/tEAABAAAAAAAAAwBL//z7//16ev3/+/z/SwADAAAAAAAABACc/Pr/1DwAADzU//r8nAAEAAAAAAAAAwCf//2QCwAEBAALkP3/nwADAAAAAAAAAQAWhEwAAAMAAAMAAEyEFgABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['globe-simplified']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACABFqxo8AAI/FaA4AAwAAAAAAAAAAAQIAYN3/+RRYSRb4/9paAAIBAAAAAAABAwCY////awL04wBu////kQADAQAAAAADAJb/+f3rA3r//2IF6/35/40AAwAAAAAAVv/6+v+PAur+/toAkf/6+v9NAAAAAAAM3v79/f8yP//8/f8qNf/9/P7WBwAAAABg//z+//QDi/76+v50BPT//v3/UwAAAAC1/vz9/9cAuv/8+/+kANf//fz+qQAAAADp/////8gA0/////+/AMr/////4QAAAAAaGhoaGxMAFRoaGhsTABMbGhoaGgAAAABbZGRjZEwAU2RjY2RLAFBkY2RkXQAAAADx/////9YA3f/////EAOH/////7AAAAACx+vj5+9cAsfv49/qSAOT7+fj6qQAAAABh//3+//YFhf77/P9YFf7//v3/VQAAAAAK2/78/f8zOv/8/voRXf/7/P/RBgAAAAAATP/6+v+MAen+/7AAwf/7+/9BAAAAAAADAIP/+vznAX7//i0p/vr8/3cAAwAAAAAAAwB/////XQb+qwC0////dAADAAAAAAAAAAIARMT/8RJYGVH//789AAMAAAAAAAAAAAADAABHoWEACLCWQwAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['grid']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACZ////////////////////////igAAAAD/y4mNi4r03IqMjIrk7YqLjYnT/AAAAAD+gQAAAADkrQAAAADA1AAAAACU/wAAAAD/jAQJBATmtAQHBwTF2AQFCASe/wAAAAD/igEGAQHmswEEBAHE1wECBQGc/wAAAAD/hgAAAADlsAAAAADC1gAAAACZ/wAAAAD/7dfZ2Nj789fY2Nf2+dfY2Nfw9QAAAAD/5MTFxMT57cTFxcTx9sTExcTo9gAAAAD/gwAAAADlrwAAAADB1QAAAACW/wAAAAD/iwMIAwPmtAMGBgPF1wMEBwOd/wAAAAD/jAMIAwPmtAMGBgPF2AMEBwOd/wAAAAD/ggAAAADkrgAAAADA1AAAAACW/wAAAAD/3bO2tLT46bO1tbPu87S0tbPi9wAAAAD/8+bm5ub99+bm5ub5++bm5ub19AAAAAD/iAABAADmsgAAAADD1gAAAACa/wAAAAD/igAFAADmswADAwDE1wABBACc/wAAAAD/jAUJBQXmtAUICAXF2AUGCQWe/wAAAAD+gQAAAADkrQAAAADA1AAAAACU/wAAAAD/y4qNi4v03YqNjIrk7YuMjYrT/AAAAACZ////////////////////////igAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['two-stacked-squares']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACK////////////////7kEAAgAAAAAAAAD72ZmbmpqampqampqX+6MABAAAAAAAAAD/lAAAAAAAAAAAAAAA66oABAAAAAAAAAD/ngQIBAQEBAQEBQQE7KgABAAAAAAAAAD/nAAEAAACAQAAAQEA9q0ABQABAwAAAAD/nAAEAAAAAAAAAAAAQykAAAAAAAAAAAD/nAAEAgBCxM/Pz8/PwsfPz8/KawAAAAD/nAAEAgDH/////////////////wAAAAD/nAAEAQDJ/Pr9/f39/f39/f38/gAAAAD/nAAEAQDJ//z//////////////wAAAAD/nAAFAQDJ//z//////////////wAAAAD+nAADAQHJ//z//////////////wAAAAD/mQABAADK//z//////////////wAAAADr/+bn5kS7//z//////////////wAAAAA7oa6trC+///z//////////////wAAAAAAAAAAAADK//z//////////////wAAAAACBAMDBQHI//z//////////////wAAAAAAAAAAAQDJ//z//////////////gAAAAAAAAAAAgDK//z//////////////wAAAAAAAAAAAwBl9fz///////////37mQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['speedometer']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQQAAAAAAAAAAAABAgAAAAAAAAAAAAACAAAFOGWAgGJADQIBAF5SAAAAAAAAAAMACXXY///////QHgACjP9xAAAAAAAAAwAx0f///vn6/5oLABu6/6kAAgAAAAADADrx//v9+//7bgAAQOH/2hEEAgAAAAACGur/+//7/+JBAABt+//4OAAAAQAAAAAAqP/7//z/vR0ACpz/+v9xABd5AAAAAAA1/f3//P+tAwAmx//4/6wAAKH/LwAAAACX//z+/uoRAEnp//n/3RIAZf/9lQAAAADY//37/6QAKPj/+vz7OQAw9/z/1wAAAAD2///7/4wCWP/2+f9wAA7W//z/9QAAAAD////8/64AHef//6kAAKP/+////gAAAAD1///+/vMiACuLdAoAZ//7////9QAAAADW//3//f/LHAAAAABP+fz+//3/1gAAAACT//z///3/6IhaY6n///7///z/lAAAAAAx/P3////9/////////v////38MQAAAAAAov/4+/v7+vf4+Pj7+/v7+P+iAAAAAAACFub//////////////////+YXAgAAAAACADGcnJ2dnZ2dnZ2dnZ2cnDEAAgAAAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['location-pin']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQAymNn09NeULgABAQAAAAAAAAAAAAECAYb3////////9H8AAgEAAAAAAAAAAQMBqf///P37+/38//+gAAMAAAAAAAAAAwB+//n//f/////9/vn/cwADAAAAAAACAB/4/P7+//CztPL//v788xkAAgAAAAAEAHr/+/3/xR8AACPM//37/28ABAAAAAADALj++/72IQAFBQAq+f37/q0AAwAAAAAAAND/+v/IAAMAAAIA0v/6/8YAAQAAAAABAM3/+v/RAAQBAQMB2v/6/8MAAgAAAAADAKz++/39PwAAAABJ/v37/qIABAAAAAAEAGT//P7/5k0LDFLq/v78/1kABAAAAAABAQ/o/v3////j5f////3+4QsBAQAAAAAAAwBW//v9/v3///3+/Pz/TAADAAAAAAAAAAMAdv///f/9/f/9//9tAAMAAAAAAAAAAAADAFDX//7///7/00oAAwAAAAAAAAAAAAAAAwAIsf78/P6oBgADAAAAAAAAAAAAAAAAAAYARP/8/f85AAYAAAAAAAAAAAAAAAAAAAEBE+///+gNAQEAAAAAAAAAAAAAAAAAAAACALv//7AAAwAAAAAAAAAAAAAAAAAAAAADAVb49UwBAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['location-pin-map']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAADAAAAAAAAAAAAAAAAAAAAAAACAAUrKwUAAgAAAAAAAAAAAAAAAAAAAAIAXtr9/dpeAAIAAAAAAAAAAAAAAAAAAwBi////////YQADAAAAAAAAAAACBAECAQ/s/f/Gxv/97A8BAgEEAgAAAAAAAAAAAED//7gAALj//0AAAAAAAAAAAAAefNpxAEv//6QAAKT//0oAcdp8HgAAAADf/7k8ABz4/PuVlfv89xwAPbn/3wAAAAD/cgAABgCF//3///3/hQAGAABy/wAAAAD+bgMGAAACjv75+f6OAgAABgNu/gAAAAD/cAACXV0BAGb//2UAAV1dAgBw/wAAAAD/cAAAz9AAAgr19AoCANDPAABw/wAAAAD/cAAAwMEAAwLa2gIDAMHAAABw/wAAAAD/cAACxMUDBQAaGgAFA8XEAgBw/wAAAAD/cgEAvr8AAgQhJQQCAL++AAFy/wAAAAD9ZAAq2981CAC5ygAGNN/bKgBk/QAAAAD/ws7/8u//76TZ4aLu/+/y/87C/wAAAACY8L5hGBJMmuX//+WaTRIYYb7wlwAAAAAACAAAAAAAAAArKwAAAAAAAAAIAAAAAAACAAMEAQEDBAAAAAAEAwEBBAMAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['crown']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAgAAAAAAAgA4OQABAAAAAAACAQAAAAAAAAECAAADAEX8/UcAAwAAAgEAAAAAAAABJgAABAICCd3//90JAgIEAAAnAgAAAACt/bkwAAMAg//7+/+AAAMAMrr9sQAAAAD4///5hgYl+Pz+/vz2IAiJ+v//+gAAAADX/vv//83L//3///3/yND///v+2QAAAAC9//3+/P///v/////+///8/v3/vwAAAACf//z///39/////////f3///z/oQAAAACA//z///////////////////z/gQAAAABh//3///////////////////3/YgAAAABE//7///////////////////7/RQAAAAAq+v/+/////////////////v/6KwAAAAAV6//9/Pv7/P3+/v38+/v8/f/rFQAAAAAE1vz///////////////////zWBAAAAAAAyv/ptH9YPi8oKC8+WH+06f/KAAAAAAAAfFkAAAQfNkZOTkY2HwQAAFl8AAAAAAABABl7yfH///////////HJexkAAQAAAAABG+b///////z7+/z//////+YbAQAAAAABAR9trNTr+P7///7469SsbR8BAQAAAAAAAAAAAAMWJzQ7OzQnFgMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['flame']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEP3vXRhhwAAwAAAAAAAAAAAAAAAAAABAFQ//7//+dWAAMAAAAAAAAAAAAAAAAAAwC+//v+/P//UQADAAAAAAAAAAAAAAAEAE3//P////z+6xMBAQAAAAAAAAAAAAIBFeX+/f/////7/3EABAAAAAAAAAAAAQMBuf/8///////8/rkBBQEAAAAAAAAAAwCH//v////////9/9gAAAAAAAAAAAADAD//+/7////+///9/9cOOxwAAQAAAAACAcX//P////////////Ti/7cAAgAAAAAAKf7+//////39/f7//////vQVAAAAAAAAVv/8///9/85c//39//79/f89AAAAAAAAZf/7///7/4oAev///v///P5TAAAAAAAAWf/7///9/0ACAD7f/v3//P9OAAAAAAAAMf/+//7/9BcCCQBw//v//v8sAAAAAAABBdv+/f7+9x0ABACJ//v9/dgEAQAAAAAEAGr/+v/9/7MbBkvx/v76/2kABAAAAAABAgTD//n//v/w3f///vr/xAQCAQAAAAAAAgEX0//+/fz///38/v/UGAECAAAAAAAAAAIAEqP9/////v///qMSAAIAAAAAAAAAAAACAABCpOD6++KlQgAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['lock-closed']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAUtT//8I4AAIAAAAAAAAAAAAAAAAAAwBu/+KVnfP7RgADAAAAAAAAAAAAAAACACj/tAgAABna7A4BAQAAAAAAAAAAAAAEAIj+GQAHBwBE/1UABAAAAAAAAAAAAAMFAbHqAAIBAwIX/nwBBgMAAAAAAAAAAQAAAK/mAAAAAAAT/3oAAAABAAAAAAACAGTCye/6y8vLy8rQ/+TJukcAAgAAAAAAR/////////////////////okAQAAAAAAhv34/f7//Pz7+/z9//79+f9XAAAAAAAAg//7/////////////////P5XAAAAAAAAhP/7/////v/h6v/+/////P9XAAAAAAAAhP/7/////v8kVf/8/////P9XAAAAAAAAhP/7//////8ZSP/8/////P9XAAAAAAAAhP/7//////8dS//8/////P9XAAAAAAAAhP/7/////v8UR//8/////P9XAAAAAAAAhP/7/////v+/0P/+/////P9XAAAAAAAAhP37////////////////+/xXAAAAAAAAhv/8/Pz9/v/8/f/+/fz9/v9WAAAAAAABLs/8////////////////+L0WAQAAAAABAAM3c6nQ6ff+/fXlyaFqLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['bell']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAABawO349+q2SwABAAAAAAAAAAAAAAECCaj//////////5MBAwEAAAAAAAAAAAIArf/7/f7///79/P+QAAMAAAAAAAAAAwBQ//r//////////vv/NQADAAAAAAAAAwCy/fv///////////v+kwAEAAAAAAABAArl//7///////////3/zQABAAAAAAADADP//v////////////7/9hoAAgAAAAAEAGv/+//////////////8/00AAwAAAAADAKb/+//////////////7/4gABAAAAAAABNz//f/////////////8/8EAAgAAAAAAJvz////////////////+/+8RAAAAAAAAW//8/////////////////f8/AAAAAAAAlf/7////////////////+/93AAAAAAAAy//9/////////////////P+wAAAAAAAi8/v6/Pz+//39/f3//vz8+vvjDgAAAAA7///////////////////////3IQAAAAACNXCatsP4+Nzn5df88sK0lWosAAAAAAAAAAAAAACl+ioAAED/gQAAAAAAAAAAAAAAAgQEBQIi6fOWnv/WEgMEBAQCAAAAAAAAAAAAAAIALcD//7AdAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['compass']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAECABBpue07ZemxXwkAAwAAAAAAAAAAAQEAYN3///8nU////9NQAAMAAAAAAAABAwGa///8/P4bTP74/f//hQADAAAAAAADAJv/+v3//f+nvP77/f37/4EAAwAAAAAAXP/6/////fv////////++/9DAAAAAAAP4/39///+/////+/M0P/+/P7OBAAAAABo//z///7/xoZUNBgAB+T//f3/SgAAAAC6/Pv9/P/GAAAcAAABFO7//Pr9nAAAAAD6////+/+HALH/24kBN//+////4AAAAABBLS6q/v9YBu39//gBW///iCwuQAAAAABeTE24//8nLP///7oBjv/+nEtMWgAAAAD8//////ERCoTL82MAuP/7////4gAAAAC2+/n7/8kAAAAAAwAf6f7+/fj7mAAAAABi//39/8oHDzJWfa3p//7///3/RQAAAAAL3v79///c5////////v///P/HAgAAAAAAU//6/v////////z+///++/87AAAAAAADAJD/+/39/P+Qq//9//z8/3YAAwAAAAABAwCO///9+/4aSv74/f//eAADAAAAAAAAAQIAVNP///8nVf///8hEAAMAAAAAAAAAAAADAAlcq+E7Y92jUQIAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['controller']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAECAAAAAAAAAAAAAAAAAwAAAAAAAAAAAQAALmVyc3Nzc3NzcVgXAAIAAAAAAAABAQyj///////////////ubQACAAAAAAACArb//fv7+/v7+/v7+Pj//2oAAwAAAAAAU//5/vz+/////////////fMVAAAAAAAApf35/////f////r7kWPw+f9SAAAAAAAAyP//2UfX//3/////HwDb//+AAAAAAAAO5f/hlgCT4f39/p6Nxqu/fviwAAAAAAAr+v8fAAkAHf/+9QAA8f9BAMniAQAAAABQ//ywbABqr/39/6qavp7Hjvj1HQAAAAB5//n/zxTN//z/////HADa//7/RgAAAACj//z8+vD6/P////r7onfz+vv/dQAAAADL//3///////39/f7///////z/pwAAAADu//7///7//v///////Pv///3/1gAAAAD+///////8/8o/ReD//f////7/7gAAAADj/f3///77/DAAAEP/+v7///z90wAAAABq//77+/3/hAAGBgCP//v7+/3/XwAAAAAAhv////yTAgMBAQMFqP////+CAAAAAAABAC1kYCkAAAAAAAEAAD93cTAAAQAAAAAAAgAAAAACAAAAAAABAQAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['magnifying-glass']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAEmj2/T026NJAAADAAAAAAAAAAAAAwAotf//////////tSgAAwAAAAAAAAADAD/u//+0akREarT//+4/AAMAAAAAAAABJfH/2EEAAAAAAABB2P/wJgECAAAAAAABuv/aGgADBAMDBAMAGtr/vgECAAAAAABI//s7AAUAAAAAAAAFADv6/0MAAwAAAACo/7MABAAAAAAAAAAABACz/p4ABAAAAADh/2EBBAAAAAAAAAAABAFh/9ICAAAAAAD5/z0AAwAAAAAAAAAAAwA8/+kOAAAAAAD7/zoAAwAAAAAAAAAAAwA6/+sPAAAAAADm/1kBBAAAAAAAAAAABAFZ/9cDAAAAAACz/qYABAAAAAAAAAAABACl/qgAAwAAAABX//YpAAQAAAAAAAAEACn1/1IABAAAAAAFzP/HCgAFAwICAwUACsj/0AYBAQAAAAAAOPz/wSYAAAAAAAAmwf/4MgAFAAAAAAADAFr7/++SRyYmR5Lv////nQkABAAAAAAAAwBD1P////7+////1VDG/8YeAAAAAAAAAAMACma56P396LpmCwAf5f/hQAAAAAAAAAACAAAADyIiDwAAAAUAOPH/6QAAAAAAAAAAAQQCAAAAAAIEAQAEAF3ndgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['sword']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABACY8vL08/PscwAAAAAAAAAAAAAAAAAEAHH/////////6QAAAAAAAAAAAAAAAAMARf/8/v////7+6AAAAAAAAAAAAAAAAgAf6/79//////7/6AAAAAAAAAAAAAABAwbK//z///////7/6AAAAAAAAAAAAAAEAJ7/+/z+//////7/5gAAAAAAAAAAAAQAbf/6/v////////3+7wAAAAAAAQMAAwBA/fr9/6no//7//f//gwAAAAAAAAABARvo/fr/awC4//z8//lhAAAAAAAAKbEPAMf/+f9sAID+/fv/4DoAAwAAAAAASv9ci//4/24Aff/8+/+9GQAEAAAAAAACC77///z/cAB7//n+/5IDAAMAAAAAAAACAg7C//lmAHj/+P/6ZgABAgAAAAAAAAAAAAAFv/9Zav/3/+I9AAQBAAAAAAAAAAAAOKsqBMT///3/wRsABAAAAAAAAAAAAACf///lJgTA//iJAAADAAAAAAAAAAAAAAD9/vn/5C0MwP9bGAQBAAAAAAAAAAAAAABx//35/7EADLz/uQADAAAAAAAAAAAAAAAAbv///zgBAARGKAABAAAAAAAAAAAAAAAEAHLtoQECAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['crosshairs']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAADbyAAAAAMAAAAAAAAAAAAAAAAAAgAHQYT/+3o7AgADAAAAAAAAAAAAAAEBAF3U///9////zFAAAgAAAAAAAAAAAQMCnP//3Kf/+qXk//+JAAMBAAAAAAAAAwCc//h2CwDo1gARhP//hAADAAAAAAADAFb/9ksAAAIZFQMAAGD8/z8AAwAAAAACBtf/eAAGAQIAAAEBBgCS/78BAwAAAAAAO//gBQQBAAAAAAAAAgMT8P0kAAAAAAAAff6gCQABAReZkRABAQALuv9lAAAAAADJ+P7z6lEBAKf//5EAAWns9P32swAAAADc//76+lsAAK///5oAAHX8+v3/xQAAAAAFiP6kFwABAR+rpBYBAQAYvP9wAgAAAAAAPv/aAAQBAAAAAAAAAgMM7P4mAAAAAAACCNz/cQAGAQEAAAEBBgCL/8UCAwAAAAAEAF3/80UAAQRdUwQAAFn6/0UAAwAAAAAAAwCi//ZxCQj/9QAPf/3/igADAAAAAAAAAQIEof//26X69KPi//+OAAMBAAAAAAAAAAEBAGDU///+////zFMAAgAAAAAAAAAAAAABAgAHQYT/+3o7AgACAAAAAAAAAAAAAAAAAAMAAADbyAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['pencil']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAQ962DgADAAAAAAAAAAAAAAAAAAAABQRO7///whIAAwAAAAAAAAAAAAAAAAADAACv//j7/88XAAAAAAAAAAAAAAAAAAQAUUYAtf/7+//TIAAAAAAAAAAAAAAABQBO//c8ALf/+/v/zwAAAAAAAAAAAAAFAFH8/f/0PQC4//j/1AAAAAAAAAAAAAUAVPz+/v3/9D0At//dJwAAAAAAAAAABQBX/f79///9//Q6AJ8sAAAAAAAAAAAFAFn+/f3//////f72QAAAAgAAAAAAAAUAXP/9/v///////f/uOgMEAAAAAAAABABf//3+///////9/+4zAAIAAAAAAAAEAGL//f7///////3/8TgABAAAAAAAAAAAY//9/v///////f/0PQAEAAAAAAAAAABl//3+///////9/vdCAAQAAAAAAAAAAAD2//7///////3++UcABAAAAAAAAAAAAAD//////////f77TAAEAAAAAAAAAAAAAAD+///////+/f1RAAUAAAAAAAAAAAAAAAD+//////3+/1cABQAAAAAAAAAAAAAAAAD//////v/9WwAEAAAAAAAAAAAAAAAAAACh/P3+/exhAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['pencil-square']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADMDIyMjIyMjItAwABBAWP6HkAAwAAAAC3////////////OQAFAG3//P99AAAAAAD/o0xPTExMTE1HCwAFJQ26//j/hgAAAAD9cgAAAAAAAAAAAACg8jIAvv/88AAAAAD/fAMHAwMDAwUFAJ7///A1Ab7/ZwAAAAD/egAEAAAAAQIAof/7/P/vMA1VAAAAAAD/egAEAAACAgCk//r///z/9RcAAwAAAAD/egAEAAEBAaf/+v///vv/gQcIAQAAAAD/egAEAQIEqv/6////+/+DAAAAAAAAAAD/egAEAgGg//r////7/4kAAw8/AgAAAAD/egAGAB3//f7///r/jwAHAFj/IQAAAAD/egAGACj7/v3++v+VAAMFAF3+JgAAAAD/egAGACX//////5oAAwEEAFz/JQAAAAD/egAFAQi3+vnzlAACAQAEAFz/JQAAAAD/egAEAQABISQaAAEBAAAEAFz/JQAAAAD/egAEAAAAAAAAAgAAAAAEAFz/JQAAAAD/fAQIBAQFBgYGBAQEBAQIBF//JQAAAAD+cAAAAAAAAAAAAAAAAAAAAE//JQAAAAD/u3p9e3t7e3t7e3t7e3t9eqv/JAAAAACh//////////////////////+rBgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['trash-can']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwFP8f/////xTwEDAAAAAAAAAAAAAQMEBQDJ2XZ6enbYygAFBAMBAAAAAAAAAAAAAAv9gQMHBwOB/QsAAAAAAAAAAAAAFlCErdT/9ff39/f1/9SthFAXAAAAAAAt/f/////////////////////9LQAAAAARWMj7+f3//f7+/v79//35+8hYEQAAAAABAKL/+//////////////7/6IAAQAAAAAFBJT/+///6//////r///7/5QEBQAAAAAEAID/+f/XEs///88S1//5/4AABAAAAAAEAG3/+f/UALP//7MA1P/5/20ABAAAAAAEAFr/+v/kAaX//6UB5P/6/1oABAAAAAADAEn/+//uAJT//5MA7v/7/0kAAwAAAAADADj//f/4CIP//4MI+P/9/zgAAwAAAAACACj+////C2n//2kL/////igAAgAAAAACABr1//3/Pn3//30+//3/9RoAAgAAAAABAA7q//3/+v3///35//3/6g4AAQAAAAABAATc//3///////////3/3AQAAQAAAAAAAADT/Pr9/f7///79/fr80wAAAAAAAAAAAwCl////////////////pQADAAAAAAAAAQEVdqrQ6ff+/vfp0Kp2FQEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['book-closed']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgB83gR48e3w8PDw8O/vxSMBAgAAAAAEAGb/+QKB//7////+/////68AAwAAAAACAMz98gOA/vr///////79/dYAAAAAAAAAANH/9AOA//7RL1Cb2P/9/9EAAAAAAAAAANH/9AOA//93ACYABHX//9IAAAAAAAAAANH/9AOA//8sQv/ZB2H//9IAAAAAAAAAANH/9AN+/+IAgv/gALX//9IAAAAAAAAAANH/9AN+/8wCADU+B+v//9IAAAAAAAAAANH/9AOA//zSjEMKU//7/9IAAAAAAAAAANH/9AOA//v////z+P/8/9IAAAAAAAAAANH/9AOA//v9+/z////9/9IAAAAAAAAAANH/9AOA//v////+/v/9/9IAAAAAAAAAANH/9AOA//v////////9/9IAAAAAAAAAANH/9AOA//v////////9/9IAAAAAAAAAANH/9AOA//v////////9/9EAAAAAAAAAANH+8wOA//v////////8/tUAAAAAAAAAAM///AeG/////////////8gAAQAAAAAAAOLAHAAEGxobGxseG8XYHwsAAQAAAAADAL/fZG9pZGRkZGRmY9bnaUMAAQAAAAACASze/////////////////8YAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['check']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQQEAgAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIABYOaJAAAAAAAAAAAAAAAAAAAAAAAAgEFsv//0gAAAAAAAAAAAAAAAAAAAAACAQWy//f95gAAAAAAAAAAAAAAAAAAAAIBBbL/+P/2SQAAAAAAAAAAAAAAAAAAAgEFsv/4/vlIAAAAAAACBAQAAAAAAAACAQWy//j/+UoABQAAAAAAAAAAAAAAAAIBBbL/+P74SQAEAAAAAAAum3QAAgEAAgEFsv/4/vlKAAQAAAAAAADn//+cAAIDAQWy//n/+UoABAAAAAAAAAD8+/n/mwAABrP/+f75SgAFAAAAAAAAAABg//35/5oRtP/4/vlKAAQAAAAAAAAAAAAAXv/8/P/j//v++UoABQAAAAAAAAAAAAAFAGH//fz/+/75SgAFAAAAAAAAAAAAAAAABQBh//z4//lLAAQAAAAAAAAAAAAAAAAAAAQAYv//+EsABQAAAAAAAAAAAAAAAAAAAAAEAEeLNwAEAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAMEAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['three-dots-horizontal']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAwQDAQAAAAMDBAIAAAACAwQDAQAAAAAAAAAAAAEAAAAAAAABAAAAAAAAAAAAAAAMlJxWGAACAGynaCsAAgA8qn07AwAAAABg////6iwAHP////1lAQDG////sgAAAACo+vj6/0gAV/z49/+QABvv+/n+5AAAAADu//r76hEAmP/6+f9KAE7//vj8mgAAAACK7f//swABSd////MTAR3G/P//TQAAAAAAFEt2IAACAAk3c0IAAgAAKGhjAwAAAAACAAAAAAAAAgAAAAABAAEAAAAAAAAAAAAAAQMEAgAAAAEDBAMAAAAAAgQEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['three-bars-horizontal']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBAQEBAQEBAQEBAQEBAQEBAQEAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABnk5KTk5OTk5OTk5OTk5OTk5KTWwAAAAD/////////////////////////+gAAAABJdHN0dHR0dHR0dHR0dHR0dHN0QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAIISAhISEhISEhISEhISEhISEhBQAAAADg////////////////////////zgAAAADE6unp6enp6enp6enp6enp6ejptAAAAAAADAwMDAwMDAwMDAwMDAwMDAwMAAAAAAAEAQEBAQEBAQEBAQEBAQEBAQEBBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkkY+QkJCQkJCQkJCQkJCQkI+QWAAAAAD/////////////////////////+gAAAABNd3Z3d3d3d3d3d3d3d3d3d3Z3QwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBAQEBAQEBAQEBAQEBAQEBAQEAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['chevron-small-down']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEAAAAAAAAAAAAAAAAAAAEBAAAAAAADAAADAAAAAAAAAAAAAAAAAwAAAgAAAAAAEBAAAgAAAAAAAAAAAAACAA8SAAAAAABj6OljAAQAAAAAAAAAAAQAYObqZwAAAAD7////ZwAEAAAAAAAABABm////9QAAAADw//v8/2YABQAAAAAEAGj//Pr/2wAAAABQ+f/8/P9lAAQAAAQAaP/8/P/wOwAAAAAATvz+/P3/ZAAFBABq//z8//Q9AAAAAAAFAFH7/vz9/2MAAGv//fz/9UEABAAAAAAABABR+/78/f9ZYv/8/P/2QwAEAAAAAAAAAAUAUvz+/f////78//hGAAUAAAAAAAAAAAAFAFL9/v3//v3/+EgABQAAAAAAAAAAAAAABQBT/P78/P75SwAEAAAAAAAAAAAAAAAAAAQAVP3///tOAAUAAAAAAAAAAAAAAAAAAAAEAE7U2EwABAAAAAAAAAAAAAAAAAAAAAAAAwABAwACAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['chevron-small-up']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAgAQEQACAAAAAAAAAAAAAAAAAAAAAAAEAGXo6mIABAAAAAAAAAAAAAAAAAAAAAQAaf////9jAAUAAAAAAAAAAAAAAAAABABp//z8/Pz/YQAFAAAAAAAAAAAAAAAEAGj//P3///39/14ABQAAAAAAAAAAAAQAZ//8/P/6/P/8/f9bAAQAAAAAAAAABABn//38//pETf7+/P3+WAAFAAAAAAAEAGf//Pz++k4AAFX9/vz+/lUABQAAAAAAZP/9/P77TwAEBQBU/P78/v1RAAAAAABk//38/vtPAAQAAAUAU/z+/P76TQAAAAD4/fv++1AABQAAAAAFAFL7/vr+5QAAAADz///8UQAEAAAAAAAABABR/P//7gAAAABP1tdNAAQAAAAAAAAAAAQAStPZUwAAAAAAAgIAAgAAAAAAAAAAAAADAAEDAAAAAAADAAADAAAAAAAAAAAAAAAAAwAAAgAAAAAAAQEAAAAAAAAAAAAAAAAAAAEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['chevron-large-left']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQIAmtg3AAIAAAAAAAAAAAAAAAAAAAABAgCd//9+AAQAAAAAAAAAAAAAAAAAAAECAKL//9IYAQEAAAAAAAAAAAAAAAAAAQIAo///1RkAAgAAAAAAAAAAAAAAAAABAgCk///WGgADAAAAAAAAAAAAAAAAAAICAab//9caAAMAAAAAAAAAAAAAAAAAAQIBp///1xsAAwAAAAAAAAAAAAAAAAABAAGp///YHAADAAAAAAAAAAAAAAAAAAECBar//9ocAAMAAAAAAAAAAAAAAAAAAAMAkf/7zxsAAwAAAAAAAAAAAAAAAAAAAAQAnv/7wgkBAgAAAAAAAAAAAAAAAAAAAAECDsD//8YOAAIAAAAAAAAAAAAAAAAAAAABAAvA///FDgACAAAAAAAAAAAAAAAAAAAAAgALwP//xQ4AAwAAAAAAAAAAAAAAAAAAAAIAC8D//8UOAAIAAAAAAAAAAAAAAAAAAAACAAvA///FDgACAAAAAAAAAAAAAAAAAAAAAgALwP//xg8AAQAAAAAAAAAAAAAAAAAAAAIAC8H//8USAgEAAAAAAAAAAAAAAAAAAAACAAu8//97AAQAAAAAAAAAAAAAAAAAAAAAAgAMwfFCAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['chevron-large-right']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAXdtxAAQAAAAAAAAAAAAAAAAAAAAAAAQAt///cgAEAAAAAAAAAAAAAAAAAAAAAAIBNu7//3YABAAAAAAAAAAAAAAAAAAAAAACADnw/v93AAQAAAAAAAAAAAAAAAAAAAAABAA68f7/eAAEAQAAAAAAAAAAAAAAAAAAAAQAO/H+/3oABAAAAAAAAAAAAAAAAAAAAAAEADzy/v97AAQBAAAAAAAAAAAAAAAAAAAABAA88v7/fQADAAAAAAAAAAAAAAAAAAAAAAQAPvT//34AAgAAAAAAAAAAAAAAAAAAAAAEADjo+/9eAAMAAAAAAAAAAAAAAAAAAAADACHi+/9oAAQAAAAAAAAAAAAAAAAAAAQAKef//5YBAgAAAAAAAAAAAAAAAAAABAAq5f//lgACAQAAAAAAAAAAAAAAAAAEACnl//+WAAMBAAAAAAAAAAAAAAAAAAQAKuX//5cAAwEAAAAAAAAAAAAAAAAABAAq5f//lwADAQAAAAAAAAAAAAAAAAACACrl//+XAAMBAAAAAAAAAAAAAAAAAAIBKeX//5gAAwEAAAAAAAAAAAAAAAAAAAQAs///lAADAQAAAAAAAAAAAAAAAAAAAAMAbPWZAAMBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['heart']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQIAAAAAAAADAwAAAAAAAAIBAAAAAAABAAAycot9TQoAAApNfYtyMgAAAQAAAAAADKP//////91RUd3//////6MMAAAAAAAFuf/9+/v7/P/////8+/v7/f+5BQAAAABz//r///////3+/v3///////r/cwAAAADb/f3///////////////////392wAAAAD7////////////////////////+wAAAAD6////////////////////////+QAAAADY/v3///////////////////3+2AAAAACI//z///////////////////z/iAAAAAAc8P3+/////////////////v3wHAAAAAAAcf/6////////////////+v9xAAAAAAADAbb/+v/////////////6/7YBAwAAAAABAQ7L//r///////////r/yw4BAQAAAAAAAgATxv/6/v/////++v/GEwACAAAAAAAAAAIAC6r//vz///z+/6oLAAIAAAAAAAAAAAACAAB4+//7+//7eAAAAgAAAAAAAAAAAAAAAQIAOcr//8o5AAIBAAAAAAAAAAAAAAAAAAADAANkZAMAAwAAAAAAAAAAAAAAAAAAAAAAAwAAAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['Clock']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAApdr9/z8tunUwMAAwAAAAAAAAAAAQIAVtX//////////8pGAAMAAAAAAAABAwCQ///9/f78/P78/f//egADAAAAAAADAJH/+/3///////////z8/3cAAwAAAAAAVP/6/v///f+Lnv/8///++/88AAAAAAAM3v79/////f8hQf/8/////P/IAwAAAABj//3//////f8xTv/8//////3/RQAAAAC6/vz//////f8uS//8//////z+mwAAAADp//7//////f8wT/38//////3/0AAAAAD8/////////f8nQ//7//////7/5gAAAAD9/////////P98AJb//f////7/5wAAAADr//7///////3/bgCR//z///3/0QAAAAC9/vz///////79/2hc//z///z+nwAAAABo//3////////+/v////////3/SgAAAAAP4/39//////////3+/////P7OBAAAAAAAXP/6///////////////++/9DAAAAAAADAJv/+v3///////////37/4EAAwAAAAABAwGb///9/f7///79/f//hQADAAAAAAAAAQEAYN3//////////9NQAAMAAAAAAAAAAAECABBpu+n8++WzXwkAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['key']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAMeLhZgAAAwAAAAAAAAAAAAAAAAAABAAu5f///7YfAAMAAAAAAAAAAAAAAAADAC7q//z+/P/nOAADAAAAAAAAAAAAAAIALun//P/9//n/8TQAAgAAAAAAAAAAAgEg6P/8///////8/+UXAgAAAAAAAAAABABg//r//vlmKrH/+f+uAAAAAAAAAAAABABg/vv8/88AAC///Pz/UAAAAAAAAAAABAJY//v+/vJGEJb//P380QAAAAAAAAAABgCB//v//v/+6v////v/sgAAAAAAAAAEAGT9/f////7///3/+/+8DgAAAAAAAAUAYv/9/v/////+/v/7/8ALAAAAAAAABABh//z+/////vz9/fv/wQwAAgAAAAAFAGD//f7////7//////+9DAACAAAAAAAAXP/9/v//////71hDQz4EAAIAAAAAAABg/v3+///+++2rNgAAAAAAAQAAAAAAAAD7//7////8/7kAAAMDAwMBAAAAAAAAAAD//v////73gjsEBAAAAAAAAAAAAAAAAAD+/v//+//fAAABAAAAAAAAAAAAAAAAAAD//////+49BAQAAAAAAAAAAAAAAAAAAACT8PLz4EEAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['flag']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACZsAAka7fZy4QWAAAAAAY5gVcAAQAAAACM+rvy///////gdUJTldb+//8rAAAAAAA3/////f3+/fz/////////+/gjAAAAAAAJ3vz8///////9+/38+/37/7AAAwAAAAAApf/7///////////////9/0oABAAAAAAAY//7//////////////3/2wADAQAAAAAAJvz+/v////////////799VwABAAAAAABAtX//f/////////////+//5MAAAAAAAEAJb/+/78/P3//////////f7zPQAAAAAEAFL//P/////8/v////78/Pz/lgAAAAACABn0/+/FueT///z8/f////vCKAAAAAAAAgDPzxUAAA105////+2yaigAAAAAAAAABACJ8gIBAwAAEUheRhUAAAABAQAAAAAAAwA+/zsAAwEDAAAAAAACBAIAAAAAAAAAAQAK+IMABAAAAQMEAwEAAAAAAAAAAAAAAAMAwNAAAgAAAAAAAAAAAAAAAAAAAAAAAAQAc/0SAAEAAAAAAAAAAAAAAAAAAAAAAAIALf9LAAQAAAAAAAAAAAAAAAAAAAAAAAEAA/GiAAQAAAAAAAAAAAAAAAAAAAAAAAADAJigAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['tag']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQBZ3+jq6urq6ejjbwAAAAAAAAAAAAAEAFX6////////////6gAAAAAAAAAAAAUAV//+/f7+/v/+//7+6QAAAAAAAAAABQBW/v3+///+/+guVvz/6AAAAAAAAAAFAFb+/f7////9/9oAIfr/6AAAAAAAAAUAVv79/f///////v/R4v//6QAAAAAABABW/v3+//////////////7/6QAAAAAFAFb+/f3////////////9/f7/6AAAAAAAVP79/f////////////////7+6QAAAABW/P79//////////////////3/6AAAAAD1/v3//////////////////v79WgAAAACw//v////////////////+/f9YAAAAAAAJs//7//////////////79/1oABQAAAAAABrf/+v///////////v3/WgAFAAAAAAACAQe3//v////////+/f9bAAUAAAAAAAAAAgAHt//6//////79/1sABQAAAAAAAAAAAAIAB7j/+////v3/XAAEAAAAAAAAAAAAAAACAAe5//v+/v9cAAUAAAAAAAAAAAAAAAAAAgAHtf///FsABQAAAAAAAAAAAAAAAAAAAAIACbXtXwAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['photo-camera']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQMCBAIKbH99fX9oBgIDAgIBAAAAAAACAAAAAACv////////oQAAAAAAAgAAAAAAEzU4Nn3/+fv7+/v6/3E2ODQPAAAAAABV6P/////+/////////v/////jSQAAAADx//3+/v3//v/7/P7///3+/vz/4wAAAAD//v/////////////+/f/////99AAAAAD+//////z/kS1sreT/////////8gAAAAD///////7/MAAAAA4+w/79////8wAAAAD//////f/iCQIFAwEAkf/7////8wAAAAD/////+/+pAAMAAQEG2f/9////8wAAAAD/////+/9gBAgCAwAq/f7/////8wAAAAD//////f8/AAAABANo//v/////8wAAAAD//////v7moV8lAACu//v/////8wAAAAD+///////////6zKX3//7/////8gAAAAD//P3+/v/++/z////////+/v389wAAAADX//////38/Pv6+fj7/P3/////xAAAAAAmrdzx////////////////79qkHAAAAAAAAAQVKT1NWWFlZWFYTDsoFAMAAAAAAAACAwAAAAAAAAAAAAAAAAAAAAADAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['image']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+kpmZmpqampqampqampqamZmSPgAAAAD4+ubo5+jo5+fn5+fn5+fn6Ob6+AAAAAD/awAAAAAAAAAAAAAAAAAAAABr/wAAAAD+cAAEAAcAAAAAAAAAAAAABABw/gAAAAD/cAACR96vDAIBAQQFAQAABABw/wAAAAD/cAAArP//MQADAgAAAAEABABw/wAAAAD/cAABOc2cBwIEAFZ4BwACBABw/wAAAAD/cAAFAAAAAAUAdP//ugkABgBw/wAAAAD/cAEGAAMCBQBz//v4/7oIAwFw/wAAAAD/cgAABQAEAHH//P7/+/+5CQBz/wAAAAD/agCm3mIAcf/8/v////v/uwBq/wAAAAD/dKH///+q//7+///////6/6R0/wAAAAD/8v/8/f///v///////////f/z/wAAAAD///3////8//////////////3//wAAAAD+/v/////////////////////+/gAAAAD/+/v7+/v7+/v7+/v7+/v7+/v7/wAAAAD9/////////////////////////AAAAABJmpydnZ2dnZ2dnZ2dnZ2dnZyaSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['cloud']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEEBAQEBAEAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAADAAAAAAAAAAAAAAAAAAADAAVQjqSTWgwAAwAAAAAAAAAAAAAAAAMAPND//////95RAAMAAAAAAAAAAAAAAwBA+P/7+/v7+///XQADAAAAAAAAAAABARDl//v///////z9+CUEBgIAAAAAAAAEAG//+//////////7/5IAAAADAAAAAAADAbv+/P/////////+/uyfficAAgAAAAABANH//f////////////////dkAAAAAAAAA9b+/f////////////77+v//RwAAAAAVwv79//////////////////z+ywAAAACo//3/////////////////////+gAAAAD4/f/////////////////////++wAAAAD7/P7///////////////////v/wwAAAACT//37/f////////////79+v/0MwAAAAAEkv/////8+/v7+/v7/P///9o8AAAAAAAAADma3v////////////fHbw0AAgAAAAAAAgAACC9Wd4yYmItyTSEAAAACAAAAAAAAAAIDAAAAAAAAAAAAAAABBAEAAAAAAAAAAAAAAQIEBAQEBAQEBAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['sun']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAwComgADAAAAAgAAAAAAAAAAAAAAAgAAAgDYyAADAAABAAAAAAAAAAAAAAopAAAAAgCZjQADAQAAKwMAAAAAAAADAD7/bAIDAwIAAAMDAgWS/x0AAgAAAAAAAgWW/xUCAAAKCAAAAjX/cAICAAAAAAAAAAAAJgMAVbvi369AAAklAAAAAAAAAAAAAAABAACO////////agAAAgAAAAAAAAADAwMEAlv/+vz+/fv9/zYCAwMDAwAAAAAAAAABAs/9/P/////7/6YAAwAAAAAAAACju4MAF/L//v/////9/tUBA5S7kQAAAACyzI8AGPP//v/////9/9YAA6HMnwAAAAAAAAABAtH9/P/////7/qkAAwAAAAAAAAADAgIEAWD/+vz+/vv8/zoCAwMCAwAAAAAAAAABAACW////////cgAAAgAAAAAAAAAAAAAAHgIAXcPp5rhHAAgdAAAAAAAAAAAAAgOM/BUBAAAQDgAAAjX/ZwECAAAAAAADAD3/dgIDBAEAAAIDAgec/x0AAgAAAAABAA0zAAAAAgCPgwADAQAANQUAAAAAAAAAAAAAAgAAAgDYyAADAAAAAAAAAAAAAAAAAAEDAAAAAwCyowADAAABAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['moon']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAK77sOQADAAAAAAAAAAAAAAAAAAAAAwBS7f//owAEAAAAAAAAAAAAAAAAAAADAFT///j+mwAEAAAAAAAAAAAAAAAAAAABJvb+/fv/fQAEAAAAAAAAAAAAAAAAAAAAtf/7//v/gQAEAAAAAAAAAAAAAAAAAAA6/v3///v/oQADAAAAAAAAAAAAAAAAAACa//z///3/3AQBAAAAAAAAAAAAAAAAAADY//3////9/0cABAAAAAAAAAAAAAAAAAD2///////8/swBAwIAAAAAAAAAAAAAAAD//////////P+QAAIDAQAAAAAAAAAAAAD2//////////z/jwMAAAMEBAQEAgAAAADZ//7////////8/8hLBgAAAAAAAAAAAACc//z//////////P//2aOCfpyeNgAAAAA9//3///////////39////////8AAAAAAAuP/7/////////////fv7+/j+uwAAAAABKfj9/f///////////////f7vIgAAAAADAFj///v////////////7//9LAAAAAAAAAwBZ9v/+/P7////+/P//8lIAAwAAAAAAAAMALbT+//////////yvKAADAAAAAAAAAAADAABAmdf0/vTVljwAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['trophy']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAis7Mzs7Ozs7Ozc+wEAAAAAAAAAANUVZy////////////////oVVVFQAAAADA/////v39/f39/f39/f39////2QAAAADyuCA/+v/+//////////z/eCCf/wAAAACo6AAM8f/+//////////z/TQDQywAAAABd/yYE5//+//////////3/Owr+fQAAAAAe/2MC3P/9////////////Izz/NwAAAAAA4bMAyv/8/////////v/+BIn2BwAAAAAAf/8pe/77/////////f/EF/WjAAAAAAACDMz/w//9/////////f7Z7uYcAQAAAAABAA+T6vz//v/////+/f/trCAAAQAAAAAAAQAABjn0//3///77/20LAAABAAAAAAAAAAEDAABG9v/+//7/ggAAAwIAAAAAAAAAAAAAAQQAQOj+/Pt3AAQBAAAAAAAAAAAAAAAAAAAGAE/6/5EAAgEAAAAAAAAAAAAAAAAAAAIAdef8/fGlCwEBAAAAAAAAAAAAAAAAAwBi////////qgACAAAAAAAAAAAAAAABAAvn+/n8/Pv3/zwAAwAAAAAAAAAAAAABARHg////////+0MAAwAAAAAAAAAAAAAAAQAeYo+rsJpyNwABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['bug']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAQAAAAIAHK/08qkWAAEAAAABAgAAAAAAAAAAAQEL0P/////GBgIBAAAAAAAAAAAbBwAABAB1/+fV1+n/ZQAEAAAKGAAAAADzYgAEAgNDLQAAAAAzQAMCBACB6wAAAAD/bgQIAwAARpEaN4s6AAADCASO/wAAAAD/dgAAAFXc//8qWv//z0QAAACX/QAAAADA/qWXqP//+/snU/v4//+hman/oAAAAAATnd3+//39/v8nVP/7/f7/99yNCQAAAAAAAA3g+/3//v8nVP/7//z7yAAAAAAAAAAFA3H/+////v8nVP/7///9/0kDBAAAAAADALn+/P///v8nVP/7///7/pAABAAAAAAAAdf//f///v8nVP/7///8/7MAAwAAAAAABdz//f///v8nVP/7///8/7kDAwAAAAADALj+/P///v8nVP/7///7/osABgAAAAAAZOv//v///v8nVP/7///9/9lQAAAAAACE/8P4/f7//v8nVP/7//7+7cr/YgAAAAD8mwCI//n+/v8nVP/7/vr/YAC66QAAAAD/bgIFr///+/4nVP34//+OAAGR/wAAAABuJwABA4n3//8nVf//7XAAAwA1ZQAAAAAAAAABAAAzldokTtSGIwACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['wallet']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGjw5OTk5OTk5OTk5OTcGAAEAAAAAAABZ6v/////////////////WDwMCAAAAAAD0//14TE5MTExMTExMS0xUBgAAAQAAAAD//fxHEhYUFBQUFBQUFBQSISQHAAAAAAD+////////////////////+/zSGgAAAAD////+//////////////////7/ZAAAAAD//////v7+/v7+/v7+/v7+/vv9kgAAAAD////////////////+/Pz7/v3/uAAAAAD///////////////////////3/0wAAAAD//////////////v7xX0yQ7P7/5QAAAAD/////////////+/+aAAAATf//7wAAAAD//////////////P9QBw0HO///8wAAAAD//////////////P9bAAAAgv/+8AAAAAD//////////////v7ui0ZN5v7/6AAAAAD///////////////////////3/1wAAAAD////////////////++/39/v3/vQAAAAD9//////////////////////z+mQAAAAD//v7+/v7+/v7+/v7+/v7+/vv/bQAAAADA///////////////////////nJAAAAAAKRUpKSkpKSkpKSkpKSkpKSUofAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['shopping-cart']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADz//ZgBAcEBQUFBQUFBQUFBQUEAQAAAACNpu/eAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJr/iICBgICAgICAgICAgIByFQAAAAAIA2P+////////////////////wgAAAAADADH++vr7+/v7+/v7+/v7+/r74wAAAAABAArm//3///////////////z/nAAAAAAAAgC4//z///////////////3/UwAAAAAABACD//v//////////////v/tFgAAAAAAAwBN//z//////////////P64AAAAAAAAAgAe+P/7+/v7+/v7+/v79/53AAAAAAAAAAEC1P////////////////8tAAAAAAAAAAQAo/6ZkZKSkpKSkpKQkU0AAgAAAAAAAAQAa/82AAAAAAAAAAAAAAABAAAAAAAAAAIAI/r70NLR0dHR0dDRySsAAgAAAAAAAAACAEnK5OLj4+Pj5Ofl3C4AAgAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAC6FQAABAAEAFYBeAAIAAAAAAAAAAAEBDeH/+SQBAgMAtP//UgADAAAAAAAAAAEAE/P//y8AAwIAxf//YQAEAAAAAAAAAAACAF3MegACAAIAMr2XCAEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['phone']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5buzSsBAgAAAAAAAAAAAAAAAAAAAAAWtv/+/8oCAgEAAAAAAAAAAAAAAAAAAADE//v/+/9eAAQAAAAAAAAAAAAAAAAAAAD//f///f7gDQEBAAAAAAAAAAAAAAAAAAD6//////z/UgAEAAAAAAAAAAAAAAAAAADs//7///v/PQADAAAAAAAAAAAAAAAAAADN//3/+v+RAAIAAAAAAAAAAAAAAAAAAACX//z7/5UAAgEAAAAAAAAAAAAAAAAAAABN//z/lgADAQAAAAAAAAAAAAAAAAAAAAAL3v6SAAMBAAAAAAAAAAAAAAAAAAAAAAAAf/8fAgMAAAAAAAAAAAMDAQAAAAAAAAABEvW2AAQAAAAAAAAAAQAAAAMAAAAAAAADAGn/XwAFAAAAAAEBAENSCgABAgAAAAAAAwCz/zkABQAAAQIAmf//2l8AAAAAAAAAAQIO0/c6AAMDAgCc//v7///DKQAAAAAAAAIAGNP/XwAAAJz/+v///fr/ygAAAAAAAAACABCy/7MumP/6//////778QAAAAAAAAAAAgAAbPj///z8/f7///v/jAAAAAAAAAAAAAEBABaB2v///////f+vAgAAAAAAAAAAAAAABAAADE+WzOv6+7sPAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['envelope']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9jI+Pj4+Pj4+Pj4+Pj4+Pj4+MPQAAAAD6////////////////////////+gAAAAD4//n5+/v7+/v7+/v7+/v7+fn/+AAAAAAZqf//+/7///////////77//+pGQAAAAA8AEna///8/////////P//2kkAPAAAAAD/phEAg/r//P3///38//qDABGm/wAAAAD9/+9sACO5///7+///uSMAbO///QAAAAD//P//yTMAWOT//+RYADPJ///8/wAAAAD///78//+WBwSZmQQHlv///P7//wAAAAD//////f7/5lwAAFzm//79/////wAAAAD////////7//+9vf//+////////wAAAAD//////////v3///3+/////////wAAAAD////////////8/P///////////wAAAAD//////////////////////////wAAAAD9/////////////////////////QAAAAD///37+/v7+/v7+/v7+/v7+/3//wAAAADC////////////////////////wgAAAAADK0ZcbX2Hj5SWlpSPh31tXEYrAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['microphone']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBn3/3+/vrTTQACAAAAAAAAAAAAAAADAGP/////////+j8AAwAAAAAAAAAAAAEBCOT+/P/////6/78AAgAAAAAAAAAAAAIAH/r//v/////9/t8EAAEAAAAAAAAAAAIAIPr//v/////9/98GAAEAAAAAAAAAAAIAIPr//v/////9/98GAAEAAAAAAAAAAAIAIPr//v/////9/98GAAEAAAAAAAAAAAIAIPr//v/////9/98GAAEAAAAAAAAAAAIAIPr//v/////9/98GAAEAAAAAAAAAAAIBHvn+/v/////9/t4EAQEAAAAAAAAAAAAAB9v/+f39/f34/7QAAAAAAAAAAAAAAAIdAFX/////////9TMAHAAAAAAAAAACACv9UwBGudnb29etLgB/9w0AAQAAAAABAge2/2MAAAAAAAAAA4D/jwIDAAAAAAAAAQAJpv/xysO2ucTO+v+HAAEBAAAAAAAAAAEAAD6Xv8T/9sO9ii4AAQAAAAAAAAAAAAABAgAAAADUpgAAAAADAAAAAAAAAAAAAAAAAAMAAADXpwAAAAIAAAAAAAAAAAAAAAAAAgA1cW/q0W9xJAABAAAAAAAAAAAAAAAABACV////////aAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['headphones']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAADWY4P////3WhiUAAAEAAAAAAAAAAgAXpP//yqOamqjT//+IBwABAAAAAAACACrj/4YcAAAAAAAAKqH/xBEBAQAAAAACFeLwOAAAAgQEBAMBAABW/8AEAwAAAAAArP80AAYCAAAAAAAAAgUAWv97AAAAAAA4/4IABgAAAAAAAAAAAAAFALP2FQAAAACl9xACAgAAAAAAAAAAAAADAjP/bQAAAADvvgACAAAAAAAAAAAAAAABAALpuwAAAAD/kQEEAAAAAAAAAAAAAAAAAgDE4gAAAAD+igQIAQAAAAAAAAAAAAACBwS86gAAAAD/gAAAAAEAAAAAAAAAAAIAAAC26wAAAAD/wHhrEwACAAAAAAAAAgAkcnjc4gAAAAD/////1xMBAgAAAAADAC/v////2QAAAAD//fv5/7kAAwEAAAEBEdv/+fr+2gAAAAD0////+v+LAAMAAAIDtf/7//3/zQAAAADJ/v3//vz/NwADBABh//r///z/mAAAAABi//v///v/YAAEBACQ/Pv//vz+NQAAAAAEwf/6/vz4IAACAwBF//v++v+WAAAAAAABGdH//v+YAAMAAAIBxf///7MHAgAAAAACABKg6a4QAgEAAAIBJMXmhQMAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['speaker']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAQCAAAAAAAAAAAAAAMAWop9GAABAAAAAAAAAAAAAAAAAAAABQB4////ogAEAAAEAWUoAQAAAAABAwMGAGb/+vf7uAADAAAAAfS1AAAAAAAAAAAAVv/8/vz/tAADAQNFBHT8GQAAAAARSEpm+v7+//z/tQAEABf/WRD/aQAAAADS//////7///z/tQAEDwHXvADitwAAAAD//Pz8/v////z/uABW5gCN9gCp7QAAAAD9//////////z/uABN/x1X/wR//wAAAAD///////////z/twAt/jg//xNq/wAAAAD///////////z/twAt/Tc//xJq/wAAAAD9//////////z/uABP/xxY/wSA/wAAAAD//Pz8/v////z/uABV4QCP9QCr6wAAAADV//////////z/tQADCwHZugDktQAAAAATTE1r/P7+//z/tQAEABf/VhL/ZwAAAAAAAAAAXP/7/vz/tAADAQM+A3n7FwAAAAABAwMGAHD/+vj7twADAAAAAfWxAAAAAAAAAAAABACE////qQAEAAADAV4lAQAAAAAAAAAAAQMAa52QIQABAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAQCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['x']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACE98AQAAIAAAAAAAAAAAMAG832cAAAAAD//v/BDgACAAAAAAAAAwAY0P//8gAAAADE//j/xQ4AAgAAAAADABjU//j/rgAAAAATxv/3/8MNAAIAAAMAF9L/9/+2CgAAAAAAEMn/9//CDQACAwAX0v/2/7oIAAAAAAADABLK//f/wQwBABbR//f/uggAAgAAAAAAAwASy//3/8EFEND/9/+7CQACAAAAAAAAAAMAEsv/+P+9yP/3/7wJAAIAAAAAAAAAAAADABPO//v///v/vQoAAgAAAAAAAAAAAAAAAgAQxf76+v+1CAECAAAAAAAAAAAAAAAAAgAQxf76+v+1CAECAAAAAAAAAAAAAAADABPO//v///v/vQoAAgAAAAAAAAAAAAMAEsv/+P+9yP/3/7wJAAIAAAAAAAAAAwASy//3/8EFEND/9/+7CQACAAAAAAADABLK//f/wQwBABbR//f/uggAAgAAAAAAEMr/9//CDQACAwAX0v/2/7oIAAAAAAATxv/3/8MNAAIAAAMAF9L/9/+2CgAAAADE//j/xQ4AAgAAAAADABjU//j/rgAAAAD//v/BDgACAAAAAAAAAwAY0P//8gAAAACE98AQAAIAAAAAAAAAAAMAG832cQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['pin']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwBZ20AAAwEAAAAAAAAAAAAAAAAAAAAAAwIg5fdqAAIBAAAAAAAAAAAAAAAAAAADAABs7P3/kgACAQAAAAAAAAAAAAAAAAQAE6z///77/6YCAQEAAAAAAAACAQABAwA93P/7/v//+v+sAgIBAAAAAAAAAAMAAHL7//v///////r/pAADAQAAAAAzCwAUq//+/f/////////6/48ABAAAAAD/u0fd//v+////////////+v9kAAAAAABX/////P///////////////v/9OQAAAAAATvv8/v/////////////+/u7p4wAAAAAFAFP9/v3////////////7/14kUgAAAAAABABT/f/+//////////v/pAAAAAAAAAAAAAQAVu76/f///////f/YDAIDAwAAAAAAAAEGAK///f7////+/PkyAAMAAAAAAAAAAQQAjP+s+P/9///7/2kABAAAAAAAAAABBACH/4cAVv39/vz/pwAEAAAAAAAAAAAEAIb/ggAGAFb9/f7ZDgIBAAAAAAAAAAAAg/+DAAQBBQBV/v83AAQAAAAAAAAAAACS/4EABAEAAAQAUvm0DwIBAAAAAAAAAAD4kQAEAQAAAAAFAFz7LAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['circle-i']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAApdr9/z8tunUwMAAwAAAAAAAAAAAQIAVtX//////////8pGAAMAAAAAAAABAwCQ///9/f78/P78/f//egADAAAAAAADAJH/+/3///////////z8/3cAAwAAAAAAVP/6/v///f9nff/9///++/88AAAAAAAM3v79/////f1NZ//8/////P/IAwAAAABj//3///////////////////3/RQAAAAC6/vz///3/1Co2f//9//////z+mwAAAADp//7///3/21EETP/8//////3/0AAAAAD8//////////80Tf/8//////7/5gAAAAD9/////////PstTP/8//////7/5wAAAADr//7/////+/stS/v6//////3/0QAAAAC9/vz///////8yUv////////z+nwAAAABo//3///3/x5saLZvS//3///3/SgAAAAAP4/39//v/dAAQDgCR//v//P7OBAAAAAAAXP/6////9u7s7O74///++/9DAAAAAAADAJv/+v3///////////37/4EAAwAAAAABAwGb///9/P3+/v38/f//hQADAAAAAAAAAQEAYN3//////////9NQAAMAAAAAAAAAAAECABBpu+n8++WzXwkAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['circle-question']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAARSotTq6c+aRwAAAwAAAAAAAAAAAAIATMz//////////8E9AAMAAAAAAAABAwCG///9/Pv6+vr8/v//cQAEAAAAAAADAIn/+/3//f///////vz9/28AAwAAAAAAT//6/v///8SAdKX4//7+/P83AAAAAAAK2/79//32aAAAAAA88v7+/P/EAgAAAABf//3//v7sHS/E0EgAqf/7//3/QgAAAAC4/vz///7/7+///50Anf/7//z/mQAAAADo//7////+////1h0O4v79//3/zwAAAAD8////////+/3QFA7C//3///7/5gAAAAD9/////////f8jANb//P////7/5wAAAADr//7////+//5iiv/7//////3/0gAAAAC+/v3///////////3///////z+oAAAAABp//3////+/+8tU//+//////3/SwAAAAAP5P39///+/+sFMv/+/////P7PBQAAAAAAXv/6//////7t8P/////++/9EAAAAAAADAJz/+v3///////////37/4MAAwAAAAABAgGc///8/f7+/v79/f//hgADAAAAAAAAAQEAYd3//////////9NRAAMAAAAAAAAAAAECABFqu+n8++WzYAkAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['triangle-exclamation']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAgNycgMCAQAAAAAAAAAAAAAAAAAAAAADAH///38AAwAAAAAAAAAAAAAAAAAAAAIBI/f6+vcjAQIAAAAAAAAAAAAAAAAAAAMAsv/8/P+yAAMAAAAAAAAAAAAAAAAAAwBL//z9/fz/TAADAAAAAAAAAAAAAAABAwja/v3///3+2gkDAQAAAAAAAAAAAAADAH3/+f9+cf/5/30AAwAAAAAAAAAAAAIBIfX9+/86Kv/8/fUhAQIAAAAAAAAAAAMAr//8/P9HOf/9/P+vAAMAAAAAAAAAAwBI//z//P9AMf/9//z/SAADAAAAAAABAgfY/v3//P9VRv/8//3+2AcCAQAAAAAEAHr/+//////////+///7/3oABAAAAAABHvT9/v///v+4rP7+///+/fQeAQAAAAAAqP/8///+//IAAOH//f///P+oAAAAAABL//3//////v2IePn+//////3/SgAAAADf+/n7+/v7+/v///z7+/v7+/n73wAAAADi////////////////////////4gAAAAAlfIKDg4ODg4ODg4ODg4ODg4J8JQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['calendar']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgYCKe83AgQBAQQCOe0eAgUCAAAAAAABAAAAMv9DAAAAAAAARP8lAAAAAQAAAAAAMafE0v7WxsfHx8fG1v7Pw6MpAAAAAAAr7/////3///////////3////nIQAAAACg////////////////////////jgAAAACf4+Hk5OTk5OTk5OTk5OTk5OHjkQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABgi4mLi4uLi4uLi4uLi4uLi4mLVwAAAAC9////////////////////////rAAAAACt+/j7////+/v///v7///++/j7nQAAAACw//v/63Dj//+Vlf//4XLx//v/oAAAAACw//v/4C/T//9jY///0TLo//v/oAAAAACw//z///////////////////z/oAAAAACw//z///////////////////z/oAAAAACw//z//Nn6///l5f//+tr9//z/oAAAAACv//r/1gDH//88PP//xQDh//r/nwAAAACx/vz/+cP2///V1f//9cX7//z+oQAAAACj//n9///////////////+/fn/kgAAAAA28//////////9/f/////////tLAAAAAAAOqHC1+jx+P3///z48efWwJ4yAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['hashtag']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEL3cQEAQIAHu2dAAIAAAAAAAAAAAAAAgAu/+YHAAQAUv/DAAIAAAAAAAAAAAAABABQ/r0AAgQAdv6WAAQAAAAAAAAABAQECAR1/5sECAgEnf9zBAgEAwAAAAAAAAAAAACX/2IAAAAAwP86AAAAAAAAAAAHZIB+gH/d/6d+gX+C7v6Wf39/RwAAAAA4////////////////////////9QAAAAAJbIaGhpf+9YyGiIam/uWHhoWGTwAAAAAAAAAAAC3/zgAAAABU/6cAAAAAAAAAAAAABAQIBGX/qwQHCASM/4QECAQEAwAAAAADBAQIBIf/iAQIBgOv/2EECAQEAQAAAAAAAAAAAKv/UgAAAADS/ysAAAAAAAAAAABgm5qcnOr+tZudm6H3/qmbm52BDQAAAADy////////////////////////NwAAAAA1aWlphf7qa2lraZn/1WlqaGlRBAAAAAAAAAAAPf+8AAAAAGb/kwAAAAAAAAAAAAACBAgEdf+YBAgIBJ3/cQQIBAQDAAAAAAAAAAQAl/5yAAQCAL7+TAADAAAAAAAAAAAAAAIAxf9NAAQAB+n/KgACAAAAAAAAAAAAAAIAj9oXAAIBA7TICAEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['robux']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAHKP/94sNAAADAAAAAAAAAAAAAAMBAAl5+feUof/pYQAAAgIAAAAAAAAAAgAAXOj/mxYAACmz/9RFAAACAAAAAAACAD/M/7ovAAJpVQAARdD/tCsAAgAAAAAAdf/VSgAAUdL//7g1AABg6f9RAAAAAAAn/44AAC+y///+///7lBcACbbvDAAAAABZ/xwAavj/+/L19fL//+dAAEb/LAAAAABZ/yQB0P/1QhkbHBlw+/+YAU3+LQAAAABZ/yIAxv7xEQAAAAA///6TAEz/LQAAAABZ/yIAyP/yGwECBAFJ//+UAEz/LQAAAABZ/yIAyP/yHAIDBQJJ//+UAEz/LQAAAABZ/yIAx/7xDQAAAAA9//2UAEz/LQAAAABZ/yQBzf/2Vy4wMS6B+/+UAU3+LQAAAABZ/xwAVun//////////9MyAEX/LAAAAAAn/44AAByY+//8/v/seQkACbbvDAAAAAAAdf/VSgAAOrz//58hAABg6f9RAAAAAAACAD/M/7kxAABOPAAARdD/tCsAAgAAAAAAAgAAXOj/mxkAACqz/9RFAAACAAAAAAAAAAMBAAl5+feToP/pYQAAAgIAAAAAAAAAAAAABAAAHKP/94sNAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['discord']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQMEAgAAAAACBAMBAAAAAAAAAAAAAAADAAAAAAQDAwQAAAAAAwAAAAAAAAAAAAAABTh4LwAAAAA1dzcEAAEAAAAAAAAAAgJ62P//05atrJbY///WdwECAAAAAAAEAGj///77////////+/7//2YAAwAAAAABEOr8+////fv8+/v9///7/OoQAQAAAAAAc//7///9/v/////+/f//+/9yAAAAAAAF1f79//////7///7///7//f7UBQAAAAA9/v7+///N7f/+/v/rzf///v7+PAAAAACF//z9/2gAIuH+/twdAGr//fz/ggAAAAC8//v/5gIFAIz//4EABQLm//v/uAAAAADd//3+8RcAAKn//6AAABfx/v3/2gAAAADu//79/7g/dvz+/vpzP7j//f7/6gAAAADv/v7///////39/f3///////797AAAAAD1//r+6dD//////////87q/vn/8QAAAABd5f//4X5gl8DU1MGWYYDj///iWQAAAAAAF43s/+wBAAAAAAAABfL/6ooVAAAAAAADAAAYcEABBgIAAAIGAENuFgAAAwAAAAAAAQMAAAABAAAAAAAAAQAAAAMBAAAAAAAAAAACBAIAAAAAAAAAAAIEAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['plus-small']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACADjZ1DEBAgAAAAAAAAAAAAAAAAAAAAADALf//6oAAwAAAAAAAAAAAAAAAAAAAAACAMX+/roAAgAAAAAAAAAAAAAAAAAAAAACAML//7cAAgAAAAAAAAAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAACAwICAgIEAsT//7kCBAICAgIDAgAAAAAAAAAAAAAAAMD//7UAAAAAAAAAAAAAAAA+rbu6urq7uu///+y6u7q6ubynKgAAAADw////////////////////////zwAAAAD1////////////////////////1AAAAABFt8LDw8PEw/H//+7DxMPDwsKwMAAAAAAAAAAAAAAAAMH//7UAAAAAAAAAAAAAAAADAgICAgIEAsP//7kCBAICAgIDAgAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAAAAAAAAAACAMP//7gAAgAAAAAAAAAAAAAAAAAAAAACAML//7cAAgAAAAAAAAAAAAAAAAAAAAACAMT+/rkAAgAAAAAAAAAAAAAAAAAAAAADALz//7AAAwAAAAAAAAAAAAAAAAAAAAADAEbt6j4AAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['minus-small']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEBAQEBAQEBAQEBAQEBAQEBAAAAAAADAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAABA0MDAwMDAwMDAwMDAwMDA0EAAAAAABc2Ofm5+fn5+fn5+fn5+fn5ufYXAAAAAD7////////////////////////+wAAAADt////////////////////////7QAAAAA+uMfIycnJycnJycnJycnJyMe4PgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAgEBAQEBAQEBAQEBAQEBAQECAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['play-small']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAT/GpHwAAAwAAAAAAAAAAAAAAAAAAAAAAjf//6G4EAAMCAAAAAAAAAAAAAAAAAAAAiP74///MRgAABAEAAAAAAAAAAAAAAAAAif/7/vz//6MgAAADAAAAAAAAAAAAAAAAif/7///9/f/udQcAAwIAAAAAAAAAAAAAif/7//////z//89JAAAEAQAAAAAAAAAAif/7///////++///pyQAAAMAAAAAAAAAif/7//////////39//F7CAABAAAAAAAAif/7/////////////P//004AAgAAAAAAif/7//////////////77//9mAAAAAAAAif/7//////////////78//9iAAAAAAAAif/7/////////////P//zEYAAQAAAAAAif/7//////////3+/+xxBQABAAAAAAAAif/7///////+/P//nh4AAAMAAAAAAAAAif/7//////v//8dAAAAEAQAAAAAAAAAAif/7///8/v/oawIAAwEAAAAAAAAAAAAAif/7/vz//pcaAAEDAAAAAAAAAAAAAAAAiP74///COwAABAAAAAAAAAAAAAAAAAAAjf//4GMAAAMBAAAAAAAAAAAAAAAAAAAASOmcFgABAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['pause-small']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC3397f397YOQADAwBg3t3f393fjQAAAAD/////////cQAEBACk////////3gAAAAD9/v7+/vr+bAAEBACd/vr+/v3+1QAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD///////v/bQAEBACe//v///7/1wAAAAD+//////v/bAAEBACd//v///7/1gAAAAD///////v/cQAEBACj//v///7/3AAAAADb//7///35SgADBAB3/vz///3/rQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['stop-small']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWpN3f4ODg4ODg4ODg4ODg39uKBQAAAAC5////////////////////////hQAAAAD//f7+/v7+/v7+/v7+/v7+/vz92QAAAAD+//////////////////////7/1gAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD///////////////////////7/1wAAAAD+//////////////////////7/1gAAAAD//f////////////////////392gAAAADP//3///////////////////3/nAAAAAAtzP3+/////////////////vqzEwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]}
State.iconMasks['skull']={w=24,h=24,a=[[AAAAAAAAAAEDAwAAAAADAwEAAAAAAAAAAAAAAAAAAgAAAAEODgEAAAACAAAAAAAAAAAAAAADAABMn9Xx8dWfTAAAAwAAAAAAAAAAAAMAL7/////09f///74vAAMAAAAAAAAAAwBG8f/cdDASEzB03P/wRgADAAAAAAACACzy/54PAAAAAAAAEJ7/8isAAgAAAAACA8T/nwAABAIBAQIEAACf/8MCAgAAAAMASf/dCwEDAQAAAAABAwEM3v9IAAMAAAMAof5yAAcAAAIAAAIAAAYAc/6gAAMAAQAD1/8tAQAGBgAAAAAGBgABLv/WAwABAQAO8PYWAFPc3FMAAFLc3FQAFvbvDgABAQAO8PcRBOf//+cGB+f//+cEEvfvDgABAQAD1v8rBOj//+YHB+b//+gELP/WAwABAAMAof51AFTb3FMAAFHb3FYAdv6gAAMAAAMASP/eDAAHBgACAgAGBwAM3/9IAAMAAAACAsP/oQYBAAfCwgcAAQai/8ICAgAAAAACACrq/18BAWH//2EBAV//6ikAAgAAAAABAAXh+S0AAFLo6FIAAC364AUAAQAAAAABAAzs+D8BAgAPDwACAUD46wwAAQAAAAAAAwCP//+4AgAAAAACuP//jgADAAAAAAAAAQEHk/32IA8REQ8g9v2SBwEBAAAAAAAAAAEAAOb/8/T09PTz/+UAAAEAAAAAAAAAAAADAlHZ7O7v7+7s2VACAwAAAAAAAAAAAAAAAQAHERAQEBARBwABAAAAAAAA]]}
State.iconMasks['leaf']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAAAAAIAAgMAAQAAAAAAAAAAAAAAAAAAAAABBQANxL8GAQEAAAAAAAAAAAAAAQIDBAIAABe+//9aAAQAAAAAAAAAAAMDAAAAAAAZaN7/8v3IAQEAAAAAAAABAgAAARxEd7Tw//+4MuP/LgACAAAAAAEAADqW0vr////5tlUBAJn/cwAEAAAAAQAKmv///+zCjVUfAAAEAlf/rAADAAABAgu///OFNA8AAAAAAQMDAC//0QEAAAACAJ3/2S4AAAABBAQCAAABABv86AkAAAMAOP/vKQAGAgECAAAAAAABABHz8w8AAAMAm/+EAAYAAQQAAQEAAAABABP28A4AAQAD2P8uAgUEAAAlycMHAQECACn/2wMAAQAR8/ISAAAACWvr/8oGAQEEAV3+rQADAQAR9fMEAytz1P//pBAAAQADALz/YgAEAQAF1P6n2P///8pSAAABAAUASf7pEgABAAMAuP3//+CfSwIAAgEABQAZ3v9vAAMAAwBy/v/3XQAAAAEEAgQCABzK/7sDAwEAACn89sf/0C0AAAAAAAAAUN7/zxUBAgAAAI7/lQjD//SHNhQTLGG7//+3FgACAAAAAs39NQALmf////b1////424BAAIAAAAAD/P/FAEAADmV0O/w1qdfEgAAAQAAAAAABr/CBQEBAgAAAA4OAgAAAAMAAAAAAAAAAAICAAAAAAIDAAAAAAMEAQAAAAAAAAAAAAAAAAAAAAAAAQEBAQAAAAAAAAAAAAAA]]}
State.iconMasks['rocket']={w=24,h=24,a=[[AAAAAAAAAAAAAAAAAAABBAAAAAAIEgEAAAAAAAAAAAAAAAAAAAIAAAdHjMDd67MGAAAAAAAAAAAAAAAAAwAGbNf///////ISAAAAAAAAAAAAAAAEADTJ///Pfz08/dwHAAAAAAABAwQEAwUAVvX/z1EDAAA4/78AAAAAAAEAAAAAAABV/v+VCgAACAN7/o0AAAAAAQAESG5vTk70/38AAAQBAgLP/0gAAAACARrI////////mwAEAQAEAEn/3wkBAAACAbr/1o2I1/3cCgICAAEDB9D/bgAEAAMARP/eEgAA3P9KAAQAAQQAlf/RCQIBAAMAnP1/DBN9/7oAAwAEAACB//UyAAMAAQAI5//z9PP8/E8ACAIADJr//VUAAwAAAQEHue/y9PP2/8gYAABK0//wVAAEAAAAAAAAAhMLDRQlzv/LWbf///xSAAUAAAAAAAABAAAKBgAAF83////e1f9TAwQAAAAAAAEAF6Xu5o0KACDz+HoQgf9yAAQAAAAAAQIHx//6//+PAA/y8wgAiv5xAAQAAAAABABj/9YlPffsCA708wAY0/9IAAMAAAAAAQHI/1MAHvbwCQzx8n/g/8sIAgEAAAAAACH85hpZ1/+nABT3////tRwAAgAAAAAAAFj76ub//8MYAge535xGAAABAAAAAAAAAHj////DZQUAAQACCAAAAQEAAAAAAAAAABh1ViQAAAABAAAAAAMDAAAAAAAAAAAAAAAAAAABBAEAAAABAQAAAAAAAAAAAAAA]]}
if Base64Decode then
for k,v in pairs(IconData)do
local b=Base64Decode(v)
if b~=""then IconBytes[k]=b end
end
end
State._rebuildIcons()
WriteGlobal(LibName,ui)
WriteGlobal(LibName.."UI",ui)
return ui
