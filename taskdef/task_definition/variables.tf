variable "family" {
  description = "A unique name for your task defintion."
  type        = string
}

variable "container_definition" {
  description = "A list of valid container definitions provided as a single valid JSON document."
  type        = string
}

variable "task_role_arn" {
  description = "The Amazon Resource Name for an IAM role for the task"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  description = "The Amazon Resource Name for an execution role for the task"
  type        = string
  default     = ""
}

variable "volume" {
  description = "Volume block map with 'name' and 'host_path'."
  type        = map(string)
  default     = {}
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task"
  type        = string
  default     = "bridge"
}

variable "volumes" {
  type = map(object({
    name = string
    host_path = string
  }))
  default = {
  }
}

variable "placement_constraint_on_demand_only" {
  description = "Add placement constraint to only run on on-demand instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {}
}
