; for script:
; keywords for highlight:
;   controls:
;     if
;     else
;     function
;     break
;     while

; "\\<\\(break\\|else\\|function\\|if\\|for\\|while\\)\\>"

;   variables:
;     make
;     this
;     arg
;     ret
;     function names (between '.' and '(')
;     anything between quotes (single and double) (handled by c++ mode)
;     comments (handled by C++ mode)
;
;
;
;  indentation:
;     in on:
;        single statement after if
;        single statement after else
;        open bracket
;        $(
;     out on:
;        #)
;        close bracket
;        line following single statement after if
;        line following single statement after else
;
; for ml:
;   highlight:
;     <<TBD>>
;   indentation:     (may need to limit to specific tags)
;     in on open_tag
;     out on close_tag

(defvar plscript-mode-hook nil)

 (defvar plscript-mode-map
   (let ((plscript-mode-map (make-sparse-keymap)))
     ;key mods here
     (define-key plscript-mode-map "\C-ci" 'indent-region)
     (define-key plscript-mode-map "\C-cC-c" 'comment-region)
     (define-key plscript-mode-map "\C-cC-u" 'uncomment-region)
     plscript-mode-map)
    "Keymap for PLScript mode")


(setq plscript-tab-width 4)
(setq plscript-xml-tab-width 1)
(setq plscript-if-tab-width 2)

(add-to-list 'auto-mode-alist '("\\.pls\\'" . plscript-mode))
(add-to-list 'auto-mode-alist '("\\.dat\\'" . plscript-mode))
(add-to-list 'auto-mode-alist '("\\.pg\\'" . plscript-mode))

;syntax coloring stuff


;keywords

(defconst plscript-font-lock-keywords-1
  (list 
;   '("//.*$" . font-lock-comment-face)
   '("\\([$]\\)\(" . (1 'font-lock-constant-face))
   '("\\(#\\)\)" . (1 'font-lock-constant-face))
   '("</?\\(.*\\)[ \t]*>" . (1 'font-lock-constant-face))
   '("<\\([^>]*\\)[ \t].*>" . (1 'font-lock-constant-face)))
   "Keyword highlighting")

(defconst plscript-font-lock-keywords-2
  (append plscript-font-lock-keywords-1
	  (list
	   '("\\<\\(else\\|function\\|method\\|if\\|for\\|while\\)\\>" . font-lock-keyword-face)
	   '("\\<\\(break\\)\\>" . font-lock-warning-face)
	   '("\\<\\(\\(_\\|\\w\\)*\\)(" . (1 'font-lock-function-name-face))
	   '("^[ \t]*function[ \t]*\\(\\(_\\|\\w\\)*\\)[ \t]*$" . (1 'font-lock-function-name-face))))
  "bracket highlighting")

(defconst plscript-font-lock-keywords-3
  (append plscript-font-lock-keywords-2
	  (list
	   '("\\<\\(this\\|arg\\|ret\\)\\>" . 'font-lock-variable-name-face)
	   '("\\<\\(null\\)\\>" . font-lock-builtin-face)))
  "builtin highlighting")

(defvar plscript-font-lock-keywords plscript-font-lock-keywords-3
  "Default syntax coloring")

;utility for pl_script-indent-line
(defun plscript-open-paren (start end)
  "Determine if there are more open parens than closed in a statement
if >0, more open parens
if <0, more closed parens
if 0, balanced parens"
  (interactive)
  (save-excursion
    (setq open-count 0)
    (setq close-count 0)
    (setq current start)
    (while (< current end)
      (goto-char current)
      (if (looking-at "(")
	  (setq open-count (+ open-count 1))
	(if (looking-at ")")
	    (setq close-count (+ close-count 1))))
      (setq current (+ current 1)))
    (- open-count close-count)))

;; (defun paren-test ()
;;   (interactive)
;;   (message (number-to-string (plscript-open-paren 24 31))))

;indentations stuff
 (defun plscript-indent-line ()
   "Indent current line as PLscript code"
   (interactive)
   (save-excursion
     (setq ifdent 0)
     (beginning-of-line)
     (if (bobp)              ; if at beginning of buffer, no indent
	 (indent-line-to 0)
       (let ((not-indented t) cur-indent search-term found-term re-success (count 0))
	 (if (looking-at "^[ \t]*\\(#)\\|\}\\)")            ;check for end of block here. line open with corresponding opening statement
	     (progn
 	       (save-excursion
 		 (setq found-term (buffer-substring (match-beginning 1) (match-end 1)))
 		 (if (looking-at "^[ \t]*}")                     ;determine which closing bracket was found, and set the target opening bracket
 		     (setq search-term "^[ \t]*{")
 		   (setq search-term "^[ \t]*[$]("))
 		 (while not-indented
 		   (forward-line -1)
 		   (if (looking-at (concat "^[ \t]*" found-term)) ;if this is another closing bracket of the same type increment count so we know how nested the open brackets are
 		       (setq count (+ count 1))
 		     (progn
 		       (if (and (looking-at search-term) (not (looking-at (concat ".*" found-term)))) ;if we find the term, and count is zero, then we are at the proper indentation level. If count is > 1, then we are still in a nested block
 			   (progn
 			     (if (= count 0)
 				 (progn
 				   (setq cur-indent (current-indentation))
 				   (setq not-indented nil))
 			       (setq count (- count 1))))
 			 (if (bobp) ;no match found? no indent
 			     (progn
 			       (setq cur-indent 0)
 			       (setq not-indented nil)))))))))
	       (save-excursion
		 (forward-line -1)
		 (setq cur-indent (- (current-indentation) plscript-tab-width))
		 (if (not (looking-at "^[ \t]*\{"))
		     (progn
		       (forward-line -1)
		       (if (looking-at "^[ \t]*\\(if\\|else\\)")       ;if the last line is indented as a single line following an if/else statement, use the indent level above it
			   (progn
			     (setq cur-indent (- cur-indent plscript-tab-width))
			     )))

		   (setq cur-indent (current-indentation))))
	       (if (< cur-indent 0)
 		(setq cur-indent 0)))
	   (save-excursion
	     (if (looking-at "^[ \t]*</\\(.*\\)>") ;find indentation for closing tag
		 (progn
		   (setq search-term (concat "<" (buffer-substring (match-beginning 1) (match-end 1))))      ;determine text of opening tag
		   (setq found-term (concat "</" (buffer-substring (match-beginning 1) (match-end 1)) ">"))  ;save full form of closing tag
		   (while not-indented
		     (forward-line -1)
		     (if (looking-at (concat "^[ \t]*" found-term)) ;another closing tag of the same type? increment nesting count by 1
			 (setq count (+ count 1))
		       (progn
			 (if (and (looking-at (concat "^[ \t]*" search-term "\\([ \t]+[^ \t]+.*\\)?>")) (not (looking-at (concat ".*" found-term)))) ;if count = 0, we found the matching tag. otherwise decrement count
			     (progn
			       (if (= count 0)
				   (progn
				     (setq cur-indent (current-indentation))
				     (setq not-indented nil))
				 (setq count (- count 1)))))))
		     (if (bobp)                ;no matching opening tag? no indent!
			 (progn
			   (setq cur-indent 0)
			   (setq not-indented nil)))))
	       (forward-line -1)
	       (if (and (looking-at "^[ \t]*\\(if\\|else\\)") (not (looking-at "^.*;")))                     ;indent if there is an if/else followed by a single statement
		(progn
		  ;insert open paren check here?
;; 		  (if (and (= ifdent 0) (not (= (plscript-open-paren (beginning-of-line) (end-of-line)))))
;; 		      (progn
;; 			(setq ifdent 1)
;; 			(setq cur-indent (+ (current-indentation) plscript-if-tab-width))

		  (forward-line 1)
		  (if (not (looking-at "^[ \t]*\{"))
		      (progn
			(forward-line -1)
			(setq cur-indent (+ (current-indentation) plscript-tab-width)))
		    (progn
		      (forward-line -1)
		      (setq cur-indent (current-indentation)))))
		(progn
		  (forward-line 1)
		  (setq xml-tag 0)
		  (if (looking-at "^[ \t]*\\(<.*>\\)")
		      (setq xml-tag 1))
		  (while not-indented
		    (forward-line -1)
		    (if (looking-at "^[ \t]*\\(\\(#)\\|\}\\)\\|</.*>\\)")     ;are we at closing block statement?
			(progn
			  (if (looking-at "^[ \t]*\\(</.*>\\)")
			      (if (> xml-tag 0)
				  (progn
				    (setq cur-indent (current-indentation))
				    (setq not-indented nil)))
			    (progn
			      (setq cur-indent (current-indentation))
			      (setq not-indented nil))))
		      (if (looking-at "^[ \t]*\\(\\(\$(\\|\{\\)\\|<.*>\\)")   ;are we at opening block statement?
			(progn
			  (if (looking-at "^[ \t]*\\(<.*>\\)")
			      (if (> xml-tag 0)
				  (setq cur-indent (+ (current-indentation) plscript-xml-tab-width))
				(setq cur-indent 0))
			    (setq cur-indent (+ (current-indentation) plscript-tab-width)))
;			  (message (number-to-string plscript-tab-width))
			  (setq not-indented nil))
			(if (bobp)
			    (setq not-indented nil)))))))))
		  
	 (if cur-indent
	     (progn
	       (indent-line-to cur-indent)
	       (setq cur-off cur-indent))
	   (indent-line-to 0)))))
   (if (= (current-column) 0)
       (back-to-indentation)))


(defun plscript-indent-region (start end)
  (save-excursion
    (setq total-lines (count-lines start end))   ;grab total number of lines
    (setq curr-line 0)
    (goto-char start)
    (skip-chars-forward " \t\n")
    (while (and (< curr-line total-lines) (not (eobp)))
      (plscript-indent-line)
      (forward-line 1)
      (setq curr-line (+ curr-line 1)))))

;modified syntax table
;; (defvar plscript-mode-syntax-table
;;   (let ((plscript-mode-syntax-table (make-syntax-table)))
;;     (modify-syntax-entry ?_ "w" plscript-mode-syntax-table)
;;     (modify-syntax-entry ?/ ". 1234b" plscript-mode-syntax-table)
;;     (modify-syntax-entry ?\n "> b" plscript-mode-syntax-table)
;;     plscript-mode-syntax-table)
;;   "Syntax table for plscript-mode")


					;register everything here
(define-derived-mode plscript-mode c++-mode "PLScript"
   "Major mode for editing PLScript files"
;   (use-local-map plscript-mode-map)
;   (set-syntax-table plscript-mode-syntax-table)
   (setq-default indent-tabs-mode nil)
   (setq indent-region-function 'plscript-indent-region)
   (set (make-local-variable 'indent-line-function) 'plscript-indent-line)
   (set (make-local-variable 'font-lock-defaults) '(plscript-font-lock-keywords)))


(defun plscript-insert-tag (type name value)
  "Insert skeleton for tag"
  (interactive "MTag Type: \nMTag Name: \nMTag Value: ")
  (setq start (point))
  (setq ret (concat "<" type))
  (if(not (= (length name) 0))
      (setq ret (concat ret " name=\"" name "\"")))
  (insert (concat ret ">\n"))
  (if (string= type "Script_func")
      (insert "<Str name=\"script\">\n"))
  (if(not (= (length value) 0))
      (insert value))
  (save-excursion
    (if (string= type "Script_func")
	(insert "\n</Str>"))
    (insert (concat "\n</" type ">"))
    (setq end (point)))
  (if(> (length value) 0)
      (progn
	(forward-line 1)
	(if (string= type "Script_func")
	    (forward-line 1))   ;extra distance for extra stuff added to script func
	(end-of-line)))
  (plscript-indent-region start end))

(defun plscript-insert-page-elem (type)
  "Insert skeleton for page element"
  (interactive "MElement Type: ")
  (plscript-insert-tag "Synthetic" "" "")
  (plscript-insert-tag type "element" "")
  (plscript-insert-tag "Script_func" "init_func" ""))

(defun plscript-insert-page-dynamic ()
  "Insert skeleton for page dynamic"
  (interactive)
  (plscript-insert-tag "Synthetic" "" "")
  (plscript-insert-tag "Script_func" "dynamic" ""))

(defun plscript-insert-field-item (type name label)
  "Insert skeleton for tag"
  (interactive "MField Type: \nMField Name: \nMField Label: ")
  (setq start (point))
  (setq ret "<Synthetic>\n")
  (if(not (= (length type) 0))
      (setq ret (concat ret "<Str name=\"type\">\n" type "\n</Str>\n")))
  (if(not (= (length name) 0))
      (setq ret (concat ret "<Str name=\"name\">\n" name "\n</Str>\n")))
  (if(not (= (length label) 0))
      (setq ret (concat ret "<Str name=\"label\">\n" label "\n</Str>\n")))
  (setq ret (concat ret "</Synthetic>\n"))
  (insert ret)
  (setq end (point))
  (plscript-indent-region start end))


(defun plscript-insert-make (name args)
  "Insert make statement"
  (interactive "MObject Type: \nMArgs: ")
  (setq start (point))
  (setq ret (concat "make(\"" name "\""))
  (if (not (= (length args) 0))
      (setq ret (concat ret ", " args)))
  (setq ret (concat ret ");"))

  (insert ret)
  (setq end (point))
  (plscript-indent-region start end))

(defun plscript-insert-break ()
  "Insert break word"
  (interactive)
  (setq start (point))
  (setq ret "break;\n")
  (insert ret)
  (setq end (point))
  (plscript-indent-region start end))

(defun plscript-insert-get_property (name prop)
  "Insert get_property statement"
  (interactive "MObject: \nMProp: ")
  (setq start (point))
  (setq ret (concat "get_property(" name "," prop ")"))
  (insert ret)
  (setq end (point))
  (plscript-indent-region start end))


;;stuff for writing breakpoints to plapp file
(defun ret-trim-path (top fullpath)
  (string-match (concat top "/\\(.*\\)") fullpath)
  (match-string 1 fullpath))

(defun get-entry (top)
  "create string for break_point based on location in buffer"
  (concat (ret-trim-path top buffer-file-name) ":" (number-to-string (line-number-at-pos (point))) "\n"))

(defun mark-break (top breakpath)
  (interactive "sPath: ")
  "open file, add breakpoint, close file"
  (setq entry (get-entry top))
  (save-excursion
    (set-buffer (find-file-noselect breakpath))
    (if (not (re-search-forward entry nil t))
	(progn
	  (end-of-buffer)
	  (insert entry)
	  (save-buffer 0))
      (message (concat entry " exists")))
    (kill-buffer (current-buffer))))

(defun plscript-add-break-point ()
  (interactive)
  "walk up from current file path until ./pl_app/break_points.dat is located"
  (setq dir (file-name-directory buffer-file-name))
  (setq target "")
  (while (and (not (string= dir "/")) (string= target ""))
    (message dir)
    (setq contents (directory-files dir nil nil t))
    (while (and contents (string= target "")) 
      (setq cur (car contents))
      (setq contents (cdr contents))
      (if(string= cur "pl_app")
	  (setq target (concat dir cur "/break_points.dat"))))
    (if (string= target "")
	(setq dir (file-name-directory (directory-file-name dir)))))

  (if (not (string= target ""))
      (mark-break (directory-file-name dir) target) ;<==== insert open, write, close here!
    (message "pl_app not found")))

