-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 显示 markdown 中的标记符号（如反引号 `）
-- 0 = 显示所有字符, 1 = 用简洁符号替代, 2 = 完全隐藏
vim.opt.conceallevel = 0

-- 软换行设置 (默认关闭，用 <Leader>tw 切换)
vim.opt.wrap = false
vim.opt.linebreak = true   -- 在单词边界换行，而不是字符中间
vim.opt.breakindent = true -- 换行后保持缩进
