# Security Policy / Notes

## Do not commit secrets
Never commit:
- subscription IDs used in production
- service principal secrets
- tenant-specific internal names
- IPs, usernames, or anything that looks like credentials

## Recommended Authentication
Use GitHub Actions OIDC with Azure federated credentials:
- no client secret stored in GitHub
- short-lived tokens
- better audit trail

## Least privilege
Assign minimal RBAC:
- for power operations: `Microsoft.Compute/virtualMachines/*` as needed
- for snapshots: `Microsoft.Compute/snapshots/*`
- for Run Command: `Microsoft.Compute/virtualMachines/runCommand/action`

## Logging
Workflows intentionally print commands for auditability.
If your environment treats VM names / RG names as sensitive, reduce logging.
