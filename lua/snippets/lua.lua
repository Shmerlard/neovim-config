local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- Function snippet
    s("f1", {
        t("function "), i(1, "name"), t("()"),
        t({ "", "    " }), i(2),
        t({ "", "end" }),
    }),

    -- Keymap snippet
    s("map", fmt([[vim.keymap.set("{}", "{}", {}, {{ desc = "{}" }})]], {
        i(1, "n"),                 -- mode
        i(2, "<leader>x"),         -- key
        i(3, '"<cmd>echo Hello<CR>"'), -- command
        i(4, "Do something")       -- description
    })),
}
