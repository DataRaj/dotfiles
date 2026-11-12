-- ── Fix for flash.nvim FFI crash on Neovim 0.13 nightly ─────────────────────
-- Neovim 0.13 nightly builds before commit 9bfa337 export `search_match_lines`
-- and `search_match_endcol` rather than `SearchState Search`.
-- flash.nvim commit 7eff7f8 checks `vim.fn.has("nvim-0.13") == 1` and assumes
-- `Search` exists, crashing with:
--   "undefined symbol: Search" -> "Flash error during redraw"
--
-- We monkey-patch `flash.hacks` dynamically when flash is loaded so it safely
-- probes whether `Search` or `search_match_lines` exists in the running binary.

return {
  {
    "folke/flash.nvim",
    opts = function(_, opts)
      local ffi = require("ffi")

      -- Detect which symbol is actually present in the running Neovim binary
      local has_search_struct = pcall(function()
        ffi.cdef([[
          typedef struct {
            bool hl_match;
            int32_t match_lines;
            int32_t match_endcol;
            int32_t first_line;
            int32_t last_line;
            bool no_smartcase;
            int cmdlen;
            bool no_hlsearch;
          } FlashSearchStateCheck;
          FlashSearchStateCheck Search;
        ]])
        return ffi.C.Search.match_lines
      end)

      local hacks = require("flash.hacks")

      if not has_search_struct then
        -- Binary has legacy globals (search_match_lines / search_match_endcol)
        ffi.cdef([[
          int search_match_endcol;
          unsigned int search_match_lines;
        ]])

        local Pos = require("flash.search.pos")
        local incsearch_state = {}

        hacks.get_end_pos = function(from)
          local ret = Pos({
            from[1] + ffi.C.search_match_lines,
            math.max(0, ffi.C.search_match_endcol - 1),
          })
          local line = vim.api.nvim_buf_get_lines(0, ret[1] - 1, ret[1], false)[1]
          if line then
            local char_idx = vim.fn.charidx(line, ret[2])
            ret[2] = vim.fn.byteidx(line, char_idx)
          end
          return ret
        end

        hacks.save_incsearch_state = function()
          incsearch_state.match_lines = ffi.C.search_match_lines
          incsearch_state.match_endcol = ffi.C.search_match_endcol
        end

        hacks.restore_incsearch_state = function()
          if incsearch_state.match_lines and incsearch_state.match_endcol then
            ffi.C.search_match_lines = incsearch_state.match_lines
            ffi.C.search_match_endcol = incsearch_state.match_endcol
          end
        end
      end

      return opts
    end,
  },
}
