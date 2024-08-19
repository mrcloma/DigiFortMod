<#
.SYNOPSIS
    Funcao do modulo Empresa para listar os usuarios de um servidor Digifort.

.DESCRIPTION
    Funcao do modulo Empresa para listar os usuarios de um servidor Digifort.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a listagem dos usuarios venha de um servidor em especifico.

.EXAMPLE
    Get-UserList -Server monitoramento4

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-UserList {

	param (
	[parameter(Mandatory=$true)]
    [string]$Server)

    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Users/GetUsers?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Users.Name
			Write-Host "`nUsuarios:"
            $filteredData
        } else {
            Write-Host "A propriedade 'Data' não foi encontrada na resposta JSON."
        }
    } catch {
		throw "Falha ao recuperar informacoes da camera. $_"
    }
}

Export-ModuleMember -Function 'Get-UserList'
