#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция возвращает элемент таблицы доступных печатных форм объекта печати
//
Функция ДобавитьПечатнуюФорму(ПечатныеФормы) Экспорт
	
	МетаданныеМакета = МетаданныеМакета();
	МенеджерПечати = МетаданныеМакета.Родитель().ПолноеИмя();
	
	ПечатнаяФорма = УправлениеПечатьюПоддержкаПроектов.ДобавитьПечатнуюФорму(ПечатныеФормы, "М11", МенеджерПечати);
	ПечатнаяФорма.ПутьКМакету = ФормированиеПечатныхФормПоддержкаПроектов.ПутьКМакету(МетаданныеМакета);
	ПечатнаяФорма.Представление = МетаданныеМакета.Представление();
	
	ПечатнаяФорма.Параметризуемая = Истина;
	ПечатнаяФорма.ДополнительныеПараметры.Вставить("ВыводитьИсполнение", Ложь);
	
	Возврат ПечатнаяФорма;
	
КонецФункции

// Функция формирует печатную форму требование накладная ф.0504204
//
Функция ПечатьМ11(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
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
		
		Если ТипЗнч(ПараметрыПечати) = Неопределено Тогда
			ПараметрыПечати = Новый Структура;
		КонецЕсли;
		ПараметрыПечати.Вставить("ПолучатьЦены");
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечати(СтруктураОбъектов.Значение, ПараметрыПечати);
		
		СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьТабличныйДокумент(ТабличныйДокумент, Макет, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати)
	
	ВыводитьИсполнение = Неопределено;
	
	Если ПараметрыПечати <> Неопределено Тогда
		
		Если ПараметрыПечати.Свойство("ВыводитьИсполнение", ВыводитьИсполнение) И ВыводитьИсполнение Тогда
			ТаблицаИсполнения = ДанныеДляПечати.ТаблицаИсполнения;
		КонецЕсли;
		
	КонецЕсли;
	
	МассивВыводимыхОбластей = Новый Массив;
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(Шапка.Ссылка, ТабличныйДокумент, Макет);
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Получение параметров для заполнения
		ДанныеШапки = ПолучитьДанныеШапкиДокумента(Шапка);
		
		// Вывод области Заголовок
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Заголовок", ДанныеШапки);
		
		// Вывод области ЗаголовокТаблица
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ЗаголовокТаблица", ДанныеШапки);
		
		// Вывод области ПодписиЗаголовка
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ПодписиЗаголовка", ДанныеШапки);
		
		// Инициализация нумерации
		Нумерация = ИнициализироватьНумерацию();
		
		// Вывод области ШапкаТаблицы
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы", Нумерация);
		
		// Инициализация итогов по документу
		ПараметрыИтого = Новый Структура;
		ПараметрыИтого.Вставить("Сумма", 0);
		
		ВыборкаПоДокументам.Сбросить();
		ПараметрыПоиска = Новый Структура("Документ", Шапка.Ссылка);
		Если ВыборкаПоДокументам.НайтиСледующий(ПараметрыПоиска) Тогда
			ВыборкаСтрокТовары = ВыборкаПоДокументам.Выбрать();
			
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
			
			КоличествоСтрок = ВыборкаСтрокТовары.Количество();
			
			ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
			Пока ВыборкаСтрокТовары.Следующий() Цикл
				
				Если ВыборкаСтрокТовары.Отменено Тогда
					КоличествоСтрок = КоличествоСтрок - 1;
					Продолжить;
				КонецЕсли;
				
				ФормированиеПечатныхФормПоддержкаПроектов.УвеличитьНомер(Нумерация, "НомерСтроки");
				
				КлючиПараметров = ФормированиеПечатныхФормПоддержкаПроектов.ПолучитьИменаКолонокТаблицы(ВыборкаСтрокТовары);
				ДанныеСтроки = Новый Структура(КлючиПараметров);
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВыборкаСтрокТовары);
				
				// Вывод исполнения
				МассивИсполнения = Новый Массив;
				Если ВыводитьИсполнение = Истина Тогда
					
					ОтборИсполнения = Новый Структура("ДокументТребование, ОтборНоменклатуры, ЕдиницаИзмерения, КодСтроки");
					ЗаполнитьЗначенияСвойств(ОтборИсполнения, ВыборкаСтрокТовары);
					ОтборИсполнения.ДокументТребование = Шапка.Ссылка;
					
					СтрокиИсполнения = ТаблицаИсполнения.НайтиСтроки(ОтборИсполнения);
					
					Если СтрокиИсполнения.Количество() = 1
					   И СтрокиИсполнения[0].Номенклатура = ВыборкаСтрокТовары.Номенклатура
					   И СтрокиИсполнения[0].Упаковка = ВыборкаСтрокТовары.ЕдиницаИзмерения Тогда
						
						Исполнение = СтрокиИсполнения[0];
						
						ДанныеСтроки.Вставить("Отпущено", Исполнение.Отпущено);
						ДанныеСтроки.Вставить("Цена",    Исполнение.Цена);
						ДанныеСтроки.Вставить("Сумма",   Исполнение.Сумма);
						
					Иначе
						
						Для Каждого Исполнение Из СтрокиИсполнения Цикл
							
							ПараметрыИсполнения = Новый Структура(КлючиПараметров);
							ЗаполнитьЗначенияСвойств(ПараметрыИсполнения, Исполнение);
							
							ОтборЦеныПоИсполнению = Новый Структура("Ссылка", Исполнение.Документ);
							
							ПараметрыИсполнения.Вставить("ТоварНаименование", ПолучитьПредставлениеНоменклатуры(Исполнение));
							ПараметрыИсполнения.Вставить("Цена",              Исполнение.Цена);
							ПараметрыИсполнения.Вставить("Отпущено",          Исполнение.Отпущено);
							ПараметрыИсполнения.Вставить("ЕдиницаИзмерения",  Исполнение.Упаковка);
							ПараметрыИсполнения.Вставить("Сумма",             Исполнение.Сумма);
							
							ОбластьСтрокаИсполнение = Макет.ПолучитьОбласть("СтрокаИсполнение");
							ОбластьСтрокаИсполнение.Параметры.Заполнить(ПараметрыИсполнения);
							МассивИсполнения.Добавить(ОбластьСтрокаИсполнение);
							
							ПараметрыИтогоПоСтроке = Новый Структура;
							ПараметрыИтогоПоСтроке.Вставить("Отпущено", Исполнение.КоличествоЗаказа);
							ПараметрыИтогоПоСтроке.Вставить("Сумма",    Исполнение.Сумма);
							ФормированиеПечатныхФормПоддержкаПроектов.РассчитатьИтоги(ПараметрыИтогоПоСтроке, ДанныеСтроки);
							
						КонецЦикла;
						
					КонецЕсли;
					
				КонецЕсли;
				
				ДанныеСтроки.Вставить("НомерСтроки", Нумерация.НомерСтроки);
				ДанныеСтроки.Вставить("ТоварНаименование", ПолучитьПредставлениеНоменклатуры(ВыборкаСтрокТовары));
				
				ОбластьСтрока.Параметры.Заполнить(ДанныеСтроки);
				
				ЭтоПоследняяСтрока = Нумерация.НомерСтроки = КоличествоСтрок;
				ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ОбластьСтрока, ЭтоПоследняяСтрока, Нумерация);
				
				// Вывод области Строка
				ТабличныйДокумент.Вывести(ОбластьСтрока, 1);
								
				// Вывод области СтрокаИсполнения
				Для каждого ОбластьСтрокаИсполнения Из МассивИсполнения Цикл
					ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ОбластьСтрокаИсполнения, ЭтоПоследняяСтрока, Нумерация);
					ТабличныйДокумент.Вывести(ОбластьСтрокаИсполнения, 2);
				КонецЦикла;
				
				ФормированиеПечатныхФормПоддержкаПроектов.РассчитатьИтоги(ДанныеСтроки, ПараметрыИтого);
				
			КонецЦикла;
			
			// Вывод сверх заказа
			Если ВыводитьИсполнение = Истина Тогда
				ОтборИсполнения = Новый Структура("ДокументТребование, КодСтроки");
				ОтборИсполнения.ДокументТребование = Шапка.Ссылка;
				ОтборИсполнения.КодСтроки = 0;
				
				СтрокиИсполнения = ТаблицаИсполнения.НайтиСтроки(ОтборИсполнения);
				
				Для Каждого Исполнение Из СтрокиИсполнения Цикл
					
					НомерСтроки = НомерСтроки + 1;
					
					ПараметрыСверхЗаказ = Новый Структура;
					ПараметрыСверхЗаказ.Вставить("НомерСтроки"      , НомерСтроки);
					ПараметрыСверхЗаказ.Вставить("ТоварНаименование", ПолучитьПредставлениеНоменклатуры(Исполнение));
					ПараметрыСверхЗаказ.Вставить("ОтборНоменклатуры", Исполнение.Номенклатура);
					ПараметрыСверхЗаказ.Вставить("ЕдиницаИзмерения" , Исполнение.Упаковка);
					ПараметрыСверхЗаказ.Вставить("КодПоОКЕИ"        , Исполнение.КодПоОКЕИ);
					ПараметрыСверхЗаказ.Вставить("Затребовано"      , Исполнение.Отпущено);
					ПараметрыСверхЗаказ.Вставить("Отпущено"         , Исполнение.Отпущено);
					ПараметрыСверхЗаказ.Вставить("Цена"             , Исполнение.Цена);
					ПараметрыСверхЗаказ.Вставить("Сумма"            , Исполнение.Сумма);
					
					ОбластьСверхЗаказ = Макет.ПолучитьОбласть("Строка");
					ОбластьСверхЗаказ.Параметры.Заполнить(ПараметрыСверхЗаказ);
					ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ОбластьСверхЗаказ, ЭтоПоследняяСтрока, Нумерация);
					ТабличныйДокумент.Вывести(ОбластьСверхЗаказ, 1);
					
					ФормированиеПечатныхФормПоддержкаПроектов.РассчитатьИтоги(ПараметрыСверхЗаказ, ПараметрыИтого);
					
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
		
		// Вывод области Итого
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "Итого", ПараметрыИтого);
		
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
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	
	Параметры.Вставить("НомерДокумента",           ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента));
	Параметры.Вставить("ОрганизацияПредставление", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации));
	Параметры.Вставить("ОрганизацияКодПоОКПО",     СведенияОбОрганизации.КодПоОКПО);
	
	ЗатребовалФИО  = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СокрЛП(Шапка.Затребовал));
	РазрешилФИО    = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СокрЛП(Шапка.Разрешил));
	МОЛОтправителя = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладОтправитель, Шапка.ДатаДокумента);
	МОЛПолучателя  = РегистрыСведений.МатериальноОтветственныеЛица.ПолучитьДанныеОтветственного(Шапка.СкладПолучатель, Шапка.ДатаДокумента);
	ЧерезКого      = ?(ЗначениеЗаполнено(МОЛПолучателя.ФИО), МОЛПолучателя.Должность + " " + МОЛПолучателя.ФИО, "");
	
	// Данные подписей заголовка
	Параметры.Вставить("ЗатребовалФИО",       ЗатребовалФИО);
	Параметры.Вставить("ЗатребовалДолжность", Шапка.ЗатребовалДолжность);
	Параметры.Вставить("РазрешилФИО",         РазрешилФИО);
	Параметры.Вставить("РазрешилДолжность",   Шапка.РазрешилДолжность);
	Параметры.Вставить("ЧерезКого",           ЧерезКого);
	
	// Данные подписей документа
	Параметры.Вставить("ОтправительФИО",       МОЛОтправителя.ФИО);
	Параметры.Вставить("ОтправительДолжность", МОЛОтправителя.Должность);
	Параметры.Вставить("ПолучательФИО",        МОЛПолучателя.ФИО);
	Параметры.Вставить("ПолучательДолжность",  МОЛПолучателя.Должность);
	
	Возврат Параметры;
	
