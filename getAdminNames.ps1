#admins.ps1
#Author: ingenium21
#This script gets the members from Schema Admins, Domain Admins, Enterprise Admins, and SQL Admins.  It then emails the list to administrators

import-module activedirectory #imports Active Directory module; you will need the AD module, helps to run this from a DC

#declare variables for Send-MailMessage
$emailFrom = "administrator@eteraconsulting.com"
$emailTo = "" #Emails you want here, separate them with a comma
$smtpServer = "" #put in your SMTP server IP here
$date = get-date
$emailSubject = "Admin Report -- $date"

#get list of the members of particular AD Group
$schemaAdmins = get-ADGroupMember "Schema Admins" | Sort Name | Select -Expand Name #-expand switch removes the "Name" Header
$schemaAdminsList = foreach ($s in $schemaAdmins) {write-output $s "<br>"} #moved objects in previous variable to a list with <br> for HTML
$domainAdmins = get-ADGroupMember "Domain Admins" | Sort Name | Select -Expand Name
$domainAdminsList = foreach ($d in $domainAdmins) {write-output $d "<br>"}
$enterpriseAdmins = get-ADGroupMember "Enterprise Admins" | Sort Name | Select -Expand Name
$enterpriseAdminsList = foreach ($e in $enterpriseAdmins) {write-output $e "<br>"}
$sqlAdmins = get-ADGroupMember "SQL Admins" |Sort Name | Select -Expand Name
$sqlAdminsList = foreach ($q in $sqlAdmins) {write-output $q "<br>"}

#declare the Body of the Email using HTML formatting
$emailBody += Write-output "<b>Here is a list of your Domain Admins</b> <br>"
$emailBody += Write-output "<b>============================ </b> <br>"
$emailBody += $domainAdminsList | out-string #without the out-string command 
$emailBody += write-output "<br>"
$emailBody += write-output "<br>"

$emailBody += Write-output "<b>Here is a list of your Schema Admins</b><br>"
$emailBody += Write-output "=========================== <br>"
$emailBody += $schemaAdminsList | out-string
$emailBody += write-output "<br>"
$emailBody += write-output "<br>"

$emailBody += Write-output "<b>Here is a list of your Enterprise Admins</b><br>"
$emailBody += write-output "============================= <br>"
$emailBody += $enterpriseAdminsList | out-string
$emailBody += write-output "<br>"
$emailBody += write-output "<br>"

$emailBody += write-output "<b>Here is a list of your SQL Admins</b><br>"
$emailBody += write-output "=========================<br>"
$emailBody += $sqlAdminsList | out-string

#Sends the Email
Send-MailMessage -From $emailFrom -To $emailTo -Subject $emailSubject -Body $emailBody -SmtpServer $smtpServer -BodyAsHTML
