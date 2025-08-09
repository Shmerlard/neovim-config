-- local ls = require("luasnip")
-- local s = ls.snippet
-- local t = ls.text_node
-- local i = ls.insert_node
-- local fmt = require("luasnip.extras.fmt").fmt
-- local rep = require("luasnip.extras").rep
--
-- return {
--     s("f1", {
--         t("function "), i(1, "name"), t("()"),
--         t({"", "  "}), i(2),
--         t({"", "end"}),
--     }),
--
--     s("ARCH", {
--         t("ARCHITECTURE "), i(1, "rtl"), t(" OF "), i(2, "name"), t(" IS"),
--         t({"", "\t"}), i(3),
--         t({"", "BEGIN"}),
--         t({"","\t"}), i(4),
--         t({"","END ARCHITECTURE "}), rep(1), t(";")
--     })
-- }
--
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
    -- Function
    s("f1", {
        t("function "), i(1, "name"), t("()"),
        t({ "", "  " }), i(2),
        t({ "", "end" }),
    }),

    -- Architecture
    s("ARCH", {
        t("ARCHITECTURE "), i(1, "rtl"), t(" OF "), i(2, "name"), t(" IS"),
        t({ "", "\t" }), i(3),
        t({ "", "BEGIN" }),
        t({ "", "\t" }), i(4),
        t({ "", "END ARCHITECTURE " }), rep(1), t(";")
    }),

    -- Entity
    s("ENTITY", fmt([[
entity {} is
    port (
        {} : in std_logic;
    );
end entity {};
    ]], {
        i(1, "name"),
        i(2, "input"),
        rep(1)
    })),

    -- Signal
    s("signal", fmt("signal {} : {};", {
        i(1, "name"),
        i(2, "std_logic")
    })),

    -- Process
    s("process", fmt([[
process({})
begin
    {}
end process;
    ]], {
        i(1, "clk"),
        i(2, "-- logic here")
    })),

    -- If-Then-Else
    s("if", fmt([[
if {} then
    {}
elsif {} then
    {}
else
    {}
end if;
    ]], {
        i(1, "cond1"),
        i(2, "-- do something"),
        i(3, "cond2"),
        i(4, "-- else if"),
        i(5, "-- else")
    })),

    -- Case
    s("case", fmt([[
case {} is
    when {} =>
        {};
    when others =>
        {};
end case;
    ]], {
        i(1, "sel"),
        i(2, "option1"),
        i(3, "-- action 1"),
        i(4, "-- default action")
    })),

    -- Component instantiation
    s("comp", fmt([[
{} : entity work.{}
port map (
    );
    ]], {
        i(1, "u1"),
        i(2, "my_component"),
    })),

    -- for loop
    s("for", fmt([[
{} : for {} in {} generate
begin
    {}
end generate;
    ]], {
            i(1, "gen_i"),
            i(2, "i"),
            i(3, "range"),
            i(4, {})
        })),

    -- with select
    s("select", fmt([[
with {} select
    {} <=
        {} when {},
        {} when {},
        {} when others;
    ]], {
        i(1, "sel_signal"),
        i(2, "target_signal"),
        i(3, "val1"), i(4, "cond1"),
        i(5, "val2"), i(6, "cond2"),
        i(7, "default_val"),
    })),
}
-- function name()
--
-- end
