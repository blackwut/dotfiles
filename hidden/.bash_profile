# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Enable some Bash features when possible:
# `autocd`: e.g. `**/qux` will enter `./foo/bar/baz/qux`
# `cdspell`: autocorrect typos in path names when using `cd`
# `cmdhist: save multi-line commands in history as single line
# `dirspell`: bash will perform spelling corrections on directory names
# `globstar`: recursive globbing with `**` is enabled
# `histappend`: append to the same history file when using multiple terminals
# `nocaseglob`: when typing tab to autocomplete, do a case-insensitive search
# `no_empty_cmd_completion`: attempt to search the PATH for possible completions when completion is attempted on an empty line
# `checkwinsize`: checks the window size after each command and, if necessary, updates the values of LINES and COLUMNS
for option in autocd cdspell cmdhist dirspell globstar histappend nocaseglob no_empty_cmd_completion checkwinsize; do
  tmp="$(shopt -q "$option" 2>&1 > /dev/null | grep "invalid shell option name")"
  if [ '' == "$tmp" ]; then
    shopt -s "$option"
  fi
done

# Add tab completion for many Bash commands
# if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
# 	source "$(brew --prefix)/share/bash-completion/bash_completion";
#     echo "gne"
# elif [ -f /etc/bash_completion ]; then
# 	source /etc/bash_completion;
#     echo "gna"
# fi;

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal" killall;
