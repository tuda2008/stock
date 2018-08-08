    $(function() {
      $('#ransom_stock_user_id').change(function() {
        $.ajax({
          url: '/admin/ransom_stocks/get_companies_by_user',
          type: 'POST',
          data: {
            user_id: $(this).val()
          },
          dataType:'json',
          headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
          },
          success: function(data) {
            $('#ransom_stock_company_id').html("");
            var str = '<option value=""></option>';
            for (var i = 0; i < data.length; ++i) {
              str += '<option value="' + data[i].id + '">' + data[i].name + '</option>';
            };
            $('#ransom_stock_company_id').append(str);
          },
          error: function() {
            $('#ransom_stock_company_id').append('');
          }
        });
      });
    });