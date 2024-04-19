
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ЗначениеИзСтруктуры;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрыКомпоновки", ЗначениеИзСтруктуры) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначениеИзСтруктуры);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоМесяца(КонецПериода);
	КонецЕсли;
	
	Если Параметры.ВыборВОтделении Тогда
		Элементы.РежимОтбораПартий.СписокВыбора.Добавить(Перечисления.РежимыОтбораПартий.ПоОтпускамТоваровВОтделения);
		Если Не ЗначениеЗаполнено(РежимОтбораПартий) Тогда
			РежимОтбораПартий = Перечисления.РежимыОтбораПартий.ПоОтпускамТоваровВОтделения;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РежимОтбораПартий) Тогда
		РежимОтбораПартий = Перечисления.РежимыОтбораПартий.ПоОборотам;
	КонецЕсли;
	
	МожноСоздаватьПартию = Параметры.МожноСоздаватьПартию И ПравоДоступа("Добавление", Метаданные.Документы.Партия);
	Элементы.СписокДобавить.Видимость = МожноСоздаватьПартию;
	
	НастроитьФорму();
	УстановитьВидимостьПолей();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьВидимостьПолей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ФормироватьСписокПриОткрытии Тогда
		СформироватьСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Партия = ПолучитьПартиюНоменклатуры(НовыйОбъект);
	
	ОповеститьОВыборе(Партия);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьСервер();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РежимОтбораПартийПриИзменении(Элемент)
	
	УстановитьВидимостьПолей();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	Список.Очистить();
	НастроитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Не МожноСоздаватьПартию Или Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Дата", КонецПериода);
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	
	ОткрытьФорму("Документ.Партия.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат; 
	КонецЕсли;
	
	ТекущийДокумент = ТекущиеДанные.Документ;
	Если Не ЗначениеЗаполнено(ТекущийДокумент) Тогда
		ТекущийДокумент = ТекущиеДанные.Партия;
	КонецЕсли;
	
	ПоказатьЗначение( ,ТекущийДокумент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекущийДокумент = ТекущиеДанные.Партия;
	Если НЕ ЗначениеЗаполнено(ТекущийДокумент) Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущийДокумент);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура НастроитьФорму()
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		ПараметрыУчета = Справочники.Номенклатура.ПараметрыУчета(Номенклатура);
		ИспользоватьСерии = (ПараметрыУчета.ИспользоватьСерии = Истина);
		ЕдиницаИзмерения = НоменклатураСервер.ОсновнаяЕдиницаИзмерения(Номенклатура);
	Иначе
		ИспользоватьСерии = Ложь;
		ЕдиницаИзмерения = Неопределено;
	КонецЕсли;
	
	Элементы.СерияНоменклатуры.Доступность = ИспользоватьСерии;
	Элементы.СписокОстаток.Заголовок = ?(
		ЗначениеЗаполнено(ЕдиницаИзмерения),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='Остаток, %1'"), ЕдиницаИзмерения),
		НСтр("ru ='Остаток'"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолей()
	
	ПодборПоОстаткам = (РежимОтбораПартий = Перечисления.РежимыОтбораПартий.ПоОстаткам);
	Элементы.СписокОстаток.Видимость = ПодборПоОстаткам;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСервер()
	
	Список.Очистить();
	
	ТаблицаИсточник = Неопределено;
	Если РежимОтбораПартий = Перечисления.РежимыОтбораПартий.ПоРеквизитам Тогда
		
		ТаблицаИсточник = ПолучитьДанныеСпискаПоРеквизитам();
		
	ИначеЕсли РежимОтбораПартий = Перечисления.РежимыОтбораПартий.ПоОборотам Тогда
		
		ТаблицаИсточник = ПолучитьДанныеСпискаПоОборотам();
		
	ИначеЕсли РежимОтбораПартий = Перечисления.РежимыОтбораПартий.ПоОстаткам Тогда
		
		ТаблицаИсточник = ПолучитьДанныеСпискаПоОстаткам();
		
	ИначеЕсли РежимОтбораПартий = Перечисления.РежимыОтбораПартий.ПоОтпускамТоваровВОтделения Тогда
		
		ТаблицаИсточник = ПолучитьДанныеСпискаПоОтпускамВОтделения();
		
	КонецЕсли;
	
	Если ТаблицаИсточник <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаИсточник, Список);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеСпискаПоРеквизитам()
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	Партии.КлючАналитики КАК Партия,
	               |	Партии.ДокументОприходования КАК Документ,
	               |	ВЫБОР
	               |		КОГДА Партии.ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров
	               |			ТОГДА Партии.ДокументОприходования.ПроектЗадания
	               |		ИНАЧЕ НЕОПРЕДЕЛЕНО
	               |	КОНЕЦ КАК ПроектЗадания
	               |ИЗ
	               |	РегистрСведений.АналитикаУчетаПартий КАК Партии
	               |ГДЕ
	               |	Партии.ДокументОприходования.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И &Отбор";
	
	ТекстОтбора = "ИСТИНА";
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И ДокументОприходования.Организация = &Организация";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И Партии.ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров И Партии.ДокументОприходования.ПроектЗадания = &ПроектЗадания";
	КонецЕсли;
	
	Запрос = Новый Запрос(СтрЗаменить(ТекстЗапроса, "&Отбор", ТекстОтбора));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Организация", Организация); 
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		Запрос.УстановитьПараметр("ПроектЗадания", ПроектЗадания);
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		Запрос.УстановитьПараметр("ПроектЗадания", ПроектЗадания);
	КонецЕсли;

	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеСпискаПоОборотам()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Партия КАК Партия,
	|	АналитикаПартий.ДокументОприходования КАК Документ,
	|	АналитикаПартий.Поставщик КАК Поставщик,
	|	ВЫБОР
	|		КОГДА АналитикаПартий.ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров
	|			ТОГДА АналитикаПартий.ДокументОприходования.ПроектЗадания
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ПроектЗадания
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки.Обороты(&НачалоПериода, &КонецПериода,, Партия <> ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка) И &Отбор) КАК Товары
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПартий КАК АналитикаПартий
	|	ПО
	|		Товары.Партия = АналитикаПартий.КлючАналитики
	|";
	
	ТекстОтбора = "Номенклатура = &Номенклатура";
	Если ЗначениеЗаполнено(СерияНоменклатуры) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И СерияНоменклатуры В (&СерияНоменклатуры, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))";
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И Организация = &Организация";
	КонецЕсли;
	Если ЗначениеЗаполнено(Склад) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И Партия.ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров И Партия.ДокументОприходования.ПроектЗадания = &ПроектЗадания";
	КонецЕсли;

	Запрос = Новый Запрос(СтрЗаменить(ТекстЗапроса, "&Отбор", ТекстОтбора));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		Запрос.УстановитьПараметр("ПроектЗадания", ПроектЗадания);
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеСпискаПоОстаткам()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Партия КАК Партия,
	|	АналитикаПартий.ДокументОприходования КАК Документ,
	|	АналитикаПартий.Поставщик КАК Поставщик,
	|	Товары.ВНаличииОстаток / ЕСТЬNULL(ЕдиницыИзмерения.Коэффициент, 1) КАК Остаток,
	|	ВЫБОР
	|		КОГДА АналитикаПартий.ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров
	|			ТОГДА АналитикаПартий.ДокументОприходования.ПроектЗадания
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ПроектЗадания
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки.Остатки(&КонецПериода, Партия <> ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка) И &Отбор) КАК Товары
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПартий КАК АналитикаПартий
	|	ПО
	|		Товары.Партия = АналитикаПартий.КлючАналитики
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ЕдиницыИзмеренияНоменклатуры КАК ЕдиницыИзмерения
	|	ПО
	|		ЕдиницыИзмерения.Номенклатура = &Номенклатура
	|		И ЕдиницыИзмерения.ЕдиницаИзмерения = &ЕдиницаИзмерения
	|";
	
	ТекстОтбора = "Номенклатура = &Номенклатура";
	Если ЗначениеЗаполнено(СерияНоменклатуры) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И СерияНоменклатуры В (&СерияНоменклатуры, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))";
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И Организация = &Организация";
	КонецЕсли;
	Если ЗначениеЗаполнено(Склад) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров И ДокументОприходования.ПроектЗадания = &ПроектЗадания";
	КонецЕсли;
	
	Запрос = Новый Запрос(СтрЗаменить(ТекстЗапроса, "&Отбор", ТекстОтбора));
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", ЕдиницаИзмерения);
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		Запрос.УстановитьПараметр("ПроектЗадания", ПроектЗадания);
	КонецЕсли;

	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеСпискаПоОтпускамВОтделения()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Товары.Партия КАК Партия,
	|	АналитикаПартий.ДокументОприходования КАК Документ,
	|	АналитикаПартий.Поставщик КАК Поставщик,
	|	ВЫБОР
	|		КОГДА АналитикаПартий.ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров
	|			ТОГДА АналитикаПартий.ДокументОприходования.ПроектЗадания
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ПроектЗадания
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки.Обороты(&НачалоПериода, &КонецПериода, АВТО, Партия <> ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка) И &Отбор) КАК Товары
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПартий КАК АналитикаПартий
	|	ПО
	|		Товары.Партия = АналитикаПартий.КлючАналитики
	|ГДЕ
	|	Товары.Регистратор ССЫЛКА Документ.ОтпускТоваровВОтделение
	|	И &Условие
	|";
	
	ТекстОтбора = "Номенклатура = &Номенклатура";
	Если ЗначениеЗаполнено(СерияНоменклатуры) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И СерияНоменклатуры В (&СерияНоменклатуры, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))";
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстОтбора = ТекстОтбора + "
		|	И Организация = &Организация";
	КонецЕсли;
	
	ТекстУсловия = "ИСТИНА";
	Если ЗначениеЗаполнено(Склад) Тогда
		ТекстУсловия = ТекстУсловия + "
		|	И ВЫРАЗИТЬ(Товары.Регистратор КАК Документ.ОтпускТоваровВОтделение).СкладПолучатель = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		ТекстУсловия = ТекстУсловия + "
		|	И Партия.ДокументОприходования ССЫЛКА Документ.ПоступлениеТоваров И Партия.ДокументОприходования.ПроектЗадания = &ПроектЗадания";
	КонецЕсли;

	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Отбор", ТекстОтбора);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Условие", ТекстУсловия);
	
	Запрос = Новый Запрос();
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	
	Если ЗначениеЗаполнено(ПроектЗадания) Тогда
		Запрос.УстановитьПараметр("ПроектЗадания", ПроектЗадания);
	КонецЕсли;

	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьПартиюНоменклатуры(ДокументПартии)
	
	ПараметрыАналитики = Новый Структура;
	ПараметрыАналитики.Вставить("ДокументОприходования", ДокументПартии);
	ПараметрыАналитики.Вставить("Поставщик", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументПартии, "Контрагент"));
	
	Возврат Справочники.ПартииНоменклатуры.ЗначениеКлючаАналитики(ПараметрыАналитики);
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыФункции
