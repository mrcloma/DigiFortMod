<#
.SYNOPSIS
    Funcao do modulo Empresa para consultar os grupos de cameras de um servidor.

.DESCRIPTION
    Funcao do modulo Empresa para consultar os grupos de cameras de um servidor.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a informacao seja consultada de um servidor em especifico.

.PARAMETER Properties
    E necessario indicar o parametro -Properties para filtrar com apenas as Properties indicadas. As Properties disponíveis são ID, Name, Parent
	
.EXAMPLE
    Get-CameraGroups -Server monitoramento4

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-CameraGroups {
	
	param (
		[parameter(Mandatory=$true)]
		[string]$Server,
		[string[]]$Properties = @("ID", "Name", "Parent"))


    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Cameras/GetGroups?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"
	
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Groups | Select-Object -Property $Properties
            $filteredData
        } else {
            Write-Host "Dados nao retornados."
        }
    } catch {
		throw "Falha ao recuperar informacoes. $_"
    }
}

Export-ModuleMember -Function 'Get-CameraGroups'