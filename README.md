# Jenkins Pipeline for HD task of SIT753: Professional Practice

### 1. How to run this pipeline locally
- Clone this repository in your local machine: git clone https://github.com/sontung2310/Jenkins-pipeline.git
- Create accounts for: Azure, SonarQube, Snyk, New Relic.
- Set up the Jenkins on local machine, install necessary in Jenkins for tool utilization ex: Snyk, New Relic plugins.
https://www.jenkins.io/doc/book/installing/
- Make sure your compute have already install Python, Docker.

### 2. Application introduction
This is a simple Account Management System built with Flask, a Python web framework. The app has three main features:
-	User Registration API: lets new users create an account with a username and password.
-	Login API: allows existing users to log in with their credentials.
-	Welcome Page: shows a welcome message to confirm the app is running.

It uses SQLite as the database to store user data, and Flask-SQLAlchemy to manage the database. Passwords are securely hashed using werkzeug.security. 

### 3. Brief description of each stage of pipeline
3.1.	Build Stage:
-	Tool used: Docker
-	Containerized the application by creating a Docker image using a Dockerfile. The Dockerfile uses a Python base image and installs all necessary dependencies to run the app. The Docker image will keep everything the app needs, so it can run the same way anywhere — on any computer or cloud server.
-	This makes it easy to deploy, test, and share the application. By using containers, we ensure the app runs smoothly in different environments.

3.2.	Test stage:
-	Tool used: Pytest
-	I use Pytest to automatically run unit tests inside the Docker container to verify that the core functionalities of the application, such as user registration and login, behave as expected.

3.3.	Code Quality analysis stage
-	Tool used: SonarCloud + SonarScanner CLI
-	Purpose: Checks my code on the structure, style, and maintainability. It uploads results to SonarCloud, a cloud-based code quality tool.

3.4.	Security stage

-	Tools used: Snyk, pip-review
-	Ensures that vulnerabilities in dependencies are detected and addressed early in the CI/CD pipeline.
-	Scans your Python dependencies for security vulnerabilities using Snyk.
-	Tries to auto-fix vulnerable packages with pip-review
-	Re-tests after fixing to ensure safety.


3.5.	Deployment stage
-	Tool used: Docker Compose
-	This stage deploys the Flask application using Docker Compose. It runs the application in containers based on the Docker image that was built earlier.
-	The Docker image is tagged with a version using the variable $RELEASE_TAG (for example: flaskapp:50). This makes each deployment traceable. If any issue happens in the latest version, we can easily identify which version is running. If a deployment causes errors, we can quickly roll back by re-deploying a previous image tag.


3.6.	Release stage
-	Tool used: Azure Kubernetes Service (AKS) 
-	Purpose: Deploys the Docker image to Azure Kubernetes Service using a custom shell script (azure_script.sh). 
-	Once the deployment is complete, AKS exposes a public IP address, allowing users to access and interact with the application through that endpoint.


3.7.	Monitoring and Alert stage
-	Tools used: Azure Monitor, New Relic
-	In this stage, I leveraged Azure's monitoring and alerting capabilities to track the application's performance in production and proactively detect any issues.
-	I also configured an alert rule that triggers when CPU usage exceeds 80% over a 15-minute period. Once triggered, the alert will immediately send a notification to my email, ensuring timely awareness and response to potential performance bottlenecks.
-	I also implement monitoring with New Relic tools. The New Relic dashboard provides real-time monitoring and performance insights for the AKS (Azure Kubernetes Service) cluster. It shows key metrics such as CPU and memory usage per node and pod, container restarts, pod status, and network traffic. It also tracks cluster health, workload resource usage, and deployment changes over time.


