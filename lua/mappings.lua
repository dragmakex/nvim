require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

local function fff_files()
  require("fff").find_in_git_root()
end

local function fff_cwd()
  require("fff").find_files()
end

local function fff_grep()
  require("fff").live_grep()
end

local function is_jj_repo()
  return vim.fn.system("jj root 2>/dev/null"):find("^/") ~= nil
end

local function vcs_worktree_view()
  if is_jj_repo() then
    vim.cmd "JJ status"
  else
    vim.cmd "DiffviewOpen"
  end
end

local function vcs_history_view()
  if is_jj_repo() then
    vim.cmd "JJ log"
  else
    vim.cmd "DiffviewFileHistory"
  end
end

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

for _, lhs in ipairs {
  "<leader>fw",
  "<leader>fb",
  "<leader>fh",
  "<leader>ma",
  "<leader>fo",
  "<leader>fz",
  "<leader>cm",
  "<leader>gt",
  "<leader>pt",
  "<leader>th",
  "<leader>ff",
  "<leader>fa",
} do
  pcall(del, "n", lhs)
end

map("n", "<leader>ff", fff_files, { desc = "find files in git root" })
map("n", "<leader>fa", fff_cwd, { desc = "find files in cwd" })
map("n", "<leader>fw", fff_grep, { desc = "live grep in files" })
map("n", "<leader>gt", vcs_worktree_view, { desc = "vcs worktree view" })
map("n", "<leader>cm", vcs_history_view, { desc = "vcs history view" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "git status" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "git diff split" })
map("n", "<leader>gD", "<cmd>Gvdiffsplit<CR>", { desc = "git diff vertical split" })
map("n", "<leader>gb", "<cmd>Gblame<CR>", { desc = "git blame" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
