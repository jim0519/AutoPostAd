@echo off
cls
echo.
echo http://localhost/AutoPostAdSite
start cmd /c "C:\Program Files\Internet Explorer\iexplore.exe" http://localhost/AutoPostAdSite

ping 127.0.0.1 -n 8 -w 60000 > nul
taskkill /f /im iexplore.exe /t