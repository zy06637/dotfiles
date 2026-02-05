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
      custom_surroundings = {
        -- Markdown: b=加粗, k=斜体, x=删除线, c=行内代码, C=代码块
        b = {
          input = { "%*%*().-()%*%*" },
          output = { left = "**", right = "**" },
        },
        k = {
          input = { "%*().-()%*" },
          output = { left = "*", right = "*" },
        },
        x = {
          input = { "~~().-()~~" },
          output = { left = "~~", right = "~~" },
        },
        c = {
          input = { "`()`.-`()`" },
          output = { left = "`", right = "`" },
        },
        C = {
          input = { "```%w*\n()", "()\n```" },
          output = { left = "```\n", right = "\n```" },
        },
      },
    },
  },
}
