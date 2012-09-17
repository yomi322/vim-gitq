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
  let [gitcmd, gitopts] = [args[0], args[1:]]
  let qropts = s:get_quickrun_options(gitcmd, gitopts)
  execute 'QuickRun -type gitq ' . join(qropts) . ' -src "' . escape(gitcmdline, '"') . '"'
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
