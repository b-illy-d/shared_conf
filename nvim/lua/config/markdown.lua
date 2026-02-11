vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
})

function _G.md_headings_only_foldexpr()
  local line = vim.fn.getline(vim.v.lnum)
  local hashes = line:match("^(#+)%s")
  if hashes then
    return ">" .. #hashes
  end
  return "="
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    local function heading_level_at(lnum)
      local line = vim.fn.getline(lnum)
      local hashes = line:match("^(#+)%s+")
      return hashes and #hashes or nil
    end

    local function nearest_heading_level_above()
      local lnum = vim.fn.line(".")
      while lnum >= 1 do
        local lvl = heading_level_at(lnum)
        if lvl then return lvl end
        lnum = lnum - 1
      end
    end

    local function goto_heading(dir)
      local flags = (dir > 0) and "W" or "bW"
      -- Vim regex: ^#\+\s\+
      vim.fn.search("^#\\+\\s\\+", flags)
    end

    local function goto_heading_end(dir)
      goto_heading(dir)
      vim.cmd("normal! $")
    end

    local function goto_same_level(dir)
      local lvl = heading_level_at(vim.fn.line(".")) or nearest_heading_level_above()
      if not lvl then return end
      local flags = (dir > 0) and "W" or "bW"
      local pat = "^" .. string.rep("#", lvl) .. "\\s\\+"
      vim.fn.search(pat, flags)
    end

    local function goto_parent()
      local lvl = heading_level_at(vim.fn.line(".")) or nearest_heading_level_above()
      if not lvl or lvl <= 1 then return end
      local pat = "^" .. string.rep("#", lvl - 1) .. "\\s\\+"
      vim.fn.search(pat, "bW")
    end

    vim.keymap.set("n", "]]", function() goto_heading(1) end, opts)
    vim.keymap.set("n", "[[", function() goto_heading(-1) end, opts)
    vim.keymap.set("n", "][", function() goto_heading_end(1) end, opts)
    vim.keymap.set("n", "[]", function() goto_heading_end(-1) end, opts)

    vim.keymap.set("n", "]h", function() goto_same_level(1) end, opts)
    vim.keymap.set("n", "[h", function() goto_same_level(-1) end, opts)

    vim.keymap.set("n", "gh", goto_parent, opts)
  end,
})
