param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(
        "health", "list_tasks", "add_task", "update_task", "set_task_status",
        "delete_task", "list_sessions", "set_session_status",
        "generate_study_plan", "replan_missed_sessions"
    )]
    [string]$Action,

    [string]$Json = "{}",
    [string]$BaseUrl = $env:PLANOVA_API_URL
)

if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
    throw "Set PLANOVA_API_URL to the deployed Jac server URL, or pass -BaseUrl explicitly."
}

$parsedBaseUrl = $null
if (-not [Uri]::TryCreate($BaseUrl, [UriKind]::Absolute, [ref]$parsedBaseUrl) -or
    $parsedBaseUrl.Scheme -notin @("http", "https")) {
    throw "BaseUrl must be an absolute HTTP or HTTPS URL."
}

$payload = ConvertFrom-Json -InputObject $Json
$body = ConvertTo-Json -InputObject $payload -Depth 20
$uri = "{0}/walker/{1}" -f $BaseUrl.TrimEnd("/"), $Action

try {
    $response = Invoke-RestMethod -Method Post -Uri $uri `
        -ContentType "application/json" -Body $body
    $response | ConvertTo-Json -Depth 20
} catch {
    Write-Error ("Planova API request failed: {0}" -f $_.Exception.Message)
    exit 1
}
