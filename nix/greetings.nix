{
  writeShellApplication,
  hello,
  cowsay,
  lolcat,
}: let
  f = builtins.path {
    path = ../scripts/greetings.sh;
    name = "greetings";
  };
in
  writeShellApplication {
    name = "greetings";
    runtimeInputs = [hello cowsay lolcat];
    text = builtins.readFile f;
  }