КонецФункции

Функция ПолучитьПредставлениеНоменклатуры(СтрокаТовары)
	
	Если ЗначениеЗаполнено(СтрокаТовары.Номенклатура) Тогда
		ТоварНаименование = ОбщегоНазначенияПоддержкаПроектов.ПолучитьПредставлениеНоменклатурыДляПечати(
			СтрокаТовары.ТоварНаименование,
			СтрокаТовары.СерияНоменклатуры,
			,
			СтрокаТовары.Описание);
	КонецЕсли;
	
	Возврат ТоварНаименование;
	
КонецФункции

Функция ИнициализироватьНумерацию()
	
	Нумерация = Новый Структура;
	Нумерация.Вставить("НомерСтроки"  , 0);
	Нумерация.Вставить("НомерСтраницы", 1);
	
	Возврат Нумерация;
	
КонецФункции

Функция ПроверитьВыводСтроки(ТабличныйДокумент, Макет, МассивВыводимыхОбластей, ТекущаяОбласть, ЭтоПоследняяСтрока, Нумерация)
	
	МассивВыводимыхОбластей.Очистить();
	МассивВыводимыхОбластей.Добавить(ТекущаяОбласть);
	Если ЭтоПоследняяСтрока Тогда
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Итого"));
		МассивВыводимыхОбластей.Добавить(Макет.ПолучитьОбласть("Подписи"));
	КонецЕсли;
	
	СтрокаНеПомещаетсяНаСтраницу = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей);
	
	Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивВыводимыхОбластей) Тогда
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ФормированиеПечатныхФормПоддержкаПроектов.УвеличитьНомер(Нумерация, "НомерСтраницы");
		ФормированиеПечатныхФормПоддержкаПроектов.ВывестиОбластьПоИмени(ТабличныйДокумент, Макет, "ШапкаТаблицы", Нумерация, 1);
	КонецЕсли;
	
	Возврат СтрокаНеПомещаетсяНаСтраницу;
	
КонецФункции

Функция МетаданныеМакета()
	
	Возврат Метаданные.Обработки.ПечатьМ11.Макеты.ПФ_MXL_М11;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
