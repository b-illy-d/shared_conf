#compdef tw
###-begin-tw-completions-###
#
# yargs command completion script
#
# Installation: tw completion >> ~/.zshrc
#    or tw completion >> ~/.zprofile on OSX.
#
_tw_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" tw --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _tw_yargs_completions tw
###-end-tw-completions-###

