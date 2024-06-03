# function get report name

function Get-ReportName {
    
    param(
    
    
        [String] $pathToReport

    )

    $strDate = (Get-date).ToString("yyyyMMdd_Hms")

 
      
    $strReverse = $pathToReport[-1..-$pathToReport.Length] -join ''

    $strTmp = $strReverse.Split(".")

    $strExtension = $strTmp[0][-1..-$strTmp[0].Length] -join ''

    $strReportName = $strTmp[1][-1..-$strTmp[1].Length] -join ''


    return "$($strReportName)_$($strDate).$($strExtension)"

}# end function

# Get-ReportName("C:\tmp\run03.txt")