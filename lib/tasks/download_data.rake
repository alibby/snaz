require 'net/http'
require 'uri'


namespace :snaz do
	desc "download application data"
	task :download_data do
		urls = %w{
			http://www.xforty.com/~alibby/snaz_data/RFC-all.tar.gz
			http://www.xforty.com/~alibby/snaz_data/rfc-index.xml
		}

		urls.map { |i| URI.parse i }.each do |url|
			file = "%s/data/%s" % [ RAILS_ROOT, File.basename(url.path) ]
			if(File.file?(file))
				puts "%s already downloaded, skipping fetch" % [ File.basename(file) ]
				next
			end
			
			puts "Downloading %s" % [ url.to_s ]
			head = Net::HTTP::Head.new(url.path)
			get = Net::HTTP::Get.new(url.path)
			size = 0
			Net::HTTP.start(url.host, url.port) do |http|
				http.request(head) do |head_resp|
					size = head_resp.content_length
				end
				
				fetched = 0
				http.request(get) do |resp|
					File.open("%s/data/%s" % [ RAILS_ROOT, File.basename(url.path) ], 'w' ) do |fh|
						resp.read_body do |seg|
							fetched+=seg.length
							print "\r%s - %1.2f%%" % [ url.to_s, ( fetched.to_f / size.to_f ) * 100 ]
							fh.write seg
						end
					end
				end
			end
		end

		unless File.directory?("%s/data/RFCs" % [ RAILS_ROOT ])
			puts "Unarchiving RFCs"
			cmd = "mkdir %s/data/RFCs && cd %s/data/RFCs && tar -zxvpf ../RFC-all.tar.gz" % [ 
				RAILS_ROOT, RAILS_ROOT
			]
			system cmd
		else
			puts "Looks like RFCs are already unarchvied in data/RFCs"
		end

	end
end