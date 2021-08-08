(local cursor vim.fn.cursor)
(local search vim.fn.search)

(fn _G.Img [count]
  (set vim.b.img (or vim.b.img 0))
  (let [stop (+ vim.b.img (or count 1))]
    (while (< vim.b.img stop)
      (set vim.b.img (+ vim.b.img 1))
      (let [name (vim.fn.expand "%")
            image (.. "<img src=\"/images" (name:sub 8 (- (length name) 4)) "_"
                      vim.b.img ".jpg\">'")]
        (vim.cmd (.. "exe 'norm o" image))))))

(fn img-count []
  (let [name (vim.fn.expand "%")]
    (if (vim.startswith name :content/articole)
        (let [path (.. :content/images/ (name:sub 9 (- (length name) 4))
                       "_[0-9]*.jpg")
              images (vim.fn.glob path 0 1)]
          (length (vim.tbl_filter #(not ($:find "_small%d+.jpg")) images))))))

(fn _G.AutoImg []
  (set vim.b.img 0)
  (let [cmd vim.cmd
        count (img-count)]
    (if (= count nil) (print "No images were found\n")
        (if (> count 0)
            (if (> (search :<img) 0)
                (vim.notify "ERROR: images already present"
                            vim.log.levels.ERROR)
                (do
                  (cmd :TrimTrailingSpace)
                  (cmd :TrimTrailingBlankLines)
                  (cursor (+ 1 (search "-------")) 0)
                  (_G.Img)
                  (cursor (. (vim.fn.getpos "$") 2) 0)
                  (cmd "exe 'norm o'")
                  (_G.Img (- count 1))
                  (cursor 0 0)))))))

(fn _G.AutoFB []
  (cursor 1 0)
  (let [line (search "^foto:" :n "^---$")]
    (if (and (> line 0) (= 0 (search "^foto:\\s*Facebook" :n "^---$")))
        (let [fb-foto (string.gsub (vim.fn.getline line) "foto:%s*(.*)"
                                   "foto:  Facebook %1")]
          (vim.fn.setline line fb-foto)))))

(fn _G.CorrectTitleMarker []
  (let [pos (search "-------")
        len (length (string.gsub (vim.fn.getline (- pos 1)) "[�-�]" ""))
        title (string.rep "-" len)]
    (vim.fn.setline pos title)))

nil

