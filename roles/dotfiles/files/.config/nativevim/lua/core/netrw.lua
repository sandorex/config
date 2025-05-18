vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
      -- go to next or prev directory with arrow keys
      vim.keymap.set("n", "<left>", "-", { desc = "Go to parent", remap = true, buffer =true })
      vim.keymap.set("n", "<right>", "<cr>", { desc = "Enter", remap = true, buffer = true })
    end,
})

