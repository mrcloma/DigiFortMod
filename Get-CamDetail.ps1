<#
.SYNOPSIS
    Funcao do modulo Empresa para listar os detalhes de uma camera de um servidor Digifort.

.DESCRIPTION
    Funcao do modulo Empresa para listar os detalhes de uma camera de um servidor Digifort.

.PARAMETER Server
    E necessario indicar o parametro -Server para que a listagem das cameras venha de um servidor em especifico.
	
.PARAMETER Camera
    E necessario indicar o parametro -Camera para que os detalhes da camera indicada venha de um servidor em especifico.

.EXAMPLE
    Get-CamDetail -Server monitoramento4 -Camera CAM004

.NOTES
    A funcao deve ser executada apos a abertura de sessao com o servidor.

.LINK
    Nao ha Links para documentacao relacionada ou recursos adicionais. Solicitar ao mantenedor em caso de necessidade a documentacao da API Digifort.

#>
function Get-CamDetail {
    param (
        [parameter(Mandatory=$true)]
        [string]$Server,
        [parameter(Mandatory=$true)]
        [string]$Camera
    )

    if (-not $Camera) {
        throw "O parametro '-Camera' e obrigatorio. Forneça um nome de camera valido."
    }
    $AuthDataPath = "C:\Users\marcelod.lima\Downloads\empresa\AuthData.txt"
    $AuthSessionIDPath = "C:\Users\marcelod.lima\Downloads\empresa\AuthSessionID.txt"

    $AuthData = Get-Content -Path $AuthDataPath -Raw
    $AuthSessionID = Get-Content -Path $AuthSessionIDPath -Raw

    $apiUrl = "http://${Server}:8601/Interface/Cameras/GetCameras?AuthSession=$AuthSessionID&AuthData=$AuthData&ResponseFormat=JSON"

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get | ConvertTo-Json -Depth 5

        $jsonData = $response | ConvertFrom-Json -ErrorAction Stop

        if ($jsonData.Response) {
            $cameraData = $jsonData.Response.Data.Cameras | Where-Object { $_.Name -eq $Camera }

            if ($cameraData) {
                $cameraData
            } else {
                Write-Host "Camera com o nome '$Camera' nao encontrada."
            }
        } else {
            Write-Host "A propriedade 'Data' não foi encontrada na resposta JSON."
        }
    } catch {
        throw "Falha ao recuperar informacoes da câmera. $_"
    }
}

Export-ModuleMember -Function 'Get-CamDetail'
