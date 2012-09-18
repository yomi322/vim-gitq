let s:save_cpo = &cpo
set cpo&vim


function! s:set_quickrun_config()
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

function! s:set_quickrun_options(gitcmd, gitopts)
  let config = {}
  for conf in map(a:gitopts, '"g:gitq_config[a:gitcmd . \"/" . v:val . "\"]"')
  \           + ['g:gitq_config[a:gitcmd]', 'g:gitq_config["_"]']
    if exists(conf)
      call extend(config, eval(conf), 'keep')
    endif
  endfor
  return values(map(config, '"-" . v:key . " " . v:val'))
endfunction


function! gitq#run(args)
  let gitcmdline = 'git ' . a:args
  let args = split(a:args)
  let gitcmd  = args[0]
  let gitopts = s:get_git_options(args[1:])
  let qropts = s:set_quickrun_options(gitcmd, gitopts)
  call s:set_quickrun_config()
  execute 'QuickRun -type gitq' join(qropts) '-src "' escape(gitcmdline, '"') '"'
endfunction

function! s:parse_gitcmd_options(args)
  let opts = []
  for arg in filter(a:args, 'v:val =~# "^-"')
    if arg =~# '^--[-0-9A-Za-z]\+=\S\+$\|^--[-0-9A-Za-z]\+$'
      call add(opts, matchstr(arg, '--\zs[-0-9A-Za-z]\+\ze=\S\+\|--\zs[-0-9A-Za-z]\+'))
    elseif arg =~# '^-[0-9A-Za-z]\+$'
      let opts = opts + split(matchstr(arg, '-\zs[0-9A-Za-z]\+'), '\zs')
    endif
  endfor
  return opts
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
