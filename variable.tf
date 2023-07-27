    # default value for the variable location
 variable "internalport" {
   type = number
   description = 80
   default = 80
}

 # default value for the variable location
 variable "externalport" {
   type = number
   description = 8082
   default = 8084
}
 # default value for the variable location
 variable "name" {
   type = string
   description = "dockerngnxtestterraform"
   default = "docker-terraform-test"
}