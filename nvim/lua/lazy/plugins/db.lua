return {
  {
    'tpope/vim-dadbod',
    lazy = true,
    event = 'VimEnter',
    dependencies = {
      'tpope/vim-dotenv',
      'kristijanhusak/vim-dadbod-ui'
    },
    config = function ()
      if vim.g.is_enable_my_debug then
        vim.fn.echo("begin /plugins/db.lazy.post.source.vim")
      end

      -- TOML FORMAT
      -- [local]
      -- connection_string = "mysql://xxxx"
      -- type =  "mysql"
      -- port = "3306"
      -- user =  "LOCAL"
      -- password =  "PASSWD"
      -- [local.ssh]
      -- address = "localhost"
      -- port = "22"
      -- user = "LOCAL"
      -- password = "PASSWD"
      -- identifier = ""

      local db_toml_dir = vim.fn.expand('~/.cache/vim_dadbod')
      vim.g.dbs = {}

      if vim.fn.isdirectory(db_toml_dir) ~= 1 then
        vim.fn.execute('!mkdir ' + db_toml_dir, "silent")
      end

      local filelist =  vim.fn.expand(db_toml_dir + "/*.toml")
      local splitted = vim.fn.split(filelist, "\n")
      -- for s:file in s:splitted
      --   let s:read = dein#toml#parse_file(expand(s:file))
      --   for s:prefix in keys(s:read)
      --     let s:preference = s:read[s:prefix]
      --     let s:conn_str = s:preference['type'] . "://" . s:preference['user'] . ":" . s:preference['password'] . "@" . s:preference['host'] . ":" . s:preference['port']
      --     let g:dbs[fnamemodify(s:file, ':t') . "." . s:prefix] = s:conn_str
      --   endfor
      -- endfor

      if vim.g.is_enable_my_debug then
        vim.fn.echo("end /plugins/db.lazy.post.source.vim")
      end

    end
  }
}

