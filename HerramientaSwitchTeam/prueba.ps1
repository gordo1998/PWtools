
$menu = "opciones:`n1) Listar adaptadores de red`n2)Crear nuevo SwitchTeam`n3)Eliminar SwitchTeam`n"
$Host.UI.RawUI.ForegroundColor = 'Yellow'
$menu

do
{
	$opcionMenu = Read-host -prompt "Ingresa un numero de seleccion"

	if ([string]::IsNullOrEmpty($opcionMenu)) {
		$Host.UI.RawUI.ForegroundColor = 'Red'
		Write-Host "Debe introducir un valor."
		$Host.UI.RawUI.ForegroundColor = 'Yellow'
	}
}
until($opcionMenu -match '^\d+$' )

if ($opcionMenu -eq 1)
{
	$array = Get-NetAdapter
	$ColumName = $array | Select-Object -ExpandProperty Name
	$columName
}elseif ($opcionMenu -eq 2)
{
	Write-host "Elija al menos dos adaptadores..."
	$array = Get-NetAdapter #Coge toda la tabla
	$ColumName = $array | Select-Object -ExpandProperty Name #Selecciona solo los datos de la tabla Name
	$arrayDos = $ColumName -split "`n" | Where-Object { $_ -ne "" } # Convierte el esos datos y los mete en la matriz



	for($i = 0; $i -lt $arrayDos.count; $i = $i + 1) #Listamos la matriz con su índice para que escoja la opción
	{
		"$i)$($arrayDos[$i])"
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
	
	
		
	$adaptadores = New-Object System.Collections.ArrayList
	$adapterNoExist = $false
	for ($y = 0; $y -lt $cantAdaptadores; $y = $y + 1)
	{
		do {
			$adapter = Read-host -prompt "Elije el adaptador"
			$adapterNoExist = ipconfig | Select-String -Pattern "\b$($arrayDos[$adapter])\b" -Quiet
			Write-Host "adaptador: $adapterNoExist"
			if ($adapterNoExist -ne $true){
				Write-Host "El adapatador ya se encuentra en un equipo!"
			}
		}until($adapter -match '^\d+$' -and $adapterNoExist -eq $true)
		
		$adaptadores.Add($arrayDos[$adapter])
	}
	
	do {
		$nameTeam = [String] (Read-host -prompt "Ahora elije el nombre de grupo")
		if(($arrayDos -contains $nameTeam)){
			$Host.UI.RawUI.ForegroundColor = 'Red'
			Write-Host "Ya existe este nombre equipo!!"
			$Host.UI.RawUI.ForegroundColor = 'Yellow'
		}

	}until(-not($arrayDos -contains $nameTeam))
	
	
	$adaptadores = $adaptadores.ToArray([String])

	New-NetSwitchTeam -Name $nameTeam -TeamMembers $adaptadores
			
		

}elseif($opcionMenu -eq 3)
{
	$nombreAdaptador = Read-Host -Prompt "Indique el nombre del equipo"
	Remove-NetSwitchTeam -Name $nombreAdaptador
}

