local cmp = require("cmp")

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<tab>'] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources({
    -- { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'emoji' },
    { name = 'buffer' },
    {
      name = 'path',
      option = {
        pathMappings = {
          ['@'] = '${folder}/src',
          -- ['/'] = '${folder}/src/public/',
          -- ['~@'] = '${folder}/src',
          -- ['/images'] = '${folder}/src/images',
          -- ['/components'] = '${folder}/src/components',
        },
      },
    },
  }),
  cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  }),
  cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' }
        }
      }
    })
  })
}
