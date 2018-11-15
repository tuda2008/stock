$(function() {
  var sum_stock_capital_sum = 0, sum_stock_holders_buy_sum_price = 0, sum_stock_ransom_sum_price = 0, sum_stock_stockholders_num = 0;
  $('td.col-capital_sum').each(function() {
    var v = parseFloat($(this).html().replace(/\,/g, '') || 0);
    sum_stock_capital_sum += v;
  });
  $('td.col-stockholders_num').each(function() {
    var v = parseFloat($(this).html().replace(/\,/g, '') || 0);
    sum_stock_stockholders_num += v;
  });
  $('td.col-holders_buy_sum_price').each(function() {
    var v = parseFloat($(this).html().replace(/\,/g, '') || 0);
    sum_stock_holders_buy_sum_price += v;
  });
  $('td.col-ransom_sum_price').each(function() {
    var v = parseFloat($(this).html().replace(/\,/g, '') || 0);
    sum_stock_ransom_sum_price += v;
  });

  var tr_class = "odd";
  if ($("#index_table_stock_companies tbody tr:last").hasClass('odd')) {
    tr_class = "even";
  }
  var rowItem = '<tr class="stock_companies ' + tr_class + '">'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '<td class="col">合计</td>'
                + '<td class="col">' + sum_stock_capital_sum.toFixed(1).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>'
                + '<td class="col">' + sum_stock_stockholders_num.toFixed(0).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>'
                + '<td class="col">' + sum_stock_holders_buy_sum_price.toFixed(1).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>'
                + '<td class="col">' + sum_stock_ransom_sum_price.toFixed(1).toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + '</td>'
                + '<td class="col"></td>'
                + '<td class="col"></td>'
                + '</tr>';
  $("#index_table_stock_companies tbody:last").append(rowItem);
});