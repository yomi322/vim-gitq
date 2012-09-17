if exists('g:loaded_gitq')
  finish
endif
let g:loaded_gitq = 1

let s:save_cpo = &cpo
set cpo&vim


command! -nargs=+ -complete=customlist,gitq#complete Gitq call gitq#run(<q-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
