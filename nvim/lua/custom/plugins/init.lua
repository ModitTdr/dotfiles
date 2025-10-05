-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

vim.keymap.set({ 'n', 'i' }, '<C-z>', function()
  vim.cmd 'undo'
end, { noremap = true })

vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true }) --delete word-before(ctrl+backspace)
vim.keymap.set('i', '<C-Del>', '<Esc>dw', { noremap = true }) --delete word-after(ctr+del)
vim.api.nvim_set_keymap('n', '<C-A>', 'ggVG', { noremap = true, silent = true })

return {
  {},
}
