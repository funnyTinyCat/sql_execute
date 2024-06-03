#

function Alter-ModuleName {

    param(
    
        [String] $moduleNameOriginal,
        [String] $moduleNameError

    )# end param

            
#    "`n`n u fun alter-moduleName"

    $prefixNumberModule = [int] ($moduleNameOriginal.subString(0,2))

    $prefixNumberModuleErr = [int] ($moduleNameError.substring(0,2))
        

    if (($prefixNumberModule -lt $prefixNumberModuleErr)) {


        return $true

    } elseif ( $prefixNumberModule -eq $prefixNumberModuleErr ) {
    

# stigao do ovdje?
        $suffixNumberModule = [int] ($moduleNameOriginal.Substring(($moduleNameOriginal.length - 5), 5))
        
        $suffixNumberModuleErr = [int] ($moduleNameError.Substring(($moduleNameError.length - 5), 5))


        if ( $suffixNumberModule -lt $suffixNumberModuleErr ) {

            
            return $true

        } else {
        

            return $false
        
        }# end if

    } else {


        return $false
    
    }# end if



}# end function


# Alter-ModuleName -moduleNameOriginal "01DB_62001" -moduleNameError "02DB_62002"

