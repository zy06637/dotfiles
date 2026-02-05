return {
  "mg979/vim-visual-multi",
  branch = "master",
  keys = {
    { "<C-n>", mode = { "n", "v" }, desc = "Select next occurrence" },
    { "<C-Down>", mode = { "n", "v" }, desc = "Create cursor down" },
    { "<C-Up>", mode = { "n", "v" }, desc = "Create cursor up" },
  },
  config = function()
    -- 使用默认配置
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>", -- 选择下一个匹配
      ["Find Subword Under"] = "<C-n>", -- 选择下一个子词
      ["Skip Region"] = "<C-x>", -- 跳过当前匹配
      ["Remove Region"] = "<C-p>", -- 移除当前选择
    }
  end,
}
