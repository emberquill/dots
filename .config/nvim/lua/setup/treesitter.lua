require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    sync_install = false,
    highlight = {
        enable = true,
        custom_captures = {
            -- ["<capture group>"] = "<highlight group>",
            -- ["keyword"] = "TSString"
        },
        additional_vim_regex_highlighting = true
    },

    indent = {
        enable = true
    }
})
