$Holiday = "False"
$SLAMissed = "False"
$FGC = 0
$Day = (Get-Date).dayofweek
$Month = "{0:MMMM}" -f (Get-Date)
$Year = "{0:yy}" -f (Get-Date)
$OutputFolderPath = "D:\Work\ProjectWork2016\OTSI\" + $Month + $Year
if(!(Test-Path $OutputFolderPath))
{
    New-Item -Path $OutputFolderPath -type directory 
}
$DFFN ="{0:dd-MM-yyyy}" -f (get-date).adddays(-1)
$DDBFN ="1000056361_Invensys-Tools_Sustenance_" + $DFFN +".xls"
$DDBFNPath = "D:\Work\ProjectWork2012\ProjectStatusReport\NewOTSLMFILE\DS001_InvensysToolsSustenance.xls"
#$DDBFNPath = "D:\Work\ProjectWork2016\DS001_InvensysToolsSustenance.xls"

if(Test-Path $DDBFNPath)
{
    $xlRSLA=New-Object -ComObject "Excel.Application"
    $wbSLA=$xlRSLA.Workbooks.Open($DDBFNPath)
    $wsSLA=$wbSLA.Worksheets.Item(1)
    
    $SLA = @()
    $CH =""
    $CH2 =""
    Write-Host "Checking the SLA from $DDBFNPath..."
    for($i=104; $i -le 111; $i++)
    {
        $SLA1=$wsSLA.Cells.Item($i, 6).Text
        $SLA = $SLA + $SLA1
    }
    $SLACount = 0
    foreach ($element in $SLA)
    {
        $SLACount = $SLACount + 1
        
        if(($element -eq 100) -or ($element -eq "NA"))
        {
            $CH = "True"
                        
        }
        else
        {
            $SLAMissed = @()
            $CH2 = "Flase"
            if($SLACount -eq 1)
            {
               $SLAMissed1 = "Missed Response for P1"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            }
            elseif($SLACount -eq 2)
            {
               $SLAMissed1 = "Missed Response for P2"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            }
            elseif($SLACount -eq 3)
            {
               $SLAMissed1 = "Missed Response for P3"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            }
            elseif($SLACount -eq 4)
            {
               $SLAMissed1 = "Missed Response for P4"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            }
            elseif($SLACount -eq 5)
            {
               $SLAMissed1 = "Missed Resolved time for P1"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            }            
            elseif($SLACount -eq 6)
            {
               $SLAMissed1 = "Missed Resolved time for P2"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            } 
            elseif($SLACount -eq 7)
            {
               $SLAMissed1 = "Missed Resolved time for P3"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            } 
            else
            {
               $SLAMissed1 = "Missed Resolved time for P4"
               $SLAMissed = $SLAMissed + $SLAMissed1  
            } 

                       
        }
    }
    $wbSLA.Close()
    $xlRSLA.Quit()
    if($CH2 -eq "Flase")
    {
        Write-Host "Missed SLA"
        $SLAMissed = "True"
        #Send-MailMessage –From "uttam.naskar@invensys.com" –To "Subramanyeswari.Ravinutala@cognizant.com" -cc "Biswajeet.Tripathy@cognizant.com","bharadwaj.sarmaulvr@cognizant.com","uttam.naskar@cognizant.com" –Subject "$SLAMissed on $DFFN" –Body "$SLAMissed on $DFFN" –SmtpServer "SMTP.wonderware.com"
    }
    .{.\ReadWriteXLFile.ps1}
    

}
else
{
    Write-Host "$DDBFNPath not found!!!"
    Send-MailMessage –From "uttam.naskar@invensys.com" –To "RaviKumar.Theegala@cognizant.com" -cc "Subramanyeswari.Ravinutala@cognizant.com","uttam.naskar@cognizant.com","HEMA.SHESHADRI@cognizant.com" –Subject "OTSLM BAT FILE RUN TO FAILED" –Body "DS001_InvensysToolsSustenance.xls file not found in \\10.91.42.163\ProjectStatusReport\NewOTSLMFILE path." –SmtpServer "SMTP.wonderware.com"
}
