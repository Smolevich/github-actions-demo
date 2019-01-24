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

action "Save docker image" {
  needs = "Build Docker image"
  uses = "actions/docker/cli@master"
  args = ["save", "--output", "go-image.tar", "smolevich/test-demo"]
}

action "Tag image" {
  needs = "Save docker image"
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

action "Test Shell" {
  needs = "Push image to Registry"
  uses = "actions/bin/sh@master"
  args = ["pwd && tar -xvf go-image.tar -C go-image && ls -ltr"]
}

action "aws deploy" {
  needs = "Test Shell"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_ACCOUNT_ID", "AWS_EXECUTION_ROLE"]
  env = {
    AWS_DEFAULT_REGION = "us-east-1"
  }
  uses = "actions/aws/cli@master"
  args = "lambda update-function-code --region $AWS_DEFAULT_REGION --function-name lambda-handler --zip-file fileb://handler.zip"
}