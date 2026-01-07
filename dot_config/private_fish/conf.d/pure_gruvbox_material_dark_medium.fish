# Pure × Gruvbox Material (Dark, Medium)
# Palette (approx):
# bg 282828 | fg d4be98 | red ea6962 | green a9b665 | yellow d8a657
# blue 7daea3 | purple d3869b | aqua 89b482 | gray 7c6f64

# ---- Prompt symbol ----
set -g pure_color_prompt 7daea3 # blue/aqua: 输入焦点
set -g pure_color_prompt_on_error ea6962 # red: 错误强提醒

# ---- Current directory ----
set -g pure_color_path 89b482 # aqua/green: 路径
set -g pure_color_path_basename a9b665 # green: 最后一级目录更突出

# ---- Command status / execution time ----
set -g pure_color_command_duration d8a657 # yellow: 耗时提示
set -g pure_color_success a9b665 # green: 成功
set -g pure_color_error ea6962 # red: 失败

# ---- Git ----
set -g pure_color_git_branch d3869b # purple: 分支名
set -g pure_color_git_dirty d8a657 # yellow: working tree dirty
set -g pure_color_git_stash ea6962 # red: stash 强提醒（也可改成 gray）
set -g pure_color_git_unpulled_commits 7daea3 # blue: behind
set -g pure_color_git_unpushed_commits a9b665 # green: ahead

# ---- Secondary / subtle ----
set -g pure_color_jobs 7c6f64 # gray: 后台任务数（不抢眼）
set -g pure_color_host 7c6f64 # gray: 主机/SSH（不抢眼）
set -g pure_color_user 7c6f64 # gray: 用户名（不抢眼）

# ---- Optional: make git indicators a bit more readable ----
# set -g pure_color_git_arrow        d4be98  # fg
# set -g pure_color_git_separator    7c6f64  # gray
