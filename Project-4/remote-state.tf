
data "terraform_remote_state" "projects" {
  backend = "azurerm"
  config = {
    resource_group_name  = "backend_rg"
    storage_account_name = "stgacctconfig"
    container_name       = "container-config"
    key                  = "Terraform-project.tfstate"
  }
}