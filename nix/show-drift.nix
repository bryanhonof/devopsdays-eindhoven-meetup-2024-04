{
  writeShellApplication,
  opentofu,
  tf-summarize,
  gitFull,
  bash,
}: let
  f = builtins.path {
    path = ../scripts/show-drift.sh;
    name = "show-drift";
  };
in
  writeShellApplication {
    name = "show-drift";
    runtimeInputs = [opentofu tf-summarize gitFull bash];
    text = builtins.readFile f;
  }
