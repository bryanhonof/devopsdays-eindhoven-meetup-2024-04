{
  writeShellApplication,
  awscli2,
  bash,
}: let
  f = builtins.path {
    path = ../scripts/aws-switch.sh;
    name = "aws-switch";
  };
in
  writeShellApplication {
    name = "aws-switch";
    runtimeInputs = [awscli2 bash];
    text = builtins.readFile f;
  }
