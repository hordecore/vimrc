:runtime! ftplugin/man.vim

"-------------------------------------------------------------------------------------------------------

set nobackup                            "не создавать файлы с резервной копией (filename.txt~)"
set history=50                          "сохранять 50 строк в истории командной строки
set ruler                               "постоянно показывать позицию курсора
set incsearch                           "показывать первое совпадение при наборе шаблона
set nohlsearch                          "подсветка найденного
set autoindent                          "включаем умные отступы
set smartindent
set ai                                  "при начале новой строки, отступ копируется из предыдущей
set ignorecase                          "игнорируем регистр символов при поиске
set visualbell                          "мигаем вместо пищания
set showmatch                           "показываем открывающие и закрывающие скобки
set shortmess+=tToOI                    "убираем заставку при старте
set rulerformat=%(%l,%c\ %p%%%)         "формат строки состояния строка х столбец, сколько прочитано файла в %
set wrap                                "не разрывать строку при подходе к краю экрана
set linebreak                           "переносы между видимыми на экране строками только между словами
set t_Co=256                            "включаем поддержку 256 цветов
set wildmenu                            "красивое автодополнение
set wcm=<Tab>                           "WTF? but all work
set autowrite                           "автоматом записывать изменения в файл при переходе к другому файлу
set encoding=utf8                       "кодировка по дефолту
set termencoding=utf8                   "Кодировка вывода на терминал
set fileencodings=utf8,cp1251,koi8r     "Возможные кодировки файлов (автоматическая перекодировка)
set showcmd showmode                    "показывать незавершенные команды и текущий режим
set wak=yes                             "используем ALT как обычно, а не для вызова пункта мени
set dir=~/.vim/swapfiles                "каталог для сохранения своп-файлов
set noex                                "не читаем файл конфигурации из текущей директории
set ssop+=resize                        "сохраняем в сессии размер окон Vim'а
set listchars=tab:→→,trail:⋅

"-------------------------------------------------------------------------------------

colorscheme ron 			"цветовая схема для терминала
syntax on                               "включаем подсветку синтаксиса
filetype plugin indent on               "включаем автообнаружение типа файла
map Q gq

autocmd FileType text setlocal textwidth=80 "устанавливаем ширину в 80 знаков для текстовых файлов
au FileType c,cc,h,sh au BufWinEnter * let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1) "Подсвечиваем 81 символ и т.д.

"При редактировании файла всегда переходить на последнюю известную
"позицию курсора. Если позиция ошибочная - не переходим.
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Если есть makefile - собираем makeом.
" Иначе используем gcc для текущего файла.
if filereadable("Makefile")
    set makeprg=make
else
    set makeprg=gcc\ -Wall\ -o\ %<\ %
endif

"----------------------------------------------------------------------------

" формат строки с ошибкой для gcc и sdcc, это нужно для errormarker
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

" Некоторые настройки для плагина TagList
let g:Tlist_Show_One_File=1                         " показывать информацию только по одному файлу
let g:Tlist_GainFocus_On_ToggleOpen=1               " получать фокус при открытии
let g:Tlist_Compact_Format=1
let g:Tlist_Close_On_Select=0                       " не закрывать окно после выбора тега
let g:Tlist_Auto_Highlight_Tag=1                    " подсвечивать тег, на котором сейчас находимся

"-----------------------------------------------------------------------------

" Несколько удобных биндингов для С
au FileType c,cc,h inoremap #m int main(int argc, char * argv[]) {<CR>return 0;<CR>}<CR><Esc>2kO
au FileType c,cc,h inoremap #d #define 
au FileType c,cc,h inoremap #el #else<Esc>i
au FileType c,cc,h inoremap #en #endif<Esc>hhi
au FileType c,cc,h inoremap #in #include <Esc>i
au FileType c,cc,h inoremap #ifd #ifdef <Esc>i
au FileType c,cc,h inoremap #ifn #ifndef <Esc>i
au FileType c,cc,h inoremap #< #include <><Esc>i
au FileType c,cc,h inoremap ;; <END>;<CR>
"----------------------------------------------------------------------------------------------"
au FileType sh inoremap #! #!/bin/bash<Esc>i
au FileType sh inoremap while while; do<END><CR><END><CR>done<Esc>kklli
au FileType sh inoremap case case in<END><CR>)<END><CR>;;<END><CR>)<END><CR>;;<END><CR>esac<Esc>kkkkkli
au FileType sh inoremap () () {<END><CR><END><CR>}<Esc>ki

" Close buffer without saving
map <Esc><Esc> :q!<CR>

" Auto adding by Tab (use Shift-TAB unstead)
"imap <Tab> <C-N>

" Так получим более полную информацию, чем просто <C-g>
map <C-g> g<C-g>

" Открытие\закрытие новой вкладки
imap <C-t>t <Esc>:tabnew<CR>a
nmap <C-t>t :tabnew<CR>

" Выводим красиво оформленную man-страницу прямо в Vim
" в отдельном окне (см. начало этого файла)
nmap <S-k> :exe ":Man " expand("<cword>")<CR>

" показать\спрятать номера строк
imap <C-c>n <Esc>:set<Space>nu!<CR>a
nmap <C-c>n :set<Space>nu!<CR>

" Запуск проверки правописания
menu Spl.next ]s
menu Spl.prev [s
menu Spl.word_good zg
menu Spl.word_wrong zw
menu Spl.word_ignore zG
imap <C-c>s <Esc>:setlocal spell spelllang=ru,en<CR>a
nmap <C-c>s :setlocal spell spelllang=ru,en<CR>
imap <C-c>ss <Esc>:setlocal spell spelllang=<CR>a
nmap <C-c>ss :setlocal spell spelllang=<CR>
"map  <C-c>sm :emenu Spl.<TAB>

" Compile programs using Makefile (and do not jump to first error)
"
au FileType c,cc,h,s imap <C-c>m <Esc>:make!<CR>a
au FileType c,cc,h,s nmap <C-c>m :make!<CR>
" Use LaTeX to compile LaTeX sources
au FileType tex map <C-c>m :!pdflatex -shell-escape "%"<CR>

" List of errors
imap <C-c>l <Esc>:copen<CR>
nmap <C-c>l :copen<CR>

" Work with vim-projects
nmap <silent> <C-c>p <Plug>ToggleProject

" work with taglist
imap <C-c>t <Esc>:TlistToggle<CR>:TlistUpdate<CR>
nmap <C-c>t :TlistToggle<CR>:TlistUpdate<CR>

"переключаемся между соответствующими *.c и *.h файлами
"в текущем каталоге (a.vim)
imap <C-c>sw <Esc>:AT<CR>
nmap <C-c>sw :AT<CR>

"Генерируем tags файл
map <C-c>gt :!ctags -a *.c *.h<CR>
map <C-c>gT :!ctags -Ra *.c *.h<CR>
