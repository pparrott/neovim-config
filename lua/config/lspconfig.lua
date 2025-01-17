local map = vim.keymap.set

local lspconfig = require "lspconfig"
local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = { "gopls" }

local lsp_reference = function() 
    require("telescope.builtin").lsp_references()
end

local on_attach = function(client, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end

    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "gi", vim.lsp.buf.implementation, opts "Go to implentation")
    map("n", "gr", lsp_reference, opts "Go to references")
    map("n", "<leader>rn", vim.lsp.buf.rename, opts "Refactor")
    map("n", "st", vim.lsp.buf.hover, opts "Show signature")
    -- auto-format on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = {only = {"source.organizeImports"}}
                -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                -- machine and codebase, you may want longer. Add an additional
                -- argument after params if you find that you have to write the file
                -- twice for changes to be saved.
                -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                for cid, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                        if r.edit then
                            local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                            vim.lsp.util.apply_workspace_edit(r.edit, enc)
                        end
                    end
                end
                vim.lsp.buf.format({async = false})
            end,
            desc = "Auto-format and organize imports with LSP"
        })
    end
end


for _, lsp in ipairs(servers) do
    
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            gopls = {
                gofumpt = true,  -- Use gofumpt for stricter formatting
                staticcheck = true,  -- Enable additional static checks
                analyses = {
                    unusedparams = true,  -- Enable analysis for unused parameters
                },
                experimentalPostfixCompletions = true,
                usePlaceholders = true,
                completeUnimported = true,
                semanticTokens = true,
            },
        },
    }
end
