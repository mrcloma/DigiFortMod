<#
.SYNOPSIS
    Funcao do modulo Empresa para listar as cameras de um servidor Digifort.

.DESCRIPTION
    Funcao do modulo Empresa para listar as cameras de um servidor Digifort. Pode ser filtrado pelas propriedades que sao retornadas na consulta para a API.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a listagem das cameras venha de um servidor em especifico.
	
.PARAMETER Properties
    E necessario indicar o parametro -Properties para que a listagem das cameras venha com as Properties indicadas. As Properties disponíveis são Name, Description, Active, Model, DeviceType, ConnectionAddress, ConnectionPort, Latitude, Longitude, Memo, MediaProfiles, Group

.EXAMPLE
    Get-Cameras -Server monitoramento4 -Properties Name,Model,Active

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-Cameras {

	param (
	[parameter(Mandatory=$true)]
    [string]$Server,
    [string[]]$Properties = @("Name", "Description", "Active", "Model", "DeviceType", "ConnectionAddress", "ConnectionPort", "Latitude", "Longitude", "Memo", "MediaProfiles", "Group"))

    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Cameras/GetCameras?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Cameras | Select-Object -Property $Properties
            $filteredData
        } else {
            Write-Host "A propriedade 'Data' não foi encontrada na resposta JSON."
        }
    } catch {
		throw "Falha ao recuperar informacoes da camera. $_"
    }
}

Export-ModuleMember -Function 'Get-Cameras'
