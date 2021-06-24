provider "aws" {
  allowed_account_ids = ["499015291023"]
  region = "eu-west-2"
}



module "webserver_cluster"{
  source = "../../../modules/services/webserver-cluster"

  cluster_name="webservers-stage"
  instance_type="t2.micro"
  min_size=2
  max_size=4
}
