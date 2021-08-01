(local site_util {})

(fn site_util.unpack_G [...]
  (each [_ v (ipairs (vim.tbl_flatten [...]))]
    (tset _G v (. site_util v))))

(fn site_util.Img [count]
  (set-forcibly! count (or count 1))
  (set-forcibly! vim.b.img (or vim.b.img 0))
  (local stop (+ vim.b.img count))
  (while (< vim.b.img stop)
    (set vim.b.img (+ vim.b.img 1))
    (local name (vim.fn.expand "%"))
    (local image (.. "<img src=\"/images"
                     (string.sub name 8 (- (length name) 4)) "_" vim.b.img
                     ".jpg\">'"))
    (vim.cmd (.. "exe 'norm o" image))))

(fn site_util.ImgCount []
  (local prefix :content/articole)
  (local name (vim.fn.expand "%"))
  (when (vim.startswith name prefix)
    (var count 0)
    (local path (.. :content/images/ (: name :sub 9 (- (length name) 4))
                    "_[0-9]*.jpg"))
    (local images (vim.fn.glob path 0 1))
    (each [_ v (ipairs images)]
      (if (not (string.find v "_small%d+.jpg")) (set count (+ count 1))))
    count))

(fn site_util.AutoImg []
  (set vim.b.img 0)
  (local count (site_util.ImgCount))
  (when (> count 0)
    (if (> (vim.fn.search :<img) 0)
        (vim.notify "ERROR: images already present" vim.log.levels.ERROR)
        (do
          (vim.cmd :TrimTrailingSpace)
          (vim.cmd :TrimTrailingBlankLines)
          (vim.fn.cursor (+ 1 (vim.fn.search "-------")) 0)
          (site_util.Img)
          (vim.fn.cursor (. (vim.fn.getpos "$") 2) 0)
          (vim.cmd "exe 'norm o'")
          (site_util.Img (- count 1))
          (vim.fn.cursor 0 0)))))

(fn site_util.AutoFB []
  (vim.fn.cursor 1 0)
  (local line (vim.fn.search "^foto:" :n "^---$"))
  (when (> line 0)
    (when (= 0 (vim.fn.search "^foto:\\s*Facebook" :n "^---$"))
      (local x (string.gsub (vim.fn.getline line) "foto:%s*(.*)"
                            "foto:  Facebook %1"))
      (vim.fn.setline line x))))

(fn site_util.CorrectTitleMarker []
  (local title-marker-line (vim.fn.search "-------"))
  (local len (length (: (vim.fn.getline (- title-marker-line 1)) :gsub
                        "[�-�]" "")))
  (vim.fn.setline title-marker-line (string.rep "-" len)))

site_util

