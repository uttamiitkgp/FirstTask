$SLAFlag = "$SLAMissed"
 
$fileD = "{0:yyyyMMdd}" -f (get-date).adddays(-1)
$FN= "OTSI_DD_602_Invensys_SW_Dev_Services_" + $fileD + ".csv"

$IncidentVolume1 = 0
[double[]] $IncidentVolume=@()
$TotalIncidentVolume = 0

$OpenIncidents=@()
$TotalOpenIncidents=0

$ResolvedIncidents=@()
$TotalResolvedIncidents=0

[double[]] $MTTR =@()
$TotalMTTR = 0
$MTTR1 = 0

    Write-Host "Reading data from $DDBFNPath file...."
    $xlR=New-Object -ComObject "Excel.Application"
    $wb=$xlR.Workbooks.Open($DDBFNPath)
    $ws=$wb.Worksheets.Item(1)
    for($i=2; $i -le 103; $i++)
    {
        if(($i -ge 2) -and ($i -le 5))
        {
            $IncidentVolume1 = $ws.Cells.Item($i, 6).Text
            $IncidentVolume = $IncidentVolume + $IncidentVolume1
            $TotalIncidentVolume = $TotalIncidentVolume + $IncidentVolume1
        }
        if(($i -ge 6) -and ($i -le 9))
        {
            $OpenIncidents1 = $ws.Cells.Item($i, 6).Text
            $OpenIncidents = $OpenIncidents + $OpenIncidents1
            $TotalOpenIncidents = $TotalOpenIncidents + $OpenIncidents1
        }
        if(($i -ge 14) -and ($i -le 17))
        {
            $ResolvedIncidents1 = $ws.Cells.Item($i, 6).Text
            $ResolvedIncidents = $ResolvedIncidents + $ResolvedIncidents1
            $TotalResolvedIncidents = $TotalResolvedIncidents + $ResolvedIncidents1
        }
        if(($i -ge 95) -and ($i -le 98))
        {
            $MTTR1 = $ws.Cells.Item($i, 6).Text
            $MTTR = $MTTR + $MTTR1
            $TotalMTTR = $TotalMTTR + $MTTR1
        }
    }
    $wb.Close()
    $xlR.Quit()
 
    [double[]] $PMTTR =@()
    $TPMTTR =0
    for ($u=0; $u -le 3; $u++)
    {
        $PMTTR1 = $MTTR[$u] * $ResolvedIncidents[$u]
        $PMTTR = $PMTTR +$PMTTR1
        $TPMTTR = $TPMTTR + $PMTTR1
    }

    Write-Host "creating new xls file..." 
    $xlW=New-Object -ComObject "Excel.Application"
    $wc=$xlW.Workbooks.Add()
    $wd=$wc.ActiveSheet
    $cells=$wd.Cells
    $cells.item(1,1) = "Date"
    for($i=2; $i -le 26; $i++)
    {
        $cells.item($i,1) = "$DFFN"
    }
    $cells.item(1,2) = "Engagement Key"
    for($i=2; $i -le 26; $i++)
    {
        $cells.item($i,2) = "602"
    }
    $cells.item(1,3) = "Metric ID"
    $cells.item(1,4) = "Metric Definition"
    $cells.item(1,5) = "Measure"
    $cells.item(2,5) = "$TotalIncidentVolume"
    $cells.item(7,5) = "$TotalOpenIncidents"
    $cells.item(12,5) = "$TotalResolvedIncidents"
    $cells.item(2,6) = "$TotalIncidentVolume"
    $cells.item(7,6) = "$TotalOpenIncidents"
    $cells.item(12,6) = "$TotalResolvedIncidents"

    $cells.item(1,6) = "Numerator"
    $cells.item(1,7) = "Denominator"
    $cells.item(17,5) = "$TotalMTTR"
    $cells.item(17,7) = "$TotalResolvedIncidents"
    $cells.item(22,6) = "$TotalResolvedIncidents"
    $cells.item(22,7) = "$TotalResolvedIncidents"

    for($i=2; $i -le 26; $i++)
    {
        if ($i -le 16)
        {
            $cells.item($i,3) = $i-1
        }
        if (($i -gt 16) -and ($i -le 21))
        {
            $cells.item($i,3) = $i + 10
        } 
        if (($i -gt 21) -and ($i -le 26))
        {
            $cells.item($i,3) = $i + 11
        } 
        if ($i -eq 2)
        {
            $cells.item($i,4) = "Incident Volume"
        }

        if (($i -gt 2) -and ($i -le 6))
        {
            $Priority = $i - 2
            $cells.item($i,4) = "Incident Volume by Priority P$Priority"
            $cells.item($i,5) = $IncidentVolume[$Priority-1]
            $cells.item($i,6) = $IncidentVolume[$Priority-1]
        } 
        if ($i -eq 7)
        {
            $cells.item($i,4) = "Open Incidents"
        }
        if (($i -gt 7) -and ($i -le 11))
        {
            $Priority = $i - 7
            $cells.item($i,4) = "Open Incidents by Priority P$Priority"
            $cells.item($i,5) = $OpenIncidents[$Priority-1]
            $cells.item($i,6) = $OpenIncidents[$Priority-1]
        } 
    
        if ($i -eq 12)
        {
            $cells.item($i,4) = "Resolved Incidents"
        }
        if (($i -gt 12) -and ($i -le 16))
        {
            $Priority = $i - 12
            $cells.item($i,4) = "Resolved Incidents by Priority P$Priority"
            $cells.item($i,5) = $ResolvedIncidents[$Priority-1]
            $cells.item($i,6) = $ResolvedIncidents[$Priority-1]
        } 
    
        if ($i -eq 17)
        {
            $cells.item($i,4) = "MTTR"
        }
        if (($i -gt 17) -and ($i -le 21))
        {
            $Priority = $i - 17
            $cells.item($i,4) = "MTTR by Priority P$Priority"
            $cells.item($i,5) = $MTTR[$Priority-1]
            $cells.item($i,7) = $ResolvedIncidents[$Priority-1]
            $cells.item($i,6) = $PMTTR[$Priority-1]
        } 
    
        if ($i -eq 22)
        {
            $cells.item($i,4) = "Resolution SLA"
        }
        if (($i -gt 22) -and ($i -le 26))
        {
            $Priority = $i - 22
            $cells.item($i,4) = "Resolution SLA by Priority P$Priority"
            $cells.item($i,6) = $ResolvedIncidents[$Priority-1]
            $cells.item($i,7) = $ResolvedIncidents[$Priority-1]
            if ( $ResolvedIncidents[$Priority-1] -eq 0)
            {
                $cells.item($i,5) = 0 
            }
            else
            {
                $cells.item($i,5) = 100
            }
        } 
    }

    if ( $TotalResolvedIncidents -eq 0)
    {
        $cells.item(22,5) = 0
    }
    else
    {
        $cells.item(22,5) = 100
    }

    if ( $TotalMTTR -eq 0)
    {
        $cells.item(17,6) = 0
    }
    else
    {
        $cells.item(17,6) = $TPMTTR
    }


$objWorksheet = $wc.Worksheets.Item("Sheet1") 
[void] $objWorksheet.Activate() 
$objWorksheet.Name = "OTSI_DD_602_Invensys_SW_Dev_Ser"

$wc.SaveAs("D:\Work\ProjectWork2016\OTSI\Temp\Temp.xls")
$wc.Close()
$TempFilePath = "D:\Work\ProjectWork2016\OTSI\Temp\Temp.xls" 
.{.\ConvertExcelToCSV.ps1}
