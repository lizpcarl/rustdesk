##Windows版rustdesk远程桌面打包过程

1. 下载sciter SDK，解压后，复制“sciter-sdk.zip\bin.win\x64\sciter.dll”到编译环境的target的子目录，分别为debug和release这两个目录下；

2. release版本编译前，需要执行以下python脚本：
```
$ python inline-sciter.py
```
用来生成src/ui/inline.rs相关文件，否则编译

3. 调试版本直接使用
```
cargo run
```
生成rustdesk.exe，在项目根目录下，使用“target\debug\rustdesk.exe”运行，对应的日志会在终端显示；
如果安装到C盘之后，需要在“C:\Program Files\RustDesk\”里放入以下文件和文件夹：
“sciter.dll”
“src/”
否则会打不开。

4. release版本用以下命令：
```
cargo build --release --features inline
```
生成rustdesk.exe，可以去"target\release\rustdesk.exe"中双击运行；如果安装到C盘之后，还需要将“sciter.dll”放入“C:\Program Files\RustDesk\”中。
release版的日志文件log目录和配置config目录在如下位置：
```
%AppData%\RustDesk
```

5. Windows installer使用NSIS工具，需要安装nsis(例如nsis-3.08-setup.exe)；
项目根目录的配置文件setup.nsi中，VERSION已配置，sciter.dll文件已经引入。
先把“.\target\release\rustdesk.exe”复制到项目根目录，
再打开“makensisw.exe”之后，将项目要目录下的“setup.nsi”拖入，即可生成对应的安装包。

6. 调试web调用“URL Protocol”接口的启动方式：
```
.\target\debug\rustdesk.exe   --play "rustdesk://meshinfo/desk?id=1277363449&password=8n6tyn"
.\target\release\rustdesk.exe --play "rustdesk://meshinfo/desk?id=1277363449&password=8n6tyn"
```

7. 安装时会写入注册表“\HKEY_CLASSES_ROOT\rustdesk\”
web页面调用打开时，通过url的GET方式传入id、password参数，例如：
href="rustdesk://meshinfo/desk?id=1277363449&password=8n6tyn"





------------------------------------
##Windows版rustdesk远程桌面打包过程

###环境安装问题
1. 在MacOS下，使用vcpkg install libvpx时报BUILD_FAIL，主要原因是vcpkg的编译依赖中没有提示缺少pkg-config。使用以下方式安装即可：
brew install automake pkg-config
brew install create-dmg
另外，要安装cargo bundle ,运行cargo install cargo-bundle；

2. vcpkg使用当前最新的一个备注了mac分支(led3a8935,"Fix cross compiling macOS(#26240)")；
3. rustdesk使用Aug16的最新代码，可编译通过。
4. 下载依赖库[libsciter.dylib](https://raw.githubusercontent.com/c-smile/sciter-sdk/master/bin.osx/libsciter.dylib)，放到项目根目录。

###打包相关
1. 使用"python3 build.py"生成RustDesk.app时设置“CFBundleURLSchemes”为“rustdesk”，响应该URL Schema.
2. 为了传递web端的参数，使用了AppleScript，保存在要目录下，命名为"rustdeskregister.applescript"，判断在"on open"时按参数打开目标设备的远程连接；如果不是web端call起，就默认调用正常的rustdusk。
3. 将rustdeskregister导出为app应用，导出时选用的“文件格式”为“应用程序”，“选项”中只勾选“仅运行”，“存储”到任意目录。
4. 选择rustdeskregister.app，右键“显示包内容”，拷贝好以下文件：“Contents/MacOS/applet”、“Contents/Resources/applet.rsrc”、“Contents/Resources/Scripts/main.scpt”；再对RustDesk.app“显示包内容”，粘贴上述3个文件到对应的目录；
5. 修改RustDesk.app的info.plist，修改启动时的可执行文件为AppleScript的编译文件。
```
<key>CFBundleExecutable</key>
<string>applet</string>
```
6. 最后手动打包为dmg安装文件。
```
create-dmg --window-pos 150 80 --window-size 640 480 --app-drop-link 320 200 --icon "RustDesk.app" 30 50 --hide-extension "RustDesk.app" rustdesk-mesh1.1.9.dmg target/release/bundle/osx/RustDesk.app
```
------------------------------------




