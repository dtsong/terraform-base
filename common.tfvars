terragrunt = {
  remote_state = {
    backend = "s3"
    config {
      bucket = "project-terraform"
      region = "${get_env("TF_VAR_region", "us-west-2")}"
      key = "${path_relative_to_include()}/terraform.tfstate"
      encrypt = true

      s3_bucket_tags {
        Owner = "Daniel Song"
        name = "Terraform state storage"
        Resource = "s3_bucket"
      }
    }
  }

  terraform {
    extra_arguments "init_args" {
      commands = [
        "init"
      ]

      arguments = [
        "-get-plugins=false"
      ]
    }
  }
}
