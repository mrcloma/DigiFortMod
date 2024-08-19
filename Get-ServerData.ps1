<#
.SYNOPSIS
    Funcao do modulo Empresa para consultar informacoes de um servidor.

.DESCRIPTION
    Funcao do modulo Empresa para consultar informacoes de um servidor.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a informacao seja consultada de um servidor em especifico.

.PARAMETER Properties
    E necessario indicar o parametro -Properties para que a listagem dos dados do servidor venha com apenas as Properties indicadas. As Properties disponíveis são Edition, Version, ReleaseDate, ReleaseType, Platform, UpTime, Date, Time, DateTime, UTCDateTime, ServerType

.EXAMPLE
    Get-ServerData -Server monitoramento4

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-ServerData {
	
	param (
		[parameter(Mandatory=$true)]
		[string]$Server,
		[string[]]$Properties = @("Edition", "Version", "ReleaseDate", "ReleaseType", "Platform", "UpTime", "Date", "Time", "DateTime", "UTCDateTime", "ServerType")
	)


    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Server/GetInfo?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Info | Select-Object -Property $Properties
            $filteredData
        } else {
            Write-Host "Dados nao retornados."
        }
    } catch {
		throw "Falha ao recuperar informacoes. $_"
    }
}

Export-ModuleMember -Function 'Get-ServerData'
