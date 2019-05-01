
To install:
1 Copy zip file to target SQL Server, to any directory desired.
2 Unzip the file extract the directory "prepost-automation".
3 All files that are unzipped with names ending in ".cmd.txt" should
  be renamed to ".cmd".  They were renamed to allow emailing of this package.
4 In the prepost-automation directory is a subdirectory called
  "MoveToProgramFilesActifioScripts".  Copy the two files (prepost.cmd and
   prepost.ps1) to "C:\Program Files\Actifio\Scripts".  If the "Scripts"
   directory does not exist, create it first.


To configure Actifio to use this framework:
1 Create a workflow on the desired SQL database, consistency group, or SQL
  instance.
2 Define a pre script that runs "prepost.cmd <drive> <path to prepost-config.csv>".
  For example "prepost.cmd C \actifio\prepost-automation\prepost-config.csv")
3 Write and test the scripts you wish to have run at the different phases, such as
  a script for PREUNMOUNT that extracts some data, or a script that runs POSTMOUNT
  to import that data.
4 In the directory "prepost-automation", modify the file "prepost-config.csv" file
  so that it runs your scripts in the phases desired.  There is sample text in the
  file to show how to use it.  Do not remove the first row in the file.

When the workflow is run, watch for the log files to be created in the "C:\Program 
Files\Actifio\Scripts" directory.  Any output sent to standard-out from your scripts
will be put into these files.

Actifio will set several environment variables that can be referenced in your scripts
so that the same script can be used without additional customization across different
servers.  Here are samples of the environment variables that are set:

Sample environment variables for POSTMOUNT phase for a group of databases (prefix of
"prefix_" was specified):
◦ ACT_APPNAME=smalldb
◦ ACT_JOBNAME=Job_37200305
◦ ACT_JOBTYPE=mount
◦ ACT_LOGSMART_TYPE=db
◦ ACT_MOUNT_POINTS=X:\;Y:\;
◦ ACT_MULTI_END=true
◦ ACT_MULTI_OPNAME=mount
◦ ACT_PHASE=post
◦ ACT_POLICY=12hr Snap
◦ ACT_PROFILE=Remote Profile HQ to DR
◦ ACT_SCRIPT_TMOUT=600
◦ ACT_SOURCEHOST=hq-sql
◦ ACT_TEMPLATE=Silver LogSmart
◦ ConsistencyGroupName=SalinsCG
◦ PHASE=post
◦ dbnameprefix=prefix_
◦ recover=true
◦ sqlinstance=DEMO-SQL-11

Sample environment variables for PREUNMOUNT phase of a single database (smalldb is
source, was mounted as smalldbtest):
◦ ACT_APPNAME=smalldb
◦ ACT_JOBNAME=Job_37201405
◦ ACT_JOBTYPE=reprovision
◦ ACT_LOGSMART_TYPE=db
◦ ACT_MULTI_END=true
◦ ACT_MULTI_OPNAME=unmount
◦ ACT_PHASE=pre
◦ ACT_POLICY=12hr Snap
◦ ACT_PROFILE=Remote Profile HQ to DR
◦ ACT_SCRIPT_TMOUT=600
◦ ACT_SOURCEHOST=hq-sql
◦ ACT_TEMPLATE=Silver LogSmart
◦ PHASE=pre
◦ dbname=smalldbtest
◦ recover=true
◦ sqlinstance=DEMO-SQL-11

