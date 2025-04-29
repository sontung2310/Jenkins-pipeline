#!/bin/bash

resource_group="FlaskAuthRG"
cluster_name="flaskappcluster"
action_group_name="MonitoringandAlerting"
action_group_short_name="maa"
email="buisontung2310@gmail.com"
workspace_id="<your-workspace-id>"

subscription_id=$(az group show --name $resource_group --query "id" -o tsv | cut -d'/' -f3)

# Create the Action Group
action_group_id=$(az monitor action-group create \
  --resource-group $resource_group \
  --name $action_group_name \
  --short-name $action_group_short_name \
  --query "id" -o tsv)

# Output the Action Group ID
echo "Action Group ID: $action_group_id"

# Update the Action Group to add an email receiver
az monitor action-group update \
  --ids $action_group_id \
  --add emailReceivers email=$email

# Create an alert for HTTP 4xx or 5xx errors in FlaskApp
az monitor metrics alert create \
  --name "FlaskAppErrorAlert" \
  --resource-group $resource_group \
  --scopes "/subscriptions/$subscription_id/resourceGroups/$resource_group/providers/Microsoft.ContainerService/managedClusters/$cluster_name" \
  --description "Alert when Flask API returns 4xx or 5xx errors" \
  --condition "count AzureDiagnostics | where StatusCode >= 400 and StatusCode < 600 > 0" \
  --action-group $action_group_id \
  --enabled true \
  --frequency "PT5M" \
  --window-size "PT15M"