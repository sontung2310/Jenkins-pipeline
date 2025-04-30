#!/bin/bash

resource_group="FlaskAuthRG"
cluster_name="flaskappcluster"
action_group_name="MonitoringandAlerting"
action_group_short_name="maa"
email="buisontung2310@gmail.com"

subscription_id=$(az group show --name $resource_group --query "id" -o tsv | cut -d'/' -f3)

az aks enable-addons --addons monitoring \
  --resource-group $resource_group \
  --name $cluster_name

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
  --add emailReceivers name='MyEmailReceiver' emailAddress="$email"

az monitor metrics alert create \
  --name "AKSHighCPUAlert" \
  --resource-group "$resource_group" \
  --scopes "/subscriptions/$subscription_id/resourceGroups/$resource_group/providers/Microsoft.ContainerService/managedClusters/$cluster_name" \
  --description "Alert if average CPU > 80% for 15 mins" \
  --condition "avg apiserver_cpu_usage_percentage > 80" \
  --window-size "PT5M" \
  --evaluation-frequency "PT5M" \
  --action "$action_group_id"
