locals {
  vnet = data.terraform_remote_state.projects.outputs.vnet["project3_vnet"]
  rg   = data.terraform_remote_state.projects.outputs.rg["Project3-rg"]
}
