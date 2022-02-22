vim.cmd([[
    augroup Packer
        autocmd!
        autocmd BufWritePost init.lua PackerCompile
    augroup end
]])

-- Bootstrap Packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'git@github.com:wbthomason/packer.nvim',
        install_path
    })
end

function get_setup(name)
    return string.format('require("setup/%s")', name)
end

-- Plugins
return require('packer').startup({
    function(use)
        use('wbthomason/packer.nvim')
        use('numirias/semshi')
        use('edkolev/tmuxline.vim')
        use({
            'sheerun/vim-polyglot',
            config = get_setup('vim-polyglot'),
        })
        use({
            'nvim-lualine/lualine.nvim',
            config = get_setup('lualine'),
            event = 'VimEnter',
            requires = {
                'kaicataldo/material.vim',
                config = get_setup('material.vim'),
            },
        })
        
        if packer_bootstrap then
            require('packer').sync()
        end
    end,
    config = {
        display = {
            open_fn = require('packer.util').float,
        },
        profile = {
            enable = true,
            threshold = 1,
        }
    }
})
