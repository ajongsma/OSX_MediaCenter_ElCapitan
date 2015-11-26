brew install fish

# add Fish to /etc/shells
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells

# Change default shell to Fish
chsh -s /usr/local/bin/fish
