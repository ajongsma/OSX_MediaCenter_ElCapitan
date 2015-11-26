brew install fish

# add Fish to /etc/shells
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells

# Change default shell to Fish
chsh -s /usr/local/bin/fish

# Create the Fish config directory
mkdir -p ~/.config/fish

# Create initial config file
#vim ~/.config/fish/config.fish

# add /usr/local/bin to the PATH environment variable
#set -g -x PATH /usr/local/bin $PATH

fish_config

# Disable Fish welcome greeting
#echo "set -g -x fish_greeting ''" >> ~/.config/fish/config.fish
