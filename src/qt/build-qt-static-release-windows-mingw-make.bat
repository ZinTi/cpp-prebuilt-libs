@echo off
:: 0. check environment (print version)
cmake --version
g++ --version
mingw32-make -v

:: 1. declare path variable
set "DIR_SCRIPT=%~dp0"
set "DIR_SRC=%DIR_SCRIPT%qt-everywhere-src-6.10.0"
set "DIR_BUILD_RELEASE=%DIR_SRC%/build-release"
REM set "DIR_BUILD_DEBUG=%DIR_SRC%/build-debug"
set "DIR_INSTALL=%DIR_SCRIPT%/qt-install"

:: 2. make directory
cd /d "%DIR_SRC%"
if exist "%DIR_BUILD_RELEASE%" rmdir /s /q "%DIR_BUILD_RELEASE%"
REM if exist "%DIR_BUILD_DEBUG%" rmdir /s /q "%DIR_BUILD_DEBUG%"
if exist "%DIR_INSTALL%" rmdir /s /q "%DIR_INSTALL%"

mkdir "%DIR_BUILD_RELEASE%"
REM mkdir "%DIR_BUILD_DEBUG%"
mkdir "%DIR_INSTALL%"

:: 3. generate makefile using Qt's configure script for static builds
echo ========================================
echo Configuring RELEASE build (Static Qt, Dynamic C++ Runtime)
echo ========================================
cd /d "%DIR_BUILD_RELEASE%"
call "%DIR_SRC%/configure.bat" ^
    -prefix "%DIR_INSTALL%/release" ^
    -static ^
    -release ^
    -confirm-license ^
    -opensource ^
    -platform win32-g++ ^
    -nomake examples ^
    -nomake tests ^
    -skip webengine ^
    -skip qtwebview ^
    -opengl desktop ^
    -no-dbus ^
    -no-icu ^
    -sql-sqlite ^
    -qt-libpng ^
    -qt-libjpeg ^
    -qt-zlib ^
    -qt-freetype ^
    -qt-harfbuzz ^
    -qt-pcre

if %errorlevel% neq 0 (
    echo RELEASE configure failed!
    pause
    exit /b 1
)

REM echo ========================================
REM echo Configuring DEBUG build (Static Qt, Dynamic C++ Runtime)
REM echo ========================================
REM cd /d "%DIR_BUILD_DEBUG%"
REM call "%DIR_SRC%/configure.bat" ^
    REM -prefix "%DIR_INSTALL%/debug" ^
    REM -static ^
    REM -debug ^
    REM -confirm-license ^
    REM -opensource ^
    REM -platform win32-g++ ^
    REM -nomake examples ^
    REM -nomake tests ^
    REM -skip webengine ^
    REM -skip qtwebview ^
    REM -opengl desktop ^
    REM -no-dbus ^
    REM -no-icu ^
    REM -sql-sqlite ^
    REM -qt-libpng ^
    REM -qt-libjpeg ^
    REM -qt-zlib ^
    REM -qt-freetype ^
    REM -qt-harfbuzz ^
    REM -qt-pcre

REM if %errorlevel% neq 0 (
    REM echo DEBUG configure failed!
    REM pause
    REM exit /b 1
REM )

:: 4. build and install
echo ========================================
echo Building RELEASE version
echo ========================================
cd /d "%DIR_BUILD_RELEASE%"
cmake --build . --target install --parallel 14

if %errorlevel% neq 0 (
    echo RELEASE build failed!
    pause
    exit /b 1
)

REM echo ========================================
REM echo Building DEBUG version
REM echo ========================================
REM cd /d "%DIR_BUILD_DEBUG%"
REM cmake --build . --target install --parallel 12

REM if %errorlevel% neq 0 (
    REM echo DEBUG build failed!
    REM pause
    REM exit /b 1
REM )

echo ========================================
echo Qt Static Build Completed Successfully!
echo ========================================
echo.
echo Release version installed to: %DIR_INSTALL%/release
REM echo Debug version installed to: %DIR_INSTALL%/debug
echo.
echo To use Release version:
echo   set QTDIR=%DIR_INSTALL%/release
echo   set PATH=%%QTDIR%%\bin;%%PATH%%
echo.
REM echo To use Debug version:  
REM echo   set QTDIR=%DIR_INSTALL%/debug
REM echo   set PATH=%%QTDIR%%\bin;%%PATH%%
REM echo.
pause
