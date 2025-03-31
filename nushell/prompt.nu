
# Prompt

const INSERT_COLOR = '#6272a4'
const NORMAL_COLOR = '#4c566a'
const MULTI_COLOR = '#5e81ac'
const TEXT_COLOR = "#ffffff"
const INSERT = (ansi { fg: $TEXT_COLOR bg: $INSERT_COLOR attr: b })
const INSERT_INVERSE = (ansi {  fg: $INSERT_COLOR })
const NORMAL = (ansi { fg: $TEXT_COLOR bg: $NORMAL_COLOR attr: b })
const NORMAL_INVERSE = (ansi { fg: $NORMAL_COLOR })
const MULTI = (ansi { fg: $TEXT_COLOR bg: $MULTI_COLOR attr: b })
const MULTI_INVERSE = (ansi { fg: $MULTI_COLOR })
const RESET = (ansi reset)
const INDICATOR = ""

export def create_left_prompt [] {
  $env.STARSHIP_SHELL = "nu"
  $env.STARSHIP_CONFIG = ($env.HOME | path join ".config/starship/starship_nu.toml")
  starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

export-env {
  $env.PROMPT_COMMAND = { || create_left_prompt }
  $env.PROMPT_COMMAND_RIGHT = ""
  $env.PROMPT_INDICATOR = ""
  $env.PROMPT_INDICATOR_VI_INSERT =  $"($INSERT) INSERT ($RESET)($INSERT_INVERSE)($INDICATOR)($RESET) "
  $env.PROMPT_INDICATOR_VI_NORMAL = $"($NORMAL) NORMAL ($RESET)($NORMAL_INVERSE)($INDICATOR)($RESET) "
  $env.PROMPT_MULTILINE_INDICATOR = $"($MULTI) MULTI ($RESET)($MULTI_INVERSE)($INDICATOR)($RESET) "
}
