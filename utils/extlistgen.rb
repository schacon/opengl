#!/usr/bin/env ruby
#
# Copyright (C) 2007 Jan Dvorak <jan.dvorak@kraxnet.cz>
#
# This program is distributed under the terms of the MIT license.
# See the included MIT-LICENSE file for the terms of this license.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# extlistgen.rb - generates HTML table of extension support from .in file

# main
require 'csv'

#infile = "../doc/extensions.txt.in"
#outfile = "../doc/extensions.txt"
#versions = ["svn","0.50","0.40","0.30"]

opengl_extdoc_url = "http://opengl.org/registry/specs/"

begin
	if ARGV.size < 3
		puts "Parameters: infile outfile version [version ...]"
		raise 		
	end
	
	infile,outfile,*versions = ARGV
	
	# read the list
	extensions = []
	CSV.open(infile, 'r') do |row|
		next if row[0][0] == ?#  # discard comment line
		extensions << row
	end
	extensions.sort!

	# create output
	File.open(outfile, 'w') do |f|
		f << "<table class='extlist'>\n"
		f << "<tr>\n"

		# header
		f << "<th>Extension</th>\n"
		versions.each do |ver|
			f << "<th>#{ver}</th>\n"
		end
		f << "</tr>\n"

		# content
		extensions.each do |ext|
			next if ext[1]=="NonGL" # skip non-GL (WGL,GLX) extensions

			tmp, subdir, *fname = ext[0].split("_")
			link = opengl_extdoc_url + subdir + "/" + fname.join("_") + ".txt"

			f << "<tr>\n"
			f << "<td><a href='#{link}'>#{ext[0]}</a></td>"

			versions.each do |ver|
				if (ext[1]=="Supported" && (ver>=ext[2]))
					f << "<td class='supported'>YES</td>"
				elsif (ext[1]=="Other")
					f << "<td class='other'>NO</td>"
				else # unsupported
					f << "<td class='unsupported'>NO</td>"
				end
			end
			f << "</tr>\n"
		end

		f << "</table>"
	end
rescue
	puts $!
end
