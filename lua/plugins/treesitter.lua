return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		priority = 1000,
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local status, configs = pcall(require, "nvim-treesitter.configs")
			if not status then
				return
			end

			configs.setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"c",
					"cpp",
					"java",
					"python",
					"html",
					"css",
					"javascript",
					"typescript",
					"tsx",
					"sql",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
			})

			local autotag_status, autotag = pcall(require, "nvim-ts-autotag")
			if autotag_status then
				autotag.setup()
			end
		end,
	},
}
