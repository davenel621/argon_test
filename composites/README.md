## [`.\common\download-dearchive-move-artifacts\action.yaml`](.\common\download-dearchive-move-artifacts\action.yaml) - Download, de-archive and move artifacts:
- Download build artifacts
- De-archive build artifacts
- Place build artifacts to "app" and "tests" directories on runner

### Inputs:

<br>
<br>
___


## [`.\common\mock-security-scans\action.yaml`](.\common\mock-security-scans\action.yaml) - Mock security scans for demonstration:
- Runs mock static analysis scan
- Runs mock dependency vulnerability scan
- Provides security scan summary output

### Inputs:
- message-one
- message-two
<br>
<br>
___

## [`.\common\security-scans\action.yaml`](.\common\security-scans\action.yaml) - Run Fortify and SonarQube scans:
- Runs Fortify SCA scan
- Runs Fortify SAST scan
- Runs SonarQube scan
- Runs SonarQube quality gate check

### Inputs:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
<br>
<br>
___

## [`.\common\stage-archive-publish\action.yaml`](.\common\stage-archive-publish\action.yaml) - Stage, archive and publish build artifacts:
- Stage artifacts from build directory to drop directory
- Archive artifacts into compressed zip file
- Upload build artifacts for use in other jobs

<br>
<br>
___

## [`.\dotnet\build\action.yaml`](.\dotnet\build\action.yaml) - Builds and scans a .NET application:
- Install .NET tools
- Run SCA Test
- Run SAST Test
- Restore .NET Dependencies
- Build .NET application
- Run unit tests
- Stage, archive, and publish artifacts

### Inputs:
- dotnetVersion
<br>
<br>
___

## [`.\dotnet\deploy\action.yaml`](.\dotnet\deploy\action.yaml) - Deploys a .NET application:
- Install .NET tools
- Setup SSH Key
- Download and de-archive artifacts
- Make .NET application Executable
- Create systemd Service File
- Stop Existing .NET Application
- Start .NET Application
- Check Application Status
- Run Health Check
- Run Smoke Tests
- Run .NET Mock Tests (dev)
- Run .NET E2E Tests (Environments higher than Dev)
- Display Application Logs

### Inputs:
- dotnetVersion
- environment
<br>
<br>
___

## [`.\dotnet\test\action.yaml`](.\dotnet\test\action.yaml) - Orchestrates the tests for a .NET application:
- Finds the File Name for Test DLL (if running against build artifact)
- Runs "All", "Unit", "Mock", or "E2E" tests based on the "testType" input

### Inputs:
- workingDirectory
- runAgainstBuildArtifact
- testType
<br>
<br>
___

## [`.\java\build\action.yaml`](.\java\build\action.yaml) - Builds and scans a Java application:
- Install Java tools and setup cache
- Build Java application via Gradle
- Run unit tests
- Run security scans
- Stage, archive, and publish artifacts

### Inputs:
- jdkVersion
- javaDistribution
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
<br>
<br>
___

## [`.\java\deploy\action.yaml`](.\java\deploy\action.yaml) - Deploys a Java application:
- Download build artifacts
- Copy, de-archive and move build artifacts
- Restart the Java application
- Run smoke tests on remote Java app
- Run integration tests on remote Java app

### Inputs:
- sshPrivateKey
- remoteUser
- remoteHost
- remotePath
- webAppDirectory
- artifactJarName
<br>
<br>
___

## [`.\npm-node\build\action.yaml`](.\npm-node\build\action.yaml) - Builds and scans a Node.js application:
- Setup Node.js environment with specified version
- Create build directory
- Install dependencies via NPM or Yarn
- Build Node.js application
- Run unit tests
- Fortify SCA scan (Software Composition Analysis)
- Fortify SAST scan (Static Application Security Testing)
- SonarQube scan and quality gate check
- Stage, archive, and publish artifacts

### Inputs:
- nodeVersion
- packageManager
- buildScript
- testScript
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
<br>
<br>
___

## [`.\npm-node\deploy\action.yaml`](.\npm-node\deploy\action.yaml) - Deploys a Node.js application:
- Download build artifacts
- Copy build artifacts to deployment targets via SSH
- De-archive build artifacts on target machines
- Place build artifacts in web application directory
- Install Node.js dependencies in production mode
- Stop existing Node.js application
- Start Node.js application
- Wait for application to start and stabilize
- Run smoke tests on remote Node.js app
- Run integration tests on remote Node.js app

### Inputs:
- sshPrivateKey
- remoteUser
- remoteHost
- remotePath
- webAppDirectory
- packageManager
- nodeVersion
- startScript
<br>
<br>
___

## [`.\sql\build\action.yaml`](.\sql\build\action.yaml) - Builds and scans a SQL application:
- Install SQL tools
- Build SQL
- Run unit tests
- Run security scans
- Stage, archive, and publish artifacts

### Inputs:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
<br>
<br>
___

## [`.\sql\deploy\action.yaml`](.\sql\deploy\action.yaml) - Deploys a SQL application:
- Download build artifacts
- Copy, de-archive and move build artifacts
- Restart the SQL application
- Run smoke tests on remote SQL app
- Run integration tests on remote SQL app

### Inputs:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
<br>
<br>
___

## [`.\ssis-ssrs\build\action.yaml`](.\ssis-ssrs\build\action.yaml) - Builds and scans an SSIS/SSRS application:
- Install SSIS/SSRS tools
- Build SSIS/SSRS app
- Run unit tests
- Run security scans
- Stage, archive, and publish artifacts

### Inputs:
- SSC_URL
- SSC_TOKEN
- SC_SAST_CLIENT_AUTH_TOKEN
- DEBRICKED_TOKEN
- SONAR_TOKEN
- SONAR_HOST_URL
<br>
<br>
___

## [`.\ssis-ssrs\deploy\action.yaml`](.\ssis-ssrs\deploy\action.yaml) - Deploys an SSIS/SSRS application:
- Download build artifacts
- Copy, de-archive and move build artifacts
- Restart the SSIS/SSRS application
- Run smoke tests on remote SSIS/SSRS app
- Run integration tests on remote SSIS/SSRS app

### Inputs:
- sshPrivateKey
- remoteUser
- remoteHost
- remotePath
- webAppDirectory
<br>
<br>
___