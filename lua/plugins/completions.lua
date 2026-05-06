return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Se carga justo cuando vas a escribir
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- El que ya tenías y daba error
      "hrsh7th/cmp-buffer",   -- Sugiere palabras que ya escribiste en el archivo
      "hrsh7th/cmp-path",     -- Sugiere rutas de archivos
      "L3MON4D3/LuaSnip",     -- Motor de fragmentos de código (snippets)
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.rounded(),
          documentation = cmp.config.window.rounded(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- Forzar mostrar sugerencias
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter para aceptar
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Sugerencias del LSP (C, Java, etc)
          { name = "luasnip" },  -- Snippets
        }, {
          { name = "buffer" },   -- Palabras del buffer actual
          { name = "path" },     -- Rutas de carpetas
        }),
      })
    end,
  },
}
