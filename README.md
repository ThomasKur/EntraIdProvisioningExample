# Entra ID Provisioning Example

This repository contains an example solution to deploy a complete provisioning system based on Zoho People. The solution retrieves employee data from Zoho People and synchronizes it with the Entra ID Provisioning API. While this example is tailored for Zoho People, it can be adapted for other systems.

---

## Table of Contents
1. [Prepare](#prepare)
2. [Deploy Infrastructure](#deploy-infrastructure)
3. [Connect Your HR Tool](#connect-your-hr-tool)
4. [Uninstall the Solution](#uninstall-the-solution)

---

## Prepare

Before deploying the solution, you need to set up a Provisioning API App in Entra ID. Follow the official Microsoft documentation to configure the app:

[Microsoft Documentation: Configure the Inbound Provisioning API App](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/inbound-provisioning-api-configure-app)

---

## Deploy Infrastructure

This solution deploys an Azure Function that retrieves employees from Zoho People and pushes the data to the Entra ID Provisioning API.

### Prerequisites
1. **Azure CLI**: Ensure the Azure CLI is installed and authenticated.
2. **Bicep CLI**: Ensure the Bicep CLI is installed for deploying the infrastructure.
3. **Permissions**: Ensure you have sufficient permissions to create Azure resources.

### Deployment Steps
Run the following commands to provision the solution:

```powershell
# Log in to Azure
az login --scope https://management.core.windows.net//.default 

# Create a resource group
az group create --name rg-mmseidprov-02 --location westeurope

# Deploy the infrastructure using the Bicep template
az deployment group create --resource-group rg-mmseidprov-02 --template-file deploy.bicep --parameters appName='eidprov2' provisioningAppObjectId='a38bc2ac-abcd-4895-abe7-8ad5a46f1add'
```

### Notes
- Replace `appName` and `provisioningAppObjectId` with the appropriate values for your deployment.
- The `deploy.bicep` file contains the infrastructure definition, including the Azure Function, Key Vault, and other required resources.

---

## Connect Your HR Tool

Two options exist for connecting your HR tool. If you are using Zoho People as your HR system, proceed directly to the **Configure Zoho People** section. If you are using a different HR system, follow the instructions in the **Configure Other HR Systems** section.

---

### Configure Other HR Systems

You can leverage this solution with any HR system as long as you can retrieve the data via an API. The data must be transformed into an array of objects with a flat property structure. It is recommended to store secrets securely in the provisioned Azure Key Vault.

#### Steps:
1. Replace the following lines of code in the script with your custom implementation for retrieving employee data:

    ```powershell
    # Request all employees from Zoho People API
    # This can be replaced with any other source, but it must return an array of objects with a flat property structure.
    Write-Output "Requesting all employees from Zoho People API..."
    $FormattedEmployeeObjects = Get-ZohoPeopleEmployees -ImportSince (Get-Date).AddDays(-1)
    ```

2. Adjust the mapping table object defined in the `$AttributeMapping` variable at the beginning of the script to match the structure of your HR system's data.

3. After making these changes, you are ready to execute the function for the first time.

---

### Configure Zoho People

To simplify the setup process, a separate Azure Function has been created to retrieve the Refresh Token and store all required values in the Azure Key Vault.

#### Steps:
1. Execute the `ZohoPeopleGetRefreshToken` function in the Azure Portal.
2. Submit the required information, which can be retrieved by setting up a self-client according to the [Zoho People API documentation](https://www.zoho.com/people/help/api/).
3. Specify the following scope when setting up the client: `ZOHOPEOPLE.forms.READ`.

Once this is complete, you can trigger the `ZohoPeopleProvisioning` function to verify that everything is working correctly.

---

## Uninstall the Solution

To deprovision the solution, run the following command:

```powershell
# Delete the resource group
az group delete --name rg-mmseidprov-02
```

### Additional Cleanup
- Remove the Provisioning API App created in the **Prepare** section.
- Ensure any sensitive data stored in Azure Key Vault is securely deleted.

---

## Additional Information

For more details on the implementation or to customize the solution, refer to the source code and comments in the `deploy.bicep` and `run.ps1` files.

---

## Support

If you encounter any issues or have questions, feel free to open an issue in this repository or consult the official Microsoft documentation for Entra ID and Azure Functions.