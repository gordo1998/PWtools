
$imageOne = @"
                            ______       _            _        _______                
                           / _____)     (_)  _       | |      (_______)               
                          ( (____  _ _ _ _ _| |_ ____| |__        _ _____ _____ ____  
                           \____ \| | | | (_   _) ___)  _ \      | | ___ (____ |    \ 
                           _____) ) | | | | | |( (___| | | |     | | ____/ ___ | | | |
                          (______/ \___/|_|  \__)____)_| |_|     |_|_____)_____|_|_|_|
"@

$herramienta = @"
                                   MMMMMMMMMMMWX0kddodxkOXWMMMMMMMMMMMWXXWM
                                   MMMMMMMWXkl,.         .:OWMMMMMMMNOc.'dN
                                   MMMMMWKl.        .,clodd0WMMMMMWk,   ;OW
                                   MMMMWk'         :0WMMMMMMMMMMMW0:..'xNMM
                                   MMMNd.          cXMMMMMMMMMMW0ocd0KXWMMM
                                   MWXl.           .dKNMMMMMMNOlcdXWMMMMMMM
                                   Kl'...         .'..,cxXMNkccxXMMMMMMMMMM
                                   '    ..'cddl;'..      'ccckNMMMMMMMMMMMM
                                   x;.   'OWMMMWO,         .oXWMMMMMMMMMMMM
                                   MNOc,lKWMMMMNkc,.         'dXWMMMMMMMMMM
                                   MMMWWWMMMMXx:. ...          .oKWMMMMMMMM
                                   MMMMMMMW0o,',;'.  .,,.        .lKWMMMMMM
                                   MMMMMNOc,',:;;;,..oKN0c.        .l0WMMMM
                                   MMMXx;'',;;,;,',lKWMMMWO:.        .c0WMM
                                   W0o,'',,,,,,',lKWMMMMMMMNk;         .cOW
                                   c'''',,,,,',lKWMMMMMMMMMMMNx,         .:
                                    ...,,,,',lKWMMMMMMMMMMMMMMMXd'         
                                   o. ...',lKWMMMMMMMMMMMMMMMMMMMXo.     .o
                                   W0o;',oKWMMMMMMMMMMMMMMMMMMMMMMWKo,';o0W
                                   MMMWXNWMMMMMMMMMMMMMMMMMMMMMMMMMMWNXWMMM
"@

$Host.UI.RawUI.ForegroundColor = 'DarkCyan'
$imageOne
$Host.UI.RawUI.ForegroundColor = 'Red'
$herramienta
$Host.UI.RawUI.ForegroundColor = 'Yellow'
$menu = "`t`t`t`t`t| opciones:                    |`n`t`t`t`t`t|------------------------------|`n`t`t`t`t`t| 1) Listar adaptadores de red |`n`t`t`t`t`t| 2) Crear nuevo SwitchTeam    |`n`t`t`t`t`t| 3) Eliminar SwitchTeam       |"
$Host.UI.RawUI.ForegroundColor = 'Yellow'
"`t`t`t`t`t ------------------------------"
$menu
"`t`t`t`t`t ------------------------------`n"

do #Itera hasta que se ponga un valor válido ffffffffAAAAAAAAA
{
	$opcionMenu = Read-host -prompt "Ingresa un numero de seleccion"
	#si opcionMenu esta vacio vuelve a preguntar
	if ([string]::IsNullOrEmpty($opcionMenu)) {
		$Host.UI.RawUI.ForegroundColor = 'Red'
		Write-Host "Debe introducir un valor."
		$Host.UI.RawUI.ForegroundColor = 'Yellow'
	}
}
until($opcionMenu -match '^\d+$' )

#Se puede intentar realizat todo este bloque if else con un switch
#Este bloque ejecuta todo el programa principal
if ($opcionMenu -eq 1) #Lista todos los adaptadores
{
	$array = Get-NetAdapter #Guarda el comando para listar los adaptadores
	$ColumName = $array | Select-Object -ExpandProperty Name #Extrae unicamente los nombres
	for ($i = 0; $i -lt $columName.count; $i++){
		"Adaptador $($i + 1): $($columName[$i])"
	}
	
}elseif ($opcionMenu -eq 2) # Crea un nuevo equipo
{
	Write-host "Elija al menos dos adaptadores..."
	$array = Get-NetAdapter #Coge toda la tabla
	$ColumName = $array | Select-Object -ExpandProperty Name #Selecciona solo los datos de la tabla Name
	$arrayDos = $ColumName -split "`n" | Where-Object { $_ -ne "" } # Convierte el esos datos y los mete en la matriz



	for($i = 0; $i -lt $arrayDos.count; $i = $i + 1) #Listamos la matriz con su índice para que escoja la opción
	{
		"$i)$($arrayDos[$i])" #mostramos en pantalla las opciones
	}

	do{

		$cantAdaptadores = read-host -prompt "Cuantos adaptadores vas a unir?"

		if ([string]::IsNullOrEmpty($cantAdaptadores)) {
			$Host.UI.RawUI.ForegroundColor = 'Red'
			Write-Host "Debe introducir un valor."
			$Host.UI.RawUI.ForegroundColor = 'Yellow'
			continue  # Salta al siguiente ciclo de la iteración
		} 
		try {
			$cantAdaptadores = [int]$cantAdaptadores
		}
		catch {
			$Host.UI.RawUI.ForegroundColor = 'Red'
			Write-Host "Debe introducir un numero"
			$Host.UI.RawUI.ForegroundColor = 'Yellow'
		}
		
	}until($cantAdaptadores -match '^\d+$')
	
	
		
	$adaptadores = New-Object System.Collections.ArrayList #Aquí se ubicarán todos los adaptadores
	$adapterExist = $false # Utilizamos esta variable para saber si el adaptador esta disponible o no
	for ($y = 0; $y -lt $cantAdaptadores; $y = $y + 1)
	{
		do {
			$adapter = Read-host -prompt "Elije el adaptador"
			$adapterExist = ipconfig | Select-String -Pattern "\b$($arrayDos[$adapter])\b" -Quiet #Devuelve verdadero si existe
			Write-Host "adaptador: $adapterNoExist"
			if ($adapterExist -ne $true){
				Write-Host "El adapatador ya se encuentra en un equipo!"
			}
		}until($adapter -match '^\d+$' -and $adapterExist -eq $true)#saldrá del bucle si el adaptador está disponible
		
		$adaptadores.Add($arrayDos[$adapter])
	}
	
	do {
		$nameTeam = [String] (Read-host -prompt "Ahora elije el nombre de grupo")
		if(($arrayDos -contains $nameTeam)){  # Si el nombre de equipo ya existe le diremos que no puede
			$Host.UI.RawUI.ForegroundColor = 'Red'
			Write-Host "Ya existe este nombre equipo!!"
			$Host.UI.RawUI.ForegroundColor = 'Yellow'
		}

	}until(-not($arrayDos -contains $nameTeam))
	
	
	$adaptadores = $adaptadores.ToArray([String])

	New-NetSwitchTeam -Name $nameTeam -TeamMembers $adaptadores #Crea el Switch team
			
		

}elseif($opcionMenu -eq 3)
{
	$nombreAdaptador = Read-Host -Prompt "Indique el nombre del equipo"
	Remove-NetSwitchTeam -Name $nombreAdaptador #Borra el Switch team
}

