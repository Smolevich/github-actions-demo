workflow "New workflow" {
  on = "push"
  resolves = [
    "Push image to Registry"
  ]
}

action "Docker Registry" {
  uses = "actions/docker/login@76ff57a6c3d817840574a98950b0c7bc4e8a13a8"
  secrets = ["GITHUB_TOKEN"]
}

action "Build docker image" {
  uses = "actions/docker/cli@master"
  args = "ls -alt && build -t smolevich/github-actions-demo ."
}

action "Push image to Registry" {
  needs = "Build docker image"
  uses = "actions/docker/cli@master"
  args = "tag $GITHUB_REF $GITHUB_SHA"
}
