
. "$($home)\desktop\isporuke\install\sql_execute\functions\fun_get_properties.ps1"


function  Execute-Script {

#    [CmdletBinding()]

    param(
    
#        [Parameter(Mandatory=$true)]
        [string] $moduleName01,

 #       [Parameter(Mandatory)]
        [string] $scriptName,

#        [Parameter(Mandatory)]
        [string] $date02,

        [bool] $sqlServerNameTestOrNotPar,

        [bool] $dbNameTestOrNotPar

    )


 
    # variables declaration
    $tmp = ""
    $sqlServerName = ""
    $dbName = ""
    $clientName = ""
    $scriptPosition = ""
    $errorPosition = ""

    $breakScript = $false
    $foundBegin = $false
    $foundEnd = $false

    $begin = ""
    $end = ""


    $properties = Get-Properties

    # konekcija na bazu podataka - uzimati iz konfiguracijskog fajla properties

    if ($sqlServerNameTestOrNotPar) {


        $SQLServer = $properties[0].sqlServerNameTest

    } else {
    
    
        $SQLServer = $properties[0].sqlServerName
    
    }# end if


    if ($dbNameTestOrNotPar) {


        $db3 = $properties[0].dbNameTest

    } else {
    

        $db3 = $properties[0].dbName
    
    }# end if


    # setovati begin i end varijable
    $begin = "SBEGIN DB=$($db3) - MODUL=$($moduleName01) - SCRIPT=$($scriptName) - $((get-date).tostring(“dd-MM-yyyy HH:mm:ss”))"

    $end = "SEND DB=$($db3) - MODUL=$($moduleName01) - SCRIPT=$($scriptName) - $((get-date).tostring(“dd-MM-yyyy HH:mm:ss”))"

    $modulePath = "$($home)\Desktop\Isporuke\$($date02)_$($properties[0].clientName)\$($date02)_$($properties[0].clientName)\skripte\$($moduleName01)"


    # zapisi u fajl
    $pathScript04 = "$($home)\Desktop\Isporuke\$($date02)_$($properties[0].clientName)\$($date02)_$($properties[0].clientName)\skripte\$($moduleName01)\$($scriptName)"


    Add-Content $properties[0].pathToReport "`n$($begin)"


    Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -QueryTimeout 0 -InputFile $pathScript04  -OutputSQLErrors $true  -ErrorVariable errorVariable -verbose  2>> $properties[0].pathToReport

#    (Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -QueryTimeout 0 -InputFile $pathScript04  -OutputSQLErrors $true  -ErrorVariable errorVariable -verbose 2>&1>> $properties[0].pathToReport )  # 2>> $properties[0].pathToReport #| tee -filePath $properties[0].pathToReport 
    

    if ($errorvariable) {


        Set-Content $properties[0].scriptPosition "module=$($moduleName01)`nscript=$($scriptName)`n$((get-date).tostring(“dd-MM-yyyy HH:mm:ss”))"


        start $properties[0].pathToReport


        Set-Content $properties[0].errorPosition "error=1`n$((get-date).tostring(“dd-MM-yyyy HH:mm:ss”))"

    } else {


        Add-Content $properties[0].pathToReport "`n Uspješno izvršena skripta."


        Set-Content $properties[0].errorPosition "error=0`n$((get-date).tostring(“dd-MM-yyyy HH:mm:ss”))"

        # ako ima fajla, izbriši ga
        $bScriptPosition = test-path $properties[0].scriptPosition


        if ($bScriptPosition) {


            remove-item $properties[0].scriptPosition

        }# end if

    }# end if


    Add-Content $properties[0].pathToReport "`n$($end)"

}# end function



# Execute-Script -moduleName01 'DB_62001' -scriptName '07_script7.sql' -date02 '20221125'

  