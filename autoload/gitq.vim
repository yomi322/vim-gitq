let s:save_cpo = &cpo
set cpo&vim


function! gitq#run(args)
  echo a:args
endfunction


function! gitq#complete(arglead, cmdline, cursorpos)
  return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
