"*******************************************************************************
" operator-digit-separator
"*******************************************************************************
scriptencoding utf-8

if exists('g:loaded_operator_digit_separator')
  finish
endif

call operator#user#define('digit-separator', 'operator#digit_separator#exec')

let g:loaded_operator_digit_separator = 1
