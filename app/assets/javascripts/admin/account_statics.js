$(function() {
  var sum_stock_num = 0, sum_breo_stock_percentage = 0, sum_stock_percentage = 0;
  $('td.col-breo_stock_num').each(function() {
    var v = parseFloat($(this).html().replace(/\,/g, '') || 0);
    sum_stock_num += v;
  });
  $('td.col-current_breo_stock_percentage').each(function() {
    var v = parseFloat($(this).html() || 0);
    sum_breo_stock_percentage += v;
  });
  $('td.col-current_company_stock_percentage').each(function() {
    var v = parseFloat($(this).html().replace(/\,/g, '') || 0);
    sum_stock_percentage += v;
  });

  var tr_class = "odd";
  if ($("#index_table_account_statics tbody tr:last").hasClass('odd')) {
    tr_class = "even";
  }
  var rowItem = '<tr class="account_statics ' + tr_class + '">'
                + '<td class="col">合计</td>'
                + '<td class="col"></td>'
                + '<td class="col">' + sum_stock_num.toFixed(1).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>'
                + '<td class="col">' + sum_breo_stock_percentage.toFixed(4) + ' %</td>'
                + '<td class="col">' + sum_stock_percentage.toFixed(4) + ' %</td>'
                + '</tr>';
  $("#index_table_account_statics tbody:last").append(rowItem);
});