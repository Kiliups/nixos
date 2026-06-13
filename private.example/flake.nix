{
  description = "Example private host data";

  outputs = _: {
    darwinHosts = {
      macbook = {
        username = "user";
        name = "Public User";
        email = "user@example.invalid";
        privateName = "Public User";
        privateEmail = "user@example.invalid";
        dirs = {
          projects = "~/projects";
          private = "~/private";
          workScripts = "~/projects/work-scripts";
        };
        system = "aarch64-darwin";
      };
    };

    nixosHosts = {
      laptop = {
        type = "laptop";
        username = "user";
        name = "Public User";
        email = "user@example.invalid";
        system = "x86_64-linux";
        modules = [ ./laptop/hardware-configuration.nix ];
      };

      workstation = {
        type = "workstation";
        username = "user";
        name = "Public User";
        email = "user@example.invalid";
        system = "x86_64-linux";
        modules = [ ./workstation/hardware-configuration.nix ];
      };
    };
  };
}
