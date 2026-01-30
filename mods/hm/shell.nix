# hm/shell: configure shell and tools
{...}: {
  home.shell.enableBashIntegration = true;

  programs.bash = {
    enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      pgrep = "pgrep --color=auto";

      ll = "ls -l";
      gs = "git status";
      gl = "git log --graph --all --decorate";
    };

    historyControl = ["erasedups" "ignoreboth"];
    initExtra = ''
      # Load __git_ps1 bash command.
      . ~/.nix-profile/share/git/contrib/completion/git-prompt.sh
      # Also load git command completions for bash.
      . ~/.nix-profile/share/git/contrib/completion/git-completion.bash

      export PS1='\[\033[38;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] $\[\033[00m\] ';
      export TERM=xterm-256color
    '';
  };

  programs.dircolors.enable = true;
  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
  };

  programs.bat.enable = true;
  programs.btop.enable = true;

  programs.git = {
    enable = true;

    lfs.enable = true;
    settings = {
      credential.helper = "store";

      tag.sort = "version:refname";
      versionsort.suffix = "-";
    };
  };
}
