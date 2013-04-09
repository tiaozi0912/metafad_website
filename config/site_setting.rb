# Site-Wide Settings File ./config/site_settings.rb
# This file defines Modules and Constants which should be used consistently throughout the application
module ColorScheme
  BlueishWhite = 'rgb(213,234,222)'
  Red = 'rgb(234,46,73)'
  Blue = 'rgb(119,116,211)'
  Black = 'rgb(51,55,69)'
  Yellow = 'rgb(246,247,146)'
end

module Site
  # Module Method which generates an OUTPUT CSS file *.css for each INPUT CSS file *.css.in we find in our CSS directory
  # replacing any mention of Color Constants , e.g. #SomeColor# , with the corresponding color defined above
  #
  def self.generate_CSS_files
    # assuming all your CSS files live under "./public/stylesheets"
    Dir.glob( File.join( Rails.root.to_s , 'app','assets','stylesheets', '*.css.in') ).each do |filename_in|
      filename_out = filename_in.sub(/.in$/, '')
 
      # if the output CSS file doesn't exist, or the the input CSS file is newer than the output CSS file:
      if (! File.exists?(filename_out)) || (File.stat( filename_in ).mtime > File.stat( filename_out ).mtime)
        # in this case, we'll need to create the output CSS file fresh:
        puts " processing #{filename_in}\n --> generating #{filename_out}"
       
        out_file = File.open( filename_out, 'w' )
        File.open( filename_in , 'r' ).each do |line|
          if line =~ /^\s*\/\*/ || line =~ /^\s+$/             # ignore empty lines, and lines starting with a comment
            out_file.print(line)
            next
          end
          while  line =~ /#(\w+)#/  do                         # substitute all the constants in each line
            line.sub!( /#\w+#/ , ColorScheme.const_get( $1 ) ) # with the color the constant defines
          end
          out_file.print(line)
        end
        out_file.close
      end # if ..
    end
  end # def self.generate_CSS_files
end


