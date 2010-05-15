// JavaScript that handles the dynamic ordering quantities on the ordering page.
//
// In a JavaScript block on the actual view, define the article data by calls to setData().
// You should also set the available group balance through setGroupBalance(amount).
//
// Call setDecimalSeparator(char) to overwrite the default character "." with a localized value.

var modified = false    		// indicates if anything has been clicked on this page
var groupBalance = 0;			// available group money 
var decimalSeparator = ".";		// default decimal separator
var toleranceIsCostly = true; // default tolerance behaviour

// Article data arrays:
var price = new Array();
var unit = new Array();  		// items per order unit
var itemTotal = new Array();    // total item price
var quantityOthers = new Array(); 
var toleranceOthers = new Array();
var itemsAllocated = new Array();  // how many items the group has been allocated and should definitely get
var quantityAvailable = new Array();  // stock_order. how many items are currently in stock

function setDecimalSeparator(character) {
	decimalSeparator = character;	
}

function setToleranceBehaviour(value) {
    toleranceIsCostly = value;
}

function setGroupBalance(amount) {
	groupBalance = amount;
}

function addData(itemPrice, itemUnit, itemSubtotal, itemQuantityOthers, itemToleranceOthers, allocated, available) {
	i = price.length;
	price[i] = itemPrice;
	unit[i] = itemUnit;
	itemTotal[i] = itemSubtotal;
	quantityOthers[i] = itemQuantityOthers;
	toleranceOthers[i] = itemToleranceOthers;
	itemsAllocated[i] = allocated;
	quantityAvailable[i] = available;
}

function increaseQuantity(item) {
    value = Number($('q_' + item).value) + 1;
    update(item, value, $('t_' + item).value);
}

function decreaseQuantity(item) {
    value = Number($('q_' + item).value) - 1;
    if (value >= 0) {
        update(item, value, $('t_' + item).value);
    }
}

function increaseTolerance(item) {
    value = Number($('t_' + item).value) + 1;
    update(item, $('q_' + item).value, value);
}

function decreaseTolerance(item) {
    value = Number($('t_' + item).value) - 1;
    if (value >= 0) {
        update(item, $('q_' + item).value, value);
    }
}

function update(item, quantity, tolerance) {
	// set modification flag
	modified = true
	
	// update hidden input fields
	$('q_' + item).value = quantity;
	$('t_' + item).value = tolerance;
	
	// calculate how many units would be ordered in total
	units = calcUnits(unit[item], quantityOthers[item] + Number(quantity), toleranceOthers[item] + Number(tolerance));
	if (unitCompletedFromTolerance(unit[item], quantityOthers[item] + Number(quantity), toleranceOthers[item] + Number(tolerance))) {
		$('units_' + item).update('<span style="color:grey">' + String(units) + "</span>");
	} else {
		$('units_' + item).update(String(units));
	}
	
	// update used/unused quantity
	available = Math.max(0, units * unit[item] - quantityOthers[item]);
	q_used = Math.min(available, quantity);
	// ensure that at least the amout of items this group has already been allocated is used
	if (quantity >= itemsAllocated[item] && q_used < itemsAllocated[item]) {
		q_used = itemsAllocated[item];
	}
	$('q_used_' + item).update(String(q_used));
	$('q_unused_' + item).update(String(quantity - q_used));
	$('q_total_' + item).update(String(Number(quantity) + quantityOthers[item]));	
	
	// update used/unused tolerance
	if (unit[item] > 1) {
		available = Math.max(0, available - q_used - toleranceOthers[item]);
		t_used = Math.min(available, tolerance);
		$('t_used_' + item).update(String(t_used));
		$('t_unused_' + item).update(String(tolerance - t_used));
		$('t_total_' + item).update(String(Number(tolerance) + toleranceOthers[item]));
	}
	
	// update total price
    if(toleranceIsCostly == true) {
        itemTotal[item] = price[item] * (Number(quantity) + Number(tolerance));
    } else {
        itemTotal[item] = price[item] * (Number(quantity));
    }
	$('price_' + item + '_display').update(asMoney(itemTotal[item]));

  // update missing units
  missing_units = unit[item] - (((quantityOthers[item] + Number(quantity)) % unit[item]) + Number(tolerance) + toleranceOthers[item])
  if (missing_units < 0) {
    missing_units = 0;
  }
  $('missing_units_' + item).update(String(missing_units));
    
    // update balance
    updateBalance();
}    

function increaseStockQuantity(item) {
    value = Number($('q_' + item).value) + 1;
    if (value <= quantityAvailable[item] - quantityOthers[item]) {
        updateStockQuantity(item, value);
    }
}

function decreaseStockQuantity(item) {
    value = Number($('q_' + item).value) - 1;
    if (value >= 0) {
        updateStockQuantity(item, value);
    }
}

function updateStockQuantity(item, quantity) {
  // set modification flag
	modified = true

	// update hidden input fields
	$('q_' + item).value = quantity;

	// update used/unused quantity
	available = Math.max(0, quantityAvailable[item] - quantityOthers[item]);
	q_used = Math.min(available, quantity);

	// ensure that at least the amout of items this group has already been allocated is used
	if (quantity >= itemsAllocated[item] && q_used < itemsAllocated[item]) {
		q_used = itemsAllocated[item];
	}
	$('q_used_' + item).update(String(q_used));
	$('q_total_' + item).update(String(Number(quantity) + quantityOthers[item]));

	// update total price
	itemTotal[item] = price[item] * (Number(quantity));
	$('price_' + item + '_display').update(asMoney(itemTotal[item]));

    // update balance
    updateBalance();
}

function asMoney(amount) {
	return String(amount.toFixed(2)).replace(/\./, ",");	
}

function calcUnits(unitSize, quantity, tolerance) {
    units = Math.floor(quantity / unitSize)
    remainder = quantity % unitSize
    return units + ((remainder > 0) && (remainder + tolerance >= unitSize) ? 1 : 0) 
}

function unitCompletedFromTolerance(unitSize, quantity, tolerance) {
    remainder = quantity % unitSize
    return (remainder > 0 && (remainder + tolerance >= unitSize));
}

function updateBalance() {
    // update total price and order balance
    total = 0;
    for (i = 0; i < itemTotal.length; i++) {
        total += itemTotal[i];
    }        
    $('total_price').update(asMoney(total));
    balance = groupBalance - total;
    $('new_balance').update(asMoney(balance));
    $('total_balance').value = asMoney(balance);
    // determine bgcolor and submit button state according to balance 
    if (balance < 0) {
        bgcolor = '#FF0000';
        $('submit_button').disabled = true;
    } else {
        bgcolor = '';
        $('submit_button').disabled = false;
    }
    // update bgcolor
    for (i = 0; i < itemTotal.length; i++) {
        $('td_price_' + i).style.backgroundColor = bgcolor;
    }            
}   

function confirmSwitchOrder() {
	return (!modified || confirm('Änderungen an dieser Bestellung gehen verloren, wenn zu einer anderen Bestellung gewechselt wird.'))
}
