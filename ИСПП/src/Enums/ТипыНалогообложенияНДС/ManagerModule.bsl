#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(ПродажаОблагаетсяНДС);
	ДанныеВыбора.Добавить(ПродажаОблагаетсяЕНВД);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#КонецЕсли