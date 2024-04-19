
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Изменяет значения элементов списка отборов формы по установленному значению реквизита,
// если имена полей совпадают.
//
// Параметры:
//  Форма        - УправляемаяФорма - форма отчета.
//  ИмяРеквизита - Строка - имя изменяемого поля.
//
Процедура ПриИзмененииРеквизитаОтчета(Форма, ИмяРеквизита) Экспорт
	
	Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизита);
	ЗначениеРеквизита = Форма.Отчет[ИмяРеквизита];
	
	ЭлементыОтбора = Новый Массив;
	НайтиРекурсивно(Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы, ЭлементыОтбора, 1, Поле);
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			ЭлементОтбора.ПравоеЗначение = ЗначениеРеквизита;
		Иначе
			ЭлементОтбора.Использование = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает значение реквизитов формы из списка отборов,
// если имена полей совпадают.
//
// Параметры:
//  Форма      - УправляемаяФорма - форма отчета.
//  ИменаПолей - Массив - поля таблицы отбора.
//
Процедура ПриИзмененииОтбора(Форма, ИменаПолей) Экспорт
	
	Отчет = Форма.Отчет;
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		
		ЭлементыОтбора = Новый Массив;
		НайтиРекурсивно(Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы, ЭлементыОтбора, 1, Новый ПолеКомпоновкиДанных(ИмяПоля));
		
		ЗначениеНайдено = Ложь;
		ЗначениеРеквизита = Неопределено;
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			
			Если ЭлементОтбора.Использование Тогда
				ЗначениеНайдено = Истина;
				Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
					Если ЗначениеРеквизита <> Неопределено И ЭлементОтбора.ПравоеЗначение <> ЗначениеРеквизита Тогда
						ЗначениеРеквизита = Неопределено;
						Прервать;
					Иначе
						ЗначениеРеквизита = ЭлементОтбора.ПравоеЗначение;
					КонецЕсли;
				Иначе
					ЗначениеРеквизита = Неопределено;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЗначениеНайдено Тогда
			Отчет[ИмяПоля] = ЗначениеРеквизита;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет, является ли макет отчета редактируемым макетом.
//
// Параметры:
//  ИмяОбъектаМетаданныхМакета - Строка - имя макета как оно задано в свойствах макета.
//
// Возвращаемое значение:
//  ТипМакета, Неопределено - если макет редактируется, возвращается ТипМакета,
//                            иначе возвращается Неопределено.
//
Функция ПолучитьТипМакетаОтчета(ИмяОбъектаМетаданныхМакета) Экспорт
	
	ТипыМакетов = Новый Массив;
	ТипыМакетов.Добавить("MXL");
	ТипыМакетов.Добавить("DOC");
	ТипыМакетов.Добавить("ODT");
	
	Для Каждого ТипМакета Из ТипыМакетов Цикл
		Если СтрНачинаетсяС(ИмяОбъектаМетаданныхМакета, "ПФ_" + ТипМакета) Тогда
			Возврат ТипМакета;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает список всех группировок компоновщика настроек.
//
// Параметры:
//  ЭлементСтруктуры - КомпоновщикНастроекКомпоновкиДанных, НастройкиКомпоновкиДанных - элемент структуры КД.
//  ПоказыватьГруппировкиТаблиц - Булево - признак добавления в список группировки колонок (по умолчанию Истина).
//
// Возвращаемое значение:
//  ГруппировкаТаблицыКомпоновкиДанных, ГруппировкаДиаграммыКомпоновкиДанных,
//  ЭлементСтруктурыТаблицыКомпоновкиДанных, ЭлементСтруктурыДиаграммыКомпоновкиДанных
//  ГруппировкаКомпоновкиДанных - найденная группировка.
//
Функция ПолучитьГруппировки(ЭлементСтруктуры, ПоказыватьГруппировкиТаблиц = Истина) Экспорт
	
	СписокПолей = Новый СписокЗначений;
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Структура = ЭлементСтруктуры.Настройки.Структура;
		ДобавитьГруппировки(Структура, СписокПолей);
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Структура = ЭлементСтруктуры.Структура;
		ДобавитьГруппировки(Структура, СписокПолей);
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
		ДобавитьГруппировки(ЭлементСтруктуры.Строки, СписокПолей);
		ДобавитьГруппировки(ЭлементСтруктуры.Колонки, СписокПолей);
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
		ДобавитьГруппировки(ЭлементСтруктуры.Серии, СписокПолей);
		ДобавитьГруппировки(ЭлементСтруктуры.Точки, СписокПолей);
	Иначе
		ДобавитьГруппировки(ЭлементСтруктуры.Структура, СписокПолей, ПоказыватьГруппировкиТаблиц);
	КонецЕсли;
	
	Возврат СписокПолей;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура НайтиРекурсивно(КоллекцияЭлементов, МассивЭлементов, СпособПоиска, ЗначениеПоиска)
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если СпособПоиска = 1 Тогда
				Если ЭлементОтбора.ЛевоеЗначение = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			ИначеЕсли СпособПоиска = 2 Тогда
				Если ЭлементОтбора.Представление = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			НайтиРекурсивно(ЭлементОтбора.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
			
			Если СпособПоиска = 2 И ЭлементОтбора.Представление = ЗначениеПоиска Тогда
				МассивЭлементов.Добавить(ЭлементОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Добавляет вложенные группировки элемента структуры.
//
Процедура ДобавитьГруппировки(Структура, СписокГруппировок, ПоказыватьГруппировкиТаблиц = Истина)
	
	Для Каждого ЭлементСтруктуры Из Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
			ДобавитьГруппировки(ЭлементСтруктуры.Строки, СписокГруппировок);
			ДобавитьГруппировки(ЭлементСтруктуры.Колонки, СписокГруппировок);
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
			ДобавитьГруппировки(ЭлементСтруктуры.Серии, СписокГруппировок);
			ДобавитьГруппировки(ЭлементСтруктуры.Точки, СписокГруппировок);
		Иначе
			СписокГруппировок.Добавить(ЭлементСтруктуры);
			Если ПоказыватьГруппировкиТаблиц Тогда
				ДобавитьГруппировки(ЭлементСтруктуры.Структура, СписокГруппировок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
