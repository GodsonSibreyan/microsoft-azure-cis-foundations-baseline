approved_extensions = input("approved_extensions", value: [])
my_resource_groups = input('my_resource_groups', value: [])

control "azure-cis-foundations-7.4" do
  title "Ensure that only approved extensions are installed"
  desc  "Only install organization-approved extensions on VMs."
  desc  "rationale", "Azure virtual machine extensions are small applications
that provide post-deployment configuration and automation tasks on Azure
virtual machines. These extensions run with administrative privileges and could
potentially access anything on a virtual machine. The Azure Portal and
community provide several such extensions. Each organization should carefully
evaluate these extensions and ensure that only those that are approved for use
are actually implemented."
  desc  "check", "
    **Azure Console**

    1. Go to `Virtual machines`
    2. For each virtual machine, go to `Settings`
    3. Click on `Extensions`
    4. Ensure that the listed extensions are approved for use.

    **Azure Command Line Interface 2.0**

    Use the below command to list the extensions attached to a VM, and ensure
the listed extensions are approved for use.

    ```
    az vm extension list --vm-name  --resource-group  --query [*].name
    ```
  "
  desc  "fix", "
    **Azure Console**

    1. Go to `Virtual machines`
    2. For each virtual machine, go to `Settings`
    3. Click on `Extensions`
    4. If there are unapproved extensions, uninstall them.

    **Azure Command Line Interface 2.0**

    From the audit command identify the unapproved extensions, and use the
below CLI command to remove an unapproved extension attached to VM.

    ```
    az vm extension delete --resource-group  --vm-name  --name
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
  tag nist: ["CM-7 (5)", "Rev_4"]
  tag cis_level: 1
  tag cis_controls: ["2.1", "Rev_7"]
  tag cis_rid: "7.4"
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
    azurerm_virtual_machines(resource_group: rg_name).vm_names.each do |vm_name|
      describe azurerm_virtual_machine(resource_group: rg_name, name: vm_name) do
        it { should have_only_approved_extensions approved_extensions }
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

