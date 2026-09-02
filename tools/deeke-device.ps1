# DeekeScript AI device discovery and debug helper
# Windows:  powershell -ExecutionPolicy Bypass -File tools/deeke-device.ps1 discover
# macOS:    bash tools/deeke-device.sh discover
#            (or pwsh tools/deeke-device.ps1 discover if PowerShell 7+ is installed)
param(
    [Parameter(Position = 0)]
    [ValidateSet('discover', 'set', 'status', 'snapshot', 'run', 'run-file', 'stop', 'help')]
    [string]$Command = 'help',

    [string]$BaseUrl,
    [string]$Script,
    [string]$ScriptFile,
    [int]$Type = 0,
    [switch]$Image,
    [int]$Timeout = 60000,
    [string]$ConfigFile = '.deeke-device.local.json'
)

$ErrorActionPreference = 'Stop'

function Write-Json($obj) {
    $obj | ConvertTo-Json -Depth 20 -Compress:$false
}

function Get-ConfigPath {
    $root = Get-Location
    return Join-Path $root $ConfigFile
}

function Read-DeviceConfig {
    $path = Get-ConfigPath
    if (-not (Test-Path $path)) { return $null }
    try {
        $cfg = Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($cfg.baseUrl) { return $cfg.baseUrl.TrimEnd('/') }
    } catch {}
    return $null
}

function Save-DeviceConfig([string]$url) {
    $path = Get-ConfigPath
    @{ baseUrl = $url.TrimEnd('/') } | ConvertTo-Json | Set-Content $path -Encoding UTF8
}

function Resolve-BaseUrl {
    if ($BaseUrl) { return $BaseUrl.TrimEnd('/') }
    $saved = Read-DeviceConfig
    if ($saved) { return $saved }
    throw 'No device URL. Run discover or: deeke-device.ps1 set -BaseUrl http://192.168.x.x:8080'
}

function Get-LocalLanIp {
    # Cross-platform: Windows PowerShell 5.1, Windows pwsh, macOS pwsh, Linux pwsh
    try {
        $ips = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() |
            Where-Object {
                $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up -and
                $_.NetworkInterfaceType -ne [System.Net.NetworkInformation.NetworkInterfaceType]::Loopback
            } |
            ForEach-Object { $_.GetIPProperties().UnicastAddresses } |
            ForEach-Object { $_.Address } |
            Where-Object {
                $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork -and
                $_.ToString() -like '192.168.*'
            } |
            ForEach-Object { $_.ToString() }
        if ($ips) { return $ips | Select-Object -First 1 }
    } catch {}

    if ($IsWindows -or -not (Get-Variable -Name IsWindows -ErrorAction SilentlyContinue)) {
        try {
            $ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
                Where-Object { $_.IPAddress -like '192.168.*' -and $_.PrefixOrigin -ne 'WellKnown' } |
                Select-Object -ExpandProperty IPAddress
            if ($ips) { return $ips | Select-Object -First 1 }
        } catch {}
    }

    $dnsIps = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) |
        Where-Object { $_.AddressFamily -eq 'InterNetwork' -and $_.ToString() -like '192.168.*' } |
        ForEach-Object { $_.ToString() }
    return $dnsIps | Select-Object -First 1
}

function Test-TcpPort([string]$ip, [int]$port, [int]$timeoutMs = 400) {
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $iar = $client.BeginConnect($ip, $port, $null, $null)
        if (-not $iar.AsyncWaitHandle.WaitOne($timeoutMs, $false)) { return $false }
        $client.EndConnect($iar)
        return $true
    } catch {
        return $false
    } finally {
        $client.Close()
    }
}

function Invoke-DeekeApi {
    param(
        [string]$Method,
        [string]$Path,
        [object]$Body = $null
    )
    $base = Resolve-BaseUrl
    $uri = "$base$Path"
    if ($Body) {
        $json = $Body | ConvertTo-Json -Depth 20 -Compress
        return Invoke-RestMethod -Uri $uri -Method $Method -Body $json -ContentType 'application/json; charset=utf-8' -TimeoutSec ([Math]::Max(30, [int]($Timeout / 1000) + 10))
    }
    return Invoke-RestMethod -Uri $uri -Method $Method -TimeoutSec 30
}

