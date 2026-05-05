# Functions

# Select directory from Yazi
export def --env yd [...args] {
  let directory = (yazi --cwd-file /dev/stdout)
	if $directory != "" and $directory != $env.PWD {
		cd $directory
	}
}

# Delete current directory
export def --env rd. [...args] {
  let parent = (pwd | path dirname)
  let directory = (pwd | path basename)
  cd $parent
  d rd $directory
}

# Remove one or more directories, safely
export def rd [...patterns: string] {
    let files = $patterns | each { |pattern| glob $pattern } | flatten
    if ($files | length) > 0 {
        d rd ...$files
    } else {
        echo $"No files matching patterns '($patterns | str join ', ')' found."
    }
}

# Make a directory and enter it
export def --env mcd [...args] {
  mkdir $args.0
  cd $args.0
}

# Add file to clipboard
export def pbc [...args] {
  pbcopy < $args.0
}

# Copy absolute path of target (default: cwd) to clipboard
export def pc [target?: string] {
  let path = ($target | default "." | path expand)
  $path | pbcopy
  print $path
}

# Fuzzy-find a project via zoxide and copy its path to clipboard
export def pcf [...args] {
  let path = (^zoxide query --interactive -- ...$args | str trim -r -c "\n")
  $path | pbcopy
  print $path
}

# Open Intellij in current directory
export def --env i. [...args] {
  idea .
}

# Open Intellij in current directory
export def --env c. [...args] {
  idea .
}

export def --env jjp [...args] {
  jj metaedit --update-author --config 'user.email="jimmie.fulton@gmail.com"'
}

export def --env jjw [...args] {
  jj metaedit --update-author --config 'user.email="jimmie@ybor.ai"'
}

export def --env --wrapped jjcl [repo, ...rest] {
  jj git clone --colocate $repo ...$rest
}

export def --env lscolors [...args] {
  let theme = (vivid themes | lines | input list --fuzzy)
  export-env {
    $env.LS_COLORS = (vivid generate $theme)
  }
}

# Claude Code multi-account
export def --wrapped claude-work [...args] {
  with-env { CLAUDE_CONFIG_DIR: ($env.HOME | path join ".claude-work") } { claude --dangerously-skip-permissions ...$args }
}

export def --wrapped claude-personal [...args] {
  with-env { CLAUDE_CONFIG_DIR: ($env.HOME | path join ".claude-personal") } { claude --dangerously-skip-permissions ...$args }
}

export def --wrapped clp [...args] {
  claude-personal ...$args
}

export def --wrapped clw [...args] {
  claude-work ...$args
}

export def --wrapped clpr [...args] {
  claude-personal --resume ...$args
}

export def --wrapped clwr [...args] {
  claude-work --resume ...$args
}
