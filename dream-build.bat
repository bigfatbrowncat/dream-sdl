@echo off
set OLD_PATH=%cd%
cd %~dp0

set TOOLCHAIN=%DREAM_TOOLCHAIN%-static-release
set TARGET_PATH=%OLD_PATH%\..\build\SDL\%TOOLCHAIN%

mkdir %TARGET_PATH%
cd %TARGET_PATH%
cmake -S %OLD_PATH% -B . -DSDL_STATIC=ON -DSDL_SHARED=OFF -DCMAKE_INSTALL_PREFIX=%OLD_PATH%\..\prefix-%TOOLCHAIN%
if %errorlevel% neq 0 exit /b %errorlevel%

cmake --build . --target SDL3-static
if %errorlevel% neq 0 exit /b %errorlevel%

cmake --build . --target install
if %errorlevel% neq 0 exit /b %errorlevel%

setlocal enableextensions
mkdir ..\prefix

endlocal

rem copy %TARGET_PATH%\*.a ..\prefix\lib\

cd %OLD_PATH%
