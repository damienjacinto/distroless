variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "gke_num_nodes" {
  type        = number
  default     = 3
  description = "number of gke nodes"
}

variable "gke_preemptible" {
  type        = bool
  default     = false
  description = "preemptible node"
}

variable "gke_network_name" {
  type        = string
  default     = ""
  description = "vpc name"
}

variable "gke_subnet_name" {
  type        = string
  default     = ""
  description = "subnet name"
}

variable "gke_subnet_secondary_name" {
  type        = string
  default     = ""
  description = "secondary subnet name"
}

variable "gke_services_secondary_name" {
  description = "The name associated with the services subnetwork secondary range"
  type        = string
  default     = "public-services"
}

variable "gke_enable_kubernetes_alpha" {
  type        = bool
  default     = false
  description = "enable kubernetes alpha"
}

variable "public_network_tag" {
  type        = string
  default     = ""
}

variable "private_network_tag" {
  type        = string
  default     = ""
}
