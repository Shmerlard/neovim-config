local M = {}

M.ns_id = vim.api.nvim_create_namespace("swap_state_ns")

M.swap_state = {
  saved_text = nil,
  saved_range = nil,  -- {start_line, start_col, end_line, end_col}
}

vim.api.nvim_set_hl(0, "SwapHighlight", { bg = "#FFD700", fg = "#000000" })  -- gold/yellow background

vim.api.nvim_create_user_command("SwapVisual", function()
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0,"<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0,">"))

    if M.swap_state.saved_text == nil then
        M.swap_state.saved_range = {start_row, start_col, end_row, end_col}
        M.swap_state.saved_text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
        M.swap_state.extmark_id = vim.api.nvim_buf_set_extmark(0, M.ns_id,
            M.swap_state.saved_range[1] - 1,
            M.swap_state.saved_range[2],
            {
                end_row = M.swap_state.saved_range[3] - 1,
                end_col = M.swap_state.saved_range[4] + 1, -- end col
                hl_group = "SwapHighlight",
            }
        )

        print(table.concat(M.swap_state.saved_text, "\n"))
    else
        -- replace between text
        local n_saved_text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})
        local n_start_row, n_start_col, n_end_row, n_end_col = unpack(M.swap_state.saved_range)
        vim.api.nvim_buf_set_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, M.swap_state.saved_text)
        vim.api.nvim_buf_set_text(0, n_start_row - 1, n_start_col, n_end_row - 1, n_end_col + 1, n_saved_text)
        M.swap_state.saved_range = nil
        M.swap_state.saved_text = nil
        if M.swap_state.extmark_id then
            vim.api.nvim_buf_del_extmark(0, M.ns_id, M.swap_state.extmark_id)
        end

        print("Replaced!")
    end
end, { range = true })

vim.api.nvim_create_user_command("SwapStateClear", function()
    M.swap_state.saved_range = nil
    M.swap_state.saved_text = nil
    if M.swap_state.extmark_id then
        vim.api.nvim_buf_del_extmark(0, M.ns_id, M.swap_state.extmark_id)
    end

    print("Swap State Cleared")
end, {})

vim.api.nvim_create_user_command("SwapStatePrint", function()
    if not M.swap_state or not M.swap_state.saved_text or not M.swap_state.saved_range then
        print("Swap state is not properly initialized.")
        return
    end
    print(table.concat(M.swap_state.saved_text, "\n"))
    local n_start_row, n_start_col, n_end_row, n_end_col = unpack(M.swap_state.saved_range)
    local f_range = n_start_row .. ":" .. (n_start_col + 1) .. " -> "
    f_range = f_range .. n_end_row .. ":" .. (n_end_col + 1)
    print(f_range)
end, {})


return M
