////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ФизическиеЛица", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы
