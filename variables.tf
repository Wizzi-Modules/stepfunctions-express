# General ########################################################################################################

variable "name_prefix" {
  description = "The prefix to use for all resources"
  type = string
}

variable "folder" {
  description = "The folder containing the policies and definition"
  type = string
}

variable "definition_file" {
  description = "The file containing the state machine definition"
  type = string
  default = "definition.json"
}

variable "definition_variables" {
  description = "The variables to use in the state machine definition"
  type = map
  default = {}
}

# IAM ############################################################################################################

variable "environment" {
  description = "The environment to deploy to"
  type = string
}