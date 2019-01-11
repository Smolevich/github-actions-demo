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

action "Run test container" {
  needs = "Push image to Registry"
  uses = "actions/docker/cli@master"
  env = {
    IMAGE_NAME = "smolevich/test-demo"
    CONTAINER_NAME="test-container"
  }
  args = ["run", "-it", "--name", "$CONTAINER_NAME", "$IMAGE_NAME", "go version"]
}

action "List of all containers" {
  needs = "Run test container"
  uses = "actions/docker/cli@master"
  env = {
    CONTAINER_NAME="test-container"
  }
  args = ["ps", "-a"]   
}

action "aws test" {
  needs = "List of all containers"
  uses = "actions/aws/cli@master"
  args = "lambda help"
}
