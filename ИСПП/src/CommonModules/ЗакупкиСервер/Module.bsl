
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает основные реквизиты договора
//
// Параметры
//  Договор - СправочникСсылка.ДоговорыКонтрагентов - 
//
// Возвращаемое значение
//  Структура - 
//
Функция ПолучитьОсновныеРеквизитыДоговора(Договор) Экспорт
	
	ЗапрашиваемыеПоля = Новый Структура;
	ЗапрашиваемыеПоля.Вставить("Организация");
	ЗапрашиваемыеПоля.Вставить("Контрагент");
	ЗапрашиваемыеПоля.Вставить("ВалютаВзаиморасчетов");
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, ЗапрашиваемыеПоля);
	Возврат Реквизиты;
	
КонецФункции

// Возвращает форматированный текст представления счета-фактуры в документе.
//
// Параметры:
//  Основание - ДокументСсылка - Документ, на основании которого вводится счет-фактура;
//  НеТребуется - Булево - Истина - для документа не требуется вводить счет-фактуру.
//
// Возвращаемое значение:
//  ФорматированнаяСтрока - Представление счета-фактуры.
//
Функция ПредставлениеСчетаФактурыВДокументеЗакупки(Основание, НеТребуется = Ложь, ТолькоПросмотр = Ложь) Экспорт
	
	ЧастиСтроки = Новый Массив;
	Если НеТребуется Тогда
		ЧастиСтроки.Добавить(НСтр("ru = 'Счет-фактура не требуется'"));
	Иначе
		РеквизитыСчетаФактуры = Новый Структура("ПредъявленСчетФактура, НомерВходящегоСчетаФактуры, ДатаВходящегоСчетаФактуры");
		ЗаполнитьЗначенияСвойств(РеквизитыСчетаФактуры, Основание);
		Если РеквизитыСчетаФактуры.ПредъявленСчетФактура = Истина Тогда
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Счет-фактура № %1 от %2 г.'"),
				РеквизитыСчетаФактуры.НомерВходящегоСчетаФактуры,
				Формат(РеквизитыСчетаФактуры.ДатаВходящегоСчетаФактуры, "ДЛФ=D"));
			Если ТолькоПросмотр Тогда
				ЧастиСтроки.Добавить(Представление);
			Иначе
				ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(Представление,, ЦветаСтиля.ЦветГиперссылки,, "ВвестиСчетФактуру"));
			КонецЕсли;
		Иначе
			Если ТолькоПросмотр Тогда
				ЧастиСтроки.Добавить(НСтр("ru = 'Счет-фактура отсутствует'"));
			Иначе
				ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Зарегистрировать счет-фактуру'"),, ЦветаСтиля.ЦветГиперссылки,, "ВвестиСчетФактуру"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(ЧастиСтроки);
	
КонецФункции

#Область ПроцедурыИФункцииРаботыСНоменклатуройПоставщикаВДокументахЗакупки

