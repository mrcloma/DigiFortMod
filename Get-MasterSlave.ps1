<#
.SYNOPSIS
    Funcao do modulo Empresa para consultar se o servidor e master ou slave.

.DESCRIPTION
    Funcao do modulo Empresa para consultar se o servidor e master ou slave.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a informacao seja consultada de um servidor em especifico.

.EXAMPLE
    Get-MasterSlave	-Server monitoramento4

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-MasterSlave {
	
	param (
		[parameter(Mandatory=$true)]
		[string]$Server
	)


    $caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $caminhoAuthData -Raw
    $AuthSessionID = Get-Content -Path $caminhoAuthSessionID -Raw

    $apiUrl = "http://${Server}:8601/Interface/Server/GetMasterSlaveStatus?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

    try {
        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $filteredData = $jsonData.Response.Data.Status.ServerType
			Write-Host "`nTipo do servidor: $filteredData`n"
			$slaveData = $jsonData.Response.Data.Status.SlaveConnections
			Write-Host "Servidores slave: " 
			$slaveData
        } else {
            Write-Host "Dados nao retornados."
        }
    } catch {
		throw "Falha ao recuperar informacoes. $_"
    }
}

Export-ModuleMember -Function 'Get-MasterSlave'