extends Node

var currency: int = 0
var modifier: float = 1.0
signal currency_changed(new_amount)
func _ready() -> void:
	set_currency(500)

func set_currency(value:int) -> void:
	currency = max(0,value)
	currency_changed.emit(currency)

func add_currency(amount:int) -> void:
	set_currency(currency + int(amount*modifier))

func subtract_currency(amount:int) -> bool:
	if amount > currency:
		return false #not enough currency
	set_currency(currency-amount)
	return true

func can_afford(amount:int) -> bool:
	return currency >= amount

func reset():
	set_currency(0)
