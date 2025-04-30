#!/bin/bash
# This script installs the New Relic Helm chart for monitoring and observability in Kubernetes.

helm repo add newrelic https://helm-charts.newrelic.com
helm repo update

helm upgrade --install newrelic-bundle newrelic/nri-bundle \
--namespace newrelic --create-namespace \
-f values-newrelic.yaml \
--dry-run \
--debug

helm upgrade --install newrelic-bundle newrelic/nri-bundle \
--namespace newrelic --create-namespace \
-f values-newrelic.yaml

kubectl -n newrelic get pods

