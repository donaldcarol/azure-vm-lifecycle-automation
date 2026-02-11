\# Assumptions \& Setup Notes



\## Azure authentication in GitHub Actions



\### Option A (Recommended): OIDC Federated Credentials

1\) Create App Registration (Entra ID)

2\) Create a federated credential for GitHub repo + branch

3\) Assign RBAC role to the service principal on subscription or RG scope

4\) Add repo secrets/vars:

&nbsp;  - AZURE\_CLIENT\_ID

&nbsp;  - AZURE\_TENANT\_ID

&nbsp;  - AZURE\_SUBSCRIPTION\_ID



No AZURE\_CLIENT\_SECRET is needed with OIDC.



\### Option B: Client Secret (less ideal)

Add secret:

\- AZURE\_CLIENT\_SECRET



---



\## VM prerequisites for patch workflow

\- Windows Update service should be functional

\- VM agent present (Azure VM Agent)

\- Run Command is supported and allowed by policy



