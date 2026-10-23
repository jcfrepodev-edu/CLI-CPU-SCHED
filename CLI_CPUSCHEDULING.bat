@echo off
setlocal EnableExtensions

rem ==========================================================
rem ERICK'S PART - MAIN MENU, NETWORK, AND CONNECTIVITY
rem ==========================================================

title Platform Management Toolkit
color 0F

rem ==========================================================
rem CARL'S PART - AUTOMATIC TASK SCHEDULER SUPPORT
rem ==========================================================

rem Allows Task Scheduler to run the diagnostic report automatically.
if /i "%~1"=="/auto" (
    set "auto=1"
    goto report
)

:menu
rem ERICK'S PART - MAIN MENU
cls
echo ======================================================================
echo        PLATFORM MANAGEMENT ^& DIAGNOSTIC TOOLKIT v1.0
echo ======================================================================
echo  Date: %date%   Time: %time:~0,8%
echo ======================================================================
echo  [1] Check Network Configuration (ipconfig)
echo  [2] Test Server Connectivity (ping)
echo  [3] Monitor Active Processes (tasklist)
echo  [4] Generate System Diagnostic Report Log
echo  [5] CPU Scheduling Simulator
echo  [6] Exit
echo ======================================================================
echo.

set "choice="
set /p "choice=Enter Choice [1-6]: "

if "%choice%"=="1" goto network
if "%choice%"=="2" goto connectivity
if "%choice%"=="3" goto processes
if "%choice%"=="4" goto report
if "%choice%"=="5" goto CPUSIM
if "%choice%"=="6" goto exit

echo.
echo [!] Invalid choice. Please enter a number from 1 to 6.
pause
goto menu


rem ==========================================================
rem ERICK'S PART - NETWORK CONFIGURATION
rem ==========================================================

:network
cls
echo ======================================================================
echo                  NETWORK CONFIGURATION
echo ======================================================================
echo.
echo [+] Checking Network Configuration...
echo.
ipconfig
echo.
echo [+] Network Configuration Captured.
pause
goto menu


rem ==========================================================
rem ERICK'S PART - SERVER CONNECTIVITY

rem ==========================================================

:connectivity
cls
echo ======================================================================
echo                   SERVER CONNECTIVITY
echo ======================================================================
echo.
echo [+] Testing Server Connectivity...
echo.
ping -n 4 127.0.0.1
echo.
echo [+] Connectivity Test Completed.
pause
goto menu

rem End of Erick's Part


rem ==========================================================
rem CARL'S PART - ACTIVE PROCESS MONITORING
rem ==========================================================

:processes
cls
echo ======================================================================
echo                    ACTIVE PROCESSES
echo ======================================================================
echo.
echo [+] Monitoring Active Processes...
echo.
tasklist
echo.
echo [+] Process List Captured.
pause
goto menu

rem ==========================================================
rem CARL'S PART - SYSTEM DIAGNOSTIC REPORT AND LOGGING
rem ==========================================================

:report
cls
echo ======================================================================
echo                 SYSTEM DIAGNOSTIC REPORT
echo ======================================================================
echo.
echo [+] Running Diagnostic Sequence...

set "logdir=C:\Logs"

if not exist "%logdir%\" mkdir "%logdir%" 2>nul
if not exist "%logdir%\" goto logerror

if not exist "%logdir%\Backup\" mkdir "%logdir%\Backup" 2>nul
if not exist "%logdir%\Backup\" goto logerror

rem Generate a date stamp for the report filename.
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd"') do set "stamp=%%i"

if not defined stamp goto logerror

set "logfile=%logdir%\sys_diag_%stamp%.log"

echo [+] Saving report to %logfile%

(
echo ============================================================
echo PLATFORM MANAGEMENT AND DIAGNOSTIC TOOLKIT v1.0
echo SYSTEM DIAGNOSTIC REPORT
echo Date: %date%
echo Time: %time%

echo ============================================================
echo.
echo --- NETWORK CONFIGURATION ---
ipconfig
echo.
echo --- CONNECTIVITY TEST: 127.0.0.1 ---
ping -n 4 127.0.0.1
echo.
echo --- ACTIVE PROCESSES ---
tasklist
echo.
echo --- EXISTING LOG FILES ---
dir "%logdir%\*.log"
) > "%logfile%" 2>&1

if not exist "%logfile%" goto logerror

echo [+] Network Configuration Captured...
echo [+] Process List Captured...

rem ==========================================================
rem CARL'S PART - BACKUP AND OLD LOG CLEANUP
rem ==========================================================

copy /y "%logfile%" "%logdir%\Backup\" >nul 2>&1

if errorlevel 1 (
    echo [!] Warning: Report created, but backup failed.
) else (
    echo [+] Backup copy created.
)

rem Delete backup log files older than 30 days.
forfiles /p "%logdir%\Backup" /m *.log /d -30 /c "cmd /c del @path" >nul 2>&1

echo [+] System Diagnostic Log Successfully Created!

rem ==========================================================
rem CARL'S PART - AUTOMATIC REPORT MODE

rem ==========================================================

rem Scheduled automatic mode ends without opening the menu.
if defined auto exit /b 0

echo.
echo Press any key to return to menu...
pause >nul
goto menu


rem ==========================================================
rem CARL'S PART - ERROR HANDLING
rem ==========================================================

:logerror
echo.
echo [!] ERROR: Unable to create the diagnostic report.
echo [!] Check whether C:\Logs can be created and written to.

if defined auto exit /b 1

echo.
pause
goto menu

rem End of Carl's Part



rem FURING'S PART - CPU SCHEDULING SIMULATOR
rem FCFS AND NON-PREEMPTIVE SJF
rem Option 5 runs this report only, then returns to the menu.


:CPUSIM
cls
echo.
echo ======================================================================

echo             CPU SCHEDULING ALGORITHM SIMULATION REPORT
echo ======================================================================
echo.
echo Input Workload:
echo Process ^| Arrival Time ^| Burst Time
echo P1      ^|      0       ^|     8
echo P2      ^|      1       ^|     4
echo P3      ^|      2       ^|     9
echo P4      ^|      3       ^|     5
echo.

rem Ryans part

echo ------------------------------------------------------------
echo [1] First-Come, First-Served (FCFS)
echo ------------------------------------------------------------
echo Gantt Chart: ^| P1 (0-8) ^| P2 (8-12) ^| P3 (12-21) ^| P4 (21-26) ^|
echo Average Waiting Time: 8.75 ms
echo Average Turnaround Time: 15.25 ms
echo.

rem Joshuas part

echo ------------------------------------------------------------
echo [2] Shortest Job First (SJF - Non-preemptive)
echo ------------------------------------------------------------
echo Gantt Chart: ^| P1 (0-8) ^| P2 (8-12) ^| P4 (12-17) ^| P3 (17-26) ^|
echo Average Waiting Time: 7.75 ms
echo Average Turnaround Time: 14.25 ms
echo.
echo Conclusion: SJF reduced average waiting time by 1.00 ms
echo compared to FCFS for this workload.
echo SJF also reduced average turnaround time by 1.00 ms.
echo Longer processes may wait longer when shorter jobs arrive.
echo ======================================================================
echo.
echo Press any key to return to menu...
pause >nul

goto menu



:exit
echo.
echo [+] Exiting Platform Management Toolkit.
timeout /t 2 >nul
exit /b 0
