-- 覆盖 snacks.nvim scope 配置，将 inner 前缀从 i 改为 k (Colemak 适配)
return {
  {
    "folke/snacks.nvim",
    opts = {
      scope = {
        keys = {
          textobject = {
            kk = {
              min_size = 2,
              edge = false,
              cursor = false,
              treesitter = { blocks = { enabled = false } },
              desc = "inner scope",
            },
            ak = {
              cursor = false,
              min_size = 2,
              treesitter = { blocks = { enabled = false } },
              desc = "full scope",
            },
            -- 禁用原来的 ii 和 ai
            ii = false,
            ai = false,
          },
        },
      },
    },
  },
}
