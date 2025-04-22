function Calculate-WorkTime {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$StartTime,
        
        [Parameter(Mandatory=$true, Position=1)]
        [int]$BreakMinutes,
        
        [Parameter(Mandatory=$true, Position=2)]
        [string]$EndTime
    )

    # Parse time strings to DateTime objects
    try {
        $start = [DateTime]::ParseExact($StartTime, "HHmm", $null)
        $end = [DateTime]::ParseExact($EndTime, "HHmm", $null)
    }
    catch {
        Write-Error "Invalid time format. Please use 24-hour format (HHMM)."
        return
    }

    # Handle cases where end time is on the next day
    if ($end -lt $start) {
        $end = $end.AddDays(1)
    }

    # Calculate total work time
    $totalWorkTime = $end - $start
    $breakTimeSpan = New-TimeSpan -Minutes $BreakMinutes
    $netWorkTime = $totalWorkTime - $breakTimeSpan

    # Calculate overtime (if worked more than 8 hours)
    $standardWorkDay = New-TimeSpan -Hours 8
    $extendeddWorkDay = New-TimeSpan -Hours 9
    $maxNetWorkingHours = New-TimeSpan -Hours 10
    $overtime = New-TimeSpan -Minutes 0
    if ($netWorkTime -gt $standardWorkDay) {
        $overtime = $netWorkTime - $standardWorkDay
    }

    # Format results
    Write-Host "`n==== WORK TIME REPORT ====" -ForegroundColor Cyan
    Write-Host "Start Time: " -NoNewline -ForegroundColor Green
    Write-Host $start.ToString("HH:mm")
    Write-Host "End Time:   " -NoNewline -ForegroundColor Green
    Write-Host $end.ToString("HH:mm")
    Write-Host "`nTotal Time Worked: " -NoNewline -ForegroundColor Yellow
    Write-Host $totalWorkTime.ToString("h\:mm")
    Write-Host "Break Time:        " -NoNewline -ForegroundColor Yellow
    Write-Host "$BreakMinutes min"
    Write-Host "Net Work Time:     " -NoNewline -ForegroundColor Yellow
    Write-Host $netWorkTime.ToString("h\:mm")

    if ($netWorkTime -gt $standardWorkDay) {
        Write-Host `n"Overtime:          " -NoNewline -ForegroundColor Magenta
        Write-Host $overtime.ToString("h\:mm")
    }

    # Display warning if break time is less than 45 minutes when working more than 9 hours
    if ($netWorkTime -gt $extendeddWorkDay -and $BreakMinutes -lt 45) {
        Write-Host "`nWARNING: " -NoNewline -ForegroundColor Red
        Write-Host "Break time is less than the recommended 45 minutes for workdays exceeding 9 hours." -ForegroundColor Yellow
    }

    # Display warning if netWorkTime is greater than 10 hours
    if ($netWorkTime -gt $maxNetWorkingHours) {
        Write-Host "`nWARNING: " -NoNewline -ForegroundColor Red
        Write-Host "Net work time exceeded the maximum of 10 hours." -ForegroundColor Yellow
    }

    Write-Host "`n"
}

# Create an alias function that matches the requested command name
function worktime {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$StartTime,
        
        [Parameter(Mandatory=$true, Position=1)]
        [int]$BreakMinutes,
        
        [Parameter(Mandatory=$true, Position=2)]
        [string]$EndTime
    )
    
    Calculate-WorkTime -StartTime $StartTime -BreakMinutes $BreakMinutes -EndTime $EndTime
}

Export-ModuleMember -Function Calculate-WorkTime
Export-ModuleMember -Function worktime

# Example usage:
# worktime 0730 30 1600