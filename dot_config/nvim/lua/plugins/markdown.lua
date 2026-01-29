return {
  -- 自动处理 Markdown 列表序号
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text" },
    init = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text" }
      vim.g.bullets_renumber_on_change = 1 -- 插入/删除时自动重新编号
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    config = function()
      -- 自定义函数：在新窗口打开浏览器
      vim.cmd([[
        function! OpenMarkdownPreviewInNewWindow(url)
          silent execute '!open -na "Google Chrome" --args --new-window ' . shellescape(a:url)
        endfunction
      ]])
      vim.g.mkdp_browserfunc = "OpenMarkdownPreviewInNewWindow"
    end,
  },
}
