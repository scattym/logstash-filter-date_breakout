encoding: utf-8
require "uri"

    
    ## /store2/ON166729/ON166729_iac.ism/ON166729-HE-AAC-48/00000/ON166729-HE-AAC-48_00255.aac
    ## /store2/ON166429/ON166429_iac.ism/ON166429-235/00000/ON166429-235_00095.ts
    ## /store3/ON134066/ON134066_fps.ism/ON134066_fps-video=1392000.m3u8
    url = "http://localhost/store3/ON134066/ON134066_fps.ism/ON134066_fps-video=1392000.m3u8"
    url = url.first if url.is_a? Array
    uri = URI(url)
    path_array = uri.path.split("/")
    print "array length is ", path_array.length, "\n"
    target = Hash.new
    prefix = 12
    if path_array.length == 5
      print "1 is ", path_array[1], "\n"
      target["store"] = path_array[1]
      target["on_media_id"] = path_array[2]
      target["manifest"] = path_array[3]
      target["file"] = path_array[4]
      file_array = path_array[4].split("_")
      target["file_on_media_id"] = file_array[0]
      enc_array = file_array[1].split("-")
      target["file_enc_type"] = enc_array[0]
      asset_type_array = enc_array[1].split("=")
      target["file_asset_type"] = asset_type_array[0]
      bitrate_array = asset_type_array[1].split(".")
      target["file_bitrate"] = bitrate_array[0]
      target["file_type"] = bitrate_array[1]

      print asset_type_array, target["file_type"]
    end

