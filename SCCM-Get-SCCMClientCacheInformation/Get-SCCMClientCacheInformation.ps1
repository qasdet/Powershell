function Get-SCCMClientCacheInformation {
    <#
    .SYNOPSIS
        Function to get the cache size on a SCCM Client
    .DESCRIPTION
        Function to get the cache size on a SCCM Client
    .PARAMETER ComputerName
        Specifies the name of the client
    .PARAMETER Credential
        Specifies the credential to use against the remote machine
        Only work with the WMI query for now, not the service restart
    .EXAMPLE
        Get-SCCMClientCacheInformation -ComputerName Client01

        This will get the client cache size on the computer Client01
    .NOTES
        # Cat
        #.com
        @#
        github.com/#

        1.0 | 2017/11/01 | # Cat
            Initial Version
        1.1 | 2017/11/01 | # Cat
            Update Error handling and messages
    .LINK
        https://github.com/#/PowerShell
#>
    PARAM(
        [string[]]$ComputerName = ".",

        [Alias('RunAs')]
        [System.Management.Automation.Credential()]
        [pscredential]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    FOREACH ($Computer in $ComputerName) {
        Write-Verbose -message "[PROCESS] ComputerName: $Computer"

        # Define Parameters
        $SplattingWMI = @{
            NameSpace = "ROOT\CCM\SoftMgmtAgent"
            Class     = "CacheConfig"
        }

        IF ($PSBoundParameters['ComputerName']) {
            $SplattingWMI.ComputerName = $Computer
        }
        IF ($PSBoundParameters['Credential']) {
            $SplattingWMI.Credential = $Credential
        }

        TRY {
            # Get the Client information
            Get-WmiObject @SplattingWMI

        }
        CATCH {
            Write-Warning -message "[PROCESS] Something Wrong happened with $Computer"
            $Error[0].execption.message
        }
    }
}
