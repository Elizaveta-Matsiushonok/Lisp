(defun checkToogle(path)                                                 ;проверка  нажатых checkbox
   (setq cc(ssget "_X" '((0 . "CIRCLE"))))
   (setq sp(ssget "_X" '((0 . "SPLINE"))))                               
   (setq p(ssget "_X" '((0 . "POLYLINE,LWPOLYLINE"))))
   (setq polyline(atoi(get_tile "polyline")))  
   (setq spline(atoi(get_tile "spline")))                                ; 0 = выбран    1 = не выбран
   (setq circle(atoi(get_tile "circle")))  
     (if(= polyline 1) (writepoly p path))
        (if(= spline 1) (writespline sp path))
           (if(= circle 1) (writecirc cc path))   
   (alert "Successfully written to file")  
)

(defun frame ()                                                          ;главная функция(запуск окна)
  (setq dcl_id (load_dialog "E:\\study\\OSAPr\\lisp\\frame.dcl"))
  (if (not (new_dialog "frame" dcl_id) ) (exit))
  (setq  cp(countPoly))                                                  ;подсчет числа примитивов
  (setq  cs(countSpline))
  (setq  c(countCirc))
  (action_tile "accept" "(checkToogle path )") 
  (action_tile "file" "(setq path $value)" )
  (set_tile "polyline_f" (itoa cp))                                      ;заполнение editbox
  (set_tile "spline_f" (itoa cs))
  (set_tile "circle_f" (itoa c))
          ;(action_tile "polyline" "(checkToogle path a)")   
          ;(action_tile "spline" "(checkToogle path a)")  
          ;(action_tile "circle" "(checkToogle path a)") 
          ;(action_tile "accept" "(accept)") 
  (start_dialog)
  (unload_dialog dcl_id)
  (princ a)
 )

 (defun countPoly()                                                       ;функции подсчета примитивов
    (if  (setq p(ssget "_X" '((0 . "POLYLINE,LWPOLYLINE")))) (setq np(sslength p)) (setq np 0)) 
 )
(defun countSpline()
    (if (setq sp(ssget "_X" '((0 . "SPLINE")))) (setq ns(sslength sp)) (setq ns 0)) 
)
(defun countCirc()
    (if (setq cc(ssget "_X" '((0 . "CIRCLE")))) (setq c(sslength cc)) (setq c 0))
)

(defun writespline (sp path)                       ;функция записи данных о примитиве "сплайн" 
(setq q 0)                                         ;счетчик
   (while (< q (sslength sp))
        (setq en(ssname sp q))                     ;получение имени примитива из списка 
        (setq blk(entget en))                      ;добавление примитива в список
        (setq q(+ q 1))  
        (setq h'())
        (setq i 0)  
     (while ( < i (length blk))
            (if (= (car (nth i blk)) 10)            ;вершины сплайна
                (setq h(cons  (nth i blk) h))
            )           
        (setq i(+ i 1))    
     )
             
  (if (setq f(open path "a"))                                       ; запись в файл 
      (progn                                                    
           (write-line "Spline:" f)                              
           (princ "layer:" f)                                       ; слой       
           (write-line (vl-princ-to-string (cdr(assoc 8 blk))) f)
           (princ "color:" f)                                       ;цвет 
           (write-line (vl-princ-to-string (cdr(assoc 62 blk))) f)   
           (princ "line type:" f)                                   ;тип линии 
           (write-line (vl-princ-to-string (cdr(assoc 6 blk))) f)     
           (princ "vertex:" f)                                       ;вершины
           (write-line (vl-princ-to-string h) f) 
           (write-line " " f)    
           (terpri)
     (close f)
      )
      (princ "\n Error - File was not opened.")
   ) 
  )
)


(defun writecirc(e path)                                                       ;функция записи данных о примитиве "окружность" 
  (if (setq f(open path "a"))
    (progn                                                                     ;запись в файл 
      (setq i 0)                                                               ;счетчик
       (while (< i (sslength e))  
         (setq en(ssname e i))                                                 ;получение имени примитива из списка 
         (setq enlist(entget en))                                              ;добавление примитива в список
         (setq i(+ i 1)) 
           (write-line "Circle:" f)                                
           (princ "centre:" f)                      
           (write-line (vl-princ-to-string (cdr(assoc 10 enlist))) f)          ;центр окружности  
           (princ "radius:" f)                                                 ;радиус окружности 
           (write-line (vl-princ-to-string (cdr(assoc 40 enlist))) f) 
           (princ "layer:" f)                                                  ;слой       
           (write-line (vl-princ-to-string (cdr(assoc 8 enlist))) f)
           (princ "color:" f)                                                  ;цвет окружности 
           (write-line (vl-princ-to-string (cdr(assoc 62 enlist))) f)   
           (princ "line type:" f)                                              ;тип линии 
           (write-line (vl-princ-to-string (cdr(assoc 6 enlist))) f) 
           (write-line " " f)      
       )
    (close f)
    )
     (princ "\n Error - File was not opened.")
  )
)

(defun writepoly(pl path)                                                 ;функция получения радиуса и вершин полилинии
 (setq a (length blk))
 (setq q 0)                                                                                                                                     
   (while (< q (sslength pl))
      (setq en(ssname pl q))                                              ;получение имени примитива из списка 
      (setq blk(entget en))                                               ;добавление примитива в список
      (setq q(+ q 1))  
      (setq ls'())                                                        ;список вершин и углов
      (setq hi'())                                                        ;список вершин
      (setq rad'())                                                       ;список радиусов 
      (setq i 0)  
      (setq j 1)
        (while ( < i (length blk))                                      
           (if (or (= (car (nth i blk)) 10)  (= (car (nth i blk)) 42))
             (progn 
               (setq ls(cons  (nth i blk) ls))                              ;добавление в список вершин и углов
               (if (= (car (nth i blk)) 10)                                 ;добавление в список вершин
                 (setq hi(cons  (nth i blk) hi))
               )
             )        
            )
        (setq i(+ i 1))   
        )
     (setq len(-(length ls) 2))                                             ;вычисление радиуса
     (while (< j len)
        (setq f(+ j 1 ))
        (setq s(+ j 2))
        (setq dis(distance (cdr (nth j ls)) (cdr (nth s ls))))
        (setq we(cdr (nth f ls)))
            (if (/= we 0)
		      (progn
		        (setq arg(* 4 (atan (abs we))))
		        (setq si(sin(/ arg 2)))
		        (setq r(/ dis si(* si 2)))
		        (setq blk(cons r blk))
		      )    
		    )
        (setq j(+ j 2))   
      )
  (file path blk hi)                                                   ;запись радиуса и вершин в файл                                                
   )     
)

(defun file(path lt hi)                                                ;функция записи данных о примитиве "полилиния"        
 (if (setq f(open path "a"))
  (progn               
    (write-line "Polyline:" f) 
    (setq i 0) 
    (setq j 0)  
    (setq wq (* (length lt) 1))
    (princ "Radius:" f)                                               ;радиус
      (while ( < i wq)
        (if  (=  (type  (nth i lt)) 'REAL)  
           (write-line (vl-princ-to-string (nth i lt)) f) 
        )
       (setq i(+ i 1))   
      )
    (setq i 0)
      (while ( < i wq)
        (if  (=  (type  (nth i lt)) 'LIST)   
           (progn      
              (if (= (car (nth i lt)) 8)
                (progn 
                  (princ "layer:" f)                                 ;слой
                  (write-line (vl-princ-to-string (cdr (nth i lt))) f) 
                )
              ) 
        (if (= (car (nth i lt)) 6)
          (progn 
            (princ "color:" f)                                       ;цвет
            (write-line (vl-princ-to-string (cdr (nth i lt))) f)   
         )
        )
        (if (= (car (nth i lt)) 62)
          (progn 
            (princ "line type:" f)                                  ;цвет линии
            (write-line (vl-princ-to-string (cdr (nth i lt))) f)   
          )
        )  
           )
       )
   (setq i(+ i 1)) 
      )
     (princ "vertex:" f)                                             ;вершины
     (write-line (vl-princ-to-string hi) f) 
     (write-line " " f)  
     (close f)
  )
 )
)
(frame)