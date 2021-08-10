(local {: com! : au : key-map} (require :setup))

(com! ["-bar AutoImg lua require'site.util'.AutoImg()"
       "     AutoDate 1 | if !search('^data:', 'n', '^---$') | Date | endif"
       "-bar AutoFB lua require'site.util'.AutoFB()"
       "-bar FixTitleMarker lua require'site.util'.FixTitleMarker()"
       "-bar Date exe 'norm odata:  '.strftime('%F %T %z')"
       "-bar RO setl spell spelllang=ro"
       "-bar ArticoleNoi silent! n `git ls-files -mo content/articole`"
       "     AA ArticoleNoi | argdo AutoImg | up"
       "     WordWrap exe 'setl formatoptions+=w tw=200' | exe 'g/ ./ norm gqq' | nohl"
       "-bar TrimLeadingBlankLines exe '1,/---/-1s/^\\n//e | nohl'"
       "     TrimAll TrimLeadingBlankLines | TrimLeadingBlankLines | TrimTrailingSpace | TrimTrailingBlankLines | SquashBlankLines | WordWrap"
       "     PrepArt exe 'TrimAll' | exe 'AutoDate' | FixTitleMarker | AutoFB | up"
       "-bar PrepArts n **/*.txt | argdo PrepArt"])

(au {:SiteUtil ["BufEnter */articole/**/*.txt,*/Downloads/**/*.txt setl ft=markdown spell spelllang=ro"
                "BufWritePre */articole/**/*.txt,*/Downloads/**/*.txt TrimAll"]})

(let [S {:silent true}]
  (key-map {:n [[:<Leader>a :<Cmd>AutoImg<CR> S]
                [:<Leader>d :<Cmd>Date<CR> S]
                ["<C-\\>"
                 "<Cmd>PrepArt<CR><Cmd>up<CR><bar><Cmd>let $VIM_DIR=expand('%:p:h')<CR><Cmd>Term<CR>cd \"$VIM_DIR\" && reimg && jsame && mv * .. && exit<CR>"
                 S]]}))
