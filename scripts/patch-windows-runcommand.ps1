<# 
This script runs INSIDE a Windows VM via Azure Run Command.

Goals:
- Detect pending reboot (basic registry-based checks)
- Optionally install Windows updates using Windows Update COM API
- Print a JSON summary for pipeline logs

Notes:
- Update installation can take time.
- Run Command has practical timeout limits; keep rings small.
#>

param(
  [bool]$DoInstall = $false
)

function Test-PendingReboot {
  # Basic pending reboot checks via registry keys.
  $paths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
  )
  foreach ($p in $paths) {
    if (Test-Path $p) { return $true }
  }
  return $false
}

$before = Test-PendingReboot

$result = [ordered]@{
  ComputerName         = $env:COMPUTERNAME
  PendingRebootBefore  = $before
  UpdateSearchResult   = $null
  InstallStatus        = "ReportOnly"
  PendingRebootAfter   = $null
}

if ($DoInstall) {
  $result.InstallStatus = "InstallRequested"

  # Use the built-in Windows Update API (COM) to search and install software updates.
  $session  = New-Object -ComObject Microsoft.Update.Session
  $searcher = $session.CreateUpdateSearcher()

  # Search for NOT installed software updates.
  $searchResult = $searcher.Search("IsInstalled=0 and Type='Software'")
  $count = $searchResult.Updates.Count
  $result.UpdateSearchResult = "Found $count updates"

  if ($count -gt 0) {
    $toInstall = New-Object -ComObject Microsoft.Update.UpdateColl
    for ($i = 0; $i -lt $count; $i++) {
      $toInstall.Add($searchResult.Updates.Item($i)) | Out-Null
    }

    # Download and install updates.
    $downloader = $session.CreateUpdateDownloader()
    $downloader.Updates = $toInstall
    $downloader.Download() | Out-Null

    $installer = $session.CreateUpdateInstaller()
    $installer.Updates = $toInstall
    $installResult = $installer.Install()

    $result.InstallStatus = "InstallCompleted (ResultCode=$($installResult.ResultCode))"
  } else {
    $result.InstallStatus = "NoUpdates"
  }
}

$result.PendingRebootAfter = Test-PendingReboot

# Output as JSON for easy parsing in pipeline logs
$result | ConvertTo-Json -Depth 4
