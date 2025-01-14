if exists("sqlparse")
    finish
endif
let sqlparse = 1

if !has('python') and !has('python3')
    echo "Error: Required vim compiled with +python"
    finish
endif

function! sql#FormatSQL()

python3 << EOF

import vim
import sqlparse

start = int(vim.eval('v:lnum')) - 1
end = int(vim.eval('v:count')) + start
buf = vim.current.buffer
NL = '\n'

try:
    sql = NL.join(buf[start:end + 1])
    sql_new = sqlparse.format(sql,
        keyword_case='upper',
        identifier_case='lower',
        output_format='sql',
        strip_comments=True,
        use_space_around_operators=True,
        strip_whitespace=False,
        truncate_strings=None,
        indent_columns=False,
        reindent=True,
        reindent_aligned=False,
        indent_after_first=False,
        indent_tabs=False,
        indent_width=2,
        wrap_after=0,
        comma_first=True,
        right_margin=None
        )

    lines = [line.encode('utf-8') for line in sql_new.split(NL)] + ['']

    buf[:] = buf[:start] + lines + buf[end + 1:]
except Exception as e:
    print(e)
EOF

endfunction
