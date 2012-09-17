let s:save_cpo = &cpo
set cpo&vim

if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif
let g:quickrun_config.gitq = {
\   'command': 'sh',
\   'outputter/buffer/name': '*gitq*',
\ }


function! gitq#run(args)
  echo a:args
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
