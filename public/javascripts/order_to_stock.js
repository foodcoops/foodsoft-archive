// Defaults
var decimalSeparator = ".";		// default decimal separator

// Article data arrays:
var price = new Array();
var unit = new Array();  		// items per order unit
var itemTotal = new Array();    // total item price
var quantityOthers = new Array();
var toleranceOthers = new Array();
var itemsAllocated = new Array();  // how many items should go in to stock

function addData(item, itemPrice, itemUnit, itemQuantityOthers, itemToleranceOthers, allocated) {
  price[item] = itemPrice;
  unit[item] = itemUnit;
  quantityOthers[item] = itemQuantityOthers;
  toleranceOthers[item] = itemToleranceOthers;
  itemsAllocated[item] = allocated;
}

function calcUnits(unitSize, quantity, tolerance) {
  units = Math.floor(quantity / unitSize)
  remainder = quantity % unitSize
  return units + ((remainder > 0) && (remainder + tolerance >= unitSize) ? 1 : 0)
}

function increaseQuantity(item) {
  value = Number($('q_' + item).value) + 1;
  update(item, value, 0);
}

function decreaseQuantity(item) {
  value = Number($('q_' + item).value) - 1;
  if (value >= 0) {
    update(item, value, 0);
  }
}

function update(item, quantity, tolerance) {

  // update hidden input fields
  $('q_' + item).value = quantity;
  $('qts_' + item).update(String(Number(quantity)));
  $('tq_' + item).update(String(Number(quantity + quantityOthers[item])));

  // calculate how many units would be ordered in total
  units = calcUnits(unit[item], quantityOthers[item] + Number(quantity), toleranceOthers[item] + Number(tolerance));
  $('units_' + item).update(String(units));
  luq = (Number(quantity) + quantityOthers[item]) % unit[item]
  $('luq_' + item).update(String(luq));

  // Update row background color
  if (luq == 0) {
    $('order_article_' + item).setStyle({color: 'green'})
  } else {
    $('order_article_' + item).setStyle({color: 'red'})
  }
}