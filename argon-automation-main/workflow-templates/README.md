# Workflow Templates

This directory contains ready-to-use workflow templates organized by technology stack. These templates can be copied directly to your repository's `.github/workflows/` directory and customized as needed.

## Structure

Templates are organized into technology-specific folders:
- **`sometech/`** - Example/illustration templates showing the architectural pattern
- **`net/`** - .NET ecosystem templates (C#, SQL Server, SSIS/SSRS)
- **`java/`** - Java application templates
- **`node/`** - Node.js/npm application templates

## Usage

1. Browse the appropriate technology folder
2. Copy the desired template to your repository's `.github/workflows/` directory
3. Customize the inputs and triggers as needed
4. Ensure your repository has the required secrets configured

---

## [`.\sometech\sometech-build-and-deploy-to-sometarget.yaml`](.\sometech\sometech-build-and-deploy-to-sometarget.yaml) - Example Technology Build and Deploy Template
**Note: "sometech" is used for illustration purposes only** - This template demonstrates the three-tier architecture pattern used throughout this repository.

- Entry point template that calls the reusable workflow
- Configurable deployment targets and build parameters
- Shows the proper structure for workflow templates
- Demonstrates integration with the hierarchical composite actions

### How to Use:
1. Copy this template as a starting point
2. Replace "sometech" with your actual technology name
3. Update the reusable workflow reference to match your technology
4. Customize inputs and triggers for your needs

---

## [`.\net\dotnet-build-and-deploy.yaml`](.\net\dotnet-build-and-deploy.yaml) - Builds and deploys a .NET application:
- Installs tools
- Builds a DOTNET application
- Run unit tests
- Runs SCA & SAST scans
- Deploys the application to a target via SSH
- Runs smoke tests
- Runs integration tests

### Inputs:
- dotnetVersion
- buildConfiguration
- projectPath
- publishRuntime
- remoteUser
- remotePath
- webAppDirectory
- appExecutableName
- appPort
- useSystemd
- serviceName

### Secrets Required Per Environment:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
- SSH_PRIVATE_KEY
- REMOTE_HOST
<br>
<br>
___

## [`.\java\java-build-and-deploy.yaml`](.\java\java-build-and-deploy.yaml) - Builds and deploys a Java application:
- Installs tools
- Builds a Java application
- Run unit tests
- Runs SCA & SAST scans
- Deploys the application to a target via SSH
- Runs smoke tests
- Runs integration tests

### Inputs:
- jdkVersion
- javaDistribution
- remoteUser
- remotePath
- webAppDirectory
- artifactJarName

### Secrets Required Per Environment:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
- SSH_PRIVATE_KEY
- REMOTE_HOST
<br>
<br>
___

## [`.\node\npm-node-build-and-deploy.yaml`](.\node\npm-node-build-and-deploy.yaml) - Builds and deploys a Node.js application:
- Installs tools
- Builds a Node.js application
- Run unit tests
- Runs SCA & SAST scans
- Deploys the application to a target via SSH
- Runs smoke tests
- Runs integration tests

### Inputs:
- nodeVersion
- packageManager
- buildScript
- startScript
- remoteUser
- remotePath
- webAppDirectory

### Secrets Required Per Environment:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
- SSH_PRIVATE_KEY
- REMOTE_HOST
<br>
<br>
___

## [`.\sql-build-and-deploy.yaml`](.\sql-build-and-deploy.yaml) - Builds and deploys a SQL application:
- Installs tools
- Builds a SQL application
- Run unit tests
- Runs SCA & SAST scans
- Deploys the application to a target via SSH
- Runs smoke tests
- Runs integration tests

### Inputs:
- sqlVersion
- remoteUser
- remotePath
- webAppDirectory

### Secrets Required Per Environment:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
- SSH_PRIVATE_KEY
- REMOTE_HOST
<br>
<br>
___

## [`.\ssis-ssrs-build-and-deploy.yaml`](.\ssis-ssrs-build-and-deploy.yaml) - Builds and deploys an SSIS/SSRS application:
- Installs tools
- Builds an SSIS/SSRS application
- Run unit tests
- Runs SCA & SAST scans
- Deploys the application to a target via SSH
- Runs smoke tests
- Runs integration tests

### Inputs:
- remoteUser
- remoteHost
- remotePath
- webAppDirectory

### Secrets Required Per Environment:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
- SSH_PRIVATE_KEY
- REMOTE_HOST
<br>
<br>
___