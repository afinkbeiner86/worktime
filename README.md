# worktime
Quickly calculate work related time.

## setup

- Copy files to %userprofile%\Documents\PowerShell\Modules\WorkTime
- Running ` Get-Module -ListAvailable` should show the module

## usage

```powershell
worktime {start_time hh:mm} {break_duration mm} {end_time hh:mm}

worktime 0900 30 1730
```