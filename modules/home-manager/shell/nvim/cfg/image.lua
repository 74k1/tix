 local image = require("image")

 local opt = {
   render = {
     min_padding = 5,
     show_label = true,
     show_image_dimensions = true,
     use_dither = true,
     backgroud_color = true,
     foreground_color = true,
   },
   events = {
     update_on_nvim_resize = true,
   },
 }
 
 image.setup(opt)
