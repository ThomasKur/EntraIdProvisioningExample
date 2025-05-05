using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Log the start of the function execution
Write-Output "Starting the process to request a refresh token at: $(Get-Date)"

# Authenticate with Azure using managed identity
Connect-AzAccount -Identity -AccountId $env:AZURE_CLIENT_ID
Write-Output "Authenticated with Azure using managed identity."


# Extract the grant code from the request (query or body)
$GrantCode = $Request.Body.GrantCode
if($GrantCode) {
    Write-Output "Grant code retrieved from the request."
} else {
    Write-Output "Grant code not found in the request. Exiting."
    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body       = "Grant code not found in the request. Request should look like this: { GrantCode: 'grant_code', ClientId: 'client_id', ClientSecret: 'client_secret', ZohoAccountUrl: 'https://accounts.zoho.eu', ZohoPeopleUrl: 'https://people.zoho.eu' }"
    })
    return
}

# Extract the ClientId from the request (query or body)
$ClientId = $Request.Body.ClientId
if($ClientId) {
    Write-Output "ClientId code retrieved from the request."
} else {
    Write-Output "ClientId code not found in the request. Exiting."
    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body       = "ClientId not found in the request. Request should look like this: { GrantCode: 'grant_code', ClientId: 'client_id', ClientSecret: 'client_secret', ZohoAccountUrl: 'https://accounts.zoho.eu', ZohoPeopleUrl: 'https://people.zoho.eu' }"
    })
    return
}

# Extract the Client Secret from the request (query or body)
$ClientSecret = $Request.Body.ClientSecret
if($ClientSecret) {
    Write-Output "ClientSecret code retrieved from the request."
} else {
    Write-Output "ClientSecret code not found in the request. Exiting."
    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body       = "ClientSecret not found in the request. Request should look like this: { GrantCode: 'grant_code', ClientId: 'client_id', ClientSecret: 'client_secret', ZohoAccountUrl: 'https://accounts.zoho.eu', ZohoPeopleUrl: 'https://people.zoho.eu' }"
    })
    return
}
# Extract the ZohoAccountUrl from the request (query or body)
$ZohoAccountUrl = $Request.Body.ZohoAccountUrl
if($ZohoAccountUrl) {
    Write-Output "ZohoAccountUrl code retrieved from the request."
} else {
    Write-Output "ZohoAccountUrl code not found in the request. Using default 'https://accounts.zoho.eu'."
    $ZohoAccountUrl = "https://accounts.zoho.eu"
}
# Extract the ZohoPeopleUrl from the request (query or body)
$ZohoPeopleApiUrl = $Request.Body.ZohoPeopleUrl
if($ZohoPeopleApiUrl) {
    Write-Output "ZohoPeopleUrl code retrieved from the request."
} else {
    Write-Output "ZohoPeopleUrl code not found in the request. Using default 'https://people.zoho.eu'."
    $ZohoPeopleApiUrl = "https://people.zoho.eu"
}



# Prepare the body for the token request
$body = @{
    client_id     = $ClientId
    client_secret = $ClientSecret
    grant_type    = "authorization_code"
    code          = $GrantCode
}
Write-Output "Prepared the request body for the refresh token request."

# Request the refresh token from Zoho
$refreshToken = Invoke-RestMethod -Uri "$ZohoAccountUrl/oauth/v2/token" -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body
Write-Output "Successfully requested the refresh token from Zoho."

# Store the refresh token in Azure Key Vault for future use
$RefreshTokenSecret = ConvertTo-SecureString -String $refreshToken.refresh_token -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleRefreshToken" -SecretValue $RefreshTokenSecret
Write-Output "Stored the refresh token in Azure Key Vault for future use."

# Store the Client ID in Azure Key Vault for future use
$ClientIdSecret = ConvertTo-SecureString -String $ClientId -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleClientId" -SecretValue $ClientIdSecret
Write-Output "Stored the Client ID in Azure Key Vault for future use."

#Store the Client Secret in Azure Key Vault for future use
$ClientSecretSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleClientSecret" -SecretValue $ClientSecretSecret
Write-Output "Stored the Client Secret in Azure Key Vault for future use."

# Store the ZohoAccountUrl in Azure Key Vault for future use
$ZohoAccountUrlSecret = ConvertTo-SecureString -String $ZohoAccountUrl -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleAccountUrl" -SecretValue $ZohoAccountUrlSecret
Write-Output "Stored the ZohoAccountUrl in Azure Key Vault for future use."

# Store the ZohoPeopleApiUrl in Azure Key Vault for future use
$ZohoPeopleApiUrlSecret = ConvertTo-SecureString -String $ZohoPeopleApiUrl -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleApiUrl" -SecretValue $ZohoPeopleApiUrlSecret
Write-Output "Stored the ZohoPeopleApiUrl in Azure Key Vault for future use."

# Log the end of the function execution
Write-Output "Process to request and store the refresh token completed at: $(Get-Date)"
if ($refreshToken.refresh_token) {
    $body = "Refresh token successfully retrieved and stored."
    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })
} else {
    $body = "Failed to retrieve the refresh token."
    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body       = $body
    })
}

