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
  let gitcmdline = 'git ' . a:args
  let args = split(a:args)
  let gitcmd  = args[0]
  let gitopts = map(filter(args[1:], 'v:val =~# "^-"'),
  \                 'matchstr(v:val, "--\\zs\\S\\+\\ze=\\S\\+\\|--\\zs\\S\\+\\|-\\zs\\a")')
  let qropts = s:get_quickrun_options(gitcmd, gitopts)
  execute 'QuickRun -type gitq ' . join(qropts) . ' -src "' . escape(gitcmdline, '"') . '"'
endfunction

function! s:get_quickrun_options(gitcmd, gitopts)
  let config = {}
  for conf in ['g:gitq_config[a:gitcmd]', 'g:gitq_config["_"]']
    if exists(conf)
      call extend(config, eval(conf), 'keep')
    endif
  endfor
  return values(map(config, '"-" . v:key . " " . v:val'))
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
