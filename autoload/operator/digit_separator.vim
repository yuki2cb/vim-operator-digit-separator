"*******************************************************************************
" operator-digit-separator
"*******************************************************************************
scriptencoding utf-8

let s:work_reg = '0'
let s:default_delimiter = ','
let s:default_degits = 3


function! operator#digit_separator#exec(motion_wise)
  let delimiter = s:get_separate_char()
  let digits    = s:get_separate_digits()

  " Get selected text.
  let text = s:get_text(a:motion_wise)

  " Separate numeric string with a delimiter.
  let pattern = '\v(\.\d*)@<!(\d)((\d{' . digits . '})+(\d)@!)@='
  let mod_text = substitute(text, pattern, '\=submatch(2).delimiter', 'g')

  " Paste the text to buffer.
  call s:paste_text(a:motion_wise, mod_text)
endfunction


function! s:get_separate_char()
  if exists("g:digit_separator_delimiter")
    if type(g:digit_separator_delimiter) == type("") && len(g:digit_separator_delimiter) > 0
      return g:digit_separator_delimiter
    endif
  endif
  return s:default_delimiter
endfunction


function! s:get_separate_digits()
  if exists("g:digit_separator_digits")
    if type(g:digit_separator_digits) == type(0) && g:digit_separator_digits > 0
      return g:digit_separator_digits
    endif
  endif
  return s:default_degits
endfunction


function! s:get_text(motion_wise)
  try
    " Save.
    let selection_save = &l:selection
    let &l:selection = "inclusive"
    let reg_save = [getreg(s:work_reg), getregtype(s:work_reg)]

    " Yank the text to the register.
    let visual_cmd = operator#user#visual_command_from_wise_name(a:motion_wise)
    let normal_cmd = '`[' . visual_cmd . '`]"' . s:work_reg . 'y'
    execute "silent normal! " . normal_cmd

    return getreg(s:work_reg)
  finally
    let &l:selection = selection_save
    call setreg(s:work_reg, reg_save[0], reg_save[1])
  endtry
endfunction


function! s:paste_text(motion_wise, text)
  try
    " Save.
    let selection_save = &l:selection
    let &l:selection = "inclusive"
    let reg_save = [getreg(s:work_reg), getregtype(s:work_reg)]

    " Set the text to the register to paste.
    let visual_cmd = operator#user#visual_command_from_wise_name(a:motion_wise)
    call setreg(s:work_reg, a:text, visual_cmd)

    " Execute a paste command.
    let norm_cmd = '`[' . visual_cmd . '`]"' . s:work_reg . 'p'
    execute "silent normal! " . norm_cmd
  finally
    let &l:selection = selection_save
    call setreg(s:work_reg, reg_save[0], reg_save[1])
  endtry
endfunction
