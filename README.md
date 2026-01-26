# Argon Automation

This repository contains reusable GitHub Actions workflows, composite actions, workflow templates, and automation utilities for the Argon project ecosystem.

[![Board Status](https://dev.azure.com/clavanade/96ecd287-0464-41ef-8011-7ed7e9a8ff79/49e978c5-2323-4f06-9b28-715ec398db72/_apis/work/boardbadge/a6aaef87-8f98-42cf-a95d-c2402ab044d4)](https://dev.azure.com/clavanade/96ecd287-0464-41ef-8011-7ed7e9a8ff79/_boards/board/t/49e978c5-2323-4f06-9b28-715ec398db72/Stories/)
[![Fortify Scan Verification](https://github.com/ava-client-ussouth-scg-argon/argon-automation/actions/workflows/verify-fortify-scans.yaml/badge.svg)](https://github.com/ava-client-ussouth-scg-argon/argon-automation/actions/workflows/verify-fortify-scans.yaml)

## 📁 Repository Structure

```
argon-automation/
├── .github/
│   └── workflows/           # Reusable workflows (rw-*) and required workflows (reqwf-*)
├── composites/             # Composite actions organized by technology
│   ├── common/             # Common utility actions
│   ├── dotnet/             # .NET applications
│   ├── java/               # Java applications  
│   ├── npm-node/           # Node.js/NPM applications
│   ├── sometech/           # SomeTech applications
│   ├── sql/                # SQL Server databases
│   └── ssis-ssrs/          # SSIS/SSRS packages
├── docs/
│   └── mermaid/            # Mermaid diagram documentation
├── utilities/              # PowerShell utility scripts
└── workflow-templates/     # GitHub workflow templates for end users
    ├── java/
    ├── net/                # .NET, SQL, SSIS/SSRS templates
    ├── node/
    └── sometech/
```

## 🏗️ Architecture Overview

This repository follows a three-tier architecture for maximum reusability and maintainability:

### 1. Composite Actions (`composites/`)
**Purpose**: Encapsulate reusable steps and logic
- Self-contained actions that perform specific tasks (build, scan, deploy)
- Can be used directly in workflows or called by other composite actions
- Located in: `composites/{tech-name}-{action-type}/`

### 2. Reusable Workflows (`.github/workflows/rw-*` and `reqwf-*`)
**Purpose**: Orchestrate composite actions into complete workflows
- **Reusable workflows (`rw-*`)**: Call multiple composite actions in sequence
- **Required workflows (`reqwf-*`)**: Enforce security and compliance checks
- Handle job dependencies and environment configurations
- Can only be called by other workflows (no direct execution)

### 3. Workflow Templates (`workflow-templates/`)
**Purpose**: Provide ready-to-use workflow templates for end users
- Entry points that can be copied to other repositories
- Include triggers for manual and automatic execution
- Call reusable workflows to perform the actual work

## 🎯 How It Works

### Example Flow:
1. **Developer** copies a template from `workflow-templates/`
2. **Template** calls a reusable workflow from `.github/workflows/rw-*`
3. **Required workflows** (`reqwf-*`) enforce security and compliance
4. **Reusable workflow** orchestrates multiple composite actions from `composites/`
5. **Composite actions** perform the actual build, scan, and deploy operations

### Example:
```yaml
# workflow-templates/sometech/sometech-build-and-deploy-to-sometarget.yaml
jobs:
  pipeline:
    uses: ./.github/workflows/rw-sometech-build-and-deploy-to-sometarget.yaml
    
# .github/workflows/rw-sometech-build-and-deploy-to-sometarget.yaml  
jobs:
  build:
    steps:
      - uses: ./composites/sometech/build
  deploy:
    steps:
      - uses: ./composites/sometech/deploy
```

## 📝 Naming Conventions

### Technology Organization
Components are organized by technology stack in dedicated folders:

- **`dotnet/`**: Components for .NET applications and IIS deployments
- **`java/`**: Components for Java applications
- **`npm-node/`**: Components for Node.js/NPM applications
- **`sometech/`**: Components for SomeTech applications
- **`sql/`**: Components for SQL Server database deployments
- **`ssis-ssrs/`**: Components for SQL Server Integration Services and Reporting Services
- **`common/`**: Shared utility components used across technologies

### File Naming Patterns

| Type | Pattern | Example | Purpose |
|------|---------|---------|---------|
| Composite Actions | `{tech}/{action}/action.yaml` | `sometech/build/action.yaml` | Technology-specific actions |
| Reusable Workflows | `rw-{tech}-{purpose}.yaml` | `rw-sometech-build-and-deploy-to-sometarget.yaml` | Reusable workflow components |
| Required Workflows | `reqwf-{purpose}.yaml` | `reqwf-check-env-protection.yaml` | Compliance and security enforcement |
| Workflow Templates | `{tech}-{purpose}.yaml` | `sometech-build-and-deploy-to-sometarget.yaml` | User-facing templates |

## 🚀 Usage Guide

### For End Users (Consuming Templates)

1. **Browse** available templates in `workflow-templates/`:
   - `.NET applications` → `workflow-templates/net/`
   - `Java applications` → `workflow-templates/java/`
   - `Node.js applications` → `workflow-templates/node/`
   - `SomeTech applications` → `workflow-templates/sometech/`
2. **Copy** the desired template to your repository's `.github/workflows/`
3. **Customize** inputs and triggers as needed
4. **Configure** required GitHub secrets and environment protection rules
5. **Commit** and push to trigger the workflow

### For Contributors (Adding New Components)

#### Adding a New Technology:

1. **Create composite actions**: `composites/{tech}/{action}/action.yaml`
2. **Create reusable workflow**: `.github/workflows/rw-{tech}-{purpose}.yaml`
3. **Create template folder**: `workflow-templates/{tech}/`
4. **Create template**: `workflow-templates/{tech}/{tech}-{purpose}.yaml`
5. **Follow naming conventions** and ensure proper documentation

#### Example Structure for "NewTech":
```
composites/
└── newtech/
    ├── build/action.yaml
    └── deploy/action.yaml

.github/workflows/
└── rw-newtech-build-and-deploy.yaml

workflow-templates/
└── newtech/
    └── newtech-build-and-deploy.yaml
```

## �️ Security and Compliance

### Required Workflows (`reqwf-*`)
The repository includes required workflows that enforce security and compliance:

- **`reqwf-check-env-protection.yaml`**: Validates GitHub environment protection rules
- **`reqwf-check-branch-ruleset.yaml`**: Ensures proper branch protection policies
- **`verify-fortify-scans.yaml`**: Verifies security scan compliance

These workflows run automatically and cannot be bypassed, ensuring all deployments meet security and compliance requirements.

## �🔄 Workflow Dependencies

### Current Technology Support:

#### .NET Applications (`dotnet/`)
- **Build**: Restores dependencies, builds applications, runs unit tests
- **Deploy**: IIS deployment with health checks and rollback capabilities

#### Java Applications (`java/`)
- **Build**: Maven/Gradle build with testing and artifact generation
- **Deploy**: Application server deployment with validation

#### Node.js Applications (`npm-node/`)
- **Build**: NPM install, build, and test execution
- **Deploy**: Node.js application deployment and process management

#### SomeTech Applications (`sometech/`)
- **Build**: SomeTech-specific build process with integrated scanning
- **Deploy**: Multi-environment deployment to SomeTarget platforms

#### SQL Server (`sql/`)
- **Build**: Database schema validation and package creation
- **Deploy**: Database deployment with backup and rollback

#### SSIS/SSRS (`ssis-ssrs/`)
- **Build**: Integration Services and Reporting Services package validation
- **Deploy**: SSIS/SSRS deployment to SQL Server instances

#### Common Utilities (`common/`)
- **Environment Protection**: Validates GitHub environment protection rules
- **Security Scans**: Integrated Fortify SAST and SCA scanning
- **Artifact Management**: Stage, archive, and publish build artifacts

### Composite Action Relationships:
- All build actions integrate security scanning through `common/security-scans`
- Environment protection is enforced via `common/check-environment-protection`
- Artifact management handled by `common/stage-archive-publish`
- All composite actions are self-contained with proper error handling
- Environment-specific configurations handled at the workflow level

## 🛠️ Development Guidelines

### Best Practices:
1. **Follow naming conventions** consistently
2. **Use semantic versioning** for releases
3. **Document all inputs/outputs** in action.yaml files
4. **Test workflows** before merging
5. **Keep actions focused** on single responsibilities

### Testing:
- Templates can be tested by copying to test repositories
- Reusable workflows are tested through template execution
- Composite actions should include validation and error handling

## � Additional Repository Components

### Utilities (`utilities/`)
PowerShell utility scripts to support automation development and maintenance:

- **PowerShell Scripts** (`powershell-scripts/`):
  - **GHE Tools** (`ghe/`): GitHub Enterprise management utilities
  - **Git Tools** (`git/`): Repository creation, migration, and version tagging scripts
  - **Mermaid Tools** (`mermaid/`): Diagram generation and batch processing
  - **SQL Tools** (`sql/`): Database snapshot and restore utilities

### Documentation (`docs/`)
Technical documentation and visual diagrams:

- **Mermaid Diagrams** (`mermaid/`): Visual workflow and process documentation
  - Build process flowcharts and sequence diagrams
  - Deployment process visualization
  - Workflow step details and relationships

## �📋 Standard Operating Procedures

### 🔧 Management and Administration
- In accordance with Technology Security's System Component Management Requirement for Component Owner Responsibility, enforcement of strong branch and repository protection policies (see `AGILE.md` Core Competencies) will prevent any security or quality automation from being disabled. 

- Credentials for all service principals maintained by Environment Management will be stored in CyberArk to combat administrator accounts from sharing the same passwords as general user accounts as defined in Enterprise Account and Administration Requirement Administrator Accounts guideline. Where technically feasible, administrative account management must be automated, with scheduled rotation, through a Credential Vault and supports key Process Maturity Items for organizations that adopt a culture of DevOps.

- Automation that adheres to the concepts outlined in `AGILE.md` will validate that an approved Remedy/SmartIT Change Request ticket prior to proceeding to a production deployment in accordance to the Technology Change Management Requirement. Additionally, automation should give a warning for any non-production deployment when no approved change record exists.

### 🛡️ Security
- In accordance with DSS's Governance Over Production (Secure Coding Guidelines) and their Vulnerability and Patch Management Guideline, application builds cannot proceed to production if flagged with critical or high findings from Fortify or SonarQube. 

  - By enforcing Peer Reviews on all code additions (as outlined in our `AGILE.md` Core Competencies), these scans are automated and integrated into the process. New code cannot be merged without resolving these findings. This enforcement also aligns with the Technology Application Security Requirement for Security Pre-Deployment Testing. Prior to any Pull Request being approved, post compile static scans, compositional scans, and post deployment dynamic scan security tests must successfully pass. 

  - Through adoption of Trunk-Based Development (see `AGILE.md` Core Competencies), Peer Reviews are a continuous process that ensures Production releases are validated with scans completed within the past 30 days. Additionally, no workflow should contain a scan that is older than 29 days if Peer Review is properly enforced by application teams. However, if no active Peer Reviews occur for a repository over a one-week period, a weekly CRON job will automatically trigger builds with integrated scans to meet the weekly build requirement.

  - Enforcement of Peer Reviews will prevent an artifact that does not meet security requirements from ever reaching production and will meet ADM's Certification process for production releases in accordance to the requirement of Fortify Software Code Scanning on CI/CD Pipelines.

- All workflows will execute under the Runner's Account context that is set through GitHub's Enterprise's Repository settings, thus meeting DSS's SCS Technology Security Standard in accordance to the Users who access Company Networks standard. Utilizing required workflows in alignment with the ideals of Continual Deployment (see `AGILE.md` Process Maturity Items) that will continually scan for attempts to elevate user permissions will prevent any attempt to circumvent security controls to gain access to user accounts, technology, or systems.

  - All workflows will be executed under the context of this Runner Account and will be uniquely identifiable prior to accessing any confidential business information in accordance to the Secure Access and Authentication Requirement for Identification and Authentication.

### 🔒 Authentication and Password Management
- All connectivity from GitHub and Azure DevOps to network connected resources will be managed by service principals with credentials from Active Directory to meet the guidelines definitions of the Company Approved Authentication Solutions standard.
  
  - Additionally, automation that follows the concepts outlined in `AGILE.md` will not allow for unsupported authentication methods, meeting the Technology Application Security Requirement for Authentication.

- In accordance to DSS's Password Expiration, History, and Lockouts as part of their Enterprise Account and Administration Requirement, any service principals created and maintained by the Environment Management team will adhere to these requirements for passwords:
  
  - Password history (re-use) shall be set to thirteen; passwords cannot be reused until the fourteenth password change.  

  - Human account passwords with less than sixteen characters must expire every 45 days.  

  - Human account passwords with sixteen or more characters must expire every 365 days.  

  - Systems shall warn users within ten days of their password expiration dates, if possible.  

  - Human accounts shall be locked out after no more than ten consecutive failed logon attempts and remain locked for a minimum of 10 minutes or until reset by the Technology Organization.  

  - Unless otherwise prescribed in Company requirements, all passwords must be changed after suspected exposure, if directed by Technology Security, if mandated by other regulatory requirements, or after five years have passed.

- All service accounts managed and maintained by the Environment Management team will follow the Network Complex Password Construction guidelines as noted in DSS's Password Construction and Protection Requirement. Passwords will consider the following:

  - Passwords must be at least sixteen characters in length, where technically feasible.

  - Passwords may have low complexity but must not be guessable, as noted in section 1 above.  

  - Regulatory requirements (e.g., NERC CIP, NRC, etc.) may require increased complexity in certain circumstances.

  - Passwords with fewer than sixteen characters must be at least eight characters long, and contain characters from three of the following classes:  

    - English uppercase letters: A, B, C … Z

    - English lowercase letters: a, b, c … z

    - Westernized numerals: 0, 1, 2, … 9

    - Special Characters: ˜!@#$%^&*_-+=`|\(){}[]:;"'<>,.?/

    - Unicode Characters which include characters from Asian languages

    - Other non-typeable ASCII symbols

---

For questions or contributions, please refer to the project documentation or create an issue in this repository.