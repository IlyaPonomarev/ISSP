#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//  НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//  ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса
//
// Возвращаемое значение:
//  Булево - Истина, в случае успешной установки нового статуса
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыДоговоровКонтрагентов[НовыйСтатус];
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПроектЗадания") Тогда
		ПроектЗадания = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	
	ИнициализироватьСправочник();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Согласован              = Ложь;
	ДатаНачалаДействия      = '00010101';
	ДатаОкончанияДействия   = '00010101';
	
	ИнициализироватьСправочник();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	// Дата начала действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(ДатаДоговора) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		
		Если НачалоДня(ДатаДоговора) > ДатаНачалаДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата начала действия договора должна быть не меньше даты договора'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаНачалаДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата договора.
	Если ЗначениеЗаполнено(ДатаДоговора) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
		
		Если НачалоДня(ДатаДоговора) > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты договора'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Дата окончания действия договора должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
		
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия договора должна быть не меньше даты начала действия'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// Должно быть перед проверкой загрузки
	Если Владелец <> Справочники.Контрагенты.ДляПереходаНаДоговорыБезВладельца Тогда
		Владелец = Справочники.Контрагенты.ДляПереходаНаДоговорыБезВладельца;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НаименованиеДляПечати) Тогда
		НаименованиеДляПечати = СокрЛП(Наименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ И ЗАПОЛНЕНИЕ
#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьСправочник()
	
	Менеджер = Пользователи.ТекущийПользователь();
	
	Организация = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если Не ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		ВалютаВзаиморасчетов = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти // ИнициализацияИЗаполнение

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли