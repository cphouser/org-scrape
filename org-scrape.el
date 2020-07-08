;; thanks https://emacs.stackexchange.com/a/29473
;; and https://emacs.stackexchange.com/a/49068
(defun org-scrape-link ()
      (interactive)
      (let ((elem (org-element-context)))
        (if (eq (car elem) 'link)
            (let* ((selector-begin (org-element-property :contents-begin elem))
                   (selector-end  (org-element-property :contents-end elem))
                   (url (org-element-property :raw-link elem))
                   (link-begin (org-element-property :begin elem))
                   (link-end (org-element-property :end elem)))
              (if (and selector-begin selector-end)
                  (let ((content (shell-command-to-string
                                  (format "~/small_apps/org-scrape/scrape.py \"%s\" -e \"%s\" "
                                          url
                                          (buffer-substring-no-properties selector-begin selector-end))
                                  )))
                    (delete-region link-begin link-end)
                    (org-paste-subtree nil content))
                (let ((content (shell-command-to-string
                                (format "~/small_apps/org-scrape/scrape.py \"%s\" "
                                        url))))
                  (delete-region link-begin link-end)
                  (org-paste-subtree nil content))))
          ))
      )
