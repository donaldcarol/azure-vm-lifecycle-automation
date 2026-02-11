
# Azure VM Lifecycle Automation with GitHub Actions

![VM Power](https://github.com/donaldcarol/azure-vm-lifecycle-automation/actions/workflows/vm-power.yaml/badge.svg)
![VM Snapshot](https://github.com/donaldcarol/azure-vm-lifecycle-automation/actions/workflows/vm-snapshot.yaml/badge.svg)
![VM Patch](https://github.com/donaldcarol/azure-vm-lifecycle-automation/actions/workflows/vm-patch-windows.yaml/badge.svg)



Small, production-inspired demo repository that shows how to automate common Azure VM operations using GitHub Actions:
- Start/Stop/Restart/Deallocate VMs
- OS disk snapshots with retention cleanup
- Windows patching (report / install) via Azure Run Command

This repo is designed as a clean "portfolio-style" example: safe execution patterns, auditable logs, tag-based targeting, and no hardcoded credentials.

---

## Key Features

- **OIDC auth** via `azure/login` (recommended). No secrets required when federated credentials are configured.
- **Dry-run** support for power actions (safe preview).
- **Tag-based targeting** for patch operations.
- **Snapshot retention** cleanup based on creation timestamp.
- **Audit-friendly logs** (prints commands and structured output).

---

## Workflows

### 1) VM Power Operations
File: `.github/workflows/vm-power.yaml`

Trigger: `workflow_dispatch`

Inputs:
- `action`: start | stop | restart | deallocate
- `vms`: comma-separated list `rg/vm,rg/vm`
- `dry_run`: true/false

### 2) VM Snapshot + Retention
File: `.github/workflows/vm-snapshot.yaml`

Trigger: `workflow_dispatch`

Inputs:
- `vms`: comma-separated list `rg/vm,rg/vm`
- `retain_days`: number (default 14)

### 3) Windows Patch via Run Command
File: `.github/workflows/vm-patch-windows.yaml`

Trigger: `workflow_dispatch`

Inputs:
- `target_rg`: resource group where VMs live
- `tag_name`, `tag_value`: only VMs matching `tag_name=tag_value`
- `do_install`: true/false

---

## Security Model

### Recommended: OIDC Federated Credentials
Use GitHub OIDC to authenticate to Azure without storing secrets.

**Minimum permissions in workflow**:
- `permissions: id-token: write`
- `permissions: contents: read`

See `docs/assumptions.md` for setup notes.

---

## Quick Start (Demo)

1) Configure Azure auth (OIDC preferred)
2) Go to GitHub → Actions → select a workflow → Run workflow
3) Provide inputs, e.g.
   - `action=deallocate`
   - `vms=rg-demo/vm-app01,rg-demo/vm-db01`
   - `dry_run=true`

---

## Notes & Best Practices

- Prefer **deallocate** over stop when cost matters.
- Use **tags** for controlled patch rings (e.g., `PatchGroup=Nightly`).
- Keep workflows **idempotent** where possible.
- Always add a **dry-run** option when actions are disruptive.

---

## Repository Purpose

This repository is intended as a demonstration of automation patterns and operational thinking for Azure VM administration using GitHub Actions.

