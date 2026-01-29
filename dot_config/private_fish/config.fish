# 关闭 greeting
set -g fish_greeting

# 语言 & 编辑器
set -x LANG en_US.UTF-8
set -x EDITOR nvim

# 代理
set -x http_proxy http://127.0.0.1:6152
set -x https_proxy $http_proxy

# PATH（fish 推荐方式）
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.antigravity/antigravity/bin

# zoxide（fish 版本，不用 eval）
zoxide init fish | source

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function cheat
    curl cheat.sh/$argv[1]
end

# vim mode
fish_vi_key_bindings

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# ruby
set -gx LDFLAGS -L/opt/homebrew/opt/ruby/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/ruby/include

# shortcuts
alias lg='lazygit'

# sqlit config 避免macOS+python多线程fork问题
set -Ux OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES
