" all of the colors!
" set t_Co=256

colorscheme vylight

syntax on
set background=dark

" ONES THAT WORK:
"  vylight, wuye
"

" using tabs and auto save:
set confirm
set autowriteall

" stops certain movements from always going to the start of the line
set nostartofline

" use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" allows mouse in all modes
set mouse=a

" TOTALLY EXPERIMENTAL:

" SUGGESTIONS FROM THE CS TUTOR:

" copy indent from previous line
set autoindent

" show line numbers
set nu

" smart indent
set cindent

" sets how many columns the text is indented
set shiftwidth=4
" sets how many columns vim uses when tab is used
set softtabstop=4

" adds display of cursor location
set ruler

if has("terminfo")
   let &t_Co=16
   let &t_AB="\<Esc>[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm"
   let &t_AF="\<Esc>[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm"
else
   let &t_Co=16
   let &t_Sf="\<Esc>[3%dm"
   let &t_Sb="\<Esc>[4%dm"
endif



