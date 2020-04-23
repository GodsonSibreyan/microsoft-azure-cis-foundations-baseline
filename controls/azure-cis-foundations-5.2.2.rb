control "azure-cis-foundations-5.2.2" do
  title "Ensure that Activity Log Alert exists for Create or Update Network
Security Group"
  desc  "Create an Activity Log Alert for the \"Create\" or \"Update Network
Security Group\" event."
  desc  "rationale", "Monitoring for \"Create\" or \"Update Network Security
Group\" events gives insight into network access changes and may reduce the
time it takes to detect suspicious activity."
  desc  "check", "
    **Azure Console**

    1. Navigate to `Monitor' / 'Alerts`
    2. Select `Manage alert rules`
    3. Click on the Alert `Name` where Condition contains `operationName equals
Microsoft.Network/networkSecurityGroups/write`
    4. Hover a mouse over `Condition` to ensure it is set to `Whenever the
Administrative Activity Log \"Create or Update Network Security Group
(networkSecurityGroups)\" has \"any\" level with \"any\" status and event is
initiated by \"any\"`

    **Azure Command Line Interface 2.0**

    ```
    az account get-access-token --query
\"{subscription:subscription,accessToken:accessToken}\" --out tsv | xargs -L1
bash -c 'curl -X GET -H \"Authorization: Bearer $1\" -H \"Content-Type:
application/json\"
https://management.azure.com/subscriptions/$0/providers/microsoft.insights/activityLogAlerts?api-version=2017-04-01'
| jq
'.|.value[]|{location:.location,scopes:.properties.scopes,\"condition\":.properties.condition.allOf|.[]|select(.field==\"operationName\"
and
.equals==\"microsoft.network/networksecuritygroups/write\"),enabled:.properties.enabled}'
    ```
    Ensure that an alert exists where:
    - location is set to `Global`
    - Scopes is set to entire subscription that is `/subscriptions/`
    - Enabled set to `True`
    - Condition Matches:
    ```
     {
     \"location\": \"Global\",
     \"scopes\": [
     \"/subscriptions/\"
     ],
     \"condition\": {
     \"field\": \"operationName\",
     \"equals\": \"microsoft.network/networksecuritygroups/write\",
     \"containsAny\": null
     },
     \"enabled\": true
    }
    ```
  "
  desc  "fix", "
    **Azure Command Line Interface 2.0**

    Use the below command to create an Activity Log Alert for `Create or Update
Network Security Groups`

    ```
    az account get-access-token --query
\"{subscription:subscription,accessToken:accessToken}\" --out tsv | xargs -L1
bash -c 'curl -X PUT -H \"Authorization: Bearer $1\" -H \"Content-Type:
application/json\"
https://management.azure.com/subscriptions/$0/resourceGroups//providers/microsoft.insights/activityLogAlerts/?api-version=2017-04-01
-d@\"input.json\"'
    ```

    Where `input.json` contains the Request body JSON data as mentioned below.
    ```
    {
     \"location\": \"Global\",
     \"tags\": {},
     \"properties\": {
     \"scopes\": [
     \"/subscriptions/\"
     ],
     \"enabled\": true,
     \"condition\": {
     \"allOf\": [
     {
     \"containsAny\": null,
     \"equals\": \"Administrative\",
     \"field\": \"category\"
     },
     {
     \"containsAny\": null,
     \"equals\": \"Microsoft.Network/networkSecurityGroups/write\",
     \"field\": \"operationName\"
     }
     ]
     },
     \"actions\": {
     \"actionGroups\": [
     {
     \"actionGroupId\":
\"/subscriptions//resourceGroups//providers/microsoft.insights/actionGroups/\",
     \"webhookProperties\": null
     }
     ]
     },
     }
    }
    ```

    Configurable Parameters for command line:
    ```

    ```

    Configurable Parameters for `input.json`:
    ```
     in scopes
     in actionGroupId
     in actionGroupId
     in actionGroupId
    ```
    }
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: nil
  tag gid: nil
  tag rid: nil
  tag stig_id: nil
  tag fix_id: nil
  tag cci: nil
  tag nist: ["AU-3", "Rev_4"]
  tag cis_level: 1
  tag cis_controls: ["6.3", "Rev_7"]
  tag cis_rid: "5.2.2"
  tag false_negatives: nil
  tag false_positives: nil
  tag documentable: nil
  tag mitigations: nil
  tag severity_override_guidance: nil
  tag potential_impacts: nil
  tag third_party_tools: nil
  tag mitigation_controls: nil
  tag responsibility: nil
  tag ia_controls: nil

  describe "This control is not yet implemented. Azure Stack has not yet implemented Azure Monitor Alerts." do
    skip "This control is not yet implemented. Azure Stack has not yet implemented Azure Monitor Alerts."
  end
end

