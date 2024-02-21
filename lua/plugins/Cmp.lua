-- TODO see document to know inforamtion
-- TODO what is snip
return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            {
                "saadparwaiz1/cmp_luasnip",
                dependencies = {
                    "L3MON4D3/LuaSnip",
                    dependencies = {
                        "rafamadriz/friendly-snippets",
                    }
                }
            },
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            local cmp = require'cmp'
            local luasnip = require("luasnip")
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            cmp.setup{
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    end,
                },
                sources = cmp.config.sources{
                    { name = 'nvim_lsp'},
                    { name = 'path'},
                    { name = 'luasnip'},
                    { name = 'buffer'},
                },
                mapping = cmp.mapping.preset.insert {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
                            -- that way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    --["<Tab>"] = cmp.mapping(function(fallback)
                    --    -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                    --    if cmp.visible() then
                    --        local entry = cmp.get_selected_entry()
                    --        if not entry then
                    --            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    --        else
                    --            cmp.confirm()
                    --        end
                    --    else
                    --        fallback()
                    --    end
                    --end, {"i","s","c",}),

                    --['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    --['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ----['<C-Space>'] = cmp.mapping.complete(),
                    --['<C-e>'] = cmp.mapping.abort(),

                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }
            }
        end
    }
}
