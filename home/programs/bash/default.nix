{
 programs.bash = {
      enable = true;
      historyFileSize = 100000;
      historySize = 100000;
      initExtra = ''
        # If not running interactively, don't do anything
        [[ $- != *i* ]] && return
        # get current status of git repo
        function parse_git_dirty {
          STATUS="$(git status 2> /dev/null)"
          if [[ $? -ne 0 ]]; then printf "-"; return; else printf "["; fi
          if echo $STATUS | grep -c "renamed:"         &> /dev/null; then printf ">"; else printf ""; fi
          if echo $STATUS | grep -c "branch is ahead:" &> /dev/null; then printf "!"; else printf ""; fi
          if echo $STATUS | grep -c "new file::"       &> /dev/null; then printf "+"; else printf ""; fi
          if echo $STATUS | grep -c "Untracked files:" &> /dev/null; then printf "?"; else printf ""; fi
          if echo $STATUS | grep -c "modified:"        &> /dev/null; then printf "*"; else printf ""; fi
          if echo $STATUS | grep -c "deleted:"         &> /dev/null; then printf "-"; else printf ""; fi
          printf "]"
        }
        parse_git_branch() {
          # Long form
          git rev-parse --abbrev-ref HEAD 2> /dev/null
          # Short form
          # git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'
        }
        __export_ps1() {
          if [[ -z $IN_NIX_SHELL ]]
          then
            export PS1="\n\[[\033[32m\]\W\033[00m\]] (\033[33m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty)\[\033[00m\])\] \n\[[\e[36m\]\u@\h\[\e[0m\]]> \]"
          else
            export PS1="\n\[[\033[32m\]\W\033[00m\]] (\033[33m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty)\[\033[00m\])\] \n\[[\e[36m\]nix-shell:\u@\h\[\e[0m\]]> \]"
          fi
        }
        __export_ps1
        PROMPT_COMMAND='__export_ps1'

        runInOwnNamespace() {
            unshare -c --fork --pid --mount-proc "$1"
        }
        '';
      shellAliases = {
        g = "git";
	      god = "git rebase -i --root";
        cp = "cp -iv";
	      ls = "ls -FG";
	      ll = "ls -FGlAhp";
	      mv = "mv -iv";
	      rm = "rm -iv";
        nupdate = "nix flake update";
        nswitch = "nixos-rebuild switch --use-remote-sudo --flake .#herulume";
      };
    };
}
