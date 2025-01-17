return {
    -- themes
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000, -- always load theme first
		config = function()
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
    -- syntax
	{
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = function()
		 	return require "config.treesitter"
		end,
		config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
		end,
    },
    -- lsp
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
        opts = function()
            return require "config.mason"
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp", "nvim-telescope/telescope.nvim" },
        config = function()
            require "config.lspconfig"
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = "Telescope",
        -- opts = function()
        --     return require "config.telescope"
        -- end,
    },
    -- tree
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen" }, 
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    -- cmp
    {
        "saghen/blink.cmp",
        dependencies = "rafamadriz/friendly-snippets",
        version = "*",
        opts = {
            completion = {
                accept = { auto_brackets = { enabled = true }, },
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
            },
            keymap = { preset = "super-tab" },
            -- will be removed in future release
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            -- experimental
            signature = { enabled = true },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        },
        opts_extend = { "sources.default" }
    },
    -- pairs
    {
        "windwp/nvim-autopairs",
        opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
        end,
    },
}
