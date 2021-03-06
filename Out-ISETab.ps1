#requires -version 2.0

<#
This function will take pipelined input and insert into
a new PowerShell ISE tab
#>

Function Out-ISETab {
<#
.Synopsis
Send command output to an ISE tab
.Description
This command will accept pipelined input and place it in a new PowerShell ISE tab.
.Parameter UseCurrentFile
Insert the text into the current ISE tab.
.Example
PS C:\> get-process | sort WS -descending | Select -first 5 | out-isetab

.Notes
version 2.0
updated May 20, 2014

Learn more:
 PowerShell in Depth: An Administrator's Guide, 2nd Edition (http://www.manning.com/jones6/)
 PowerShell Deep Dives (http://manning.com/hicks/)
 Learn PowerShell 3 in a Month of Lunches (http://manning.com/jones3/)
 Learn PowerShell Toolmaking in a Month of Lunches (http://manning.com/jones4/)
 
   ****************************************************************
   * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
   * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
   * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
   * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
   ****************************************************************
#>
[cmdletbinding()]

Param (
[Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True)]
[object[]]$InputObject,
[Switch]$UseCurrentFile
)

Begin {

    Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"  

    if ($UseCurrentFile) {
        Write-Verbose "Using current file"
        $tab= $psise.CurrentFile
    }
    else {
        #create a new file
        Write-Verbose "Creating a new tab"
        $tab= $psise.CurrentPowerShellTab.Files.Add()
    }
    
    $data = @()
}
Process {
   #add each piped object
   $data+= $InputObject
   

} #process

End {
    #send the data to the ISE tab
    $tab.Editor.InsertText(($data | Out-String))
   Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"  
}

} #end function

Set-Alias -Name tab -Value Out-ISETab