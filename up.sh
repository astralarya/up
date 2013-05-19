# up
# Jump to parent directory
#
# Copyright (C) 2013 Mara Kim
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see http://www.gnu.org/licenses/.


### USAGE ###
# Source this file in your shell's .*rc file


up() {
if [ "$1" ]
then
 if [ "$1" = '/' ]
 then
  # special case for root
  cd /
  return $?
 else
  local front="${PWD%/$1/*}/"
  local back="${PWD#$front}"
  if [ "${back%%/*}" -a "${back%%/*}" != "$back" ]
  then
   cd "$front${back%%/*}"
   return $?
  else
   return 1
  fi
 fi
else
 cd ..
 return $?
fi
}

# tab completion generic
_up() {
    local word="$3"
    local IFS='/'
    local compreply 
    compreply=( ${PWD#/} )

    # generate reply 
    local filter
    for completion in "${compreply[@]}"
    do
        if [ -z "${completion/#$word*}" -a "${completion/#$word}" ]
        then
            filter+=("$completion")
        fi
    done
    COMPREPLY=( "${filter[@]}" )
}

# tab completion bash
_up_bash() {
    # call generic tab completion function
    _up "$COMP_CWORD" "${COMP_WORDS[@]}"
}

# tab completion zsh
_up_zsh() {
    # call generic tab completion function
    _up "$COMP_CWORD" "${COMP_WORDS[@]}"
    COMPREPLY=( "${(q)COMPREPLY[@]}" )
}

# setup tab completion
if [ "$ZSH_VERSION" ]
then
    \autoload -U +X bashcompinit && \bashcompinit
    \complete -F _up_zsh up
else
    \complete -F _up_bash up
fi
