-- TODO To know what is treesitter
return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = {"c", "lua", "markdown", "markdown_inline"},
                sync_install = true,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                }
            }
        end
    }
}
