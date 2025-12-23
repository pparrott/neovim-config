-- lua/config/kulala.lua
return function(opts)
  -- setup kulala with passed-in opts
  require("kulala").setup(opts)

  -- keymaps (normal mode)
  vim.keymap.set("n", "<leader>Rs", function()
    require("kulala").run()
  end, { desc = "Kulala: Send request" })

  vim.keymap.set("n", "<leader>Ra", function()
    require("kulala").run_all()
  end, { desc = "Kulala: Send all requests" })

  vim.keymap.set("n", "<leader>Rb", function()
    require("kulala").scratchpad()
  end, { desc = "Kulala: Open scratchpad" })
end

