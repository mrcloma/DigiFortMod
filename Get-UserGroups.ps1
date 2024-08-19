<#
.SYNOPSIS
    Funcao do modulo Empresa para mostrar os detalhes de um grupo de usuarios de um servidor Digifort.

.DESCRIPTION
    Funcao do modulo Empresa para mostrar os detalhes de um grupo de usuarios de um servidor Digifort.

.PARAMETER Server
    E necessario indicar o parametro -Server para que o grupo de usuarios venha de um servidor em especifico.
	
.PARAMETER Properties
    E necessario indicar o parametro -Properties para que sejam indicadas as propriedades a serem retornadas pela consulta. As Properties disponiveis sao Name, Description e Users

.EXAMPLE
    Get-UserGroups -Server monitoramento4 -Properties Name, Users

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-UserGroups {

	param (
	[parameter(Mandatory=$true)]
    [string]$Server,
	[parameter(Mandatory=$true)]
    [string[]]$Properties = @("Name", "Description", "Users"))


    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Users/GetGroups?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Groups | Select-Object -Property $Properties
            $filteredData
        } else {
            Write-Host "A propriedade 'Data' não foi encontrada na resposta JSON."
        }
    } catch {
		throw "Falha ao recuperar informacoes da camera. $_"
    }
}

Export-ModuleMember -Function 'Get-UserGroups'