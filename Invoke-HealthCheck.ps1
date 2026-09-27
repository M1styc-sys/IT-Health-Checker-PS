<#
.SYNOPSIS
    Invoke-HealthCheck - A comprehensive system health monitoring script for Windows environments.

.DESCRIPTION
    This script performs a series of checks on the local machine, including:
    - Disk Space (Warning if < 10% free)
    - Memory Usage (Warning if > 90% used)
    - CPU Load (Warning if > 85% average)
    - Critical Services Status
    - Network Connectivity

    The results are outputted as a formatted report.

.EXAMPLE
    .\Invoke-HealthCheck.ps1
#>

function Write-HealthStatus {
    param (
        [string]$Item,
        [string]$Status,
        [string]$Value
    )
    $color = switch ($Status) {
        "OK"      { "Green" }
        "WARNING" { "Yellow" }
        "CRITICAL" { "Red" }
        Default   { "White" }
    }
    Write-Host ("{0,-25} : {1,-10} [{2}]" -f $Item, $Status, $Value) -ForegroundColor $color
}

function Invoke-HealthCheck {
    Write-Host "--- Windows System Health Report ---" -ForegroundColor Cyan
    Write-Host "Date: $(Get-Date)" -ForegroundColor Gray
    Write-Host ("-" * 40)

    # 1. Disk Space Check (C: drive)
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
    $diskStatus = if ($freePercent -lt 5) { "CRITICAL" } elseif ($freePercent -lt 15) { "WARNING" } else { "OK" }
    Write-HealthStatus "Disk Space (C:)" $diskStatus "$freePercent% Free"

    # 2. Memory Usage Check
    $os = Get-CimInstance Win32_OperatingSystem
    $totalMem = $os.TotalVisibleMemorySize
    $freeMem = $os.FreePhysicalMemory
    $usedPercent = [math]::Round((($totalMem - $freeMem) / $totalMem) * 100, 2)
    $memStatus = if ($usedPercent -gt 90) { "CRITICAL" } elseif ($usedPercent -gt 75) { "WARNING" } else { "OK" }
    Write-HealthStatus "Memory Usage" $memStatus "$usedPercent% Used"

    # 3. CPU Load Check
    $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadAverage -Average
    $cpuLoad = [math]::Round($cpu.Average, 2)
    # Fallback for some systems where LoadAverage is null
    if ($null -eq $cpuLoad) {
        $cpuLoad = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
        $cpuLoad = [math]::Round($cpuLoad, 2)
    }
    $cpuStatus = if ($cpuLoad -gt 85) { "CRITICAL" } elseif ($cpuLoad -gt 60) { "WARNING" } else { "OK" }
    Write-HealthStatus "CPU Load" $cpuStatus "$cpuLoad%"

    # 4. Critical Services Check (Example: Spooler, WinRM)
    $servicesToCheck = @("Spooler", "WinRM")
    foreach ($svcName in $servicesToCheck) {
        $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
        if ($null -eq $svc) {
            Write-HealthStatus "Service: $svcName" "CRITICAL" "Not Found"
        } elseif ($svc.Status -eq 'Running') {
            Write-HealthStatus "Service: $svcName" "OK" "Running"
        } else {
            Write-HealthStatus "Service: $svcName" "CRITICAL" "Stopped"
        }
    }

    # 5. Network Connectivity (Ping Google DNS)
    if (Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet) {
        Write-HealthStatus "Network (Internet)" "OK" "Connected"
    } else {
        Write-HealthStatus "Network (Internet)" "CRITICAL" "Disconnected"
    }

    Write-Host ("-" * 40)
}

Invoke-HealthCheck
