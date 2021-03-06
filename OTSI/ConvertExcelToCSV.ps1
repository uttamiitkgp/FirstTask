Write-Host "Converting Temp.xls file to CSV file..."
$xlCSV=6 
Write-Host "$DDBFNPath"
$Excelfilename = "$TempFilePath"
$CSVfilename = "$OutputFolderPath\$FN"
$Excel = New-Object -comobject Excel.Application 
$Excel.Visible = $False 
$Excel.displayalerts=$False 
$Workbook = $Excel.Workbooks.Open($ExcelFileName) 
$Workbook.SaveAs($CSVfilename,$xlCSV) 
$Excel.Quit() 
If(ps excel){kill -name excel}
Write-Host "$FN has been created successfully" 

Remove-Item D:\Work\ProjectWork2016\OTSI\Temp\* -include *.xls

if ($SLAFlag -eq "True")
{
    Send-MailMessage –From "uttam.naskar@invensys.com" –To "Subramanyeswari.Ravinutala@cognizant.com" -cc "hema.sheshadri@cognizant.com","uttam.naskar@cognizant.com" –Subject "Missed SLA on $DFFN" –Body "Missed SLA on $DFFN. File has been generated and it's avaiable on $OutputFolderPath . Please correct this file and upload into the https://slmfs.cognizantgoc.com/login.aspx before 3:30 PM." –SmtpServer "SMTP.wonderware.com"    
}
else
{    

    if(($Day -ne "Saturday") -or ($Day -ne "Sunday"))
    {
        Write-Host "Sending mail..."
        $HolidayList = Get-Content C:\MyScripts\OTSLM\HolidayList.txt
	   $FileNameC= @()
	   if($Day -eq "Monday")
	   {
                $FGC = 3
                $HOFriday ="{0:dd-MM-yyyy}" -f (get-date).adddays(-3)
                foreach($HDList in $HolidayList)
                {
                    if ($HDList -eq $HOFriday)
                    {
                        $Holiday = "True"
                        $FGC = 4
                    }
                }
    		    for($i=1; $i -le $FGC; $i++)
    		    {
        		  $DT="{0:MM/dd/yy}" -f (get-date).adddays(-$i)
        		  $fileD = "{0:yyyyMMdd}" -f (get-date).adddays(-$i)
        		  $MY = "{0:d-MMM-yy}" -f (get-date).adddays(-$i)
        		  #$fileN = "DS001_InvensysToolsSustenance_" + $fileD +".xls"
        		  $FN= "OTSI_DD_602_Invensys_SW_Dev_Services_" + $fileD + ".csv"
        		  $FileNameC = $FileNameC + $FN
    		     }

	   }
        elseif($Day -eq "Tuesday")
        {
                $FGC = 1
                $HOMonday ="{0:dd-MM-yyyy}" -f (get-date).adddays(-1)
                foreach($HDList in $HolidayList)
                {
                    if ($HDList -eq $HOMonday)
                    {
                        $Holiday = "True"
                        $FGC = 4
                    }
                }
    		  for($i=1; $i -le $FGC; $i++)
    		  {
        		  $DT="{0:MM/dd/yy}" -f (get-date).adddays(-$i)
        		  $fileD = "{0:yyyyMMdd}" -f (get-date).adddays(-$i)
        		  $MY = "{0:d-MMM-yy}" -f (get-date).adddays(-$i)
        		  #$fileN = "DS001_InvensysToolsSustenance_" + $fileD +".xls"
        		  $FN= "OTSI_DD_602_Invensys_SW_Dev_Services_" + $fileD + ".csv"
        		  $FileNameC = $FileNameC + $FN
    		  }
        }
	   else
	   {
                $PDH = "{0:dd-MM-yyyy}" -f (get-date).adddays(-1)
                $FGC = 1
                foreach($HDList in $HolidayList)
                {
                    if ($HDList -eq $PDH)
                    {
                        $Holiday = "True"
                        $FGC = 2
                    }
                }             
     		    for($i=1; $i -le $FGC; $i++)
    		    {
        		  $DT="{0:MM/dd/yy}" -f (get-date).adddays(-$i)
        		  $fileD = "{0:yyyyMMdd}" -f (get-date).adddays(-$i)
        		  $MY = "{0:d-MMM-yy}" -f (get-date).adddays(-$i)
        		  #$fileN = "DS001_InvensysToolsSustenance_" + $fileD +".xls"
        		  $FN= "OTSI_DD_602_Invensys_SW_Dev_Services_" + $fileD + ".csv"
        		  $FileNameC = $FileNameC + $FN
    		    }
	   }
    

   .{.\Email_OTSLM.ps1}
        
  }
}