
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает цену последней закупки номенклатуры
//
Функция ПолучитьЦенуПоследнейЗакупки(Номенклатура, ЕдиницаИзмерения, Дата, Документ, Склад, Поставщик, Валюта) Экспорт
	
	Возврат ЗапасыСервер.ПолучитьЦенуПоследнейЗакупки(Номенклатура, ЕдиницаИзмерения, Дата, Документ, Склад, Поставщик, Валюта);
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс