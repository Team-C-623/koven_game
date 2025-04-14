extends Node

var currency: int = 0


signal currency_changed(new_amount)
func _ready() -> void:
	set_currency(200)

func set_currency(value:int) -> void:
	currency = max(0,value)
	emit_signal("currency_changed",currency)

func add_currency(amount:int) -> void:
	set_currency(currency+amount)
	
func subtract_currency(amount:int) -> bool:
	if amount > currency:
		return false #not enough currency
	set_currency(currency-amount)
	return true

func can_afford(amount:int) -> bool:
	return currency >= amount
