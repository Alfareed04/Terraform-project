locals {
  vnet = data.terraform_remote_state.projects.outputs.vnet
  rg   = data.terraform_remote_state.projects.outputs.rg
}
