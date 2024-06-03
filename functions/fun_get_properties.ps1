
# function get properties


function Get-Properties {


#    param ( )


    $properties = get-content "$($home)\Desktop\Isporuke\Install\sql_execute\config\properties.ini"

#    "`n`n properties: $($properties)"

    $tmp = 0


    $propertiesVariables = @(


        [pscustomobject]@{sqlServerName='1';dbName='2'; dbNameTest='3'; sqlServerNameTest='4'; scriptPosition='5'; errorPosition='6'; clientName='7'; pathToReport='8' }

    )


    foreach ($property in $properties) {


        $tmp = $property.IndexOf('=')


        if($property.subString(0, $tmp) -eq 'sqlServerName') {


            $propertiesVariables[0].sqlServerName = $property.subString($tmp + 1)

        }elseif($property.subString(0, $tmp) -eq 'dbName') {


            $propertiesVariables[0].dbName = $property.subString($tmp + 1)

        }elseif($property.subString(0, $tmp) -eq 'dbNameTest') {


            $propertiesVariables[0].dbNameTest = $property.subString($tmp + 1)

        }elseif($property.subString(0, $tmp) -eq 'sqlServerNameTest') {


            $propertiesVariables[0].sqlServerNameTest = $property.subString($tmp + 1)

        }elseif($property.subString(0, $tmp) -eq 'pathToScriptPosition') {


            $propertiesVariables[0].scriptPosition = "$($home)$($property.subString($tmp + 1))"

        }elseif($property.subString(0, $tmp) -eq 'pathToErrorPosition') {


            $propertiesVariables[0].errorPosition = "$($home)$($property.subString($tmp + 1))"

        }elseif($property.subString(0, $tmp) -eq 'clientName') {


            $propertiesVariables[0].clientName = $property.subString($tmp + 1)

        }elseif($property.subString(0, $tmp) -eq 'pathToReport') {


            $propertiesVariables[0].pathToReport = "$($property.subString($tmp + 1))"

        } # end if    

    }#end foreach


    Clear-Variable -Name "tmp"


    return $propertiesVariables


}# end function

