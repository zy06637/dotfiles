-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Colemak 键位配置
-- 菱形导航布局:
--       u (上)
--    n     i (右)
--       e (下)

local map = vim.keymap.set
local del = vim.keymap.del

-- 删除 LazyVim 冲突的默认键位 (使用 pcall 避免映射不存在时报错)
pcall(del, "n", "<C-h>")
pcall(del, "n", "<C-j>")
pcall(del, "n", "<C-k>")
pcall(del, "n", "<C-l>")

-- ==================== 核心导航 ====================
map({ "n", "v" }, "u", "k", { desc = "上移" })
map({ "n", "v" }, "n", "h", { desc = "左移" })
map({ "n", "v" }, "e", "j", { desc = "下移" })
map({ "n", "v" }, "i", "l", { desc = "右移" })
map({ "n", "v" }, "gu", "gk", { desc = "软换行上移" })
map({ "n", "v" }, "ge", "gj", { desc = "软换行下移" })

-- 快速导航
map({ "n", "v" }, "U", "5k", { desc = "快速上移5行" })
map({ "n", "v" }, "E", "5j", { desc = "快速下移5行" })
map({ "n", "v" }, "N", "0", { desc = "行首" })
map({ "n", "v" }, "I", "$", { desc = "行尾" })
map({ "n", "v" }, "h", "e", { desc = "词尾" })
map({ "n", "v" }, "W", "5w", { desc = "前进5个单词" })
map({ "n", "v" }, "B", "5b", { desc = "后退5个单词" })

-- 滚动
map({ "n", "v" }, "<C-U>", "5<C-y>", { desc = "向上滚动视图" })
map({ "n", "v" }, "<C-E>", "5<C-e>", { desc = "向下滚动视图" })

-- ==================== 模式切换 ====================
map("n", "l", "u", { desc = "撤销" })
map("n", "k", "i", { desc = "插入模式" })
map("n", "K", "I", { desc = "行首插入" })

-- ==================== 插入模式快捷键 ====================
map("i", "<C-a>", "<End>", { desc = "移至行末" })
map("i", "<C-u>", "<C-o>d$", { desc = "删除至行末" })

-- ==================== 可视模式快捷键 ====================
map("v", "Y", '"+y', { desc = "复制至系统剪切板" })

-- ==================== 窗口管理 ====================
map("n", "<Leader>u", "<C-w>k", { desc = "切换到上方窗口" })
map("n", "<Leader>e", "<C-w>j", { desc = "切换到下方窗口" })
map("n", "<Leader>n", "<C-w>h", { desc = "切换到左方窗口" })
map("n", "<Leader>i", "<C-w>l", { desc = "切换到右方窗口" })

-- 分屏
map("n", "s", "<Nop>")
map("n", "su", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", { desc = "向上分屏" })
map("n", "se", ":set splitbelow<CR>:split<CR>", { desc = "向下分屏" })
map("n", "sn", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", { desc = "向左分屏" })
map("n", "si", ":set splitright<CR>:vsplit<CR>", { desc = "向右分屏" })
map("n", "sv", "<C-w>t<C-w>H", { desc = "两分屏垂直放置" })
map("n", "sh", "<C-w>t<C-w>K", { desc = "两分屏水平放置" })

-- ==================== Tab 管理 ====================
map("n", "tu", ":tabe<CR>", { desc = "新建 Tab" })
map("n", "tn", ":-tabnext<CR>", { desc = "上一个 Tab" })
map("n", "ti", ":+tabnext<CR>", { desc = "下一个 Tab" })
map("n", "tmn", ":-tabmove<CR>", { desc = "Tab 左移" })
map("n", "tmi", ":+tabmove<CR>", { desc = "Tab 右移" })

-- ==================== 其他 ====================
map("n", ";", ":", { desc = "命令模式" })
map("n", "Q", ":q<CR>", { desc = "退出" })
map("n", "S", ":w<CR>", { desc = "保存" })

-- 搜索导航重映射 (原 n/N 被占用)
map("n", "=", "n", { desc = "下一个搜索结果" })
map("n", "-", "N", { desc = "上一个搜索结果" })
