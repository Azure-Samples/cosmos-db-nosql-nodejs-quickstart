metadata description = 'Create web application environment resources.'

param envName string
param location string = resourceGroup().location
param tags object = {}

module containerAppsEnvironment '../core/host/container-apps/environments/managed.bicep' = {
  name: 'container-apps-env'
  params: {
    name: envName
    location: location
    tags: tags
  }
}

output name string = containerAppsEnvironment.outputs.name
