
$menu = "opciones:`n1) Listar adaptadores de red`n2) Crear nuevo SwitchTeam`n3) Eliminar SwitchTeam`n"
$Host.UI.RawUI.ForegroundColor = 'Yellow'
$menu

do#Itera hasta que se ponga un valor válido ffffffffAAAAAAAAA
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
if ($opcionMenu -eq 1)#Lista todos los adaptadores
{
	$array = Get-NetAdapter #Guarda el comando para listar los adaptadores
	$ColumName = $array | Select-Object -ExpandProperty Name #Extrae unicamente los nombres
	$columName
}elseif ($opcionMenu -eq 2)# Crea un nuevo equipo
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

