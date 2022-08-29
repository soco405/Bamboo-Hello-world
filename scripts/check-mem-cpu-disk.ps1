date
Write-Host "Computer Name:" $computer
#cpu use threshold
$Thresh_cpu_percent='60'
 #mem idle threshold
$mem_threshold='90'
 #disk use threshold
$disk_threshold='90'


$computer = Get-Content env:computername
    # Lets create a re-usable WMI method for CPU stats
    $ProcessorStats = Get-WmiObject win32_processor -computer $computer
    $ComputerCpu = $ProcessorStats.LoadPercentage 

    # Lets create a re-usable WMI method for memory stats
    $OperatingSystem = Get-WmiObject win32_OperatingSystem -computer $computer
    # Lets grab the free memory
    $FreeMemory = $OperatingSystem.FreePhysicalMemory
    # $FreeMemoryinMb = [math]::truncate($FreeMemory/1024)
    # # Lets grab the total memory
    $TotalMemory = $OperatingSystem.TotalVisibleMemorySize
    $Membypercent =[math]::truncate(($FreeMemory/$TotalMemory)*100)
    $Diskbypercent=(get-psdrive c | % { $_.free/($_.used + $_.free) } | % tostring p)
    
    if ($ComputerCpu -lt $Thresh_cpu_percent)
{
    Write-Host "CPU is good: $ComputerCpu%"
}
else
{
write-output "CPU is too high $ComputerCpu%"
exit  1} 

if ($Membypercent -lt $mem_threshold)
{
    Write-Host "Memory is good: $Membypercent%"
}
else
{
    Write-Host "Memory is too high: $Membypercent%"
exit  1} 

if ($Diskbypercent -lt $disk_threshold)
{
    Write-Host "Diskspace is good: $Diskbypercent%"
}
else
{
    Write-Host "Diskspace is too high: $Diskbypercent%"
exit  1}  

