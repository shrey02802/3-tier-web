region = "us-east-1"



ecr_repo_url = "302263055592.dkr.ecr.us-east-1.amazonaws.com/backend-api"


tags = {
  Project = "3-tier-app"
  Env     = "dev"
  Project = "my-app"
}
project = "my-app"

#alb_private_subnet = "subnet-0b6cefee9134d8c2d"


alb_dns_name = "internal-my-alb-1234567890.us-east-1.elb.amazonaws.com"


DB_NAME  = "mydb"
DB_USER = "admin"
DB_PASS = "StrongPass123"
DB_HOST = "mydb.c654ug8ayk6d.us-east-1.rds.amazonaws.com"