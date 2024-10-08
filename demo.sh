#! /usr/bin/env sh

demodir=$(pwd)
export TRIVY_DISABLE_NODE_COLLECTOR=true
# note, we see only HIGH/CRITICAL issues throughout the demo
export TRIVY_SEVERITY=HIGH

cd "$demodir/appy/backend"
# trivy finds vulnerability in go-gin
trivy fs .
# confirm package version
grep 'github.com/gin-gonic/gin' go.mod 
# bump package version from 1.7.0 to 1.9.0
sed -i '' 's|require github.com/gin-gonic/gin v1.7.0|require github.com/gin-gonic/gin v1.7.7|' go.mod
# reconfirm package version
grep 'github.com/gin-gonic/gin' go.mod 
# rescan
trivy fs .
# trivy finds same vuln in binary in image
trivy image appy-backend:1
# rebuild image
docker build -t appy-backend:2 .
# rescan, still vuln in openssl
trivy image appy-backend:2
# since we're using Go, we decide to ignore it
trivy image appy-backend:2 --ignorefile ./trivyignore.yaml

# ---

cd "$demodir/appy/frontend"
# trivy detects indirect vulnerabilities
trivy fs .
# identify package origin
trivy fs . --dependency-tree
# confirm package version
grep 'express' package.json
# bump package from 4.10.0 to latest
npm install express@latest --package-lock-only
# reconfirm pacakge version
grep 'express' package.json
# rescan
trivy fs .
# build image
docker build -t appy-frontend:2 .
# scan image
trivy image appy-frontend:2

# ---

cd "$demodir/appy"
# trivy detects misconfiguration in deployment
trivy fs ./k8s-deploy.yaml --scanners misconf
# fix it
echo '        securityContext:\n          readOnlyRootFilesystem: true' >> ./k8s-deploy.yaml
# rescan
trivy fs ./k8s-deploy.yaml --scanners misconf

# ---

# scan workloads in cluster
trivy k8s --report summary --include-namespaces appy
# see details
trivy k8s --report all --include-namespaces appy
# use a compliance framework
# https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline
trivy k8s --report summary --include-namespaces appy --compliance k8s-pss-baseline-0.1

# k8s cluster scanning
trivy k8s --report summary --compliance k8s-cis-1.23
