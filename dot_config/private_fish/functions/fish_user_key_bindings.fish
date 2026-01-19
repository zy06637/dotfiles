# Colemak vim 键位配置 for Fish shell
# 基于 nvim KEYMAPS.md
#
# 导航布局:
#       u
#       ↑
#   n ← · → i
#       ↓
#       e

function fish_user_key_bindings
    # 先加载默认 vi 键位
    fish_vi_key_bindings

    # ============================================
    # Normal 模式 - 核心导航
    # ============================================
    # neiu 菱形布局
    bind -M default n backward-char        # n = 左 (原 h)
    bind -M default e down-or-search       # e = 下 (原 j)
    bind -M default u up-or-search         # u = 上 (原 k)
    bind -M default i forward-char         # i = 右 (原 l)

    # ============================================
    # Normal 模式 - 快速导航
    # ============================================
    # 行首/行尾
    bind -M default N beginning-of-line    # N = 行首 (原 0)
    bind -M default I end-of-line          # I = 行尾 (原 $)

    # 词尾
    bind -M default h forward-word         # h = 词尾 (原 e)

    # ============================================
    # Normal 模式 - 模式切换
    # ============================================
    bind -M default k repaint-mode         # 占位，下面重新绑定
    # k 进入插入模式 - 使用 force-repaint 后切换
    bind -M default k 'set fish_bind_mode insert; commandline -f repaint'
    # l 撤销
    bind -M default l undo                 # l = 撤销 (原 u)

    # ============================================
    # Normal 模式 - 搜索
    # ============================================
    bind -M default = history-search-forward   # = = 下一个 (原 n)
    bind -M default - history-search-backward  # - = 上一个 (原 N)

    # ============================================
    # Visual 模式 - 导航
    # ============================================
    bind -M visual n backward-char
    bind -M visual e down-or-search
    bind -M visual u up-or-search
    bind -M visual i forward-char
    bind -M visual N beginning-of-line
    bind -M visual I end-of-line
    bind -M visual h forward-word

    # ============================================
    # 恢复被占用的原功能
    # ============================================
    # 原 n (next search) 改用 =
    # 原 e (word end) 改用 h
    # 原 u (undo) 改用 l
    # 原 i (insert) 改用 k
end
