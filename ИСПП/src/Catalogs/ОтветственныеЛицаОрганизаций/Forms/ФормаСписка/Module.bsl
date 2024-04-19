
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьОрганизацию();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Не Элементы.ОрганизацияОтбор.Видимость Тогда
		Настройки.Удалить("Организация");
	Иначе
		Организация = Настройки.Получить("Организация");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Владелец",
			Организация,
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(Организация));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Владелец",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформлениеСписка = ОбщегоНазначенияПоддержкаПроектовКлиентСервер.ПолучитьУсловноеОформлениеДинамическогоСписка(Список);
	
	// Шрифт в строках списка Список
	Элемент = УсловноеОформлениеСписка.Элементы.Добавить();
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"ПравоПодписиПоДоверенности", ВидСравненияКомпоновкиДанных.Равно, Ложь);
		
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ШрифтТекста,,, Истина));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОрганизацию()
	
	Если Параметры.Свойство("Отбор")
	   И Параметры.Отбор.Свойство("Владелец") Тогда
		
		Организация = Параметры.Отбор.Владелец;
		
		Элементы.ОрганизацияОтбор.Видимость = Ложь;
		Элементы.Владелец.Видимость         = Ложь;
		
	Иначе
		Элементы.Владелец.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
