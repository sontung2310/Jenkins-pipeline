#!/bin/bash

resource_group="FlaskAuthRG"
cluster_name="flaskappcluster"
subscription_id="f798d7f3-4431-494a-98ff-d45d54be8aa2"
action_group_name="MonitoringandAlerting"
action_group_short_name="maa"
email="buisontung2310@gmail.com"
workspace_id="<your-workspace-id>"

# Create the Action Group
action_group_id=$(az monitor action-group create \
  --resource-group $resource_group \
  --name $action_group_name \
  --short-name $action_group_short_name \
  --query "id" -o tsv)

# Output the Action Group ID
echo "Action Group ID: $action_group_id"

