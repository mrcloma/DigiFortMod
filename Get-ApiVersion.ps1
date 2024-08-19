<#
.SYNOPSIS
    Funcao do modulo Empresa para consultar a versao da API de um servidor.

.DESCRIPTION
    Funcao do modulo Empresa para consultar a versao da API de um servidor.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a informacao seja consultada de um servidor em especifico.

.PARAMETER Properties
    E necessario indicar o parametro -Properties para selecionar campos especificos na saida do comando. As Properties disponíveis sao Name, Version, Edition, Major, Minor, BugFix
.EXAMPLE
    Get-Apiversion -Server mononitoramento4 -Properties Name, Edition, Major

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-Apiversion {
	
	param (
		[parameter(Mandatory=$true)]
		[string]$Server,
		[string[]]$Properties = @("Name", "Version", "Edition", "Major", "Minor", "BugFix"))


    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/GetAPIVersion?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.ApiVersion | Select-Object -Property $Properties
            $filteredData
        } else {
            Write-Host "Dados nao retornados."
        }
    } catch {
		throw "Falha ao recuperar informacoes. $_"
    }
}

Export-ModuleMember -Function 'Get-Apiversion'
