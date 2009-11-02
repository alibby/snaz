class DocumentsController < ApplicationController
	def index
		@documents = Document.paginate :page => params[:page] || 1, :order => :name
	end
	
	def search
		return redirect_to("/search?q=%s" % [ params[:query] ]) if request.request_method == :post
		@query = query = params[:q]
		@page = page = (params[:page] ? params[:page].to_i : 1)
 		@results = Sunspot.search Document do 
			keywords query
			paginate :page => page
		end
	end
	
	def show
		fn = %Q{%s/data/RFCs/%s.txt} % [ RAILS_ROOT, params[:name].downcase ]
		return send_file(fn, :type => 'text/plain', :disposition => 'inline') if File.file?(fn)
		render "%s/public/404.html" % [ RAILS_ROOT ], :status => 404
	end
end
