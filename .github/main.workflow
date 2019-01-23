workflow "New workflow" {
  on = "push"
  resolves = [
    "aws deploy"
  ]
}

action "Login to Registry"{
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Build Docker image" {
  needs = "Login to Registry"
  uses = "actions/docker/cli@master"
  args = ["build", "-t", "smolevich/test-demo", "."]
}

action "Save docker imaage" {
  needs = "Build Docker image"
  uses = "actions/docker/cli@master"
  args = ["save", "-t", "--output", "go-image.tar", "smolevich/test-demo"]
}

action "Tag image" {
  needs = "Save docker imaage"
  uses = "actions/docker/tag@master"
  env = {
    IMAGE_NAME = "smolevich/test-demo"
  }
  args = ["$IMAGE_NAME", "$GITHUB_SHA"]
}

action "Push image to Registry" {
  needs = "Tag image"
  uses = "actions/docker/cli@master"
  env = {
    IMAGE_NAME = "smolevich/test-demo"
  }
  args = ["push", "$IMAGE_NAME"]
}

action "aws deploy" {
  needs = "Push image to Registry"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_ACCOUNT_ID", "AWS_EXECUTION_ROLE"]
  env = {
    AWS_DEFAULT_REGION = "us-east-1"
  }
  uses = "actions/aws/cli@master"
  args = "lambda update-function-code --region $AWS_DEFAULT_REGION --function-name lambda-handler --zip-file fileb://handler.zip"
}