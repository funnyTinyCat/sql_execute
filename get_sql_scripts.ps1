
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted     $PSVersionTable
#$ErrorActionPreference = 'Continue'


. "$($home)\desktop\isporuke\install\sql_execute\functions\fun_get_properties.ps1"

. "$($home)\desktop\isporuke\install\sql_execute\functions\fun_db_file_manipulations.ps1"

. "$($home)\desktop\isporuke\install\sql_execute\functions\fun_alter_moduleName_to_int.ps1"

. "$($home)\desktop\isporuke\install\sql_execute\functions\fun_alter_scriptName_to_int.ps1"

. "$($home)\desktop\isporuke\install\sql_execute\functions\fun_get_report_name.ps1"



#######################################################################################
# današnji dan u formatu yyyymmdd
$date01 = "20240602"

# da li je testni server (unesite broj 1) ili nije (unesite broj 0)
$sqlServerNameTestOrNot = 0

# da li je testna baza podataka (unesite broj 1) ili nije (unesite broj 0)
$dbNameTestOrNot = 0

#######################################################################################

$clientName=""

[bool] $executeAgain = $false


[int] $bTest02 = 0
$bDeleteErrorFiles = $false

$scriptPosition = ""
$errorPosition = ""
 

#get properties
$properties = Get-Properties


$pathModules = "$($home)\Desktop\isporuke\$($date01)_$($properties[0].clientName)\$($date01)_$($properties[0].clientName)\skripte\"


$scriptFolders = get-childitem $pathModules


# testirati da li postoji fajl sa greškom?

$errorFile = 0


$errorFile = test-path -Path $properties[0].scriptPosition


$moduleName=""
$scriptName=""


if ($errorFile) {


    $tmp = 0


    $errorFileProperties =  Get-Content $properties[0].scriptPosition


    foreach ($errorFileProperty in $errorFileProperties) {


        $tmp = $errorFileProperty.IndexOf('=')


        if ( $tmp -ge 0 ) {


            if ($errorFileProperty.Substring(0,$tmp) -eq 'module') {

                $moduleName = $errorFileProperty.Substring($tmp + 1)

            } elseif ($errorFileProperty.Substring(0, $tmp) -eq 'script') {

                $scriptName = $errorFileProperty.Substring($tmp + 1)

            }# end if

        }# end if

    }# end foreach

}# end if


# Clear-Variable -Name "tmp"


# sort sql scripts' folders
foreach ($scriptFolder in $scriptFolders) {


    $tmp = $scriptFolder -split "\t"


    if ($tmp.substring(0,2) -eq "DB") {

        Rename-Item "$($pathModules)$($tmp)" "01$($tmp)"

    } elseif ($tmp.substring(0,4) -eq "DGDB") {

        Rename-Item "$($pathModules)$($tmp)" "02$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "BP") {

        Rename-Item "$($pathModules)$($tmp)" "03$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "DG") {

        Rename-Item "$($pathModules)$($tmp)" "04$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "FK") {

        Rename-Item "$($pathModules)$($tmp)" "05$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "NA") {

        Rename-Item "$($pathModules)$($tmp)" "06$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "NB") {

        Rename-Item "$($pathModules)$($tmp)" "07$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "OP") {

        Rename-Item "$($pathModules)$($tmp)" "08$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "OS") {

        Rename-Item "$($pathModules)$($tmp)" "09$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "PL") {

        Rename-Item "$($pathModules)$($tmp)" "10$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "PR") {

        Rename-Item "$($pathModules)$($tmp)" "11$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "RI") {

        Rename-Item "$($pathModules)$($tmp)" "12$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "RM") {

        Rename-Item "$($pathModules)$($tmp)" "13$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "SI") {

        Rename-Item "$($pathModules)$($tmp)" "14$($tmp)"

    } elseif ($tmp.substring(0,2) -eq "TR") {

        Rename-Item "$($pathModules)$($tmp)" "15$($tmp)"

    }# end if

}# end foreach


#clear variable
Clear-Variable -Name "tmp"

Clear-Variable -Name "scriptFolders"
$scriptFolders=""


$scriptFolders = Get-ChildItem $pathModules


# zapisati u array modul i skriptu koja mu pripada 
foreach ($scriptFolder in $scriptFolders) {

    
    $tmp = $scriptFolder -split "\t"

#    "`n`n errorfile: $($errorFile)"

    if ($errorFile) {

#        "`n`n moduleNameOriginal - tmp: $($tmp), ##  moduleNameError - moduleName: $($moduleName)  "


        $bTestAMN = Alter-ModuleName  -moduleNameOriginal $tmp -moduleNameError $moduleName


        if ($bTestAMN) {


            continue

        } # end if

    }# end if


    $pathScripts="$($pathModules)$($tmp)\"


    $scripts = get-childitem  "$($pathScripts)" -Filter "*.sql"


    # filtriranje skripte
    foreach ($script in $scripts) {    


        $sTmp = $script -split "\t"


        $aModulsScripts += @(

            [pscustomobject]@{moduleName="$($tmp)";scriptName="$($sTmp)"}

        )

    }#end foreach

}# end foreach


Clear-Variable -Name "tmp"


foreach ($ams in $aModulsScripts) {


    if ($errorFile) {

            
        $bTest07 = Alter-ScriptName -moduleName $ams.moduleName  -moduleNameError $moduleName  -scriptName  $ams.scriptName -scriptNameError $scriptName


        if ($bTest07) {


            continue

        }# end if

    }# end if

    
    Execute-Script -moduleName01 "$($ams.moduleName)" -scriptName "$($ams.scriptName)" -date02 $date01 -sqlServerNameTestOrNotPar $sqlServerNameTestOrNot  -dbNameTestOrNotPar $dbNameTestOrNot


    $checkErrorPosition = 0


    $checkErrorPosition = Test-Path -Path $properties[0].errorPosition


    if ($checkErrorPosition) {


        $testContent = get-content $properties[0].errorPosition


        $tmp = $testContent[0].IndexOf("=")
            
        $error05 = $testContent[0].substring($tmp + 1 )
            
        $bTest02 = [int] ($error05.Trim())


    }# end if


# provjera da li čita fajl, greška, nije greška

    if ($bTest02) {


        "`n`n ponovno pokreni skriptu"

        $bDeleteErrorFiles = $true

        break

    }# end if

}#end foreach


Clear-Variable -Name "tmp"

Clear-Variable -Name "aModulsScripts"


# ako postoje fileovi u logs folderu, izbrisati ih


if (!($bDeleteErrorFiles)) {


    if ((Test-Path $properties[0].scriptPosition)) {


         Remove-Item $properties[0].scriptPosition

    }# end if


     if ((Test-Path $properties[0].errorPosition)) {


         Remove-Item $properties[0].errorPosition

    }# end if

    # create report name with date:
    $strReportName = Get-ReportName -pathToReport $properties[0].pathToReport

	# rename file
    Rename-Item -Path $properties[0].pathToReport -NewName $strReportName


    start $strReportName


    "`n`nkraj skripte - programa"

}# end if


