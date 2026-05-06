return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Necesario para los iconos
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- Cerrar Neovim si Neo-tree es la última ventana
      filesystem = {
        filtered_items = {
          visible = true, -- Mostrar archivos ocultos (como .gitignore)
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true, -- Enfocar el archivo que tienes abierto
        },
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none", -- Desactiva el espacio para que no choque con tu leader
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- Pone flechitas en las carpetas
          expander_collapsed = "",
          expander_expanded = "",
        },
      },
    })
  end,
}
