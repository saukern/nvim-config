vim.g.mapleader = " " -- Declara que nuestra tecla lider es la barra espaciadora
vim.keymap.set("n","<leader>cd",vim.cmd.Ex) --Indica que cuando estemos en modo normal la combinacion de teclas leadercd ejecute el comando de explorador de archivos
-- Abrir/Cerrar Neo-tree con <Leader>e (Espacio + e)
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Abrir explorador de archivos" })

-- Enfocar el explorador si ya está abierto
vim.keymap.set('n', '<leader>f', ':Neotree focus<CR>', { desc = "Enfocar explorador" })
