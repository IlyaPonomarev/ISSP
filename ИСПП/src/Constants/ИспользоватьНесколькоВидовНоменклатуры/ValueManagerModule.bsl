#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтотОбъект.Значение И Справочники.ВидыНоменклатуры.ИспользуетсяНесколькоВидовНоменклатуры() Тогда
		ВызватьИсключение НСтр("ru='В базе заведено несколько видов номенклатуры.
									|Отключение использования нескольких видов номенклатуры невозможно.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
