#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# LICENSE file for details.
#
# DESCRIPTION: Cadence techfile import for KLayout - core functionality.
#
require 'stringio'

module TechfileToKLayout

  class TechfileDisplayDefinitions
  
    def initialize(_packet)
      @packet = _packet
      stipple = nil
      line_style = nil
      frame_color = 0x808080
      fill_color = 0x808080
      width = 1
      xfill = false
    end
  
    attr_reader :packet
    attr_accessor :stipple
    attr_accessor :line_style
    attr_accessor :frame_color
    attr_accessor :fill_color
    attr_accessor :width
    attr_accessor :xfill
  
  end
  
  class TechFileLayer
  
    def initialize(_lp)
      @lp = _lp
      ld = nil
      visible = false
      valid = false
      display = nil
    end
  
    attr_reader :lp
    attr_accessor :ld
    attr_accessor :visible
    attr_accessor :valid
    attr_accessor :display
  
  end
  
  def self.produce_word(expr, word)
    if word == "t"
      expr.write("true")
    elsif word == "nil"
      expr.write("false")
    elsif word.length > 0 && word =~ /^-?(\d+(\.\d*)?|\d*\.\d+)([eE][+\-]?\d*)?$/
      expr.write(word)
    elsif (word =~ /^['"]/)
      expr.write(word)
    else
      expr.write("\"")
      expr.write(word.gsub(/\\/, "\\\\").gsub(/"/, "\""))
      expr.write("\"")
    end
  end
  
  def self.read_skill_file_as_ruby_expr(fn)
  
    expr = StringIO.new("", "w")
    expr.write("[")
  
    File.open(fn) do |file|
  
      file.each_line do |line|
  
        state = :reading
        word = ""
  
        line.split(//).each do |c|
  
          repeat = true
          stop = false
          while repeat
  
            repeat = false
  
            if state == :reading
              if c == ";"
                # drop comments
                stop = true
              elsif c == "\""
                expr.write(c);
                state = :quoted
              elsif c == "\'"
                expr.write(c);
                state = :singlequoted
              elsif c == "("
                expr.write("[");
              elsif c == ")"
                expr.write("], ");
              elsif c =~ /\s/
                expr.write(c)
              else
                word = c
                state = :read_word
              end
            elsif state == :read_word
              if c == "("
                expr.write("[ ")
                produce_word(expr, word)
                expr.write(", ")
                state = :reading
              elsif c == ")"
                produce_word(expr, word)
                repeat = true
                state = :reading
              elsif c =~ /\s/
                produce_word(expr, word)
                expr.write(", ")
                state = :reading
                repeat = true
              else
                word += c
              end
            elsif state == :escaped
              expr.write(c)
              state = :quoted
            elsif state == :quoted
              expr.write(c)
              if c == "\""
                state = :reading
                expr.write(", ")
              elsif c == "\\"
                state = :escaped
              end
            elsif state == :singlequoted
              if c =~ /[\s\)]/
                state = :reading
                repeat = true
                expr.write("\', ")
              else
                expr.write(c)
              end
            end
  
          end
  
          if stop
            break
          end
  
        end
  
        if state == :quoted || state == :singlequoted
          expr.write("\"")
        elsif state == :read_word
          produce_word(expr, word)
        end
  
      end
  
    end
  
    expr.write("]")
    return expr.string
  
  end

  # @brief Imports the given techfile into the given view
  # 
  # This method will erase all layer definitions from the 
  # view given by "lv" and replace them by the definitions
  # read from the techfile.
  
  def self.import_techfile(lv, tf_file)

    dir = File.dirname(tf_file)
    drf_files = Dir.glob(File.join(dir, "*.drf"))

    drf_file = nil
    if drf_files.length == 1
      drf_file = drf_files[0]
    else
      sel_drf_file = RBA::FileDialog.get_open_file_name("Select Display Resource File", dir, "Display resource files (*.drf);;All files (*)")
      if sel_drf_file.has_value?
        drf_file = sel_drf_file.value
      end
    end

    if !drf_file
      raise "Unable to locate display resource file"
    end

    tf = eval(read_skill_file_as_ruby_expr(tf_file))
    drf = eval(read_skill_file_as_ruby_expr(drf_file))

    lv.clear_layers
    lv.clear_stipples
    lv.clear_line_styles

    display_defs = {}

    begin

      colors = {}
      widths = {}
      line_styles = {}
      stipples = {}
      packets = {}

      drf.each do |section|

        sname = section.shift
        if sname == "drDefinePacket"
          section.each do |defs|
            if defs.length >= 6
              packets[defs[1]] ||= [ defs[2], defs[3], defs[4], defs[5], defs[6] ]
            end
          end
        elsif sname == "drDefineLineStyle"
          section.each do |defs|
            if defs.length >= 4
              widths[defs[1]] ||= defs[2]
              p = defs[3]
              word = 0
              bits = p.length
              p.reverse_each { |b| word = (word << 1) + b }
              line_styles[defs[1]] ||= lv.add_line_style(defs[1], word, bits)
            end
          end
        elsif sname == "drDefineStipple"
          section.each do |defs|
            if defs.length >= 3
              pat = []
              bits = 1
              defs[2].reverse_each do |p|
                word = 0
                bits = p.length
                p.reverse_each { |b| word = (word << 1) + b }
                if pat.size < 32
                  pat.push(word & 0xffffffff)
                end
              end
              stipples[defs[1]] ||= lv.add_stipple(defs[1], pat, bits)
            end
          end
        elsif sname == "drDefineColor"
          section.each do |defs|
            if defs.length >= 5
              colors[defs[1]] ||= ((defs[2] << 16) + (defs[3] << 8) + defs[4])
            end
          end
        end

      end

      packets.each do |k,v|

        stipple = stipples[v[0]]
        line_style = line_styles[v[1]]
        fill_color = colors[v[2]]
        frame_color = colors[v[3]]
        xfill = v[4].to_s == "X"
        width = widths[v[1]]
        width ||= 0

        if (fill_color && frame_color && width)
          dd = (display_defs[k] ||= TechfileDisplayDefinitions.new(k))
          dd.stipple = stipple
          dd.line_style = line_style
          dd.fill_color = fill_color
          dd.frame_color = frame_color
          dd.xfill = xfill
          dd.width = width
        end

      end

    end

    priorities = []
    layers = {}
    has_layers = false

    tf.each do |section|

      sname = section.shift
      if sname == "layerDefinitions"

        section.each do |defs|

          dname = defs.shift
          if dname == "techLayerPurposePriorities"
            defs.each { |lp| priorities.push(lp) }
          elsif dname == "techDisplays"
            defs.each do |td|
              if td.length >= 8
                dd = display_defs[td[2]]
                if dd
                  lp = [ td[0], td[1] ]
                  tl = (layers[lp] ||= TechFileLayer.new(lp))
                  tl.display = dd
                  tl.visible = td[3]
                  tl.valid = td[7]
                end
              end
            end
          end

        end

      elsif sname == "layerRules"

        section.each do |defs|

          dname = defs.shift
          if dname == "streamLayers"
            defs.each do |td|
              if td.length >= 3
                lp = td[0]
                tl = (layers[lp] ||= TechFileLayer.new(lp))
                tl.ld = [ td[1], td[2] ]
                has_layers = true
              end
            end
          end

        end

      end

    end

    if !has_layers

      # no layers in techfile -> try to locate layermap
      lmap_files = Dir.glob(File.join(dir, "*.layermap"))
      lmap_file = nil
      if lmap_files.length == 1
        lmap_file = lmap_files[0]
      else
        sel_lmap_file = RBA::FileDialog.get_open_file_name("Select Layer Map File", dir, "Layer Map files (*.layermap);;All files (*)")
        if sel_lmap_file.has_value?
          lmap_file = sel_lmap_file.value
        end
      end

      if !lmap_file
        raise "Unable to locate layer map file"
      end

      File.open(lmap_file) do |file|
        file.each_line do |l|
          l = l.sub(/#.*/, "").sub(/^\s*/, "").sub(/\s*$/, "").gsub(/\s+/, " ")
          if l != ""
            ll = l.split(/\s+/)
            if ll.size >= 3
              lp = [ ll[0], ll[1] ]
              tl = (layers[lp] ||= TechFileLayer.new(lp))
              tl.ld = [ ll[2].to_i, (ll[3] || "0").to_i ]
            end
          end
        end
      end

    end

    priorities.each do |lp|

      ldef = layers[lp]
      if ldef && ldef.ld && ldef.display
        lprops = RBA::LayerPropertiesNode.new
        lprops.source_layer = ldef.ld[0]
        lprops.source_datatype = ldef.ld[1]
        lprops.source_cellview = 0
        lprops.name = lp[0] + "." + lp[1] + " - " + ldef.ld[0].to_s + "/" + ldef.ld[1].to_s
        lprops.width = ldef.display.width
        lprops.frame_color = ldef.display.frame_color
        lprops.fill_color = ldef.display.fill_color
        lprops.visible = ldef.visible
        lprops.valid = ldef.valid
        lprops.xfill = ldef.display.xfill
        lprops.dither_pattern = ldef.display.stipple || 1
        lprops.line_style = ldef.display.line_style || 0
        lv.insert_layer(lv.end_layers, lprops)
      end

    end

  end

end

