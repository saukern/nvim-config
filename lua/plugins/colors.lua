local transparency_enabled = true

local function toggle_transparency()
	if transparency_enabled then
		vim.cmd.colorscheme("nord")
		transparency_enabled = false
	else
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		transparency_enabled = true
	end
end

return {
	{
		"haunsingh/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nord").set({})
			vim.cmd.colorscheme("nord")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.keymap.set("n", "<leader>bg", toggle_transparency, { desc = "Toggle Transparency" })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			theme = "nord",
		},
	},
}
