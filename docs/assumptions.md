# Assumptions & Setup Notes

## Azure Authentication

This repository currently demonstrates authentication using an Azure Service Principal via a GitHub secret (`AZURE_CREDENTIALS`).

The expected secret format:

```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "..."
}
