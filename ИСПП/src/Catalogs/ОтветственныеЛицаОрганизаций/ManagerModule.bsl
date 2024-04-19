
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

// Обработчик события ОбработкаПолученияДанныхВыбора
//
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		
		// Заменим платформенный механизм формирования списка выбора,
		// т.к. необходим отбор по дате получения данных об ответственных лицах
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		
		ТаблицаОтветственных = ОтветственныеЛицаВызовСервера.ПолучитьТаблицуОтветственныхЛицПоОтбору(Параметры.Отбор, Истина);
		
		Для Каждого Ответственный Из ТаблицаОтветственных Цикл
			
			СтруктураЭлементаСписка = Новый Структура;
			СтруктураЭлементаСписка.Вставить("Значение", Ответственный.Ссылка);
			СтруктураЭлементаСписка.Вставить("ПометкаУдаления", Ответственный.ПометкаУдаления);
			СтруктураЭлементаСписка.Вставить("Предупреждение"); // стандартное сообщение
			
			ДанныеВыбора.Добавить(СтруктураЭлементаСписка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
