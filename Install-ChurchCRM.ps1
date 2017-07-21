<#
    .SYNOPSIS
        Install ChurchCRM on Windows with XAMPP server

#>
#Requires -RunAs Administrator

#region SetupLogging
    $LogParams  =@{
        'LogName' = 'Setup';
        'Source' = 'ChurchCRM Setup'
    }

    if(![System.Diagnostics.EventLog]::SourceExists($LogParams.Source))
    {
        New-EventLog @LogParams
    }

    Function Write-PSEventLog {
        <#
            .SYNOPSIS
                Wrapper function to split Logging to the windows event log and to the terminal
        #>
        param(
            $LogName,
            $Source,
            $EventId,
            $EntryType,
            $Message
        )
        try{
            Write-EventLog @PsBoundParameters
        }
        catch {
            throw "Error writing to Windows Event Log.  Reason: $($_.Exception.Message)"
        }
        Finally {
            Switch($EntryType)
            {
                "Error" {
                    write-host -ForegroundColor Red $Message
                }
                "Information" {
                    write-host -ForegroundColor Green $Message
                }
            }
        }
    }
#endregion


#region functions

    Function Install-XAMPP
    {

        #xampp-win32-1.7.2.exe -dC:\ -s1 -spauto

    }

    function Set-XAMPPConfiguration
    {

    }

    Function Get-LatestChurchCRMRelease
    {

    }

    function Set-MySQLConfiguration
    {
        param(
            $username,
            $password
        )
    }

    Function Set-PHPMyAdminConfiguration
    {

    }

    function Set-ChurchCRMConfiguration
    {
          param(
            $dbhost,
            $dbusername,
            $dbpassword
        )

    }
    
    function Start-Services
    {

    }

#endregion

try {
    Write-PSEventLog @LogParams -EntryType Information -EventId 100 -Message "Starting Installation"
    Install-XAMPP
    Set-XAMPPConfiguration
    Set-MySQLConfiguration
    Set-PHPMyAdminConfiguration

    Get-LatestChurchCRMRelease
    Set-ChurchCRMConfiguration
    Start-Services
    
}
catch {
    Write-PSEventLog @LogParams -EntryType Information -EventId 800 -Message "There was an error durung installation: $($_.Exception.Message)"
}
finally {
    Write-PSEventLog @LogParams -EntryType Information -EventId 900 -Message "Stopping Installation"
}