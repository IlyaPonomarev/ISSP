#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция возвращает элемент таблицы доступных печатных форм объекта печати
//
Функция ДобавитьПечатнуюФорму(ПечатныеФормы) Экспорт
	
	МетаданныеМакета = МетаданныеМакета();
	МенеджерПечати = МетаданныеМакета.Родитель().ПолноеИмя();
	
	ПечатнаяФорма = УправлениеПечатьюПоддержкаПроектов.ДобавитьПечатнуюФорму(ПечатныеФормы, "НакладнаяНаПеремещение", МенеджерПечати);
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормПоддержкаПроектов.ПутьКМакету(МетаданныеМакета);
	ПечатнаяФорма.Представление = МетаданныеМакета.Представление();
	
	УправлениеПечатьюПоддержкаПроектов.ДобавитьКомандуПечати(ПечатнаяФорма);
	
	Возврат ПечатнаяФорма;
	
КонецФункции

// Функция формирует печатную форму Накладная на перемещение
//
Функция ПечатьНакладнаяНаПеремещение(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб        = Истина;
	
	ПолноеИмяМакета = ФормированиеПечатныхФормПоддержкаПроектов.ПутьКМакету(МетаданныеМакета());
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_" + ПолноеИмяМакета;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПолноеИмяМакета);
	
	СтруктураТипов = ОбщегоНазначенияПоддержкаПроектов.РазложитьМассивСсылокПоТипам(МассивОбъектов);
	
	НомерТипаДокумента = 0;
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечати(СтруктураОбъектов.Значение);
		
		СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати)
	
	ВалютаПечати = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(Шапка.Ссылка, ТабличныйДокумент, Макет);
		
		// Получение параметров для заполнения
		ДанныеШапки = ПолучитьДанныеШапкиДокумента(Шапка);
		
		// Вывод области Заголовок
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Заголовок", ДанныеШапки);
		
		// Вывод области РеквизитыШапки
		
		ОрганизацияПолучатель = Неопределено;
		Если ДанныеШапки.Свойство("ОрганизацияПолучатель", ОрганизацияПолучатель) И ЗначениеЗаполнено(ОрганизацияПолучатель) Тогда
			ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "РеквизитыЗаголовкаВнутреннееПеремещение", ДанныеШапки);
		Иначе
			ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "РеквизитыЗаголовка", ДанныеШапки);
		КонецЕсли;
		
		// Вывод области ШапкаТаблицы
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы", ДанныеШапки);
		
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		ВыборкаПоДокументам.Сбросить();
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		Если ВыборкаПоДокументам.НайтиСледующий(ПараметрыПоиска) Тогда
			ВыборкаСтрокТовары = ВыборкаПоДокументам.Выбрать();
			
			КлючиПараметров = ФормированиеПечатныхФормПоддержкаПроектов.ПолучитьИменаКолонокТаблицы(ВыборкаСтрокТовары);
			
			КоличествоСтрок = ВыборкаСтрокТовары.Количество();
			НомерСтроки = 0;
			Пока ВыборкаСтрокТовары.Следующий() Цикл
				
				НомерСтроки = НомерСтроки + 1;
				
				ДанныеСтроки = Новый Структура(КлючиПараметров);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
				
				ТоварНаименование = ОбщегоНазначенияПоддержкаПроектов.ПолучитьПредставлениеНоменклатурыДляПечати(
					ВыборкаСтрокТовары.ТоварНаименование,
					ВыборкаСтрокТовары.СерияНоменклатуры,
					,
					ВыборкаСтрокТовары.Описание);
					
				ДанныеСтроки.Вставить("ТоварНаименование", ТоварНаименование);
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				
				ЭтоПоследняяСтрока = НомерСтроки = КоличествоСтрок;
				ПроверитьВыводСтроки(ТабличныйДокумент, Макет, ОбластьСтрока, ЭтоПоследняяСтрока);
				
				// Вывод области Строка
				ТабличныйДокумент.Вывести(ОбластьСтрока);
				
			КонецЦикла;
		КонецЕсли;
		
		// Вывод области Подвал
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Подвал");
		
		// Вывод области Подписи
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Подписи", ДанныеШапки);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеШапкиДокумента(Шапка)
	
	КлючиПараметров = ФормированиеПечатныхФормПоддержкаПроектов.ПолучитьИменаКолонокТаблицы(Шапка);
	
	Параметры = Новый Структура(КлючиПараметров);
	ЗаполнитьЗначенияСвойств(Параметры, Шапка);
	
	// Данные заголовка
	НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Накладная на перемещение № %1 от %2'"), НомерДокумента, Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
	
	Параметры.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	
	// Данные реквизитов шапки
	СведенияОбОрганизации     = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	Параметры.Вставить("ОрганизацияПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации));
	
	ОрганизацияПолучатель = Неопределено;
	Если Параметры.Свойство("ОрганизацияПолучатель", ОрганизацияПолучатель) И ЗначениеЗаполнено(ОрганизацияПолучатель) Тогда
		СведенияОбОрганизацииПолучателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ОрганизацияПолучатель, Шапка.ДатаДокумента);
		Параметры.Вставить("ОрганизацияПолучательПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизацииПолучателе));
	КонецЕсли;
	
	// Данные подписей документа
	МОЛОтправитель = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладОтправитель, Шапка.ДатаДокумента);
	МОЛПолучатель  = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладПолучатель, Шапка.ДатаДокумента);
	
	Параметры.Вставить("МОЛОтправитель"   , МОЛОтправитель.Ответственный);
	Параметры.Вставить("МОЛФИООтправитель", МОЛОтправитель.ФИО);
	Параметры.Вставить("МОЛПолучатель"    , МОЛПолучатель.Ответственный);
	Параметры.Вставить("МОЛФИОПолучатель" , МОЛПолучатель.ФИО);
	
	Возврат Параметры;
	
КонецФункции

Процедура ПроверитьВыводСтроки(ТабличныйДокумент, Макет, ТекущаяОбласть, ЭтоПоследняяСтрока)
	
	МассивВыводимыхОбластей = Новый Массив;
	МассивВыводимыхОбластей.Добавить(ТекущаяОбласть);
	Если ЭтоПоследняяСтрока Тогда
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Подвал"));
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Подписи"));
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Тогда
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ШапкаТаблицы"));
	КонецЕсли;
	
КонецПроцедуры

Функция МетаданныеМакета()
	
	Возврат Метаданные.Обработки.ПечатьНакладнаяНаПеремещение.Макеты.ПФ_MXL_НакладнаяНаПеремещение;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