switch ($Command) {
    'help' {
        Write-Json @{
            platform = if ($IsMacOS) { 'macOS PowerShell' } elseif ($IsLinux) { 'Linux PowerShell' } else { 'Windows PowerShell' }
            commands = @(
                'discover  - scan 192.168.* subnet port 8080',
                'set -BaseUrl [url]  - save device URL',
                'status    - device status and permissions',
                'snapshot  - UI nodes and screenshot',
                'run -Script "..."  - execute DeekeScript code',
                'run-file -ScriptFile tasks/x.js  - execute project file',
                'stop      - stop running script'
            )
            macHint  = 'On macOS without pwsh, use: bash tools/deeke-device.sh discover'
        }
    }

    'discover' {
        $localIp = Get-LocalLanIp
        if (-not $localIp) {
            Write-Json @{
                skipScan = $true
                reason   = 'Local IP is not 192.168.*, scan skipped'
                hint     = 'Ask user for phone URL, e.g. http://192.168.1.113:8080, then: set -BaseUrl [url]'
                devices  = @()
            }
            exit 0
        }

        $parts = $localIp.Split('.')
        $prefix = "$($parts[0]).$($parts[1]).$($parts[2])"
        $devices = [System.Collections.Concurrent.ConcurrentBag[object]]::new()
        $ips = 1..254 | ForEach-Object { "$prefix.$_" } | Where-Object { $_ -ne $localIp }

        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $ips | ForEach-Object -Parallel {
                param($ip)
                function Test-TcpPortLocal([string]$ip, [int]$port, [int]$timeoutMs = 300) {
                    $client = New-Object System.Net.Sockets.TcpClient
                    try {
                        $iar = $client.BeginConnect($ip, $port, $null, $null)
                        if (-not $iar.AsyncWaitHandle.WaitOne($timeoutMs, $false)) { return $false }
                        $client.EndConnect($iar)
                        return $true
                    } catch { return $false }
                    finally { $client.Close() }
                }
                if (-not (Test-TcpPortLocal $ip 8080 300)) { return }
                try {
                    $resp = Invoke-RestMethod -Uri "http://${ip}:8080/ai/status" -Method Get -TimeoutSec 2
                    if ($resp.code -eq 0) {
                        [ordered]@{ ip = $ip; baseUrl = "http://${ip}:8080"; status = $resp.data }
                    }
                } catch {}
            } -ThrottleLimit 48 | Where-Object { $_ } | ForEach-Object { $devices.Add($_) }
        } else {
            $batchSize = 48
            for ($i = 0; $i -lt $ips.Count; $i += $batchSize) {
                $batch = $ips[$i..([Math]::Min($i + $batchSize - 1, $ips.Count - 1))]
                $jobs = $batch | ForEach-Object {
                    $targetIp = $_
                    Start-Job -ScriptBlock {
                        param($ip)
                        function Test-TcpPortLocal([string]$ip, [int]$port, [int]$timeoutMs = 300) {
                            $client = New-Object System.Net.Sockets.TcpClient
                            try {
                                $iar = $client.BeginConnect($ip, $port, $null, $null)
                                if (-not $iar.AsyncWaitHandle.WaitOne($timeoutMs, $false)) { return $false }
                                $client.EndConnect($iar)
                                return $true
                            } catch { return $false }
                            finally { $client.Close() }
                        }
                        if (-not (Test-TcpPortLocal $ip 8080 300)) { return $null }
                        try {
                            $resp = Invoke-RestMethod -Uri "http://${ip}:8080/ai/status" -Method Get -TimeoutSec 2
                            if ($resp.code -eq 0) {
                                return @{ ip = $ip; baseUrl = "http://${ip}:8080"; status = $resp.data }
                            }
                        } catch {}
                        return $null
                    } -ArgumentList $targetIp
                }
                $jobs | Wait-Job | Receive-Job | Where-Object { $_ } | ForEach-Object { $devices.Add($_) }
                $jobs | Remove-Job -Force
            }
        }

        $deviceList = @($devices)
        $result = @{
            skipScan = $false
            localIp  = $localIp
            subnet   = $prefix
            devices  = $deviceList
        }

        if ($deviceList.Count -eq 1) {
            Save-DeviceConfig $deviceList[0].baseUrl
            $result.autoSelected = $deviceList[0].baseUrl
            $result.configFile = (Get-ConfigPath)
        } elseif ($deviceList.Count -eq 0) {
            $result.hint = 'No device found. Enable node viewer on phone, or ask user for URL and run set -BaseUrl'
        } else {
            $result.hint = 'Multiple devices found. Ask user to pick one, then run set -BaseUrl'
        }

        Write-Json $result
    }

    'set' {
        if (-not $BaseUrl) { throw 'Missing -BaseUrl, e.g. http://192.168.1.113:8080' }
        $url = $BaseUrl.TrimEnd('/')
        $test = Invoke-RestMethod -Uri "$url/ai/status" -Method Get -TimeoutSec 5
        if ($test.code -ne 0) { throw "Cannot connect DeekeScript: $($test.msg)" }
        Save-DeviceConfig $url
        Write-Json @{ code = 0; baseUrl = $url; configFile = (Get-ConfigPath); status = $test.data }
    }

    'status' {
        Write-Json (Invoke-DeekeApi -Method Get -Path '/ai/status')
    }

    'snapshot' {
        $imageFlag = 1
        Write-Json (Invoke-DeekeApi -Method Get -Path "/ai/snapshot?type=$Type&image=$imageFlag")
    }

    'run' {
        if (-not $Script) { throw 'Missing -Script' }
        Write-Json (Invoke-DeekeApi -Method Post -Path '/ai/run' -Body @{
                script  = $Script
                file    = 'ai_debug.js'
                timeout = $Timeout
            })
    }

    'run-file' {
        if (-not $ScriptFile) { throw 'Missing -ScriptFile' }
        Write-Json (Invoke-DeekeApi -Method Post -Path '/ai/run-file' -Body @{
                file    = $ScriptFile
                timeout = $Timeout
            })
    }

    'stop' {
        Write-Json (Invoke-DeekeApi -Method Post -Path '/ai/stop')
    }
}
