# argon-automation-utilities

This directory serves as a place to store automation utilities such as PowerShell scripts

## Naming Conventions for Utilities
**Prefixes for Files:**
- create - utilities that create something, usually an artifact for deployment
- deploy - these utilities deploy to various targets
- get - utilities that fetch something, like secrets from a named source
- install - used for utilities that install tools necessary for pipelines
- pipeline - used for top-level pipeline utilities that orchestrate stages and steps
- publish - utilities that package and push artifacts
- restore - these include tasks that retrieve dependencies necessary for builds
- run - these will execute something, like a script or test
- set - utilities that set something in a named source
- migrate - prefix for utilities that move things between two systems