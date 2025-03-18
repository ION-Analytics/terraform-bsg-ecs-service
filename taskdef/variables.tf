variable "env" {
  description = "Environment name"
  default     = ""
}

variable "release" {
  type        = map(string)
  description = "Metadata about the release"
  default     = {}
}

variable "family" {
  description = "A unique name for your task defintion."
  type        = string
}

variable "container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document."
  type        = list(string)
}

variable "policy" {
  description = "A valid IAM policy for the task"
  type        = string
}

variable "volume" {
  description = "Volume block map with 'name' and 'host_path'."
  type        = map(string)
  default     = {}
}

variable "assume_role_policy" {
  description = "A valid IAM policy for assuming roles - optional"
  type        = string
  default     = ""
}

variable "is_test" {
  description = "For testing only. Stops the call to AWS for sts"
  default     = false
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task"
  type        = string
  default     = "bridge"
}

variable "placement_constraint_on_demand_only" {
  description = "Add placement constraint to only run on on-demand instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to the resources"
  type        = map(string)
  default     = {}
}