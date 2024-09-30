-- Unmap `s`, im not using it
vim.keymap.set({ 'n', 'x', 'v' }, 's', '<Nop>')

-- My custom keymaps
-- Make the file you run the command on, executable, so you don't have to go out to the command line
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set('n', '<leader>fx', '<cmd>!chmod +x "%"<CR>', { silent = true, desc = '[w]Make file executable' })
-- vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
vim.keymap.set('n', '<leader>fX', '<cmd>!chmod -x "%"<CR>', { silent = true, desc = '[w]Remove executable flag' })
vim.keymap.set('n', ']t', '<cmd>:tabn<CR>', { silent = true, desc = '[w]Switch next tab' })
vim.keymap.set('n', '[t', '<cmd>:tabp<CR>', { silent = true, desc = '[w]Switch previous tab' })
-- If this is a bash script, make it executable, and execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set('n', '<leader>cb', function()
  local file = vim.fn.expand '%' -- Get the current file name
  local first_line = vim.fn.getline(1) -- Get the first line of the file
  if string.match(first_line, '^#!/') then -- If first line contains shebang
    local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands

    -- Execute the script on a tmux pane on the right. On my mac I use zsh, so
    -- running this script with bash to not execute my zshrc file after
    -- vim.cmd("silent !tmux split-window -h -l 60 'bash -c \"" .. escaped_file .. "; exec bash\"'")
    -- `-l 60` specifies the size of the tmux pane, in this case 60 columns
    vim.cmd('silent !tmux split-window -h -l 60 \'bash -c "' .. escaped_file .. '; echo; echo Press any key to exit...; read -n 1; exit"\'')
  else
    vim.cmd "echo 'Not a script. Shebang line not found.'"
  end
end, { desc = '[w]BASH, execute file' })

-- -- If this is a bash script, make it executable, and execute it in a split pane on the right
-- -- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
-- vim.keymap.set("n", "<leader>cb", function()
--   local file = vim.fn.expand("%") -- Get the current file name
--   local first_line = vim.fn.getline(1) -- Get the first line of the file
--   if string.match(first_line, "^#!/") then -- If first line contains shebang
--     local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands
--     vim.cmd("!chmod +x " .. escaped_file) -- Make the file executable
--     vim.cmd("vsplit") -- Split the window vertically
--     vim.cmd("terminal " .. escaped_file) -- Open terminal and execute the file
--     vim.cmd("startinsert") -- Enter insert mode, recommended by echasnovski on Reddit
--   else
--     vim.cmd("echo 'Not a script. Shebang line not found.'")
--   end
-- end, { desc = "[P]Execute bash script in pane on the right" })

-- If this is a .go file, execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set('n', '<leader>cg', function()
  local file = vim.fn.expand '%' -- Get the current file name
  if string.match(file, '%.go$') then -- Check if the file is a .go file
    local file_dir = vim.fn.expand '%:p:h' -- Get the directory of the current file
    -- local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands
    -- local command_to_run = "go run " .. escaped_file
    local command_to_run = 'go run *.go'
    -- `-l 60` specifies the size of the tmux pane, in this case 60 columns
    local cmd = "silent !tmux split-window -h -l 60 'cd "
      .. file_dir
      .. ' && echo "'
      .. command_to_run
      .. '\\n" && bash -c "'
      .. command_to_run
      .. '; echo; echo Press enter to exit...; read _"\''
    vim.cmd(cmd)
  else
    vim.cmd "echo 'Not a Go file.'" -- Notify the user if the file is not a Go file
  end
end, { desc = '[w]GOLANG, execute file' })

-- Copy file path / filepath to the clipboard
vim.keymap.set('n', '<leader>fp', function()
  local filePath = vim.fn.expand '%:~' -- Gets the file path relative to the home directory
  vim.fn.setreg('+', filePath) -- Copy the file path to the clipboard register
  print('File path copied to clipboard: ' .. filePath) -- Optional: print message to confirm
end, { desc = '[w]Copy file path to clipboard' })

-- I save a lot, and normally do it with `:w<CR>`, but I guess this will be
-- easier on my fingers
-- Original lazyvim.org keymap for this was "Other Window", but I never used it
vim.keymap.set('n', '<leader>ww', function()
  vim.cmd 'write'
end, { desc = '[W]Write current file' })

vim.keymap.set('n', '<leader>fr', '<cmd>retab<CR>', { silent = false, desc = '[w]Reindent file' })

vim.keymap.set('n', '\\', ':Telescope file_browser<CR>')
