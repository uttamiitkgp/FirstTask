$Body ="Hi,<br>" 
$Body +="Please upload the attached file/files into the <a href=https://slmfs.cognizantgoc.com/login.aspx>https://slmfs.cognizantgoc.com/login.aspx</a> before 3:30 PM. <br>" 
$Body +="This is a Test Mail. Please ignore it. <br>" 
$Body +="<br>"
$Body +="<br>"
$Body +="<b><font type=Segoe UI>Regards,</b></font> <br>"
$Body +="<b><font type=Segoe UI>Uttam Naskar</b></font> <br>"
$Body +="<b><font type=Segoe UI>VNET 685226</b></font><br>"
$Body +="<b><font type=Segoe UI>MOBILE +91-9010208706 </b></font> <br>"
$Body +="<b><font type=Segoe UI>$from </b></font><br>"

[string[]] $cc = "Subramanyeswari.Ravinutala@cognizant.com","SRINIVASA.DARA@cognizant.com","hema.sheshadri@cognizant.com"
#[string[]] $cc = "uttam.naskar@cognizant.com"

$SmtpServer = "SMTP.wonderware.com"
$smtp = new-object system.net.mail.smtpClient($SmtpServer)
$mail = new-object System.Net.Mail.MailMessage
$mail.From = "uttam.naskar@invensys.com"
$mail.To.Add("uttam.naskar@cognizant.com")
foreach($mailCC in $cc)
{
    $mail.CC.Add($mailCC)
}

$mail.Subject = "Invensys_SW_Dev_Services OTSI File"
$mail.Body = $Body
$mail.IsBodyHtml = $true


$Day = (Get-Date).dayofweek
if(($Day -eq "Monday") -and ($Holiday -eq "False"))
{
    $fileN = $FileNameC[0]
    $file = "$OutputFolderPath\$fileN"
    $Attachment = New-Object System.Net.Mail.Attachment $file
    Write-Host "$file"
    $fileN1 = $FileNameC[1]
    $file1 = "$OutputFolderPath\$fileN1"
    $Attachment1 = New-Object System.Net.Mail.Attachment $file1
    Write-Host "$file1"
    $fileN2 = $FileNameC[2]
    $file2 = "$OutputFolderPath\$fileN2"
    $Attachment2 = New-Object System.Net.Mail.Attachment $file2
    Write-Host "$file2"
    #Send-MailMessage –From $from –To $to -cc $cc –Subject $subject –Body $body -BodyAsHtml  -Attachments $file,$file1,$file2 –SmtpServer $smtp
    $mail.Attachments.Add($Attachment)
    $mail.Attachments.Add($Attachment1)
    $mail.Attachments.Add($Attachment2)
    $smtp.Send($mail)
}
elseif((($Day -eq "Monday") -or ($Day -eq "Tuesday")) -and ($Holiday -eq "True"))
{
    $fileN = $FileNameC[0]
    $file = "$OutputFolderPath\$fileN"
    $Attachment = New-Object System.Net.Mail.Attachment $file
    Write-Host "$file"
    $fileN1 = $FileNameC[1]
    $file1 = "$OutputFolderPath\$fileN1"
    $Attachment1 = New-Object System.Net.Mail.Attachment $file1
    Write-Host "$file1"
    $fileN2 = $FileNameC[2]
    $file2 = "$OutputFolderPath\$fileN2"
    $Attachment2 = New-Object System.Net.Mail.Attachment $file2
    Write-Host "$file2"
    $fileN3 = $FileNameC[3]
    $file3 = "$OutputFolderPath\$fileN3"
    $Attachment3 = New-Object System.Net.Mail.Attachment $file3
    Write-Host "$file3"
    #Send-MailMessage –From $from –To $to -cc $cc –Subject $subject –Body $body -BodyAsHtml  -Attachments $file,$file1,$file2,$file3 –SmtpServer $smtp
    $mail.Attachments.Add($Attachment)
    $mail.Attachments.Add($Attachment1)
    $mail.Attachments.Add($Attachment2)
    $mail.Attachments.Add($Attachment3)
    $smtp.Send($mail)
}
elseif(($Day -ne "Monday") -and ($Holiday -eq "True"))
{
    $fileN = $FileNameC[0]
    $file = "$OutputFolderPath\$fileN"
    $Attachment = New-Object System.Net.Mail.Attachment $file
    Write-Host "$file"
    $fileN1 = $FileNameC[1]
    $file1 = "$OutputFolderPath\$fileN1"
    $Attachment1 = New-Object System.Net.Mail.Attachment $file1
    #Send-MailMessage –From $from –To $to -cc $cc –Subject $subject –Body $body -BodyAsHtml  -Attachments $file,$file1 –SmtpServer $smtp
    $mail.Attachments.Add($Attachment)
    $mail.Attachments.Add($Attachment1)
    $smtp.Send($mail)
}
else
{
    $fileN = $FileNameC[0]
    $file = "$OutputFolderPath\$fileN"
    $Attachment = New-Object System.Net.Mail.Attachment $file
    Write-Host "$file"
    #Send-MailMessage –From $from –To $to -cc $cc –Subject $subject –Body $body -BodyAsHtml  -Attachments $file –SmtpServer $smtp
    $mail.Attachments.Add($Attachment)
    $smtp.Send($mail)
}

Write-host "Done!!!!!!"

