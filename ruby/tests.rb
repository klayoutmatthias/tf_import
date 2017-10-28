
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# LICENSE file for details.
#
# DESCRIPTION: Cadence tech file importer - tests

# Force load of import_tf.rb
load File.join(File.dirname(__FILE__), "import_tf.rb")

require 'test/unit'
require 'test/unit/ui/console/testrunner'

module TechfileToKLayout

  class TFImport_TestClass < Test::Unit::TestCase
  
    def test_read1

      begin

        lv = RBA::LayoutView::new
        
        tf_file = File.join(File.dirname(__FILE__), "testdata_1", "techfile.tf")
        TechfileToKLayout.import_techfile(lv, tf_file)
        
        lp = []
        
        li = lv.begin_layers
        while !li.at_end?
          lp << [
            li.current.fill_color, 
            li.current.frame_color, 
            li.current.dither_pattern,
            li.current.line_style,
            li.current.name,
            li.current.source,
            li.current.width,
            li.current.valid?,
            li.current.xfill?
          ]
          li.next
        end

      ensure
        lv._destroy
      end

      ref = [
        # fill color  frame color dp  ls  name                   source     w  valid  xfill
        [ 0xffd9e6ff, 0xffd9e6ff, 62, 9,  'NBL.drawing - 2/0',   '2/0@1',   1, true,  false ],
        [ 0xffffbff2, 0xffffbff2, 61, 8,  'PBL.drawing - 6/0',   '6/0@1',   1, true,  false ],
        [ 0xffbf4026, 0xffbf4026, 53, 8,  'PW.drawing - 1/0',    '1/0@1',   1, true,  false ],
        [ 0xff39bfff, 0xff39bfff, 47, 13, 'NW.drawing - 12/0',   '12/0@1',  1, true,  false ],
        [ 0xffe61f0d, 0xffe61f0d, 53, 8,  'PTOP.drawing - 25/0', '25/0@1',  1, true,  false ],
        [ 0xffcccccc, 0xffcccccc, 47, 16, 'AA.drawing - 54/0',   '54/0@1',  3, true,  false ],
        [ 0xffe38b00, 0xffe38b00, 49, 8,  'VTH.drawing - 91/0',  '91/0@1',  1, true,  false ],
        [ 0xffe38b00, 0xffe38b00, 48, 8,  'P1.drawing - 30/0',   '30/0@1',  1, true,  false ],
        [ 0xff39bfff, 0xff39bfff, 53, 0,  'NHV.drawing - 23/0',  '23/0@1',  0, true,  false ],
        [ 0xffe38b00, 0xffe38b00, 56, 8,  'PHV.drawing - 24/0',  '24/0@1',  1, true,  false ],
        [ 0xffbf4026, 0xffbf4026, 54, 8,  'SP.drawing - 3/0',    '3/0@1',   1, true,  false ],
        [ 0xffbf4026, 0xffbf4026, 1,  8,  'P2.drawing - 31/0',   '31/0@1',  1, true,  false ],
        [ 0xff333399, 0xff333399, 47, 12, 'NP.drawing - 98/0',   '98/0@1',  1, true,  false ],
        [ 0xff802626, 0xff802626, 47, 8,  'PP.drawing - 97/0',   '97/0@1',  1, true,  false ],
        [ 0xff9900e6, 0xff9900e6, 1,  15, 'C1.drawing - 9/0',    '9/0@1',   3, true,  true  ],
        [ 0xff268c6b, 0xff268c6b, 47, 8,  'M1.drawing - 10/0',   '10/0@1',  1, true,  false ],
        [ 0xff8c8ca6, 0xff8c8ca6, 59, 8,  'PA.drawing - 11/0',   '11/0@1',  1, true,  false ],
        [ 0xffe38b00, 0xffffffff, 48, 14, 'P1.net - 102/0',      '102/0@1', 1, false, false ],
        [ 0xffbf4026, 0xffffffff, 1,  14, 'P2.net - 101/0',      '101/0@1', 1, false, false ],
        [ 0xff9900e6, 0xffffffff, 1,  14, 'C1.net - 104/0',      '104/0@1', 1, false, true  ],
        [ 0xff268c6b, 0xffffffff, 47, 14, 'M1.net - 103/0',      '103/0@1', 1, false, false ]
      ]

      [ ref.size, lp.size ].max.times do |i|
        assert_equal(ref[i].inspect, lp[i].inspect)
      end

    end
    
    def test_read2

      begin

        lv = RBA::LayoutView::new
        
        tf_file = File.join(File.dirname(__FILE__), "testdata_2", "techfile.tf")
        TechfileToKLayout.import_techfile(lv, tf_file)
        
        lp = []
        
        li = lv.begin_layers
        while !li.at_end?
          lp << [
            li.current.fill_color, 
            li.current.frame_color, 
            li.current.dither_pattern,
            li.current.line_style,
            li.current.name,
            li.current.source,
            li.current.width,
            li.current.valid?,
            li.current.xfill?
          ]
          li.next
        end

      ensure
        lv._destroy
      end

      ref = [
        # fill color  frame color dp  ls  name                   source     w  valid  xfill
        [ 0xffd9e6ff, 0xffd9e6ff, 62, 9,  'NBL.drawing - 2/0',   '2/0@1',   1, true,  false ],
        [ 0xffffbff2, 0xffffbff2, 61, 8,  'PBL.drawing - 6/0',   '6/0@1',   1, true,  false ],
        [ 0xffbf4026, 0xffbf4026, 53, 8,  'PW.drawing - 1/0',    '1/0@1',   1, true,  false ],
        [ 0xff39bfff, 0xff39bfff, 47, 13, 'NW.drawing - 12/0',   '12/0@1',  1, true,  false ],
        [ 0xffe61f0d, 0xffe61f0d, 53, 8,  'PTOP.drawing - 25/0', '25/0@1',  1, true,  false ],
        [ 0xffcccccc, 0xffcccccc, 47, 16, 'AA.drawing - 54/0',   '54/0@1',  3, true,  false ],
        [ 0xffe38b00, 0xffe38b00, 49, 8,  'VTH.drawing - 91/0',  '91/0@1',  1, true,  false ],
        [ 0xffe38b00, 0xffe38b00, 48, 8,  'P1.drawing - 30/0',   '30/0@1',  1, true,  false ],
        [ 0xff39bfff, 0xff39bfff, 53, 0,  'NHV.drawing - 23/0',  '23/0@1',  0, true,  false ],
        [ 0xffe38b00, 0xffe38b00, 56, 8,  'PHV.drawing - 24/0',  '24/0@1',  1, true,  false ],
        [ 0xffbf4026, 0xffbf4026, 54, 8,  'SP.drawing - 3/0',    '3/0@1',   1, true,  false ],
        [ 0xffbf4026, 0xffbf4026, 1,  8,  'P2.drawing - 31/0',   '31/0@1',  1, true,  false ],
        [ 0xff333399, 0xff333399, 47, 12, 'NP.drawing - 98/0',   '98/0@1',  1, true,  false ],
        [ 0xff802626, 0xff802626, 47, 8,  'PP.drawing - 97/0',   '97/0@1',  1, true,  false ],
        [ 0xff9900e6, 0xff9900e6, 1,  15, 'C1.drawing - 9/0',    '9/0@1',   3, true,  true  ],
        [ 0xff268c6b, 0xff268c6b, 47, 8,  'M1.drawing - 10/0',   '10/0@1',  1, true,  false ],
        [ 0xff8c8ca6, 0xff8c8ca6, 59, 8,  'PA.drawing - 11/1',   '11/1@1',  1, true,  false ],
        [ 0xffe38b00, 0xffffffff, 48, 14, 'P1.net - 102/0',      '102/0@1', 1, false, false ],
        [ 0xffbf4026, 0xffffffff, 1,  14, 'P2.net - 101/0',      '101/0@1', 1, false, false ],
        [ 0xff9900e6, 0xffffffff, 1,  14, 'C1.net - 104/0',      '104/0@1', 1, false, true  ],
        [ 0xff268c6b, 0xffffffff, 47, 14, 'M1.net - 113/0',      '113/0@1', 1, false, false ]
      ]

      [ ref.size, lp.size ].max.times do |i|
        assert_equal(ref[i].inspect, lp[i].inspect)
      end

    end
    
  end
  
  
  # Runs the tests
  
  class TestRunner < Test::Unit::UI::Console::TestRunner
    def initialize(suite, *args)
      super(suite, *args)
    end
    def test_started(name)
      super
    end
  end
  
  err = 0
  self.constants.each do |c|
    if c.to_s =~ /_TestClass$/
      r = TestRunner::new(self.const_get(c), :output => $stdout).start
      err += r.error_count + r.failure_count
    end
  end
  
  err == 0 || $stderr.puts("Test(s) failed. See log for details")

end
