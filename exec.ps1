$isoFile = 'C:\Users\lina.hachache\Downloads\SERVER_EVAL_x64FRE_en-us.iso'
$vmName = 'newVM'
$pass = 'Lina'

.\New-VMFromWindowsImage.ps1 -SourcePath $isoFile -Edition 'Windows Server 2022 Standard Evaluation (Desktop Experience)' -VMName $vmName -VHDXSizeBytes 120GB -AdministratorPassword $pass  -Version 'Server2022Standard' -MemoryStartupBytes 2GB -VMProcessorCount 4

$sess = .\New-VMSession.ps1 -VMName $vmName -AdministratorPassword $pass


.\Enable-RemoteManagementViaSession.ps1 -Session $sess

You can run any commands on VM with Invoke-Command:
Invoke-Command -Session $sess { 
    echo "Hello, world! (from $env:COMPUTERNAME)"

    # Install chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Install 7-zip  
    choco install 7zip -y
     # Install mariadb
    choco install mariadb
     # Install iis
    choco install iis.administration -y
}

Remove-PSSession -Session $sess
