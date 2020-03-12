control "azure-cis-foundations-9.9" do
  title "Ensure that 'Java version' is the latest, if used to run the web app"
  desc  "Periodically, newer versions are released for Java software either due
to security flaws or to include additional functionality. Using the latest Java
version for web apps is recommended in order to take advantage of security
fixes, if any, and/or new functionalities of the newer version."
  desc  "rationale", "Newer versions may contain security enhancements and
additional functionality. Using the latest software version is recommended in
order to take advantage of enhancements and new capabilities. With each
software installation, organizations need to determine if a given update meets
their requirements and also verify the compatibility and support provided for
any additional software against the update revision that is selected."
  desc  "check", "
    Using Console:

    1. Login to Azure Portal using https://portal.azure.com
    2. Go to `App Services`
    3. Click on each App
    4. Under `Setting` section, Click on `Application settings`
    5. Ensure that `Java version` set to the latest version available under
`General settings`

    NOTE: No action is required If `Java version` is set to `Off` as Java is
not used by your web app.

    Using Command line:

    To check Java version for an existing app, run the following command,
    ```
    az webapp config show --resource-group  --name  --query javaVersion
    ```

    The output should return the latest available version of Java.

    NOTE: No action is required If no output for above command as Java is not
used by your web app.
  "
  desc  "fix", "
    Using Console:

    1. Login to Azure Portal using https://portal.azure.com
    2. Go to `App Services`
    3. Click on each App
    4. Under `Setting` section, Click on `Application settings`
    5. Under `General settings`, Set `Java version` to latest version available
    6. Set `Java minor version` to latest version available
    7. Set `Java web container` to the latest version of web container available

    NOTE: No action is required If `Java version` is set to `Off` as Java is
not used by your web app.

    Using Command Line:

    To see the list of supported runtimes:

    ```
    az webapp list-runtimes | grep java
    ```

    To set latest Java version for an existing app, run the following command:
    ```
    az webapp config set --resource-group  --name  --java-version '1.8'
--java-container 'Tomcat' --java-container-version ''
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
  tag cis_controls: ["2.2", "Rev_7"]
  tag cis_rid: "9.9"
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

  describe "This control has not been implemented yet. App Services is an Azure Cloud offering and has not yet been implemented for Azure Stack." do
    skip "This control has not been implemented yet. App Services is an Azure Cloud offering and has not yet been implemented for Azure Stack."
  end
end

