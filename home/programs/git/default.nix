let
  gitConfig = {
    core.editor = "vim";
    pull.rebase = false;
    github.user = "herulume";
    commit.verbose = true;
    commit.template = "~/dev/tardis/home/programs/git/commit-msg-tpl";
  };
in
{
  programs.git = {
    enable = true;
    extraConfig = gitConfig;
    ignores = [
      "*.direnv"
      "*hie.yaml" # ghcide files
      "\#*\#"
    ];
    userEmail = "herulume@gmail.com";
    userName = "Eduardo Jorge";
    signing.key = null;
    # signing.signByDefault = true;
  };
}
