#
# prepost.ps1
#
# This script will read a configuration file (specified on the command line)
# and will use the contents of that file, combined with environment variables
# set during mount and unmount operations from Actifio CDS or Sky, to execute
# one or more scripts at the desired times.
#
# Configuration file example (NOTE: the header row is required)
#
# phase,script
# preunmount,C:\automation\preunmount.cmd
# postunmount,C:\automation\postunmount.cmd
# premount,C:\automation\premount.cmd
# postmount,C:\automation\postmount1.cmd
# postmount,C:\automation\postmount2.cmd
#
# Script Parameters
Param([Parameter(Mandatory=$true)][string]$phase, [Parameter(Mandatory=$true)][string]$configdrive,
      [Parameter(Mandatory=$true)][string]$configpath)

##############################
# Output to logfile function #
##############################

function log-output {
    Param([Parameter(Mandatory=$true)][string]$logfile,[switch]$debugOnly=$false,[string]$message)

    if ($debugOnly -and !$debug)
    {
        return
    }
    $logstamp = Get-Date -format "yyyy-MM-dd_HH-mm-ss"
    ($logstamp + " - " + $message) | Out-File $logfile -append
}

#############
# Main Body #
#############

# Setup some generally useful variables, and generate the logfile name with datetime stamp
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$scriptName = split-path -leaf $MyInvocation.MyCommand.Definition
$scriptBaseName = (get-childitem $MyInvocation.MyCommand.Definition).BaseName
$logstamp = Get-Date -format "yyyy-MM-dd_HH-mm-ss"
$logfile = $scriptPath + "\" + $scriptBaseName + "_" + $logstamp + ".log"
log-output -logfile $logfile -message "Started..."
if ( $debugpreference -eq "Inquire" ) { $debug=$true }

###########################
# Read Configuration Data #
###########################

if (!(test-path ($configdrive + ":" + $configpath)))
{
    log-output -logfile $logfile -message "WARNING: Cannot find config file"
    break
}

log-output -logfile $logfile -debugonly -message "Reading configuration files..."
$scripts = Import-csv ($configdrive + ":" + $configpath)

if (! $env:ACT_MULTI_END )
{
	log-output -logfile $logfile -message "Called as part of log disk mount or unmount.  No action taken."
	log-output -logfile $logfile -message "Finished"
	break
}

$phase = $env:ACT_PHASE + $env:ACT_MULTI_OPNAME
log-output -logfile $logfile -message "Determined phase $phase"


foreach ($s in ($scripts | where phase -eq $phase).script)
{
	log-output -logfile $logfile -debugonly -message "Verifying $s exists"
	if (!(test-path $s))
	{
		log-output -logfile $logfile -message "ERROR: Script not found: $s"
		continue
	}
	log-output -logfile $logfile -message "Running $s"
	[string]$output = Invoke-Expression "& `"cmd.exe`" /C `"$s`"" 
	log-output -logfile $logfile -message $output
}

log-output -logfile $logfile -message "Finished"


