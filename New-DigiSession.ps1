function Get-MD5Hash($inputString) {
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $hash = [System.BitConverter]::ToString($md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($inputString)))
    $hash -replace '-',''
}

function Get-AuthInfoFromAPI($apiEndpoint) {
    $webClient = New-Object System.Net.WebClient
    $response = $webClient.DownloadString($apiEndpoint)

    $jsonResponse = $response | ConvertFrom-Json

    $authInfo = [PSCustomObject]@{
        NOnce = $jsonResponse.Response.Data.Session.NOnce
        ID = $jsonResponse.Response.Data.Session.ID
    }

    return $authInfo
}

<#
.SYNOPSIS
    Funcao do modulo Empresa para abrir uma nova sessao com um servidor Digifort.

.DESCRIPTION
    Funcao do modulo Empresa para abrir uma nova sessao com um servidor Digifort. Possui duas funcoes auxiliares no arquivo da funcao com a finalidade de implementar a seguranca na autenticacao.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a sessao seja aberta em um servidor em especifico.

.EXAMPLE
    New-Digisession -Server monitoramento3

.NOTES
    Esta funcao deve preceder qualquer outro comando que se relacione ao Digifort. Segundo a documentacao da API a sessao deve permanecer ativa por apenas 60 segundos se renovando o periodo em caso de alguma atividade ou comando disparado.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function New-Digisession {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server
    )

    process {
		
        $user = "USER"
        $pass = "PASSW0RD"
		
		try {
			$apiEndpoint = "http://${Server}:8601/Interface/CreateAuthSession?ResponseFormat=JSON"
	
			$authInfo = Invoke-RestMethod -Uri $apiEndpoint -Method Get -ContentType "application/json"

			$nonce = $authInfo.Response.Data.Session.NOnce
			$authSessionID = $authInfo.Response.Data.Session.ID
	
			$hashedPass = Get-MD5Hash $pass

			$AuthData = Get-MD5Hash "${nonce}:${user}:${hashedPass}"

			$caminhoAuthSessionID = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"
			$caminhoAuthData = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"

			$authSessionID | Out-File -FilePath $caminhoAuthSessionID -Encoding UTF8
			$AuthData | Out-File -FilePath $caminhoAuthData -Encoding UTF8
		}
        catch {
            Write-Error "Erro ao obter informacoes de autenticacao: $_"
        }
    }
}

Export-ModuleMember -Function 'New-Digisession'