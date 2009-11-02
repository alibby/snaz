class Document < ActiveRecord::Base
	cattr_reader :per_page;
	@@per_page = 20;

	searchable do
		text :name, :title, :keywords, :abstract, :content
		string :name, :stored => true
		string :title, :stored => true
		string :abstract, :stored => true
		string :content, :stored => false do 
			content.gsub /[^[:alpha:][:digit:]]/, ''
		end
	end

	# Return the RFC number.  This is 
	# gleaned from the name, by stripping RFC from the 
	# front of the name.
	def number
		name.gsub(/^rfc/i, '').to_i
	end
	
	# Generate a string containing the path to the file on the
	# System.  Note this does no checking, it's creates a path
	# tht is where we expect the file to be.
	def filename
		"%s/data/RFCs/rfc%d.txt" % [ RAILS_ROOT, number ]
	end
	
	# Return the contents of the RFC file, or an empty string if 
	# the file does not exist, can't be read, has bad Karma, etc.
	def content
		if(File.file? filename)
			IO.readlines(filename).join ''
		else
			""
		end
	end
end

