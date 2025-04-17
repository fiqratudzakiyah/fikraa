# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  services.docker.enable = true;
  services.postgres.enable = false;
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.gnumake
    pkgs.python310
    pkgs.python310Packages.pip
  ];

  # Sets environment variables in the workspace
  env = {
    # You can get a Gemini API key through the IDX Integrations panel to the left!
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "cweijan.vscode-mysql-client2"
      "cweijan.dbclient-jdbc"
    ];

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        default.openFiles = [
          "Makefile"
        ];
        # Example: install JS dependencies from NPM
        setup = ''
          export $(grep -v '^#' .env | xargs)
          python -m venv .venv
          source .venv/bin/activate
          pip install -r requirements.txt
        '';
      };
      # Runs when the workspace is (re)started
      onStart = {
        # typescript-build = "tsc";
      };
    };

    # Enable previews
    previews = {
      enable = true;
      previews = {
        # web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
        #   command = ["npm" "run" "dev"];
        #   manager = "web";
        #   env = {
        #     # Environment variables to set for your server
        #     PORT = "$PORT";
        #   };
        # };
      };
    };
  };
}
