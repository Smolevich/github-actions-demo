workflow "New workflow" {
  on = "push"
  resolves = [
    "Push image to Registry"
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
