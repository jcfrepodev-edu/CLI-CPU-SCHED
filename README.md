# Platform Management & Diagnostic Toolkit

<img width="841" height="382" alt="image" src="https://github.com/user-attachments/assets/410b3f64-2780-4033-98f6-80bb85567541" />


A menu-driven command-line toolkit written in Windows Batch. It checks network settings, tests connectivity, lists running processes, saves a system diagnostic report to a log file, and includes a CPU scheduling simulator (FCFS vs. non-preemptive SJF).
---

## Features

- **Interactive main menu** with input validation
- **Network configuration** check using `ipconfig`
- **Server connectivity** test using `ping`
- **Active process monitor** using `tasklist`
- **System diagnostic report** saved to `C:\Logs`, with an automatic backup copy and cleanup of backups older than 30 days
- **Automatic mode** (`/auto`) so Windows Task Scheduler can generate the report without the menu
- **CPU scheduling simulator** comparing FCFS and non-preemptive SJF

## Requirements

- Windows 10 or 11
- Command Prompt (built in)
- PowerShell (built in, used only to create the date stamp for log filenames)

## Getting Started

1. Download the bat file or clone this repository:
   ```
   git clone https://github.com/<your-username>/<repo>.git
   ```
2. Open the project folder in File Explorer.
3. Double-click `CLI_CPUSCHEDULING.bat`.
4. To make things easier create a folder on Desktop, move the `CLI_CPUSCHEDULING.bat` in the folder you created.

and run it from Command Prompt:

```
cd Desktop"
cd FolderName
CLI_CPUSCHEDULING.bat
```

> Tip: in File Explorer, click the address bar, type `cmd`, and press Enter to open Command Prompt directly in the folder.

## Usage

When the toolkit starts, type a number from 1 to 6 and press Enter.

| Option | What it does |
|:------:|--------------|
| 1 | Shows network configuration (`ipconfig`) |
| 2 | Pings `127.0.0.1` four times to test connectivity |
| 3 | Lists all running processes (`tasklist`) |
| 4 | Generates a diagnostic report and saves it to `C:\Logs` |
| 5 | Runs the CPU scheduling simulation report |
| 6 | Exits the toolkit |

### Automatic mode

Generate the report without opening the menu (useful for Task Scheduler):

```
CLI_CPUSCHEDULING.bat /auto
```

The script exits with code `0` on success and `1` if the report could not be created.

## Diagnostic Reports

Option 4 creates:

```
C:\Logs\
  sys_diag_YYYYMMDD.log        <- the report (network, ping, processes, existing logs)
  Backup\
    sys_diag_YYYYMMDD.log      <- backup copy (files older than 30 days are deleted)
```

If the report is created more than once on the same day, the file for that day is overwritten.

If `C:\Logs` cannot be created, right-click the file and choose **Run as administrator**.

## CPU Scheduling Simulation

Workload used in the simulator:

| Process | Arrival Time | Burst Time |
|:-------:|:------------:|:----------:|
| P1 | 0 | 8 |
| P2 | 1 | 4 |
| P3 | 2 | 9 |
| P4 | 3 | 5 |

| Algorithm | Gantt Chart | Avg. Waiting Time | Avg. Turnaround Time |
|-----------|-------------|:-----------------:|:--------------------:|
| FCFS | P1 (0-8), P2 (8-12), P3 (12-21), P4 (21-26) | 8.75 ms | 15.25 ms |
| SJF (non-preemptive) | P1 (0-8), P2 (8-12), P4 (12-17), P3 (17-26) | 7.75 ms | 14.25 ms |

**Conclusion:** SJF lowers both average waiting time and average turnaround time by 1.00 ms for this workload. The trade-off is that longer processes can wait longer when shorter jobs keep arriving.

## Team

| Member | Contribution |
|--------|--------------|
| Erick | Main menu, network configuration, server connectivity |
| Carl | Process monitoring, diagnostic report and logging, backup and cleanup, automatic mode, error handling |
| Furing | CPU scheduling simulator |
| Ryan | FCFS section of the simulator |
| Joshua | SJF section of the simulator |

## NOTE: This project was made for educational purposes.
