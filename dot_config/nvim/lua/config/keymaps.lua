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

-- ==================== Operator-pending 模式 (支持 c/d/y 等操作符) ====================
-- Colemak 方向键
map("o", "u", "k", { desc = "上移" })
map("o", "e", "j", { desc = "下移" })
map("o", "n", "h", { desc = "左移" })
map("o", "i", "l", { desc = "右移" })

-- 文本对象前缀重映射 (原 i 被用作右移)
-- 使用 k 代替 i 作为 inner 前缀: ckw = ciw, dkw = diw, ykw = yiw
map("o", "k", "i", { desc = "inner 文本对象 (代替 i)" })

-- ==================== 可视模式快捷键 ====================
map("v", "Y", '"+y', { desc = "复制至系统剪切板" })

-- Visual 模式下的插入 (包括 Visual Block 模式 Ctrl+v)
map("x", "k", "I", { desc = "块插入 (在选区前)" })

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

-- ==================== 显示切换 ====================
map("n", "<Leader>tw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
  local status = vim.opt.wrap:get() and "开启" or "关闭"
  vim.notify("软换行: " .. status, vim.log.levels.INFO)
end, { desc = "切换软换行" })
