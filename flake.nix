{
  description = "Example Nix flake for DevOpsDays Eindhoven Meetup";

  # Flakes can have inputs, or dependencies on other (non-)flake sources
  # This will be locked in the `flake.lock` file, so that we
  # have a high chance of reproducing the same flake
  inputs = {
    # Defines that we depend on nixpkgs version "nixos-23.11"
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # Defines that we depend on cachix/pre-commit-hooks
    # and override the nixpkgs input to follow the nixpkgs input we defined above
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The flake has outputs, which are the actual things that are produced
  # This can be packages, development shells, applications, etc.
  # Notice how we define that `outputs` is a function that takes `self` and `nixpkgs`,
  # and returns a set of attributes
  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
  }: let
    # Define the system we are building for, currently it's not possible to pass
    # this as an agument to the flake, so we hardcode it here
    system = "aarch64-darwin";
    # Import nixpkgs with the configuration we want, in this case we allow unfree packages
    # since we depend on 1password for the demo
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [];
    };
  in {
    # Make everyone slightly angry by using a formatter
    formatter."${system}" = pkgs.alejandra;

    # The packages this flake exposes
    packages."${system}" = {
      default = self.packages."${system}".greetings;
      "aws-switch" = pkgs.callPackage ./nix/aws-switch.nix {};
      "show-drift" = pkgs.callPackage ./nix/show-drift.nix {};
      "greetings" = pkgs.callPackage ./nix/greetings.nix {};
    };

    # A development shell that includes some packages
    devShells."${system}".default = pkgs.mkShell {
      packages = [
        pkgs._1password
        pkgs.opentofu
        pkgs.tf-summarize
        pkgs.pre-commit
        self.packages."${system}".aws-switch
        self.packages."${system}".show-drift
      ];
      shellHook =
        ''
          export ENV="dev"
          export HCLOUD_TOKEN="$(op read op://Private/hetzner-cloud/credential)"
        ''
        + self.checks.${system}.pre-commit-check.shellHook;
    };

    # Check that the pre-commit hooks are working
    checks."${system}" = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          shellcheck.enable = true;
          shfmt.enable = true;
          terraform-format.enable = true;
        };
      };
    };
  };
}
