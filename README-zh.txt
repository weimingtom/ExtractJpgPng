1. 下载OpenCV和boost。
http://sourceforge.net/projects/opencvlibrary/
http://sourceforge.net/projects/boost/
2. 用cmake和VC2008编译OpenCV-2.2.0\3rdparty中的四个库：
zlib、libpng、libtiff、libjpeg
（先用cmake-gui打开CMakeLists.txt，
Add Entry加入条目
WITH_JPEG
WITH_PNG
WITH_TIFF
然后全选中。也可以直接修改CMakeLists.txt跳过这三个条件判断。
按两次Configure和一次Generate生成工程文件，
再用VC2008打开工程文件Project.sln批生成Debug版和Release版lib）
默认输出lib文件在3rdparty\lib目录下。
3. VC2008中主菜单->工具->选项中头文件和库文件目录加入
boost和opencv 3rdparty的头文件和库文件目录
新建C++控制台工程，把附加库目录指向opencv 3rdparty的lib文件目录
附加依赖项填入libjpeg.lib zlib.lib libpng.lib libtiff.lib
下载gil的numeric插件，解压到boost\gil\extension目录下
http://opensource.adobe.com/wiki/display/gil/Downloads

