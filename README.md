# Deploy From GitHub

This repository contains simple bash scripts used to deploy web applications from GitHub repositories. The scripts pull the latest commits from a specified branch, shuts down the webserver-service, compiles the new code, and starts up the web server again. Schedule a script to run every x minutes on a production server to achieve continuous deployment.

## Frameworks and Platforms

Deployment scripts for the following frameworks and platforms are currently provided:

- .Net Core
  - Windows (IIS Server)
  - Linux (CentOS) 
  
To run the bash scripts on Windows, you need a bash emulator (Git Bash or similar).
