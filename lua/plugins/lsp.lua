return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local mis_servidores = {
				"lua_ls",
				"clangd",
				"jdtls",
				"ts_ls",
				"cssls",
				"html",
				"jsonls",
				"emmet_ls",
			}

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = mis_servidores,
			})

			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
				float = { border = "rounded", style = "minimal" },
				igns = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local buf = args.buf
					local map = function(mode, lhs, rhs)
						vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
					end

					map("n", "K", vim.lsp.buf.hover)
					map("n", "gd", vim.lsp.buf.definition)
					map("n", "gl", vim.diagnostic.open_float)
					map("n", "<F4>", vim.lsp.buf.code_action)
					map("n", "<leader>rn", vim.lsp.buf.rename)
					if client and client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 2000 })

								if client.name == "jdtls" then
									vim.lsp.buf.execute_command({
										command = "java.action.organizeImports",
										arguments = { vim.api.nvim_buf_get_name(buf) },
									})
								end
							end,
						})
					end
				end,
			})

			local caps = require("cmp_nvim_lsp").default_capabilities()

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

			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--query-driver=/usr/bin/gcc*,/usr/bin/clang*,/usr/bin/cc*",
				},
				capabilities = caps,
			})

			vim.lsp.config("jdtls", {
				capabilities = caps,

				init_options = {
					bundles = require("spring_boot").java_extensions(),
				},

				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "JavaSE-25",
									path = "/usr/lib/jvm/java-25-openjdk-amd64",
								},
							},
						},
						eclipse = { downloadSources = true },
						maven = { downloadSources = true },
						inlayHints = {
							parameterNames = { enabled = "all" },
						},
						completion = {
							importOrder = { "java", "javax", "com", "org" },
						},
						signatureHelp = { enabled = true },
					},
				},
			})
			for _, name in ipairs(mis_servidores) do
				if name ~= "lua_ls" and name ~= "clangd" and name ~= "jdtls" then
					vim.lsp.config(name, { capabilities = caps })
				end
			end

			for name, _ in pairs(vim.lsp.config._configs) do
				if name ~= "*" then
					vim.lsp.enable(name)
				end
			end
		end,
	},
}
