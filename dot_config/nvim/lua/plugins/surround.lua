return {
  {
    "nvim-mini/mini.surround",
    version = false,
    opts = {
      mappings = {
        add = "gsa", -- 添加 surround
        delete = "gsd", -- 删除 surround
        replace = "gsr", -- 替换 surround
        find = "gsf", -- 查找右侧 surround
        find_left = "gsF", -- 查找左侧 surround
        highlight = "gsh", -- 高亮 surround
        update_n_lines = "gsn", -- 更新搜索行数
      },
    },
  },
}
