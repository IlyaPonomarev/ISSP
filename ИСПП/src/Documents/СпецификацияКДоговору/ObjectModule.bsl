#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	//ОбработкаТабличнойЧастиСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	
	ЗакупкиСервер.ПроверитьКорректностьЗаполненияНоменклатурыПоставщика(ЭтотОбъект, Отказ);
	
	НепроверяемыеРеквизиты.Добавить("Товары.Цена");
	НепроверяемыеРеквизиты.Добавить("Товары.Сумма");
	НепроверяемыеРеквизиты.Добавить("Товары.СуммаНДС");
	НепроверяемыеРеквизиты.Добавить("Товары.СуммаСНДС");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ПроектЗадания") ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ГЗ") Тогда
		ЗаполнитьПоПроекту(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаявкаПредприятия") Тогда
		ЗаполнитьПоЗаявкеПредприятий(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
	ЗаполнитьПоЗначениямАвтозаполнения();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	
	МаксимальныйКодСтроки = 0;
	Для Каждого ТекущаяСтрока Из Товары Цикл
		ТекущаяСтрока.КодСтроки = 0;
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеПоддержкаПроектов.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбработкаТабличнойЧастиСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	ЗаказыСервер.УстановитьКлючВСтрокахТабличнойЧасти(ЭтотОбъект, "Товары");
	
	СуммаДокумента = ЦенообразованиеПоддержкаПроектовКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗакупкиСервер.СвязатьНоменклатуруСНоменклатуройПоставщика(Товары, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеПоддержкаПроектов.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеПоддержкаПроектов.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	ОбновитьИсториюИзменений();
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры
#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация и заполнение документа
#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент()
	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		
		ВалютаРег = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		
		Если ЗначениеЗаполнено(ВалютаРег) Тогда
			Валюта = ВалютаРег;
		КонецЕсли;
		
	КонецЕсли;
	
	НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	
	Если ОбщегоНазначенияПоддержкаПроектов.ИспользоватьСтатусы(Ссылка) Тогда
		Статус = Перечисления.СтатусыСпецификацийКДоговорам.Проработка;
	КонецЕсли;
	
	ЗаполнитьПоляПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьПоляПоУмолчанию()
	
	Организация = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	ПодразделениеОрганизации = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьПодразделениеПоУмолчанию(ПодразделениеОрганизации, Организация);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗначениямАвтозаполнения()
	
	ОбщегоНазначенияПоддержкаПроектов.ЗаполнитьПоЗначениямАвтозаполнения(ЭтотОбъект, Неопределено, "Организация");
	ОбщегоНазначенияПоддержкаПроектов.ЗаполнитьПоЗначениямАвтозаполнения(ЭтотОбъект, Неопределено, "ПодразделениеОрганизации", "Организация");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ОбщегоНазначенияПоддержкаПроектов.ПроверитьЗаполнениеДоговораКонтрагента(ЭтотОбъект);
	ОбщегоНазначенияПоддержкаПроектов.ПроверитьЗаполнениеПодразделенияОрганизации(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗаполнитьПоПроекту(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Номер,Дата,Ответственный,Автор");
	ПроектЗадания = ДанныеЗаполнения;
	
	Если Не ДанныеЗаполнения.ПроизвольныйПредметПроекта Тогда
		Для Каждого Строка Из ДанныеЗаполнения.ПредметыПроекта Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.ЕдиницаИзмерения = Строка.Номенклатура.ЕдиницаИзмерения;
		КонецЦикла;
	КонецЕсли;
	ОбщегоНазначенияПоддержкаПроектов.ПроверитьЗаполнениеДоговораКонтрагента(ЭтотОбъект);
	ОбщегоНазначенияПоддержкаПроектов.ПроверитьЗаполнениеПодразделенияОрганизации(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаявкеПредприятий(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,"Организация, Предприятие");
	
	Для Каждого Строка Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.ЕдиницаИзмерения = Строка.Номенклатура.ЕдиницаИзмерения;
		
		НоваяСтрока = НоменклатураПоЗаявкамПредприятий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.ЗаявкаПредприятия = ДанныеЗаполнения;
	КонецЦикла;
	
	Автор = Пользователи.АвторизованныйПользователь();
		
КонецПроцедуры

#КонецОбласти // ИнициализацияИЗаполнение

////////////////////////////////////////////////////////////////////////////////
// Прочее
#Область Прочее

Функция СписокРегистровДляКонтроля() Экспорт
	
	РегистрыДляКонтроля = Новый Массив;
	
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		РегистрыДляКонтроля.Добавить(Движения.ЗаказыПоставщикам);
	КонецЕсли;
	
	Возврат РегистрыДляКонтроля;
	
КонецФункции

Процедура ОбновитьИсториюИзменений()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекДата = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ДатаОтбор = Дата(1,1,1);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияСпецификацийКДоговору.ДатаВерсии КАК ДатаВерсии,
	|	ИсторияСпецификацийКДоговору.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ИсторияСпецификацийКДоговору.Номенклатура КАК Номенклатура,
	|	ИсторияСпецификацийКДоговору.Количество КАК Количество
	|ИЗ
	|	РегистрСведений.ИсторияСпецификацийКДоговору КАК ИсторияСпецификацийКДоговору
	|ГДЕ
	|	ИсторияСпецификацийКДоговору.СпецификацияКДоговору = &Спецификация
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаВерсии УБЫВ";
	
	Запрос.УстановитьПараметр("Спецификация", Ссылка);
	
	ТЧ_ИсторияДанных = Запрос.Выполнить().Выгрузить();
	
	МассивУдаления = Новый Массив;
	
	Для Каждого СтрокаИстории Из ТЧ_ИсторияДанных Цикл     
		Если ЗначениеЗаполнено(ДатаОтбор) И СтрокаИстории.ДатаВерсии < ДатаОтбор Тогда
			МассивУдаления.Добавить(СтрокаИстории);
		Иначе
			ДатаОтбор = СтрокаИстории.ДатаВерсии; 
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаУдаления Из МассивУдаления Цикл
		ТЧ_ИсторияДанных.Удалить(СтрокаУдаления);	
	КонецЦикла;	
	
	ТЧ_Товары_Текущая = Товары.Выгрузить(,"НомерСтроки, Номенклатура, Количество");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЧ_ИсторияДанных.ИдентификаторСтроки КАК НомерСтроки,
	|	ТЧ_ИсторияДанных.Номенклатура КАК Номенклатура,
	|	ТЧ_ИсторияДанных.Количество КАК Количество
	|ПОМЕСТИТЬ ВТ_ПоследняяВерсия
	|ИЗ
	|	&ТЧ_ИсторияДанных КАК ТЧ_ИсторияДанных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧ_Товары_Текущая.НомерСтроки КАК НомерСтроки,
	|	ТЧ_Товары_Текущая.Номенклатура КАК Номенклатура,
	|	ТЧ_Товары_Текущая.Количество КАК Количество
	|ПОМЕСТИТЬ ВТ_ТекущиеТовары
	|ИЗ
	|	&ТЧ_Товары_Текущая КАК ТЧ_Товары_Текущая
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПоследняяВерсия.НомерСтроки КАК НомерСтроки,
	|	ВТ_ПоследняяВерсия.Номенклатура КАК Номенклатура,
	|	ВТ_ПоследняяВерсия.Количество КАК Количество
	|ИЗ
	|	ВТ_ТекущиеТовары КАК ВТ_ТекущиеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследняяВерсия КАК ВТ_ПоследняяВерсия
	|		ПО ВТ_ТекущиеТовары.НомерСтроки = ВТ_ПоследняяВерсия.НомерСтроки
	|			И ВТ_ТекущиеТовары.Номенклатура = ВТ_ПоследняяВерсия.Номенклатура
	|			И ВТ_ТекущиеТовары.Количество = ВТ_ПоследняяВерсия.Количество";
	
	
	Запрос.УстановитьПараметр("ТЧ_ИсторияДанных", ТЧ_ИсторияДанных);
	Запрос.УстановитьПараметр("ТЧ_Товары_Текущая", ТЧ_Товары_Текущая);
	
	РезультатСравнения = Запрос.Выполнить().Выгрузить();
	
	Если ТЧ_Товары_Текущая.Количество() = РезультатСравнения.Количество() Тогда
		Возврат;	
	КонецЕсли;
	
	//@skip-check bsl-variable-name-invalid
	НЗ = РегистрыСведений.ИсторияСпецификацийКДоговору.СоздатьНаборЗаписей();
	
	Для Каждого СтрокаТовар Из Товары Цикл 
		СтрокаНабора = Нз.Добавить();
		СтрокаНабора.ДатаВерсии = ТекДата;
		СтрокаНабора.Номенклатура = СтрокаТовар.Номенклатура;
		СтрокаНабора.ИдентификаторСтроки = СтрокаТовар.НомерСтроки;
		СтрокаНабора.СпецификацияКДоговору = Ссылка;
		СтрокаНабора.Количество = СтрокаТовар.Количество;
	КонецЦикла;	

	НЗ.Записать(Ложь);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры	




#КонецОбласти // Прочее

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли