let s:save_cpo = &cpo
set cpo&vim


function! gitq#run(args)
  let gitcmdline = 'git ' . a:args
  let args = split(a:args)
  let gitcmd  = args[0]
  let gitopts = map(filter(args[1:], 'v:val =~# "^-"'),
  \                 'matchstr(v:val, "--\\zs\\S\\+\\ze=\\S\\+\\|--\\zs\\S\\+\\|-\\zs\\a")')
  let qropts = s:get_quickrun_options(gitcmd, gitopts)
  call s:check_quickrun_config()
  execute 'QuickRun -type gitq ' . join(qropts) . ' -src "' . escape(gitcmdline, '"') . '"'
endfunction

function! s:get_quickrun_options(gitcmd, gitopts)
  let config = {}
  for conf in map(a:gitopts, '"g:gitq_config[a:gitcmd . \"/" . v:val . "\"]"')
  \           + ['g:gitq_config[a:gitcmd]', 'g:gitq_config["_"]']
    if exists(conf)
      call extend(config, eval(conf), 'keep')
    endif
  endfor
  return values(map(config, '"-" . v:key . " " . v:val'))
endfunction

function! s:check_quickrun_config()
  if !exists('g:quickrun_config')
    let g:quickrun_config = {}
  endif
  if !exists('g:quickrun_config.gitq')
    let g:quickrun_config.gitq = {
    \ 'command': 'sh',
    \ 'runner': 'shell',
    \ 'outputter/buffer/name': '*gitq*',
    \ 'outputter/buffer/filetype': 'git',
    \ }
  endif
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
