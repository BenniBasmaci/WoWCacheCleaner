@echo off
setlocal

:: Initialize variable
::set "BaseFolder="

:: Read World of Warcraft install path from registry and find data folder
for /f "tokens=3,* delims= " %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft" /v InstallPath 2^>nul') do set "BaseFolder=%%a %%b"

if not defined BaseFolder (
    echo World of Warcraft installation not found. Exiting.
    pause
    exit /b
) else (
    echo WoW retail folder found: %BaseFolder%
)

set "TargetFolder=%BaseFolder:_retail_\=Data%"

echo WoW data folder found: %TargetFolder%

:: Create WoWCacheCleaner folder if it doesn't exist
if not exist "%ProgramData%\WoWCacheCleaner" (
    mkdir "%ProgramData%\WoWCacheCleaner"
)

echo Generating WoWCacheCleaner Batch at  %ProgramData%\WoWCacheCleaner\wow_cache_cleaner.bat
:: Create wow_cache_delete.bat
(
echo @echo off
echo ::
echo echo run WoWCacheCleaner.bat....
echo echo If you see this prompt even though you didn't manually start WoWCacheCleaner, the WoWCacheCleaner failed to execute properly
echo echo If this happens regularly and you're annoyed by it, just remove WoWCacheCleaner by deleting it at %ProgramData%\WoWCacheCleaner
echo echo If you know what you're doing, you can also remove the scheduled task WoWCleaner has created. If not, no biggie. Shouldn't really be an issue.
echo echo Check if battle.net or World of Warcraft are running
echo tasklist ^/FI "IMAGENAME eq Battle.net.exe" 2^>NUL ^| find ^/I "Battle.net.exe" ^> NUL
echo if %%ERRORLEVEL%%==0 ^(
echo   echo WoWCacheCleaner can not execute while battle.net is running. exiting...
echo   pause
echo   exit /b
echo ^)
echo ::
echo tasklist ^/FI "IMAGENAME eq Wow.exe" 2^>NUL ^| find ^/I "Wow.exe" ^> NUL
echo if %%ERRORLEVEL%%==0 ^(
echo   echo WoWCacheCleaner can not execute while World of Warcraft is running. exiting...
echo   pause
echo   exit /b
echo ^)
echo echo Get the current month
echo for /f "tokens=2 delims==" %%%%I in ^('"wmic OS Get localdatetime /value"'^) do set datetime=%%%%I
echo set month=%%datetime:~4,2%%
echo ::
echo :: Define a file to store the last run month
echo set runfile=%%ProgramData%%\WoWCacheCleaner\last_run_month.txt
echo ::
echo echo Check if the script has run this month
echo if exist "%%runfile%%" ^(
echo     for ^/f "delims=" %%%%A in ^(%%runfile%%^) do set "lastmonth=%%%%A"
echo ^) else ^(
echo     set lastmonth=0
echo ^)
echo ::
echo :: If the current month is different from the last run month, run the task
echo if "%%month%%" neq "%%lastmonth%%" ^(
echo     echo Running the cache cleanup...
echo     rd /s /q "%TargetFolder%\config"
echo     rd /s /q "%TargetFolder%\indices"
echo     echo %%month%%^> %%runfile%%
echo ^) else ^(
echo     echo cache cleaner allready ran this month
echo ^)
) > %ProgramData%\WoWCacheCleaner\wow_cache_cleaner.bat

echo WoWCacheCleaner Batch created at %ProgramData%\WoWCacheCleaner\wow_cache_cleaner.bat

echo Creating scheduled task to run WoWCacheCleaner.bat...
schtasks /create /tn "WowCacheCleaner" /tr "%ProgramData%\WoWCacheCleaner\wow_cache_cleaner.bat" /sc onstart /ru "SYSTEM" /rl HIGHEST /f
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo You need to run this script as an administrator.
    pause
    exit /b
)
echo Successfully created scheduled task "WowCacheCleaner" to run WoWCacheCleaner.bat on startup
echo You can now delete this file (WoWCacheCleanerInstaller.bat)

pause