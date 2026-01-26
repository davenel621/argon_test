CI/CD Process

0.	Org rulesets are in place on all repos to ensure the following: 
o	Main (default) Branch Protections 
	PRs are required 
•	Minimum reviewers are required 
•	Stale approvals are dismissed 
•	Most recent push Requires review 
•	Conversation Resolution is required 
•	Only Squash merge is allowed 
	Force Pushes are blocked 
	Deletions are not allowed 
o	A "Check Environment Protection Rules" workflow is required to pass for all PRs 
o	Branches must follow the expected naming convention (users/some-name/some-topic) 
o	Copilot PR Reviews are automatically triggered on any PR 
  
1.	A PR is created in the Application Repo against main or changes are pushed to a PR against main. Or, workflow dispatch is manually triggered
 
2.	The "Check Environment Protection Rules" workflow is run, verifying that: 
o	A prod environment exists in the repository 
o	The prod environment has protection rules configured 
o	Deployment to the prod environment requires review from one or more ADM team members 
o	Administrators cannot bypass protection rules (critical security check) 
o	Deployment branch policies are configured 
  
3.	The calling YAML/Workflow in the Application Repo calls the appropriate Reusable Workflow in the Reusable Automation Repo, extends access to GitHub Secrets and passes in application specific parameters
 
4.	The Reusable Workflow executes a "Build" job, which proceeds to: 
o	Consume GitHub secrets to connect to a GitHub App, which generates a token, that can be used for authentication 
o	Use the generated token to checkout both the Application Repo and the Reusable Automation Repo onto the runner 
o	Call the appropriate Composite Action (which also lives in the Reusable Automation Repo) for Building and Scanning, passing in any application specific parameters 
 
5.	The Build and Scan Composite Action uses other Composite Actions, both officially published from the marketplace, and internal to the Reusable Automation Repo to: 
o	Install tech specific tools onto the runner 
o	Run the SCA scan 
o	Generate an SBOM 
o	Publish the SCA scan results 
o	Enforce SCA policy 
o	Run the SAST scan 
o	Generate a SARIF report 
o	Publish the SAST scan results 
o	Enforce SAST policy 
o	Restore dependencies 
o	Build the application 
o	Run unit tests 
o	Publish the unit test results 
o	Validate unit test results and coverage 
o	Perform post build code signing and validation 
o	Generate build manifest 
o	Stage, archive & publish build artifacts 
 
6.	The Reusable Workflow compiles a summary of the Build job and posts it to GitHub job summaries 
 
7.	The Reusable Workflow executes a "Deploy to Dev" job, which proceeds to: 
o	Consume GitHub secrets to connect to a GitHub App, which generates a token, that can be used for authentication 
o	Use the generated token to checkout the Reusable Automation Repo onto the runner 
o	Call the appropriate Composite Action (which also lives in the Reusable Automation Repo) for Deploying, targeting the Dev environment and passing in any application specific parameters 
 
8.	The Deploy Composite Action (targeting Dev) uses other Composite Actions, both officially published from the marketplace, and internal to the Reusable Automation Repo to:  
o	Install tech specific tools onto the runner 
o	Download, de-archive and move artifacts 
o	Run mock tests 
o	Publish the mock test results 
o	Validate mock test results and coverage 
o	Validating deployment prerequisites 
o	Create an application backup 
o	Prepare deployment environment 
o	Deploy application 
o	Start Application 
o	Verify deployment 
o	Run smoke tests 
o	Warm up application 
o	Perform health checks 
o	Update deployment status 
o	Post deployment cleanup 
 
9.	The Reusable Workflow compiles a summary of the Deploy to Dev job and posts it to GitHub job summaries 
 
10.	The Reusable Workflow executes a "Deploy to Test" job, which proceeds to: 
o	Consume GitHub secrets to connect to a GitHub App, which generates a token, that can be used for authentication 
o	Use the generated token to checkout the Reusable Automation Repo onto the runner 
o	Call the appropriate Composite Action (which also lives in the Reusable Automation Repo) for Deploying, targeting the Test environment and passing in any application specific parameters 
 
11.	The Deploy Composite Action (targeting Test) uses other Composite Actions, both officially published from the marketplace, and internal to the Reusable Automation Repo to:  
o	Install tech specific tools onto the runner 
o	Download, de-archive and move artifacts 
o	Validating deployment prerequisites 
o	Create an application backup 
o	Prepare deployment environment 
o	Deploy application 
o	Start Application 
o	Verify deployment 
o	Run smoke tests 
o	Warm up application 
o	Run integration tests 
o	Publish the integration test results 
o	Validate integration test results and coverage 
o	Perform health checks 
o	Update deployment status 
o	Post deployment cleanup 
 
12.	The Reusable Workflow compiles a summary of the Deploy to Test job and posts it to GitHub job summaries 
 
13.	The Reusable Workflow executes a "Deploy to Staging" job, which proceeds to: 
o	Consume GitHub secrets to connect to a GitHub App, which generates a token, that can be used for authentication 
o	Use the generated token to checkout the Reusable Automation Repo onto the runner 
o	Call the appropriate Composite Action (which also lives in the Reusable Automation Repo) for Deploying, targeting the Staging environment and passing in any application specific parameters 
 
14.	The Deploy Composite Action (targeting Staging) uses other Composite Actions, both officially published from the marketplace, and internal to the Reusable Automation Repo to:  
o	Install tech specific tools onto the runner 
o	Download, de-archive and move artifacts 
o	Validating deployment prerequisites 
o	Create an application backup 
o	Prepare deployment environment 
o	Deploy application 
o	Start Application 
o	Verify deployment 
o	Run smoke tests 
o	Warm up application 
o	Run end to end tests 
o	Publish the end to end test results 
o	Validate end to end test results and coverage 
o	Perform health checks 
o	Run performance and load tests  
o	Publish performance and load test results  
o	Update deployment status 
o	Post deployment cleanup 
 
15.	The Reusable Workflow compiles a summary of the Deploy to Staging job and posts it to GitHub job summaries 
 
16.	The Reusable Workflow proceeds to a "Deploy to Prod" job, but pauses before execution, waiting for approval from one or more members of ADM. 
 
17.	One or more members of the ADM team approve the Production deployment, which allows the Reusable Workflow to executes the "Deploy to Prod" job, which proceeds to:  
o	Consume GitHub secrets to connect to a GitHub App, which generates a token, that can be used for authentication  
o	Use the generated token to checkout the Reusable Automation Repo onto the runner 
o	Run the "Check Environment Protection Rules" workflow, which ensures that the prod protection rules were not tampered with, and the in-progress workflow did in fact abide by all the necessary requirements and safeguards 
o	Call the appropriate Composite Action (which also lives in the Reusable Automation Repo) for Deploying, targeting the Prod environment and passing in any application specific parameters 
 
18.	The Deploy Composite Action (targeting Prod) uses other Composite Actions, both officially published from the marketplace, and internal to the Reusable Automation Repo to:  
o	Install tech specific tools onto the runner 
o	Download, de-archive and move artifacts 
o	Validating deployment prerequisites 
o	Create an application backup 
o	Prepare deployment environment 
o	Deploy application 
o	Start Application 
o	Verify deployment 
o	Run smoke tests 
o	Warm up application 
o	Perform health checks 
o	Update deployment status 
o	Post deployment cleanup 
 
19.	The Reusable Workflow compiles a summary of the Deploy to Prod job and posts it to GitHub job summaries 
 
20.	The Reusable Workflow executes a "Workflow Summary" job which compiles a comprehensive but easy to read summary of the entire workflow run and posts it to the GitHub job summaries 

