-- 覆盖 mini.ai 配置，将 inner 前缀从 i 改为 k (Colemak 适配)
return {
  {
    "nvim-mini/mini.ai",
    opts = {
      mappings = {
        around = "a",
        inside = "k", -- 原为 i，改为 k 避免与 Colemak 右移冲突

        around_next = "an",
        inside_next = "kn", -- 原为 in
        around_last = "al",
        inside_last = "kl", -- 原为 il

        goto_left = "g[",
        goto_right = "g]",
      },
    },
  },
}
