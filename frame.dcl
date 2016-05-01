 frame : dialog {
  label = "Work with GDB";                     //заголовок окна
 :column {                                  //строка записи в файл
   :row{
     : edit_box{
       key = "file";
       label = "File path:                             ";
       edit_width = 30;
       value = "";
         }
     }
 }
 spacer;
:row{
   : boxed_column {                              //колонка с check-box(выбор примитива)
    label = "Save entity:"; 
        : toggle { 
            key = "polyline"; 
            label = "Polyline"; 
        }
        : toggle { 
            key = "spline"; 
            label = "Spline"; 
        }   
        : toggle { 
            key = "circle"; 
            label = "Circle"; 
        }
    }   
      
: column {                                          //колонка с edit-box(информация о количестве примитивов)
    : boxed_column { 
      label = "Found entities:";
      : edit_box{
      is_enabled = false;
        key = "polyline_f";
        label = "Polyline";
        edit_width = 3;
        value = "";
      }
       : edit_box{
      is_enabled = false;
       key = "spline_f";
       label = "Spline";
       edit_width = 3;
       value = "";
        }
      : edit_box{
       is_enabled = false;
       key = "circle_f";
       label = "Circle";
       edit_width = 3;
       value = "";
          }
    }
 }
}
 spacer;
: row{      
:column{                                       //строка с кнопками
  : button {
        key = "accept";
        label = "OK";
        width = 15;
        alignment = centered;
       fixed_width = true;
        is_default = false;
        //  edit_width = 3;
  }
}
:column{
  : button {
        key = "cancel";
        label = " Cancel ";
        width = 15;
        alignment = centered;
        fixed_width = true;
        is_default = false;
        is_cancel = true;
   }
  }
 }
}



 //:button {
  //key = "accept";
   // label = "OK";
    //is_default = true;
  //  }