$ErrorActionPreference = "Stop"

$projectId = "6506278782152367391"

$screenIds = @(
    "831e9c8aae864bd7b04a4f0b0c72694f",
    "c3eec56fbd9842819dee1be32cb63bec",
    "efc80a0a393a446d855e396743ff2200"
)

$root = Join-Path $PWD "stitch-reference"

foreach ($screenId in $screenIds) {

    Write-Host ""
    Write-Host "===================================="
    Write-Host "Exporting $screenId"
    Write-Host "===================================="

    $folder = Join-Path $root "fallback_$screenId"
    New-Item -ItemType Directory -Force $folder | Out-Null

    $requestFile = Join-Path $folder "request.json"

    $request = @{
        projectId = $projectId
        screenId  = $screenId
    } | ConvertTo-Json -Compress

    [System.IO.File]::WriteAllText(
        $requestFile,
        $request,
        [System.Text.UTF8Encoding]::new($false)
    )

    # HTML
    try {
        $htmlResult = npx @_davideast/stitch-mcp tool get_screen_code -f $requestFile |
            Out-String |
            ConvertFrom-Json

        if ($htmlResult.htmlContent) {
            [System.IO.File]::WriteAllText(
                (Join-Path $folder "design.html"),
                $htmlResult.htmlContent,
                [System.Text.UTF8Encoding]::new($false)
            )

            Write-Host "HTML OK"
        }
        else {
            Write-Warning "No htmlContent returned"
        }
    }
    catch {
        Write-Warning "HTML FAILED: $($_.Exception.Message)"
    }

    # Screenshot
    try {
        $imgResult = npx @_davideast/stitch-mcp tool get_screen_image -f $requestFile |
            Out-String |
            ConvertFrom-Json

        if ($imgResult.imageContent) {

            $imageData = $imgResult.imageContent

            if ($imageData -match '^data:image\/[^;]+;base64,') {
                $imageData = $imageData -replace '^data:image\/[^;]+;base64,', ''
            }

            [System.IO.File]::WriteAllBytes(
                (Join-Path $folder "screenshot.png"),
                [Convert]::FromBase64String($imageData)
            )

            Write-Host "IMAGE OK"
        }
        else {
            Write-Warning "No imageContent returned"
        }
    }
    catch {
        Write-Warning "IMAGE FAILED: $($_.Exception.Message)"
    }
}

Write-Host ""
Write-Host "Fallback export complete."