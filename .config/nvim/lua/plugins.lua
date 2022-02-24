vim.cmd([[
    augroup Packer
        autocmd!
        autocmd BufWritePost plugins.lua PackerCompile
    augroup end
]])

-- Bootstrap Packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
    if not string.find(vim.o.runtimepath, rtp_addition) then
        vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
    end
end

-- Plugins
function get_setup(name)
    return string.format('require("setup/%s")', name)
end

return require('packer').startup({
    function(use)
        use('wbthomason/packer.nvim')
        use('edkolev/tmuxline.vim')
        --use('sheerun/vim-polyglot')
        use({
            'RRethy/nvim-base16',
            config = get_setup('base16')
        })
        use({
            'nvim-lualine/lualine.nvim',
            config = get_setup('lualine'),
            requires = {
                'kyazdani42/nvim-web-devicons',
                opt = true
            }
        })
        use({
            'nvim-treesitter/nvim-treesitter',
            config = get_setup('treesitter'),
            run = ':TSUpdate'
        })
        use({
            'neovim/nvim-lspconfig',
            config = get_setup('lspconfig')
        })
        use({
            'windwp/nvim-autopairs',
            config = require('nvim-autopairs').setup({})
        })
        
        if packer_bootstrap then
            require('packer').sync()
        end
    end,
    config = {
        display = {
            open_fn = require('packer.util').float
        },
        profile = {
            enable = true,
            threshold = 1
        }
    }
})
