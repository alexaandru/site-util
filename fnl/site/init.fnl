(local {: com : au : māp} (require :setup))
(local {: AutoImg : AutoFB : FixTitleMarker} (require :site.util))

(com {: AutoImg
      : AutoFB
      : FixTitleMarker
      :AutoDate "1 | if !search('^data:', 'n', '^---$') | Date | endif"
      :Date "exe 'norm odata:  '.strftime('%F %T %z')"
      :RO "setl spell spelllang=ro"
      :ArticoleNoi "silent! n `git ls-files -mo content/articole`"
      :AA "ArticoleNoi | argdo AutoImg | up"
      :WordWrap "exe 'setl formatoptions+=w tw=200' | exe 'g/ ./ norm gqq' | nohl"
      :TrimLeadingBlankLines {:cmd "exe '1,/---/-1s/^\\n//e | nohl'" :bar true}
      :TrimAll "TrimLeadingBlankLines | TrimLeadingBlankLines | TrimTrailingSpace | TrimTrailingBlankLines | SquashBlankLines | WordWrap"
      :PrepArt "exe 'TrimAll' | exe 'AutoDate' | FixTitleMarker | AutoFB | up"
      :PrepArts "n **/*.txt | argdo PrepArt"})

(au {:SiteUtil ["BufEnter */articole/**/*.txt,*/Downloads/**/*.txt setl ft=markdown spell spelllang=ro"
                "BufWritePre */articole/**/*.txt,*/Downloads/**/*.txt TrimAll"]})

(let [S {:silent true}]
  (māp {:n [[:<Leader>a :<Cmd>AutoImg<CR> S]
             [:<Leader>d :<Cmd>Date<CR> S]
             ["<C-\\>"
              "<Cmd>PrepArt<CR><Cmd>up<CR><bar><Cmd>let $VIM_DIR=expand('%:p:h')<CR><Cmd>Term<CR>cd \"$VIM_DIR\" && reimg && jsame && mv * .. && exit<CR>"
              S]]}))

