workflow "New workflow" {
  on = "push"
  resolves = ["action-build", "action-push"]
}

action "Docker Registry" {
  uses = "actions/docker/login@76ff57a6c3d817840574a98950b0c7bc4e8a13a8"
  secrets = ["GITHUB_TOKEN"]
}

action "action-build" {
  uses = "actions/docker/cli@master"
  args = "ls -alt && build -t smolevich/github-actions-demo ."
}

action "action-push" {
  uses = "actions/docker/cli@master"
  args = "tag"
}
