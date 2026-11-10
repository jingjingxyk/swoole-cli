@echo off

setlocal
rem show current file location
echo %~dp0
cd %~dp0
cd ..\..\..\..\

set __PROJECT__=%cd%
cd /d %__PROJECT__%

cd /d %__PROJECT__%\var\native-build\php-src\
set "PHP_SRC=%cd%"
cd /d %__PROJECT__%\var\native-build\
echo %cd%


set "PATH=%__PROJECT__%\runtime\php;%PATH%;"

:: https://packagist.org/packages/phpredis/phpredis
if not exist "redis" (
   php -c %__PROJECT__%\runtime\php\php.ini pie.phar install phpredis/phpredis:^6.3

)

if exist "%__PROJECT__%\var\native-build\php-src\ext\redis" (
    rd /S /Q "%__PROJECT__%\var\native-build\php-src\ext\redis"
)

xcopy "redis" "%__PROJECT__%\var\native-build\php-src\ext\redis" /E /I /Y


cd %__PROJECT__%
endlocal
