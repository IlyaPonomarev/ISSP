#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не Справочники.ГруппыДоступаНоменклатуры.ИспользуютсяГруппыДоступа() Тогда
		НепроверяемыеРеквизиты.Добавить("ГруппаДоступа");
	КонецЕсли;
	
	Если ИспользоватьСерии Тогда
		
		Если Не НастройкиСерийБерутсяИзДругогоВидаНоменклатуры Тогда
			НепроверяемыеРеквизиты.Добавить("ВладелецСерий");
		КонецЕсли;
		
	Иначе
		НепроверяемыеРеквизиты.Добавить("ПолитикаУчетаСерий");
		НепроверяемыеРеквизиты.Добавить("ВладелецСерий");
	КонецЕсли;
	
	Если ИспользоватьПартии Тогда
		
		Если Не НастройкиПартийБерутсяИзДругогоВидаНоменклатуры Тогда
			НепроверяемыеРеквизиты.Добавить("ВладелецПартий");
		КонецЕсли;
		
	Иначе
		НепроверяемыеРеквизиты.Добавить("ПолитикаУчетаПартий");
		НепроверяемыеРеквизиты.Добавить("ВладелецПартий");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЭтоГруппа Тогда
		//ГруппаДоступа = Справочники.ГруппыДоступаНоменклатуры.ПолучитьГруппуДоступаПоУмолчанию(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
		
		НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
		НаборСвойствСерий = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
		
		ШаблонНаименованияДляПечатиНоменклатуры = Метаданные().Реквизиты.ШаблонНаименованияДляПечатиНоменклатуры.ЗначениеЗаполнения;
		ШаблонРабочегоНаименованияНоменклатуры = "";
		ЗапретРедактированияРабочегоНаименованияНоменклатуры = Ложь;
		ЗапретРедактированияНаименованияДляПечатиНоменклатуры = Ложь;
		
		ШаблонРабочегоНаименованияСерии = "";
		
		Если ОбъектКопирования.ИспользоватьСерии Тогда
			Если Не ОбъектКопирования.НастройкиСерийБерутсяИзДругогоВидаНоменклатуры Тогда
				НастройкиСерийБерутсяИзДругогоВидаНоменклатуры = Истина;
				ВладелецСерий = ОбъектКопирования.Ссылка;
			КонецЕсли;
		КонецЕсли;
		
		Если ОбъектКопирования.ИспользоватьПартии Тогда
			Если Не ОбъектКопирования.НастройкиПартийБерутсяИзДругогоВидаНоменклатуры Тогда
				НастройкиПартийБерутсяИзДругогоВидаНоменклатуры = Истина;
				ВладелецПартий = ОбъектКопирования.Ссылка;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Товар Тогда
		ИспользоватьСерии = Ложь;
		ИспользоватьПартии = Ложь;
	КонецЕсли;
	
	Если Не ИспользоватьСерии Тогда
		ИспользоватьНомерСерии = Ложь;
		ИспользоватьКоличествоСерии = Ложь;
		НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.НеИспользовать;
		ПолитикаУчетаСерий = Перечисления.ТипыПолитикУчетаСерий.НеУчитывать;
		НастройкиСерийБерутсяИзДругогоВидаНоменклатуры = Ложь;
		ВладелецСерий = Справочники.ВидыНоменклатуры.ПустаяСсылка();
	Иначе
		Если НастройкиСерийБерутсяИзДругогоВидаНоменклатуры
		   И Не ДополнительныеСвойства.Свойство("ПропуститьЗаполнениеПоДругомуВидуНоменклатуры") Тогда
			
			Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	ВидыНоменклатуры.НастройкаИспользованияСерий         КАК НастройкаИспользованияСерий,
			|	ВидыНоменклатуры.ПолитикаУчетаСерий                  КАК ПолитикаУчетаСерий,
			|	ВидыНоменклатуры.ИспользоватьНомерСерии              КАК ИспользоватьНомерСерии
			|ИЗ
			|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
			|ГДЕ
			|	ВидыНоменклатуры.Ссылка = &ВладелецСерий
			|");
			
			Запрос.УстановитьПараметр("ВладелецСерий", ВладелецСерий);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
			КонецЕсли;
			
		КонецЕсли;
		
		ИспользоватьКоличествоСерии = (НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ПартияТоваров);
		
	КонецЕсли;
	
	Если Не НастройкиСерийБерутсяИзДругогоВидаНоменклатуры Тогда
		ВладелецСерий = Справочники.ВидыНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Если Не ИспользоватьПартии Тогда
		ПолитикаУчетаПартий = Перечисления.ТипыПолитикУчетаПартий.НеУчитывать;
		НастройкиПартийБерутсяИзДругогоВидаНоменклатуры = Ложь;
		ВладелецПартий = Справочники.ВидыНоменклатуры.ПустаяСсылка();
	Иначе
		Если НастройкиПартийБерутсяИзДругогоВидаНоменклатуры
		   И Не ДополнительныеСвойства.Свойство("ПропуститьЗаполнениеПоДругомуВидуНоменклатуры") Тогда
			
			Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	ВидыНоменклатуры.ПолитикаУчетаПартий            КАК ПолитикаУчетаПартий,
			|	ВидыНоменклатуры.ПолитикаУчетаПартийВОтделениях КАК ПолитикаУчетаПартийВОтделениях
			|ИЗ
			|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
			|ГДЕ
			|	ВидыНоменклатуры.Ссылка = &ВладелецПартий
			|");
			
			Запрос.УстановитьПараметр("ВладелецПартий", ВладелецПартий);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если Не НастройкиПартийБерутсяИзДругогоВидаНоменклатуры Тогда
		ВладелецПартий = Справочники.ВидыНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	ОбновитьНаборыСвойств();
	
	ДополнительныеСвойства.Вставить("ЭтоНовый"                                       , ЭтоНовый());
	ДополнительныеСвойства.Вставить("ИспользоватьСерии"                              , Ложь);
	ДополнительныеСвойства.Вставить("НастройкиСерийБерутсяИзДругогоВидаНоменклатуры" , Ложь);
	ДополнительныеСвойства.Вставить("ИспользоватьПартии"                             , Ложь);
	ДополнительныеСвойства.Вставить("НастройкиПартийБерутсяИзДругогоВидаНоменклатуры", Ложь);
	
	ДополнительныеСвойства.Вставить("ОтменаПометкиУдаления", Ложь);
	
	Если Не ЭтоНовый() Тогда
		
		ЗапрашиваемыеРеквизиты = Новый Структура;
		ЗапрашиваемыеРеквизиты.Вставить("ИспользоватьСерии");
		ЗапрашиваемыеРеквизиты.Вставить("НастройкиСерийБерутсяИзДругогоВидаНоменклатуры");
		ЗапрашиваемыеРеквизиты.Вставить("ИспользоватьПартии");
		ЗапрашиваемыеРеквизиты.Вставить("НастройкиПартийБерутсяИзДругогоВидаНоменклатуры");
		ЗапрашиваемыеРеквизиты.Вставить("ПометкаУдаления");
		
		СтарыеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ЗапрашиваемыеРеквизиты);
		ЗаполнитьЗначенияСвойств(ДополнительныеСвойства, СтарыеРеквизиты);
		
		Если Не ПометкаУдаления И СтарыеРеквизиты.ПометкаУдаления Тогда
			ДополнительныеСвойства.ОтменаПометкиУдаления = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если (ДополнительныеСвойства.ЭтоНовый Или ДополнительныеСвойства.ОтменаПометкиУдаления)
	   И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовНоменклатуры") Тогда
		
		Если Справочники.ВидыНоменклатуры.ИспользуетсяНесколькоВидовНоменклатуры() Тогда
			УстановитьПривилегированныйРежим(Истина);
			Константы.ИспользоватьНесколькоВидовНоменклатуры.Установить(Истина);
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьПараметрыУчетаНоменклатурыНаСкладах();
	ОбновитьСвязанныеВидыНоменклатуры();
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

