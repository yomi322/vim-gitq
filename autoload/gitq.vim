let s:save_cpo = &cpo
set cpo&vim


let s:quickrun_config = {
\ 'type': 'gitq',
\ 'command': 'sh',
\ 'runner': 'system',
\ 'outputter/buffer/name': '*gitq*',
\ 'outputter/buffer/filetype': 'git',
\ }

function! s:set_quickrun_options(gitcmd, gitopts)
  let config = {}
  for conf in map(a:gitopts, '"g:gitq_config[a:gitcmd . \"/" . v:val . "\"]"')
  \           + ['g:gitq_config[a:gitcmd]', 'g:gitq_config["_"]', 's:quickrun_config']
    if exists(conf)
      call extend(config, eval(conf), 'keep')
    endif
  endfor
  return values(map(config, '"-" . v:key . " " . v:val'))
endfunction


function! gitq#run(args)
  let cmdline = 'git ' . a:args
  let [gitcmd, gitcmdopts] = s:parse_cmdline(cmdline)
  let qropts = s:set_quickrun_options(gitcmd, gitcmdopts)
  execute 'QuickRun' join(qropts) '-src "' escape(cmdline, '"') '"'
endfunction

function! s:parse_cmdline(cmdline)
  let gitcmd = ''
  let gitcmdopts = []
  let words = split(a:cmdline)
  let idx = 0
  while idx < len(words) && gitcmd ==# ''
    if words[idx] ==# '-c'
      let idx += 1
    elseif words[idx] ==# '--help'
      let gitcmd = 'help'
    elseif words[idx] !~# '^git$\|^Gitq$\|^-'
      let gitcmd = words[idx]
    endif
    let idx += 1
  endwhile
  if gitcmd !=# ''
    let gitcmdopts = s:parse_gitcmd_options(words[idx :])
  endif
  return [gitcmd, gitcmdopts]
endfunction

function! s:parse_gitcmd_options(args)
  let opts = []
  let idx_dash = index(a:args, '--')
  let words = idx_dash >= 0 ? a:args[: idx_dash] : a:args
  for word in filter(words, 'v:val =~# "^-"')
    if word =~# '^--[-0-9A-Za-z]\+=\S\+$\|^--[-0-9A-Za-z]\+$'
      call add(opts, matchstr(word, '--\zs[-0-9A-Za-z]\+\ze=\S\+\|--\zs[-0-9A-Za-z]\+'))
    elseif word =~# '^-[0-9A-Za-z]\+$'
      let opts = opts + split(matchstr(word, '-\zs[0-9A-Za-z]\+'), '\zs')
    endif
  endfor
  return opts
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
