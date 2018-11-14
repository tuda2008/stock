$(function() {
  var sum_stock_num = 0, sum_stock_percentage = 0, sum_stock_sum_price = 0;
  var sum_stock_capital_sum = 0, sum_stock_capital_percentage = 0;
  $('td.col-breo_stock_num').each(function() {
    var v = parseFloat($(this).html() || 0);
    sum_stock_num += v;
  });
  $('td.col-breo_stock_percentage').each(function() {
    var v = parseFloat($(this).html() || 0);
    sum_stock_percentage += v;
  });
  $('td.col-stock_sum_price').each(function() {
    var v = parseFloat($(this).html() || 0);
    sum_stock_sum_price += v;
  });
  $('td.col-capital_sum').each(function() {
    var v = parseFloat($(this).html() || 0);
    sum_stock_capital_sum += v;
  });
  $('td.col-capital_percentage').each(function() {
    var v = parseFloat($(this).html() || 0);
    sum_stock_capital_percentage += v;
  });

  var tr_class = "odd";
  if ($("#index_table_stock_accounts tbody tr:last").hasClass('odd')) {
    tr_class = "even";
  }
  var rowItem = '<tr class="stock_accounts ' + tr_class + '">'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '<td class="col">合计</td>'
                + '<td class="col">' + sum_stock_num.toFixed(0) + '</td>'
                + '<td class="col">' + sum_stock_percentage.toFixed(4) + ' %</td>'
                + '<td class="col"></td>'
                + '<td class="col">' + sum_stock_sum_price.toFixed(1) + '</td>'
                + '<td class="col">' + sum_stock_capital_sum.toFixed(1) + '</td>'
                + '<td class="col">' + sum_stock_capital_percentage.toFixed(4) + ' %</td>'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '</tr>';
  $("#index_table_stock_accounts tbody:last").append(rowItem);
});