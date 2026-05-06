return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- 1. Mason para gestionar las instalaciones físicas
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"jdtls",
					"ts_ls",
					"cssls",
					"html",
					"jsonls",
				},
			})

			-- 2. Configuración estética de diagnósticos
			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
				float = { border = "rounded", style = "minimal" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
			})

			-- 3. Autocomando para Keymaps y AUTO-FORMATO
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local buf = args.buf
					local map = function(mode, lhs, rhs)
						vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
					end

					-- Atajos de teclado
					map("n", "K", vim.lsp.buf.hover)
					map("n", "gd", vim.lsp.buf.definition)
					map("n", "gl", vim.diagnostic.open_float)
					map("n", "<F4>", vim.lsp.buf.code_action)
					map("n", "<leader>rn", vim.lsp.buf.rename)

					-- === BLOQUE DE AUTO-FORMATEO AL GUARDAR ===
					if client and client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 2000 })
							end,
						})
					end
				end,
			})

			-- 4. NUEVA API 0.11: Configuración de servidores
			local caps = require("cmp_nvim_lsp").default_capabilities()

			-- Configuración de Lua (Quitando el error de 'undefined global vim')
			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				capabilities = caps,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
					},
				},
			})

			-- Configuración de C/C++ (Clangd)
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--query-driver=/usr/bin/gcc*,/usr/bin/clang*,/usr/bin/cc*",
				},
				capabilities = caps,
			})

			-- Configuración de otros servidores
			local servers = { "jdtls", "ts_ls", "cssls", "html", "jsonls" }
			for _, name in ipairs(servers) do
				vim.lsp.config(name, { capabilities = caps })
			end

			-- ACTIVACIÓN FINAL
			for name, _ in pairs(vim.lsp.config._configs) do
				if name ~= "*" then
					vim.lsp.enable(name)
				end
			end
		end,
	},
}