//////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьНаборыСвойств()
	
	УправлениеСвойствами.ПередЗаписьюВидаОбъекта(ЭтотОбъект, "Справочник_Номенклатура");
	
	Если ИспользоватьСерии Тогда
		УправлениеСвойствами.ПередЗаписьюВидаОбъекта(ЭтотОбъект, "Справочник_СерииНоменклатуры", "НаборСвойствСерий");
	Иначе
		Если ЗначениеЗаполнено(НаборСвойствСерий) Тогда
			ОбъектНабора = НаборСвойствСерий.ПолучитьОбъект();
			ОбъектНабора.ПометкаУдаления = Истина;
			ОбъектНабора.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПараметрыУчетаНоменклатурыНаСкладах()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Склады.Ссылка  КАК Склад,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ПолитикиУчета.ПолитикаУчетаСерий = ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУчетаСерий.НеУчитывать)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ)         КАК ИспользоватьСерии,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ПолитикиУчета.ПолитикаУчетаПартий = ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУчетаПартий.НеУчитывать)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ)         КАК ИспользоватьПартии
	|ПОМЕСТИТЬ ПолитикиУчетаНаСкладах
	|ИЗ
	|	Справочник.Склады КАК Склады,
	|	Справочник.ВидыНоменклатуры КАК ПолитикиУчета
	|СГРУППИРОВАТЬ ПО
	|	Склады.Ссылка
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Склады.Ссылка                                              КАК Склад,
	|	ЕСТЬNULL(ПолитикиУчетаНаСкладах.ИспользоватьСерии, ЛОЖЬ)   КАК ИспользоватьСерииНоменклатуры,
	|	ЕСТЬNULL(ПолитикиУчетаНаСкладах.ИспользоватьПартии, ЛОЖЬ)  КАК ИспользоватьПартии
	|ИЗ
	|	Справочник.Склады КАК Склады
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПолитикиУчетаНаСкладах КАК ПолитикиУчетаНаСкладах
	|		ПО
	|			Склады.Ссылка = ПолитикиУчетаНаСкладах.Склад
	|ГДЕ
	|	НЕ Склады.ЭтоГруппа
	|	И (ЕСТЬNULL(ПолитикиУчетаНаСкладах.ИспользоватьСерии, ЛОЖЬ) <> Склады.ИспользоватьСерииНоменклатуры
	|		ИЛИ ЕСТЬNULL(ПолитикиУчетаНаСкладах.ИспользоватьПартии, ЛОЖЬ) <> Склады.ИспользоватьПартии
	|		)
	|";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СкладОбъект = Выборка.Склад.ПолучитьОбъект();
		СкладОбъект.ИспользоватьСерииНоменклатуры       = Выборка.ИспользоватьСерииНоменклатуры;
		СкладОбъект.ИспользоватьПартии                  = Выборка.ИспользоватьПартии;
		СкладОбъект.ДополнительныеСвойства.Вставить("ПропуститьОбновлениеПараметровУчетаНаСкладе");
		СкладОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСвязанныеВидыНоменклатуры()
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ИспользоватьСерии
	   И Не ДополнительныеСвойства.НастройкиСерийБерутсяИзДругогоВидаНоменклатуры Тогда
		ОбновитьНастройкиСерийВСвязанныхВидахНоменклатуры();
	КонецЕсли;
	
	Если ДополнительныеСвойства.ИспользоватьПартии
	   И Не ДополнительныеСвойства.НастройкиПартийБерутсяИзДругогоВидаНоменклатуры Тогда
		ОбновитьНастройкиПартийВСвязанныхВидахНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьНастройкиСерийВСвязанныхВидахНоменклатуры()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВидыНоменклатуры.Ссылка КАК ВидНоменклатуры
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.ВладелецСерий = &ВладелецСерий
	|");
	
	Запрос.УстановитьПараметр("ВладелецСерий", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ИзменяемыйОбъект = Выборка.ВидНоменклатуры.ПолучитьОбъект();
		
		ИзменяемыйОбъект.ИспользоватьСерии = ИспользоватьСерии;
		Если Не ИспользоватьСерии Тогда
			ИзменяемыйОбъект.НастройкиСерийБерутсяИзДругогоВидаНоменклатуры = Ложь;
			// Остальные поля очистятся при записи
			ИзменяемыйОбъект.Записать();
			Продолжить;
		КонецЕсли;
		
		ИзменяемыйОбъект.НастройкаИспользованияСерий = НастройкаИспользованияСерий;
		ИзменяемыйОбъект.ИспользоватьНомерСерии             = ИспользоватьНомерСерии;
		ИзменяемыйОбъект.ПолитикаУчетаСерий = ПолитикаУчетаСерий;		
		// Остальные поля заполнятся при записи
		ИзменяемыйОбъект.ДополнительныеСвойства.Вставить("ПропуститьЗаполнениеПоДругомуВидуНоменклатуры");
		
		ИзменяемыйОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьНастройкиПартийВСвязанныхВидахНоменклатуры()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВидыНоменклатуры.Ссылка КАК ВидНоменклатуры
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.ВладелецПартий = &ВладелецПартий
	|");
	
	Запрос.УстановитьПараметр("ВладелецПартий", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ИзменяемыйОбъект = Выборка.ВидНоменклатуры.ПолучитьОбъект();
		
		ИзменяемыйОбъект.ИспользоватьПартии = ИспользоватьПартии;
		Если Не ИспользоватьПартии Тогда
			ИзменяемыйОбъект.НастройкиПартийБерутсяИзДругогоВидаНоменклатуры = Ложь;
			// Остальные поля очистятся при записи
			ИзменяемыйОбъект.Записать();
			Продолжить;
		КонецЕсли;
		
		ИзменяемыйОбъект.ПолитикаУчетаПартий = ПолитикаУчетаПартий;;
		
		// Остальные поля заполнятся при записи
		ИзменяемыйОбъект.ДополнительныеСвойства.Вставить("ПропуститьЗаполнениеПоДругомуВидуНоменклатуры");
		
		ИзменяемыйОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли