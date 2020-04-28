my_resource_groups = input('my_resource_groups', value: [])

control "azure-cis-foundations-8.1" do
  title "Ensure that the expiration date is set on all keys"
  desc  "Ensure that all keys in Azure Key Vault have an expiration time set."
  desc  "rationale", "Azure Key Vault enables users to store and use
cryptographic keys within the Microsoft Azure environment. The `exp`
(expiration time) attribute identifies the expiration time on or after which
the key MUST NOT be used for a cryptographic operation. By default, keys never
expire. It is thus recommended that keys be rotated in the key vault and set an
explicit expiration time for all keys. This ensures that the keys cannot be
used beyond their assigned lifetimes."
  desc  "check", "
    **Azure Console**

    1. Go to `Key vaults`
    2. For each Key vault, click on `Keys`.
    3. Under the `Settings` section, Make sure `Enabled?` is set to `Yes`
    4. Then ensure that each key in the vault has `EXPIRATION DATE` set as
appropriate

    **Azure Command Line Interface 2.0**

    Ensure that the output of the below command contains Key ID (kid), enabled
status as `true` and Expiration date (expires) is not empty or null:

    ```
    az keyvault key list --vault-name  --query
[*].[{\"kid\":kid},{\"enabled\":attributes.enabled},{\"expires\":attributes.expires}]

    ```
  "
  desc  "fix", "
    **Azure Console**

    1. Go to `Key vaults`
    2. For each Key vault, click on `Keys`.
    3. Under the `Settings` section, Make sure `Enabled?` is set to Yes
    4. Set an appropriate `EXPIRATION DATE` on all keys.

    **Azure Command Line Interface 2.0**

    Update the `EXPIRATION DATE` for the key using below command.

    ```
    az keyvault key set-attributes --name  --vault-name  --expires
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
  tag cis_rid: "8.1"
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

  rgs = my_resource_groups.empty? ? azurerm_resource_groups.names :  my_resource_groups

  rgs.each do |rg_name|
    vaults =  azurerm_key_vaults(resource_group: rg_name).names
    if vaults.empty?
      impact 0
      describe "No key vaults were found in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials." do
        skip "No key vaults were found in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials."
      end
    end
    vaults.each do |vault_name|
      keys = azurerm_key_vault_keys(vault_name).names
      if keys.empty?
        impact 0
        describe "No keys were found for the vault #{vault_name} in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials." do
          skip "No keys were found for the vault #{vault_name} in resource group #{rg_name} and therefore this control is not applicable. If you think this is an error, there may be an issue with the inspec-azure resource pack or the provided azure credentials."
        end
      end
      keys.each do |key_name|
        describe azurerm_key_vault_key(vault_name, key_name) do
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

