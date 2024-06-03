#

function Alter-ScriptName {


    param(

        [string] $moduleName,
        [string] $moduleNameError,
        [string] $scriptName,
        [string] $scriptNameError

    )

                
    $prefixNumberScript = [int] ($scriptName.subString(0,2))

    $prefixNumberScriptErr = [int] ($scriptNameError.substring(0,2))
        

    if ( ($prefixNumberScript -le $prefixNumberScriptErr)  -and ( $moduleName -eq $moduleNameError  )   ) {


        return $true

    } else {
    

        return $false
    
    }# end if

}# end function