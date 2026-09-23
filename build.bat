@echo off
echo =====================================================================
echo  EV Charging Station Finder System - Build Script
echo =====================================================================
echo.

if not exist "src\main\webapp\WEB-INF\classes" (
    mkdir "src\main\webapp\WEB-INF\classes"
)

echo [1/3] Compiling Java classes...
javac -cp "src\main\webapp\WEB-INF\lib\*" -d "src\main\webapp\WEB-INF\classes" src\main\java\com\evcharging\model\*.java src\main\java\com\evcharging\util\*.java src\main\java\com\evcharging\dao\*.java src\main\java\com\evcharging\controller\*.java

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed! Please check JDK installation and classpath.
    pause
    exit /b %ERRORLEVEL%
)

echo [2/3] Compilation successful!
echo.
echo [3/3] Packaging evcharging.war...
cd src\main\webapp
jar -cvf "..\..\..\evcharging.war" *
cd ..\..\..

echo.
echo =====================================================================
echo  BUILD SUCCESSFUL!
echo  Deployable WAR generated at: evcharging.war
echo =====================================================================
