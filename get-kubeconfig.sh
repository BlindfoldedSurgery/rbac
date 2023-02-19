#!/bin/bash

namespace=$1
secretname=$2
filename=$(openssl rand -hex 12).yml

# TOKEN=$(kubectl -n $namespace create token $serviceaccount)
TOKEN=$(kubectl -n $namespace get secret -o json $2-token | jq -r '.data.token' | base64 -d)

kubectl config view --flatten --minify > $filename

export KUBECONFIG=$(pwd)/$filename 
kubectl config set-credentials $2 --token=$TOKEN
kubectl config set-context --user=$2 --current
kubectl config view --flatten --minify > $serviceaccount.config

rm $filename

/usr/bin/cat $serviceaccount.config
