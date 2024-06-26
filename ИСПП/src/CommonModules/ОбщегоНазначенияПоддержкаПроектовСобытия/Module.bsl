
#Область ОбработчикиСобытий

// Обработчик подписки на событие ПроверитьЗначениеОпцииИспользоватьНесколькоОрганизаций.
// Вызывается при записи элемента справочника "Организации".
//
Процедура ПроверитьЗначениеОпцииИспользоватьНесколькоОрганизацийПриЗаписи(Источник, Отказ) Экспорт
	
	Если Не Источник.ЭтоГруппа
	   И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций")
	   И Справочники.Организации.КоличествоОрганизаций() > 1 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Константы.ИспользоватьНесколькоОрганизаций.Установить(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик подписки на событие ПроверитьЗначениеОпцииИспользоватьНесколькоВалют.
// Вызывается при записи элемента справочника "Валюты".
//
Процедура ПроверитьЗначениеОпцииИспользоватьНесколькоВалютПриЗаписи(Источник, Отказ) Экспорт
	
	Если Не Источник.ЭтоГруппа
	   И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
	   И ОбщегоНазначенияПоддержкаПроектов.КоличествоЭлементов(Источник.Метаданные()) > 1 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Константы.ИспользоватьНесколькоВалют.Установить(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы валют.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника.
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ПереопределитьПолучаемуюФормуВалют(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаСписка" И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаЭлемента";
		Параметры.Вставить("Ключ", ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	КонецЕсли;
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписьюКонстанты.
//
Процедура ПроконтролироватьЗначенияРодительскихКонстантПередЗаписью(Источник, Отказ) Экспорт
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКонстанты      = Источник.Метаданные().Имя;
	ЗначениеКонстанты = Источник.Значение;
	
	ТипКонстанты    = ТипЗнч(ЗначениеКонстанты);
	ПримитивныеТипы = Новый ОписаниеТипов("Число, Строка, Дата, Булево, Неопределено");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПримитивныеТипы.СодержитТип(ТипКонстанты)
	 Или ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеКонстанты) Тогда
		
		СтароеЗначение = Константы[ИмяКонстанты].Получить();
		Если ЗначениеКонстанты <> СтароеЗначение Тогда
			Если Не ОбщегоНазначенияПоддержкаПроектов.ВозможноИзменитьЗначениеКонстанты(ИмяКонстанты, СтароеЗначение) Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик подписки на событие ПриЗаписиКонстанты.
//
Процедура СинхронизироватьЗначенияПодчиненныхКонстантПриЗаписи(Источник, Отказ) Экспорт
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКонстанты      = Источник.Метаданные().Имя;
	ЗначениеКонстанты = Источник.Значение;
	
	ТипКонстанты    = ТипЗнч(ЗначениеКонстанты);
	ПримитивныеТипы = Новый ОписаниеТипов("Число, Строка, Дата, Булево, Неопределено");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПримитивныеТипы.СодержитТип(ТипКонстанты)
	 Или ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеКонстанты) Тогда
		
		ПодчиненныеКонстанты = ОбщегоНазначенияПоддержкаПроектовПовтИсп.ПолучитьДопустимыеЗначенияПодчиненныхКонстант(ИмяКонстанты, ЗначениеКонстанты);
		Если ЗначениеЗаполнено(ПодчиненныеКонстанты) Тогда
			
			Для Каждого КлючИЗначение Из ПодчиненныеКонстанты Цикл
				УстановитьЗначениеКонстанты(Константы[КлючИЗначение.Ключ], КлючИЗначение.Значение);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	
КонецПроцедуры

// Производится очистка измерения "Документ" по регистрам "Границы..",
// где в текущих записях используется удаляемый документ.
// Вызывается из подписки на события "ОчиститьГраницыПередУдалениемДокумента",
// выполняется только в главном узле РИБ.
//
// Параметры:
//  Источник - ДокументСсылка - Ссылка на удаляемый документ.
//  Отказ - Булево - Признак необходимости прерывания удаления объекта.
//
Процедура ОчиститьГраницыПередУдалениемДокумента(Источник, Отказ) Экспорт
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Границы.Месяц         КАК Месяц,
	|	Границы.НомерЗадания  КАК НомерЗадания,
	|	Границы.Организация   КАК Организация,
	|	Границы.Пропускать    КАК ПропускатьПриЗаписи
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Границы.Месяц         КАК Месяц,
	|		Границы.НомерЗадания  КАК НомерЗадания,
	|		Границы.Организация   КАК Организация,
	|		ВЫБОР
	|			КОГДА Дубли.Документ ЕСТЬ NULL
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ                 КАК Пропускать
	|	ИЗ
	|		РегистрСведений.ГраницыРасчетаСебестоимостиТоваров КАК Границы
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			РегистрСведений.ГраницыРасчетаСебестоимостиТоваров КАК Дубли
	|		ПО
	|			Дубли.Месяц = Границы.Месяц
	|			И Дубли.НомерЗадания = Границы.НомерЗадания
	|			И Дубли.Организация = Границы.Организация
	|			И Дубли.Документ = НЕОПРЕДЕЛЕНО
	|	ГДЕ
	|		Границы.Документ = &Документ
	|	) КАК Границы
	|");
	
	Запрос.УстановитьПараметр("Документ", Источник.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ГраницыКОчистки = РегистрыСведений.ГраницыРасчетаСебестоимостиТоваров.СоздатьНаборЗаписей();
		ГраницыКОчистки.Отбор.Документ.Установить(Источник.Ссылка);
		ГраницыКОчистки.ОбменДанными.Загрузка = Истина;
		ГраницыКОчистки.Записать();
		
		ГраницыКЗаписи = РегистрыСведений.ГраницыРасчетаСебестоимостиТоваров.СоздатьНаборЗаписей();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Не Выборка.ПропускатьПриЗаписи Тогда
				ЗаполнитьЗначенияСвойств(ГраницыКЗаписи.Добавить(), Выборка);
			КонецЕсли;
		КонецЦикла;
		
		Попытка
			Если ГраницыКЗаписи.Количество() <> 0 Тогда
				ГраницыКЗаписи.ОбменДанными.Загрузка = Истина;
				ГраницыКЗаписи.Записать(Ложь);
			КонецЕсли;
		Исключение
			Отказ = Истина;
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Удаление помеченных объектов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.ОбщиеМодули.ОбщегоНазначенияПоддержкаПроектовСобытия,
				,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗначениеКонстанты(МенеджерКонстанты, ЗначениеКонстанты)
	
	Если МенеджерКонстанты.Получить() <> ЗначениеКонстанты Тогда
		МенеджерКонстанты.Установить(ЗначениеКонстанты);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
