ActiveAdmin.register Journal do

menu false

actions :show
 
show do
    @data = {'StockAccount' => 'stock_account', 'RansomStock' => 'ransom_stock', 'StockSplit' => 'stock_split'}
    arrs = []
    attributes_table do
      row :id
      row :user do |journal|
        journal.user.name + " " + journal.user.cert_id
      end
      row "历史详情" do |journal|
        arrs << "<ul>"
        journal.details.each do |detail|
          arrs << "<li>" + show_detail(detail, @data[journal.journalized_type]) + "</li>"
        end
        arrs << "</ul>"
        arrs.join("").html_safe
      end
      row :created_at do |journal|
        journal.created_at.strftime("%Y-%m-%d %H:%M:%S")
      end
    end
end

end