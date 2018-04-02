# Set locale
set --global --export LC_ALL en_US.UTF-8
set --global --export LANG en_US.UTF-8

# Aliases
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Configure NVM
set --global --export NVM_DIR $HOME/.nvm
function nvm
  bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
end