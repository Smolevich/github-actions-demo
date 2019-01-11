workflow "New workflow" {
  on = "push"
  resolves = [
    "aws test"
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

action "Tag image" {
  needs = "Build Docker image"
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

action "Test go application" {
  needs = "Tag image"
  uses = "./.github/actions/go"
  runs = "sh -l -c"
  args = ["go version && go get -v ./.github/actions/go/lambda-app && go build"]  
}

action "aws test" {
  needs = "Test go application"
  uses = "actions/aws/cli@master"
  args = "lambda help"
}
