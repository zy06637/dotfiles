#!/usr/bin/env fish

# Install fisher if not present
if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
end

# Install plugins from fish_plugins
fisher update
