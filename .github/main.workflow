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

action "Build docker image" {
  needs = "Login to Registry"
  uses = "actions/docker/cli@master"
  args = ["build", "-t", "github-actions-demo", "."]
}

action "Push image to Registry" {
  needs = "Build docker image"
  uses = "actions/docker/cli@master"
  args = "tag smolevich/test-demo $GITHUB_SHA"
}
