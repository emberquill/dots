-- Disable polyglot when better plugins are available
vim.g.polyglot_disabled = {'ansible', 'python'}

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone git@github.com:wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
    augroup Packer
        autocmd!
        autocmd BufWritePost init.lua PackerCompile
    augroup end
]]

-- Packer plugins
local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'numirias/semshi'
    use 'edkolev/tmuxline.vim'
    use 'sheerun/vim-polyglot'
    use {
        'kaicataldo/material.vim',
        config = function()
            vim.o.termguicolors = true
            vim.cmd('colorscheme material')
        end
    }
end)

-- General options
vim.o.syntax = 'on'
vim.o.number = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Set statusbar
vim.o.showmode = false
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = require('material.lualine'),
        component_separators = '|',
        section_separators = '',
    },
}

-- Use system python for nvim
if os.getenv('VIRTUAL_ENV') ~= nil then
    vim.g.python3_host_prog=vim.fn.substitute(vim.fn.system('which -a python3 | head -n2 | tail -n1'), '\n', '', 'g')
else
    vim.g.python3_host_prog=vim.fn.substitute(vim.fn.system('which python3'), '\n', '', 'g')
end
