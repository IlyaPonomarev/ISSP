
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьПараметрыДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ВыделенныеСтроки = Элементы.СписокСтатейРасходов.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		СтатьяРасходов = ВыделенныеСтроки[0];
		Если Не ЗначениеЗаполнено(СтатьяРасходов) Или ЭтоГруппаСтатейРасходов(СтатьяРасходов) Тогда
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Команда не может быть выполнена для указанного объекта.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСтатейРасходовПриАктивизацииСтроки(Элемент)
	
	УстановитьПараметрыДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	ВыделенныеСтроки = Элементы.СписокСтатейРасходов.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		СтатьяРасходов = ВыделенныеСтроки[0];
	Иначе
		СтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", СтатьяРасходов, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
КонецПроцедуры

&НаСервере
Функция ЭтоГруппаСтатейРасходов(СтатьяРасходов)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатьяРасходов, "ЭтоГруппа");
	
КонецФункции

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти // СтандартныеПодсистемы
