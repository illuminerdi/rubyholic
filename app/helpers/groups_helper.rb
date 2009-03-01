module GroupsHelper
  
  def column_sort_link(text, param)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
      :controller => "groups", :action => "index", :params => {:sort => key}
    }
    link_to(text, options)
  end
end
