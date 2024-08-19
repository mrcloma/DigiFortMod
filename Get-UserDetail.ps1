<#
.SYNOPSIS
    Funcao do modulo Empresa para mostrar os detalhes de um usuario de um servidor Digifort.

.DESCRIPTION
    Funcao do modulo Empresa para mostrar os detalhes de um usuario de um servidor Digifort.

.PARAMETER Server
    E necessario indicar o parametro -Server para que o usuario venha de um servidor em especifico.

.PARAMETER Server
    E necessario indicar o parametro -User para que o usuario em especifico seja selecionado a partir de todos os usuarios do servidor.

.EXAMPLE
    Get-UserDetail -Server monitoramento4 -User admin

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-UserDetail {

	param (
	[parameter(Mandatory=$true)]
    [string]$Server,
    [parameter(Mandatory=$true)]
    [string]$User)


    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Users/GetUsers?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Users | Where-Object { $_.Name -eq $User }  | Select-Object @("Name", "Description", "Memo", "Groups")
            $filteredData
        } else {
            Write-Host "A propriedade 'Data' não foi encontrada na resposta JSON."
        }
    } catch {
		throw "Falha ao recuperar informacoes da camera. $_"
    }
}

Export-ModuleMember -Function 'Get-UserDetail'