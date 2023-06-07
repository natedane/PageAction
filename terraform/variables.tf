
# environment
variable "environment" {
  type = string
  description = "This variable defines the environment to be built"
}

# azure region
variable "location" {
  type = string
  description = "Azure region where resources will be created"
  default = "centralus"
}

# # azure tenant id
# variable "MICROSOFT_PROVIDER_AUTHENTICATION_TENANT_ID" {
#   type = string
#   description = "id for tenant"
#   sensitive = true
# }

# # common name
# variable "common" {
#   type = string
#   description = "common name to use"
#   default = "nated"
# }