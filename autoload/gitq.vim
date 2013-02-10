let s:save_cpo = &cpo
set cpo&vim


let s:quickrun_config = {
\ 'type': 'gitq',
\ 'command': 'sh',
\ 'runner': 'system',
\ 'outputter/buffer/name': '*gitq*',
\ 'outputter/buffer/filetype': 'git',
\ }

function! s:set_quickrun_options(gitcmd)
  let config = {}
  for conf in ['g:gitq_config[a:gitcmd]', 'g:gitq_config["_"]', 's:quickrun_config']
    if exists(conf)
      call extend(config, eval(conf), 'keep')
    endif
  endfor
  return values(map(config, '"-" . v:key . " " . v:val'))
endfunction


function! gitq#run(args)
  let cmdline = split(a:args)
  let gitcmd = s:parse_cmdline(cmdline)
  let qropts = s:set_quickrun_options(gitcmd)
  execute 'QuickRun' join(qropts) '-src "' escape(join(['git'] + cmdline), '"') '"'
endfunction

function! s:parse_cmdline(cmdline)
  let idx = 0
  let length = len(a:cmdline)
  while idx < length
    let word = a:cmdline[idx]
    if word ==# '-c'
      let idx += 1
    elseif word ==# '--help'
      return 'help'
    elseif word !~# '^-'
      return word
    endif
    let idx += 1
  endwhile
  return ''
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
