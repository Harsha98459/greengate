# GreenGate — Carbon-Aware Deployment Gate

A FastAPI service that Jenkins queries **before deploying**. If the live electricity
grid carbon intensity is above `CARBON_THRESHOLD`, the deploy is **blocked/deferred**.

## Run locally
    bash scripts/build.sh
    bash scripts/run.sh
    bash scripts/gate.sh

## Pipeline
Jenkins → Pipeline script from SCM → this repo → `Jenkinsfile` 
