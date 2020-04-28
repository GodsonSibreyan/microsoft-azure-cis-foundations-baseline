my_resource_groups = input('my_resource_groups', value: [])

control "azure-cis-foundations-8.2" do
  title "Ensure that the expiration date is set on all Secrets"
  desc  "Ensure that all Secrets in the Azure Key Vault have an expiration time
set."
  desc  "rationale", "The Azure Key Vault enables users to store and keep
secrets within the Microsoft Azure environment. Secrets in the Azure Key Vault
are octet sequences with a maximum size of 25k bytes each. The `exp`
(expiration time) attribute identifies the expiration time on or after which
the secret MUST NOT be used. By default, secrets never expire. It is thus
recommended to rotate secrets in the key vault and set an explicit expiration
time for all secrets. This ensures that the secrets cannot be used beyond their
assigned lifetimes."
  desc  "check", "
    **Azure Console**

    1. Go to `Key vaults`
    2. For each Key vault, click on `Secrets`.
    3. Under the `Settings` section, Make sure `Enabled?` is set to `Yes`
    4. Ensure that each secret in the vault has `EXPIRATION DATE` set as
appropriate

    **Azure Command Line Interface 2.0**

    Ensure that the output of the below command contains ID (id), enabled
status as `true` and Expiration date (expires) is not empty or null:

    ```
    az keyvault secret list --vault-name  --query
[*].[{\"id\":id},{\"enabled\":attributes.enabled},{\"expires\":attributes.expires}]

    ```
  "
  desc  "fix", "
    **Azure Console**

    1. Go to `Key vaults`
    2. For each Key vault, click on `Secrets`.
    3. Under the `Settings` section, Make sure `Enabled?` is set to `Yes`
    4. Set an appropriate `EXPIRATION DATE` on all secrets.

    **Azure Command Line Interface 2.0**

    Use the below command to set `EXPIRATION DATE` on the all secrets.

    ```
    az keyvault secret set-attributes --name  --vault-name  --expires
Y-m-d'T'H:M:S'Z'
    ```
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: nil
  tag gid: nil
  tag rid: nil
  tag stig_id: nil
  tag fix_id: nil
  tag cci: nil
  tag nist: ["AC-2", "Rev_4"]
  tag cis_level: 1
  tag cis_controls: ["16", "Rev_7"]
  tag cis_rid: "8.2"
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

  rgs = my_resource_groups.empty? ? azurerm_resource_groups.names : my_resource_groups
  
  rgs.each do |rg_name|
    vaults = azurerm_key_vaults(resource_group: rg_name).names
    if vaults.empty?
      impact 0
      describe "No key vaults were found in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials." do
        skip "No key vaults were found in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials."
      end
    end
    vaults.each do |vault_name|
      secrets = azurerm_key_vault_secrets(vault_name).names
      if secrets.empty?
        impact 0
        describe "No key vault secrets were found for the vault #{vault_name} in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials." do
          skip "No key vault secrets were found for the vault #{vault_name} in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials."
        end
      end
      secrets.each do |secret_name|
        describe azurerm_key_vault_secret(vault_name, secret_name) do
          it { should be_enabled }
          it { should have_expiration_set }
        end
      end
    end
  end

  if rgs.empty?
    impact 0
    describe "No resources groups were found and therefore this control is not applicable. If you think this is an error, ensure that my_resource_groups is set correctly or that there are resource groups in the specified subscription." do
      skip "No resources groups were found and therefore this control is not applicable. If you think this is an error, ensure that my_resource_groups is set correctly or that there are resource groups in the specified subscription."
    end
  end
end

