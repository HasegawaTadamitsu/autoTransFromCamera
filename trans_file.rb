# coding: utf-8
require 'gphoto2'
#require 'pry'

@files=Array.new
def list_files(folder)
  files = folder.files
  files.each do |file|
    data=Hash.new
    data[:filename] ="#{file.name}"
    data[:path] ="#{folder.path}"
    data[:size] = file.info.size
    data[:mtime]= file.info.mtime
    @files.push  data
  end
  folder.folders.each { |child| list_files(child) }
end


MAGNITUDES = %w[bytes KiB MiB GiB].freeze
def format_filesize(size, precision = 1)
  n = 0
  while size >= 1024.0 && n < MAGNITUDES.size
    size /= 1024.0
    n += 1
  end

  "%.#{precision}f %s" % [size, MAGNITUDES[n]]
end

def renew_file_path dir, name, new_size
  file_name = File.join(dir,name)
  if File.exist? file_name
    camera_size = File.size(file_name)
    now=Time.new.strftime("%Y%m%d_%H%M%S%L")
    if new_size == camera_size
      file_name = File.join(dir,"same_size_" + now + "_" + name)
    else
      file_name = File.join(dir,now + "_" + name)
    end
  end
  raise "file exist #{file_name}. " if File.exist? file_name
  return file_name
end

def check_write_file file_name, camera_file_size
  unless File.exist? file_name
    raise "file not found.#{file_name}."
  end
  write_file_size = File.size(file_name)
  if write_file_size != camera_file_size
    raise "write file(#{file_name}) not same file size. write size #{new_size} / camera size #{org_size}."
  end
  return 
end

@save_count=0
@total_size=0
def save_and_delete(write_dir,folder)
  files = folder.files
  files.each do |file|
    return if 100 <= @save_count
    @total_size += file.info.size
    camera_file_size = file.info.size
    file_name = renew_file_path(write_dir, file.name, camera_file_size)
    puts "saving #{folder.path}/#{file.name} to #{file_name}. #{format_filesize(camera_file_size)} byte"
    start_time = Time.now
    file.save file_name
    diff_time = (Time.now - start_time).to_f 
    rate = file.info.size.to_f / diff_time
    puts ("save ok %.2f sec. %s /sec" % [diff_time, format_filesize(rate)])
    check_write_file file_name, camera_file_size
    file.delete
    @save_count += 1
    puts "delete camera file #{folder.path}/#{file.name} (#{@save_count})"
    file = nil
  end
  files = nil
  folder.folders.each do  |child|
    save_and_delete(write_dir, child)
    child = nil
  end
  folder = nil
end


camera_model='Canon EOS 7D MarkII'

if ARGV.size <= 1 or  4 <= ARGV.size then
  puts "usage: write_dir ip_address [model]"
  puts "model : default '#{camera_model}'"
  puts "ex ./ 192.168.0.1 '"
  exit
end

if ARGV.size == 3
  camera_model=ARGV[2]
end
write_dir = ARGV[0]
camera_ip_addres=ARGV[1]
puts "trans_file"
puts " write path   #{write_dir}"
puts " ptpip        #{camera_ip_addres}"
puts " camera model #{camera_model}"
begin
  camera = GPhoto2::Camera.new(camera_model,"ptpip:#{camera_ip_addres}")
  list_files(camera.filesystem)
rescue  => e
  puts "#{e}"
  puts "but ok... status"
  exit 0
end

begin
  st_file_count =  @files.size
  st_total_size =  @files.inject(0){|sum,hash| sum += hash[:size]}
  puts "#{st_file_count} files. total file size #{format_filesize(st_total_size)}."

  if st_file_count == 0
    puts "file not found in camera."
    exit 
  end
  puts "start."
  
  start_time = Time.now
  save_and_delete(write_dir, camera.filesystem)
  diff_time = (Time.now - start_time).to_f 
  size_rate = @total_size.to_f   / diff_time
  count_rate = 999999
  if @save_count != 0
    count_rate =   diff_time / @save_count
  end
  
  puts "fin."
  puts "#{@save_count} files. total file size #{format_filesize(@total_size)}."
  puts ("complete  %.2f sec. transrate %s /sec. average  %.2f sec/file. " %
        [diff_time, format_filesize(size_rate), count_rate])
  
  if st_file_count != @save_count
    puts "file count #{st_file_count}. save count #{@save_count}. remaining #{file_count-@save_count} "
    puts "retry exec program."
  end
  
  
rescue  => e
  p e
  p e.class
  p e.message
  p e.backtrace
  puts "error"
  exit 1
end
