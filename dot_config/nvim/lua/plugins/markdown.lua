return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
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
