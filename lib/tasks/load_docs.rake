require 'hpricot'

def log_msg(msg)
	$stderr.puts %Q{[ %s ] %s} % [ Time.now.strftime("%Y-%m-%d %H:%M:%S"), msg ]
end

namespace :snaz do
	desc "Whack documents"
	task :whack_documents do
		Document.delete_all
	end

	desc "Load documents"
	task :load_documents do 
		start_time = Time.now
		fn = "%s/data/rfc-index.xml" % [ RAILS_ROOT ]
		log_msg "reading/ parsing RFCs from #{fn}"
		open(fn) do |fh|
			doc = Hpricot(fh)
			log_msg "Adding RFCs to DB"
			(doc/'//rfc-entry').each do |entry|
				date = (entry/'date')
				doc = Document.create(
					:name => (entry/'/doc-id').inner_text,
					:title => (entry/'/title').inner_text,
					:author => (entry/'/author').map { |author| (author/'/name').inner_text }.join(', '),
					:date => %Q{%s %s} % [ (date/'/month').inner_text, (date/'/year').inner_text ],
					:keywords => (entry/'/keywords/kw').map { |kw| kw.inner_text }.join(', '),
					:abstract => (entry/'/abstract').inner_text
				)
				log_msg "%s %s" % [ doc.name, doc.title ]
			end
		end
		completed = Time.now
		log_msg "Started: #{start_time}"
		log_msg "Complete: #{completed}"
	end

	desc "Reload documents"
	task :reload_documents => [ :whack_documents, :load_documents ]
end