control "azure-cis-foundations-4.12" do
  title "Ensure server parameter 'log_checkpoints' is set to 'ON' for
PostgreSQL Database Server"
  desc  "Enable `log_checkpoints` on `PostgreSQL Servers`."
  desc  "rationale", "Enabling `log_checkpoints` helps the PostgreSQL Database
to `Log each checkpoint` in turn generates query and error logs. However,
access to transaction logs is not supported. Query and error logs can be used
to identify, troubleshoot, and repair configuration errors and sub-optimal
performance."
  desc  "check", "
    **Azure Console**

    1. Login to Azure Portal using https://portal.azure.com
    2. Go to Azure `Database` for `PostgreSQL` server
    3. For each database, click on `Server parameters`
    4. Search for `log_checkpoints`.
    5. Ensure that value is set to `ON`.

    **Azure Command Line Interface 2.0**

    Ensure value is set to `ON`

     az postgres server configuration show --resource-group  --server-name
--name log_checkpoints
  "
  desc  "fix", "
    **Azure Console**

    1. Login to Azure Portal using https://portal.azure.com
    2. Go to Azure Database for PostgreSQL server
    3. For each database, click on Server parameters
    4. Search for `log_checkpoints`.
    5. Click `ON` and save.

    **Azure Command Line Interface 2.0**

    Use the below command to update `log_checkpoints` configuration.

     az postgres server configuration set --resource-group  --server-name
--name log_checkpoints --value on
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: nil
  tag gid: nil
  tag rid: nil
  tag stig_id: nil
  tag fix_id: nil
  tag cci: nil
  tag nist: ["AU-12", "Rev_4"]
  tag cis_level: 1
  tag cis_controls: ["6.2", "Rev_7"]
  tag cis_rid: "4.12"
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

  describe "This control is not yet implemented. Azure Stack has not yet implemented sql databases as a service." do
    skip "This control is not yet implemented. Azure Stack has not yet implemented sql databases as a service."
  end
end

