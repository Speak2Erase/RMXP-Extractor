require_relative "lib/rmxp_extractor/classnames"
require "amazing_print"

f = File.open("Data_OLD/Map266.rxdata")
ins1 = Marshal.load(f)

f2 = File.open("Data/Map266.rxdata")
ins2 = Marshal.load(f2)

f = File.open("ins1", "w")
f2 = File.open("ins2", "w")
f.puts ins1.ai(plain: true, raw: true, object_id: false)
f2.puts ins2.ai(plain: true, raw: true, object_id: false)