// Заполняет номенклатуру, единицуИзмерения в номенклатуре поставщика с пустой номенклатурой
//
// Параметры:
//  Товары - ТаблицаЗначений - таблица, содержащая данные для связывания номенклатуры с номенклатурой поставщика.
//  Отказ - Булево - Истина, если не удалось связать номенклатуру с номенклатурой поставщика.
//
Процедура СвязатьНоменклатуруСНоменклатуройПоставщика(Товары, Отказ) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруПоставщиков") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.НоменклатураПоставщика КАК НоменклатураПоставщика,
	|	Товары.Номенклатура           КАК Номенклатура,
	|	Товары.ЕдиницаИзмерения       КАК ЕдиницаИзмерения
	|ПОМЕСТИТЬ
	|	Товары
	|ИЗ
	|	&Товары КАК Товары
	|ГДЕ
	|	Товары.НоменклатураПоставщика <> ЗНАЧЕНИЕ(Справочник.НоменклатураПоставщиков.ПустаяСсылка)
	|	И Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НоменклатураПоставщика КАК НоменклатураПоставщика,
	|	Товары.Номенклатура           КАК Номенклатура,
	|	Товары.ЕдиницаИзмерения       КАК ЕдиницаИзмерения
	|ПОМЕСТИТЬ
	|	СгруппированныеТовары
	|ИЗ
	|	Товары КАК Товары
	|ГДЕ
	|	ВЫРАЗИТЬ(Товары.НоменклатураПоставщика КАК Справочник.НоменклатураПоставщиков).Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|СГРУППИРОВАТЬ ПО
	|	Товары.НоменклатураПоставщика,
	|	Товары.Номенклатура,
	|	Товары.ЕдиницаИзмерения
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СгруппированныеТовары.НоменклатураПоставщика      КАК НоменклатураПоставщика,
	|	СгруппированныеТовары.Номенклатура                КАК Номенклатура,
	|	КОЛИЧЕСТВО(*)                                     КАК КоличествоУпаковок,
	|	МАКСИМУМ(СгруппированныеТовары.ЕдиницаИзмерения)  КАК ЕдиницаИзмерения
	|ИЗ
	|	СгруппированныеТовары КАК СгруппированныеТовары
	|СГРУППИРОВАТЬ ПО
	|	СгруппированныеТовары.НоменклатураПоставщика,
	|	СгруппированныеТовары.Номенклатура
	|");
	
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(, "НомерСтроки, НоменклатураПоставщика, Номенклатура, ЕдиницаИзмерения"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Попытка
				
				ЗаблокироватьДанныеДляРедактирования(Выборка.НоменклатураПоставщика);
				
				НоменклатураПоставщикаОбъект = Выборка.НоменклатураПоставщика.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(НоменклатураПоставщикаОбъект, Выборка);
				Если Выборка.КоличествоУпаковок > 1 Тогда
					НоменклатураПоставщикаОбъект.ЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
				КонецЕсли;
				НоменклатураПоставщикаОбъект.Записать();
				
			Исключение
				
				ТекстОшибки = НСтр("ru='Не удалось заблокировать %Элемент%. %ОписаниеОшибки%'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Элемент%",        Выборка.НоменклатураПоставщика);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				Отказ = Истина;
				ВызватьИсключение ТекстОшибки;
				
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Помещает таблицу товаров во временное хранилище
// 
// Параметры:
//  Товары - ДанныеФормыКоллекция - таблица товаров, которую необходимо поместить во временное хранилище.
//
// Возвращаемое значение:
//  Строка - Адрес таблицы товаров во временном хранилище.
//
Функция ПоместитьНоменклатуруПоставщикаВоВременноеХранилище(Товары) Экспорт
	
	ОтобранныеСтроки = Новый Массив();
	
	Для Каждого ТекущаяСтрока Из Товары Цикл
		Если ЗначениеЗаполнено(ТекущаяСтрока.НоменклатураПоставщика) И Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
			ОтобранныеСтроки.Добавить(ТекущаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Если ОтобранныеСтроки.Количество() = 0 Тогда
		АдресТоваровВоВременномХранилище = Неопределено;
	Иначе
		НоменклатураПоставщика = Товары.Выгрузить(ОтобранныеСтроки, "НомерСтроки, НоменклатураПоставщика");
		АдресТоваровВоВременномХранилище = ПоместитьВоВременноеХранилище(НоменклатураПоставщика);
	КонецЕсли;
	
	Возврат АдресТоваровВоВременномХранилище;
	
КонецФункции

// Проверяет корректность заполнения номенклатуры поставщика в документах закупки
//
// Параметры:
//  ДокументЗакупки - ДокументОбъект - документ закупки (Заказ поставщику, Поступление товаров и т.д.).
//  Отказ           - Булево - Флаг отказа от проведения документа
//
Процедура ПроверитьКорректностьЗаполненияНоменклатурыПоставщика(ДокументЗакупки, Отказ) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруПоставщиков") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Товары.НомерСтроки             КАК НомерСтроки,
	|	ВЫРАЗИТЬ(Товары.НоменклатураПоставщика КАК Справочник.НоменклатураПоставщиков) КАК НоменклатураПоставщика,
	|	Товары.Номенклатура            КАК Номенклатура
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК Товары
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВложенныйЗапросПоДублям.НомерСтроки)         КАК НомерСтроки,
	|	ВложенныйЗапросПоДублям.НоменклатураПоставщика        КАК НоменклатураПоставщика
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(ДокументТовары.НомерСтроки)              КАК НомерСтроки,
	|		ДокументТовары.НоменклатураПоставщика             КАК НоменклатураПоставщика,
	|		ДокументТовары.Номенклатура                       КАК Номенклатура
	|	ИЗ
	|		ТаблицаТовары КАК ДокументТовары
	|	ГДЕ
	|		ДокументТовары.НоменклатураПоставщика <> ЗНАЧЕНИЕ(Справочник.НоменклатураПоставщиков.ПустаяСсылка)
	|		И ДокументТовары.НоменклатураПоставщика.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	СГРУППИРОВАТЬ ПО
	|		ДокументТовары.НоменклатураПоставщика,
	|		ДокументТовары.Номенклатура
	|	) КАК ВложенныйЗапросПоДублям
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапросПоДублям.НоменклатураПоставщика
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаТовары", ДокументЗакупки.Товары.Выгрузить(, "НомерСтроки, НоменклатураПоставщика, Номенклатура"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='В строке не может быть выбрана ""%НоменклатураПоставщика%"", т.к. в предыдущих строках она соответствует другой номенклатуре'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НоменклатураПоставщика%", Выборка.НоменклатураПоставщика);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ДокументЗакупки,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "НоменклатураПоставщика"),
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ПроцедурыИФункцииРаботыСНоменклатуройПоставщикаВДокументахЗакупки

#КонецОбласти // ПрограммныйИнтерфейс