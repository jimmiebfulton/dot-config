{ config, pkgs, lib, ... }:

{
  imports = [ ./test-tmp-sweep.nix ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "jimmie";
  home.homeDirectory = "/Users/jimmie";

  # This value determines the Home Manager release that your configuration is compatible with
  home.stateVersion = "23.11"; # Adjust this to match your chosen version

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Add your home-manager configurations here
  # For example:
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Jimmie Fulton";
        email = "jimmie.fulton@gmail.com";
      };
      credential = {
        helper = "osxkeychain";
      };
    };

    includes = [
      {
        path = "~/.config/git/work.inc";
        condition = "gitdir:~/work/";
      }
      {
        path = "~/.config/git/personal.inc";
        condition = "gitdir:~/personal/";
      }
      {
        path = "~/.config/git/personal.inc";
        condition = "gitdir:~/.config/";
      }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "Jimmie Fulton";
        email = "jimmie.fulton@gmail.com";
      };

      ui = {
        default-command = ["log" "--no-pager"];
        diff-formatter = [
          "difft"
          "--display=side-by-side-show-both"
          "--color=always"
          "$left"
          "$right"
        ];
        diff-editor = ":builtin";
      };

      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
      };

      revsets = {
        immutable_heads = "builtin_immutable_heads() | dev";
      };

      # Replaces the deprecated `jj git push --allow-new`: auto-track any new
      # bookmark on push so plain `jj git push` (the `gpn` alias) keeps
      # creating new remote bookmarks. "glob:*" matches all bookmark names.
      remotes.origin.auto-track-bookmarks = "glob:*";

      aliases = {
        ci = ["commit" "-m" "initial commit"];
        dds = ["diff" "--tool" "difft-s"];
        ddi = ["diff" "--tool" "difft-i"];
        ddd = ["diff" "--tool" "delta"];
        di = ["diff" "--tool" "idea"];
        sm = ["b" "s" "main"];
        sme = ["b" "s" "main" "-r" "@"];
        smeb = ["b" "s" "main" "-r" "@" "-B"];
        smp = ["b" "s" "main" "-r" "@-"];
        smpb = ["b" "s" "main" "-r" "@-" "-B"];
        smb = ["b" "s" "main" "-B"];
        gc = ["git" "clone" "--colocate"];
        gf = ["git" "fetch"];
        gp = ["git" "push"];
        gpa = ["git" "push" "--all"];
        rao = ["git" "remote" "add" "origin"];
        rro = ["git" "remote" "remove" "origin"];
        rd = ["rebase" "-d" "dev"];
        rm = ["rebase" "-d" "main"];
        # Move nearest ancestor bookmark forward smartly:
        #   If @ has both changes and a description, tug to @
        #   Otherwise, tug to @-
        #   Optional $1: bookmark name to move (defaults to closest_bookmark(@))
        tug = ["util" "exec" "--" "sh" "-c"
          ''
            has_content=$(jj log --no-graph -r '@ & ~empty() & ~description(exact:"")' -T 'change_id' 2>/dev/null)
            TARGET=$([ -n "$has_content" ] && echo '@' || echo '@-')
            if [ -n "$1" ]; then
              jj bookmark move --from "$1" --to "$TARGET"
            else
              jj bookmark move --from 'closest_bookmark(@)' --to "$TARGET"
            fi
          ''
          "jj-tug"
        ];
        # Move nearest ancestor bookmark to exactly where specified (precise)
        tugto = ["bookmark" "move" "--from" "closest_bookmark(@)"];
        # On-demand signature markers: a normal `jj log` plus [✓︎]/[?]/[x].
        # Verification shells out per commit, so this stays opt-in rather than
        # living in ui.show-cryptographic-signatures. Takes any `jj log` args.
        sigs = ["log" "--config" "ui.show-cryptographic-signatures=true"];
        # Policy audit: prints ONLY unsigned commits, nothing for signed ones,
        # so no output means clean. Presence check, so no crypto shell-out.
        # Setting revsets.log (not `-r`) keeps `-r` overriding rather than
        # unioning, so bare `jj unsigned` audits mine() and `jj unsigned -r X`
        # narrows to X.
        unsigned = ["log" "--no-graph" "--config" "revsets.log=mine()" "-T" "unsigned_only"];
      };

      colors = {
        "commit_id prefix" = { fg = "blue"; bold = false; };
        "change_id prefix" = { fg = "red"; bold = true; };
        "working_copy change_id" = { fg = "yellow"; underline = true; };
      };

      template-aliases = {
        "format_short_id(id)" = "id.shortest(5)";

        # Emits nothing at all for signed commits, so the output is exactly the
        # set of violations. Presence check only — fast, no ssh-keygen shell-out.
        unsigned_only = ''
          if(self.signature(), "", separate(" ",
            format_short_id(commit_id),
            author.timestamp().format("%Y-%m-%d"),
            author.email().local(),
            description.first_line()
          ) ++ "\n")
        '';
      };

      git = {
        private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
      };

      signing = {
        # We sign with ssh, but GitHub signs its own merge/squash commits with
        # GPG. jj shells out to bare `gpg` to verify those, and gpg is not on
        # PATH here — without this, `jj sigs` renders a "Failed to run GPG"
        # error string in place of the marker on every GitHub-merged commit.
        # Mirrors gpg.openpgp.program in the generated gitconfig.
        backends.gpg.program = "${pkgs.gnupg}/bin/gpg";
      };

      templates = {
        git_push_bookmark = ''"jfulton/feature-" ++ change_id.short()'';
      };

      merge-tools = {
        difft-s = {
          program = "difft";
          diff-args = [
            "--display=side-by-side-show-both"
            "--color=always"
            "$left"
            "$right"
          ];
        };
        difft-i = {
          program = "difft";
          diff-args = ["--display=inline" "--color=always" "$left" "$right"];
        };
        araxis = {
          program = "/Users/jimmie/bin/araxis-merge";
          diff-args = ["-wait" "$left" "$right"];
          merge-args = ["-wait" "-merge" "-3" "-a2" "$left" "$base" "$right" "$output"];
        };
        delta = {
          program = "delta";
          diff-args = [
            "--blame-code-style=syntax"
            "--commit-decoration-style=box"
            "--diff-so-fancy"
            "$left"
            "$right"
          ];
        };
        idea = {
          program = "/Users/jimmie/Applications/IntelliJ IDEA.app/Contents/MacOS/idea";
          diff-args = ["diff" "$left" "$right"];
          merge-args = ["merge" "$left" "$right" "$base" "$output"];
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        addKeysToAgent = "yes";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_personal";
        identitiesOnly = true;
      };
      "github.com-work" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_work";
        identitiesOnly = true;
      };
    };
  };

  home.file.".config/git/work.inc".text = ''
    [user]
        email = jimmie@ybor.ai
        signingkey = /Users/jimmie/.ssh/id_ed25519_work.pub

    [core]
        sshCommand = "ssh -F /dev/null -i ~/.ssh/id_ed25519_work"

    [gpg]
        format = ssh

    [gpg "ssh"]
        allowedSignersFile = ~/.config/git/allowed_signers

    [commit]
        gpgsign = true
  '';

  home.file.".config/jj/conf.d/work.toml".text = ''
    --when.repositories = ["~/work"]

    [user]
    name = "Jimmie Fulton"
    email = "jimmie@ybor.ai"

    [signing]
    backend = "ssh"
    key = "~/.ssh/id_ed25519_work"
    behavior = "own"

    [signing.backends.ssh]
    # Without this, `jj sigs` reports every signature as "unknown" ([?]) because
    # `ssh-keygen -Y verify` has no principals to check against. Same file git
    # uses via gpg.ssh.allowedSignersFile in work.inc. Costs nothing when `jj
    # sigs` is not the command being run.
    allowed-signers = "~/.config/git/allowed_signers"
  '';

  # TODO: https://www.youtube.com/watch?v=XuQVbZ0wENE


  programs.zsh = {
    enable = true;
    envExtra = ''
# Your .zshenv content goes here
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR=nvim
export XDG_CONFIG_HOME="/Users/jimmie/.config"
export PNPM_HOME="/Users/jimmie/bin"
    '';
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
# Ensure nix-installed tools are available in bash
export EDITOR=nvim
export XDG_CONFIG_HOME="/Users/jimmie/.config"
export PNPM_HOME="/Users/jimmie/bin"

# Source nix-daemon if available
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
    '';
  };

  programs.nushell = {
    enable = true;
    # Load the local.nu file which contains sensitive environment variables
    extraConfig = ''
      # Source local configuration if it exists
      if ($"($env.HOME)/.config/nushell/local.nu" | path exists) {
        source ~/.config/nushell/local.nu
      }
    '';
  };

  # Set environment variables for all shells
  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "/Users/jimmie/.config";
    PNPM_HOME = "/Users/jimmie/bin";
  };

  # Add paths for all shells (matching nushell path.nu)
  home.sessionPath = [
    "/usr/local/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.cargo/bin"
    "$HOME/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
    "/opt/homebrew/bin"
    "$HOME/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "$HOME/.orbstack/bin"
  ];

  # Bootstrap Claude Code native installer (self-manages updates afterward)
  home.activation.installClaudeCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.local/bin/claude" ]; then
      ${pkgs.curl}/bin/curl -fsSL https://claude.ai/install.sh | ${pkgs.bash}/bin/bash
    fi
  '';

  # Additional home configurations go here
}
