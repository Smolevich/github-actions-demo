workflow "New workflow" {
  on = "push"
  resolves = ["Docker Registry"]
}

action "Docker Registry" {
  uses = "actions/docker/login@76ff57a6c3d817840574a98950b0c7bc4e8a13a8"
  secrets = ["GITHUB_TOKEN"]
}
