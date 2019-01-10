workflow "New workflow" {
  on = "push"
  resolves = [
    "Push image to Registry"
  ]
}

action "Build docker image" {
  uses = "actions/docker/cli@master"
  args = ["build", "-t", "github-actions-demo", "."]
}

action "Push image to Registry" {
  needs = "Build docker image"
  uses = "actions/docker/cli@master"
  args = "tag $GITHUB_REF $GITHUB_SHA"
}
