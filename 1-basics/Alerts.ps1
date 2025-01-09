$location = "eastus"
$pseudoRootManagementGroup = "10c5dfa7-b5c3-4cf2-9265-f0e32a960967"
$identityManagementGroup = "mg-FirstGroup"
$managementManagementGroup = "mg-secondgroup"
$connectivityManagementGroup = "academy-corp"
$LZManagementGroup="academy-landingzones"

  #Deploy policy definitions
  New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateFile ./infra-as-code/bicep/deploy_dine_policies.bicep
  
  #Deploy policy initiatives, wait approximately 1-2 minutes after deploying policies to ensure that there are no errors when creating initiatives
  New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateFile ./src/resources/Microsoft.Authorization/policySetDefinitions/ALZ-MonitorConnectivity.json
  New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateFile ./src/resources/Microsoft.Authorization/policySetDefinitions/ALZ-MonitorIdentity.json
  New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateFile ./src/resources/Microsoft.Authorization/policySetDefinitions/ALZ-MonitorManagement.json
  New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateFile ./src/resources/Microsoft.Authorization/policySetDefinitions/ALZ-MonitorLandingZone.json
  New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateFile ./src/resources/Microsoft.Authorization/policySetDefinitions/ALZ-MonitorServiceHealth.json
  
  #Assign Policy Initiatives, wait approximately 1-2 minutes after deploying initiatives policies to ensure that there are no errors when assigning them
  New-AzManagementGroupDeployment -ManagementGroupId $identityManagementGroup -Location $location -TemplateFile ./infra-as-code/bicep/assign_initiatives_identity.bicep -TemplateParameterFile ./infra-as-code/bicep/parameters-complete-identity.json
  New-AzManagementGroupDeployment -ManagementGroupId $managementManagementGroup -Location $location -TemplateFile ./infra-as-code/bicep/assign_initiatives_management.bicep -TemplateParameterFile ./infra-as-code/bicep/parameters-complete-management.json
  New-AzManagementGroupDeployment -ManagementGroupId $connectivityManagementGroup -Location $location -TemplateFile ./infra-as-code/bicep/assign_initiatives_connectivity.bicep -TemplateParameterFile ./infra-as-code/bicep/parameters-complete-connectivity.json
  New-AzManagementGroupDeployment -ManagementGroupId $LZManagementGroup -Location $location -TemplateFile ./infra-as-code/bicep/assign_initiatives_landingzones.bicep -TemplateParameterFile ./infra-as-code/bicep/parameters-complete-landingzones.json
  New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup -Location $location -TemplateFile ./infra-as-code/bicep/assign_initiatives_servicehealth.bicep -TemplateParameterFile ./infra-as-code/bicep/parameters-complete-servicehealth.json