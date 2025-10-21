@echo off
:: 0. check environment (print version)
cmake --version
g++ --version
ninja --version

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

:: 3. generate CMake build files for static builds using Ninja
echo ========================================
echo Configuring RELEASE build (Static Qt, Dynamic C++ Runtime)
echo ========================================
cd /d "%DIR_BUILD_RELEASE%"

REM 启用 gnu 扩展。使用 gnu++17 而非 c++17
cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%DIR_INSTALL%/release" ^
    -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_EXTENSIONS=ON ^
    -DBUILD_SHARED_LIBS=OFF ^
    -DQT_BUILD_EXAMPLES=OFF ^
    -DQT_BUILD_TESTS=OFF ^
    -DQT_BUILD_BENCHMARKS=OFF ^
    -DFEATURE_webengine=OFF ^
    -DFEATURE_qtwebview=OFF ^
    -DFEATURE_opengl=ON ^
    -DFEATURE_dbus=OFF ^
    -DFEATURE_icu=OFF ^
    -DFEATURE_sql_sqlite=ON ^
    -DFEATURE_system_png=OFF ^
    -DFEATURE_system_jpeg=OFF ^
    -DFEATURE_system_zlib=OFF ^
    -DFEATURE_system_freetype=OFF ^
    -DFEATURE_system_harfbuzz=OFF ^
    -DFEATURE_system_pcre=OFF ^
    -DFEATURE_static_runtime=OFF ^
    "%DIR_SRC%"

if %errorlevel% neq 0 (
    echo RELEASE configure failed!
    pause
    exit /b 1
)

REM echo ========================================
REM echo Configuring DEBUG build (Static Qt, Dynamic C++ Runtime)
REM echo ========================================
REM cd /d "%DIR_BUILD_DEBUG%"
REM 
REM cmake -G "Ninja" ^
    REM -DCMAKE_BUILD_TYPE=Debug ^
    REM -DCMAKE_INSTALL_PREFIX="%DIR_INSTALL%/debug" ^
    REM -DCMAKE_CXX_STANDARD=17 ^
    REM -DCMAKE_CXX_EXTENSIONS=OFF ^
    REM -DBUILD_SHARED_LIBS=OFF ^
    REM -DQT_BUILD_EXAMPLES=OFF ^
    REM -DQT_BUILD_TESTS=OFF ^
    REM -DQT_BUILD_BENCHMARKS=OFF ^
    REM -DFEATURE_webengine=OFF ^
    REM -DFEATURE_qtwebview=OFF ^
    REM -DFEATURE_opengl=ON ^
    REM -DFEATURE_dbus=OFF ^
    REM -DFEATURE_icu=OFF ^
    REM -DFEATURE_sql_sqlite=ON ^
    REM -DFEATURE_system_png=OFF ^
    REM -DFEATURE_system_jpeg=OFF ^
    REM -DFEATURE_system_zlib=OFF ^
    REM -DFEATURE_system_freetype=OFF ^
    REM -DFEATURE_system_harfbuzz=OFF ^
    REM -DFEATURE_system_pcre=OFF ^
    REM -DFEATURE_static_runtime=OFF ^
    REM "%DIR_SRC%"
REM 
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
cmake --build . --config Release --parallel 14

if %errorlevel% neq 0 (
    echo RELEASE build failed!
    pause
    exit /b 1
)

:: Install
cmake --build . --config Release --target install

if %errorlevel% neq 0 (
    echo RELEASE install failed!
    pause
    exit /b 1
)

REM echo ========================================
REM echo Building DEBUG version
REM echo ========================================
REM cd /d "%DIR_BUILD_DEBUG%"
REM cmake --build . --config Debug --parallel 12
REM 
REM if %errorlevel% neq 0 (
    REM echo DEBUG build failed!
    REM pause
    REM exit /b 1
REM )
REM 
REM :: Install
REM cmake --build . --config Debug --target install
REM 
REM if %errorlevel% neq 0 (
    REM echo DEBUG install failed!
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
