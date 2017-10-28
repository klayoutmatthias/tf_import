# $autorun
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# LICENSE file for details.
#
# DESCRIPTION: Cadence techfile converter for KLayout - batch mode interface
#
# Run the script with
#   klayout -z -rd tf_file=[input] -rd lyp_file=[output] -r import_tf_standalone.lym ...
#
# The script will convert the Cadence techfile [input] to the layer properties file [output].
# It will require a .drf file which must be located where [input] is found. It will also read
# a .layermap file if there is one beside the [input] file.
# It will prompt for a .drf file if it does not find a unique file. 
#
# CAUTION: the script uses a simple parsing scheme of the techfile by converting it into a
# Ruby expression. Hence, no Skill code inside the techfile is evaluated.
# 

require "import_tf"

module TechfileToKLayout

  # If tf_file is given, this script is executed
  if $tf_file
  
    $lyp_file || raise(Exception("$lyp_file not given"))
  
    mw = RBA::Application::instance.main_window
    mw.create_view
    lv = mw.current_view
    
    import_techfile(lv, $tf_file)
    lv.save_layer_props($lyp_file)
    
  end

end

