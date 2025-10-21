REM 在 x64 Native Tools Command Prompt for VS 2022 环境中编译

:: 生成
E:
cd E:\qt-build-release
..\qt-everywhere-src-6.10.0\configure.bat ^
  -static ^
  -prefix "E:\qt-install" ^
  -release ^
  -opensource ^
  -confirm-license

:: 编译
cmake --build . --parallel

:: 安装
cmake --install .
