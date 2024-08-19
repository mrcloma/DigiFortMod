<#
.SYNOPSIS
    Funcao do modulo Empresa para consultar o status de uma camera de um servidor.

.DESCRIPTION
    Funcao do modulo Empresa para consultar o status de uma camera de um servidor.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a informacao seja consultada de um servidor em especifico.

.PARAMETER Camera
    E necessario indicar o parametro -Camera para que o status da camera indicada venha de um servidor em especifico.

.PARAMETER Properties
    E necessario indicar o parametro -Properties para que a saida do comando com apenas as Properties indicadas. As Properties disponíveis são Name, Active, Working, ActiveTime, InactiveTime, ConfiguredToRecord, WrittingToDisk, RecordingFPS, RecordingHours, RecordingHoursEstimative, UsedDiskSpace

.EXAMPLE
    Get-CameraStatus -Server monitoramento4

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-CameraStatus {
	
	param (
		[parameter(Mandatory=$true)]
		[string]$Server,
		[parameter(Mandatory=$true)]
        [string]$Camera,
		[string[]]$Properties = @( "Name", "Active", "Working", "ActiveTime", "InactiveTime", "ConfiguredToRecord", "WrittingToDisk", "RecordingFPS", "RecordingHours", "RecordingHoursEstimative", "UsedDiskSpace"))

	if (-not $Camera) {
        throw "O parametro '-Camera' e obrigatorio. Forneca um nome de camera valido."
    }

    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Cameras/GetStatus?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"
	
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Cameras | Where-Object { $_.Name -eq $Camera } | Select-Object -Property $Properties

			if ($filteredData) {
                $filteredData
            } else {
                Write-Host "Camera com o nome '$Camera' nao encontrada."
            }
			
        } else {
            Write-Host "Dados nao retornados."
        }
    } catch {
		throw "Falha ao recuperar informacoes. $_"
    }
}

Export-ModuleMember -Function 'Get-CameraStatus'