(local site_util {})
(local cursor vim.fn.cursor)

(fn site_util.unpack_G [...]
  (vim.tbl_map #(tset _G $ (. site_util $)) (vim.tbl_flatten [...])))

(fn site_util.Img [count]
  (set-forcibly! vim.b.img (or vim.b.img 0))
  (let [stop (+ vim.b.img (or count 1))]
    (while (< vim.b.img stop)
      (set vim.b.img (+ vim.b.img 1))
      (let [name (vim.fn.expand "%")
            image (.. "<img src=\"/images" (name:sub 8 (- (length name) 4)) "_"
                      vim.b.img ".jpg\">'")]
        (vim.cmd (.. "exe 'norm o" image))))))

(fn site_util.ImgCount []
  (let [name (vim.fn.expand "%")]
    (if (vim.startswith name :content/articole)
        (let [path (.. :content/images/ (name:sub 9 (- (length name) 4))
                       "_[0-9]*.jpg")
              images (vim.fn.glob path 0 1)]
          (length (vim.tbl_filter #(not ($:find "_small%d+.jpg")) images))))))

(fn site_util.AutoImg []
  (set vim.b.img 0)
  (let [cmd vim.cmd
        count (site_util.ImgCount)]
    (if (> count 0)
        (if (> (vim.fn.search :<img) 0)
            (vim.notify "ERROR: images already present" vim.log.levels.ERROR)
            (do
              (cmd :TrimTrailingSpace)
              (cmd :TrimTrailingBlankLines)
              (cursor (+ 1 (vim.fn.search "-------")) 0)
              (site_util.Img)
              (cursor (. (vim.fn.getpos "$") 2) 0)
              (cmd "exe 'norm o'")
              (site_util.Img (- count 1))
              (cursor 0 0))))))

(fn site_util.AutoFB []
  (cursor 1 0)
  (let [line (vim.fn.search "^foto:" :n "^---$")]
    (if (and (> line 0) (= 0 (vim.fn.search "^foto:\\s*Facebook" :n "^---$")))
        (let [fb-foto (string.gsub (vim.fn.getline line) "foto:%s*(.*)"
                                   "foto:  Facebook %1")]
          (vim.fn.setline line fb-foto)))))

(fn site_util.CorrectTitleMarker []
  (let [pos (vim.fn.search "-------")
        len (length (string.gsub (vim.fn.getline (- pos 1)) "[�-�]" ""))
        title (string.rep "-" len)]
    (vim.fn.setline pos title)))

site_util

