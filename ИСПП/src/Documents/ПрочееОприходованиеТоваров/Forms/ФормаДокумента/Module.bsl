
////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ПЕРЕМЕННЫХ
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти // ОписаниеПеременных

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастройкаФормПоддержкаПроектов.ФормаДокумента_ПриСозданииНаСервере(ЭтотОбъект);
	НастройкаФормПоддержкаПроектов.НастроитьОтображениеИтогов(Элементы.ГруппаСуммаВсего);
	
	// БуферОбменаТоварами
	УстановитьДоступностьКомандБуфераОбмена(ЭтотОбъект, Не ОбработкаТабличнойЧастиСервер.БуферОбменаПустой());
	// Конец БуферОбменаТоварами
	
	ВалютаДокумента = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииНовогоПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастройкаФормПоддержкаПроектов.ФормаДокумента_ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПриСозданииНовогоПриЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВведенШтрихкод" И Источник = УникальныйИдентификатор Тогда
		ОбработатьШтрихкоды(ОбщегоНазначенияПоддержкаПроектовКлиентСервер.ПолучитьДанныеШтрихкода(Параметр, 1));
	КонецЕсли;
	
	Если Источник = "РегистрацияШтрихкодов"
	   И ИмяСобытия = "ЗарегистрированыШтрихкоды"
	   И Параметр.КлючВладельца = УникальныйИдентификатор Тогда
		Если Параметр.ЗарегистрированныеШтрихкоды.Количество() > 0 Тогда
			ОбновитьСтрокиНенайденныхШтрихКодов(Параметр.ЗарегистрированныеШтрихкоды);
		КонецЕсли;
	КонецЕсли;
	
	// БуферОбменаТоварами
	Если ОбработкаТабличнойЧастиКлиент.ОбрабатыватьОповещениеОтБуфераОбмена(ЭтотОбъект, ИмяСобытия, Источник) Тогда
		ДоступностьБуфераОбмена = ОбработкаТабличнойЧастиКлиент.ОпределитьДоступностьВставкиИзБуфераОбменаПоСобытию(ИмяСобытия);
		УстановитьДоступностьКомандБуфераОбмена(ЭтотОбъект, ДоступностьБуфераОбмена);
	КонецЕсли;
	// Конец БуферОбменаТоварами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ПодборТоваровКлиент.ОбработатьПодборТоваровВДокументПоступления(ЭтотОбъект, ИсточникВыбора) Тогда
		ОбработатьПодбор(ВыбранноеЗначение.АдресТоваровВХранилище, КэшированныеЗначения);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.ПрочееОприходованиеТоваров.Форма.ФормаПодбораДокументовСписания" Тогда
		ОбработатьПодбор(ВыбранноеЗначение.АдресТоваровВХранилище, КэшированныеЗначения);
	Иначе
		// БуферОбменаТоварами
		Если ОбработкаТабличнойЧастиКлиент.НужноОбработатьВставкуИзБуфераОбмена(ЭтотОбъект, ИсточникВыбора) Тогда
			ВставитьТоварыИзБуфераОбмена(ВыбранноеЗначение);
		КонецЕсли;
		// Конец БуферОбменаТоварами
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	НастройкаФормПоддержкаПроектов.ФормаДокумента_ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	НастройкаФормПоддержкаПроектов.ИзменитьЗаголовокПоХозяйственнойОперации(ЭтотОбъект);
	
	ЗаполнитьСлужебныеРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОповеститьОбИзменении(Тип("СправочникСсылка.СерииНоменклатуры"));	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНДЫ ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить()
	
	ОбработкаТабличнойЧастиКлиент.ПоказатьВводШтрихкода(УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодбор(Команда)
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("Документ"                         , Объект.Ссылка);
	ПараметрыПодбора.Вставить("Организация"                      , Объект.Организация);
	ПараметрыПодбора.Вставить("МестоХраненияОстатка"             , "Склад");
	ПараметрыПодбора.Вставить("Склад"                            , Объект.Склад);
	ПараметрыПодбора.Вставить("ПодборВПоступление"               , Истина);
	ПараметрыПодбора.Вставить("РежимПодбораБезСуммовыхПараметров", Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы"));
	
	ТипыНоменклатуры = ПодборТоваровКлиентСервер.ПолучитьОтборПоТипуНоменклатурыИзПараметровВыбора(Элементы.ТоварыНоменклатура.ПараметрыВыбора);
	ПараметрыПодбора.Вставить("ОтборПоТипуНоменклатуры", ТипыНоменклатуры);
	
	ПодборТоваровКлиент.ОткрытьПодборТоваровВДокументПоступления(ЭтотОбъект, ПараметрыПодбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНенайденныеШтрихкоды(Команда)
	
	ОбновитьСтрокиНенайденныхШтрихКодов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНенайденныеШтрихкоды(Команда)
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьНенайденныеШтрихкоды(Объект.Товары, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("ПослеРазбиенияСтроки", ЭтотОбъект, ТекущаяСтрока);
	ОбработкаТабличнойЧастиКлиент.РазбитьСтрокуТЧ(Объект.Товары, ТекущаяСтрока, Оповещение);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// Шапка
#Область Шапка

&НаКлиенте
Процедура НадписьЗаголовокОснованияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПросмотраДокументов = Новый Структура;
	ПараметрыПросмотраДокументов.Вставить("СписокДокументов", СписокОснований);
	ПараметрыПросмотраДокументов.Вставить("Заголовок", НСтр("ru='Списания на расходы (%КоличествоДокументов%)'"));
	ОткрытьФорму("ОбщаяФорма.ПросмотрСпискаДокументов", ПараметрыПросмотраДокументов, ЭтотОбъект,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ОбработатьИзменениеХозяйственнойОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбработатьИзменениеОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОрганизацииПриИзменении(Элемент)
	
	ОбработатьИзменениеПодразделения();
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	Если Склад <> Объект.Склад Тогда
		ОбработатьИзменениеСклада();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // Шапка

////////////////////////////////////////////////////////////////////////////////
// Список "Товары"
#Область Товары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ТекущаяСтрока.Штрихкод = "";
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьСериюНоменклатурыПоВладельцу(), ТекущаяСтрока.СерияНоменклатуры);
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьПартиюПоВладельцу(), ТекущаяСтрока.Партия);
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьУпаковкуПоВладельцу(), ТекущаяСтрока.ЕдиницаИзмерения);
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	Если ТекущаяСтрока.Количество > 0 Тогда
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элемент.Родитель.ТекущиеДанные;
	ОтборПартий = Новый Структура;
	ОтборПартий.Вставить("Документ"     , Объект.Ссылка);
	ОтборПартий.Вставить("Организация"  , Объект.Организация);
	ОтборПартий.Вставить("Склад"        , Объект.Склад);
	
	ПараметрыВыбораПартии = ОбработкаТабличнойЧастиКлиент.ПолучитьПараметрыВыбораПартии(ОтборПартий, ТекущаяСтрока);
	ОбработкаТабличнойЧастиКлиент.ВыбратьПартиюНоменклатуры(ЭтотОбъект, Элемент, ПараметрыВыбораПартии, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьЦену());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти // Товары

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНовогоПриЧтенииНаСервере()
	
	ПараметрыУчетаНоменклатуры = Новый ФиксированнаяСтруктура(ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(Объект));
	
	Склад = Объект.Склад;
	УстановитьДоступностьЭлементовПоТипуСклада();
	
	ОсновнойСклад = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьСкладПоУмолчанию(Неопределено, Объект.ПодразделениеОрганизации);
	
	НастройкаФормПоддержкаПроектов.ИзменитьЗаголовокПоХозяйственнойОперации(ЭтотОбъект);
	
	ЗаполнитьСлужебныеРеквизиты();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеСерийНоменклатуры(ЭтотОбъект);
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеПартий(ЭтотОбъект);
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(ЭтотОбъект, Новый Структура("Товары"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	//ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСлужебныеРеквизиты(Объект.Товары);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоТипуСклада()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитВВыделенныхСтроках(ИмяРеквизита, ПредставлениеРеквизита, ИмяФормыВыбора, ПараметрыФормы = Неопределено)
	
	ВыделенныеСтроки = Элементы.Товары.ВыделенныеСтроки;
	ЗаполнениеВозможно = ОбработкаТабличнойЧастиКлиент.ПроверитьВозможностьЗаполненияРеквизитаВТабличнойЧасти(
		Объект.Товары, ВыделенныеСтроки, НСтр("ru='Товары'"), ПредставлениеРеквизита);
	Если ЗаполнениеВозможно Тогда
		
		ПараметрыЗаполнения = Новый Структура("ИмяРеквизита, ПредставлениеРеквизита", ИмяРеквизита, ПредставлениеРеквизита);
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьРеквизитВВыделенныхСтрокахЗавершение", ЭтотОбъект, ПараметрыЗаполнения);
		ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитВВыделенныхСтрокахЗавершение(Значение, ПараметрыЗаполнения) Экспорт
	
	Если Значение <> Неопределено Тогда
		ВыделенныеСтроки = Элементы.Товары.ВыделенныеСтроки;
		ЗаполненоСтрок = ОбработкаТабличнойЧастиКлиент.ЗаполнитьРеквизитВВыделенныхСтроках(
			Объект.Товары, ВыделенныеСтроки, ПараметрыЗаполнения.ИмяРеквизита, Значение);
		ОбработкаТабличнойЧастиКлиент.ПоказатьОповещениеОЗаполненииРеквизитаВВыделенныхСтроках(
			Значение, ЗаполненоСтрок, ВыделенныеСтроки.Количество(), ПараметрыЗаполнения.ПредставлениеРеквизита);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка штрихкодов
#Область ОбработкаШтрихкодов

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	ДействияСДобавленнымиСтроками = Новый Структура;
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьСумму());
	
	ДействияСИзмененнымиСтроками = Новый Структура;
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	
	ИзменятьКоличество = Не ТолькоПросмотр;
	ПараметрыДействия = ОбработкаТабличнойЧастиКлиент.ПолучитьПараметрыОбработкиШтрихкодов(ДанныеШтрихкодов, ДействияСДобавленнымиСтроками, ДействияСИзмененнымиСтроками);
	ПараметрыДействия.ИзменятьКоличество = ИзменятьКоличество;
	ПараметрыДействия.ПараметрыУчетаНоменклатуры = Новый Структура(ПараметрыУчетаНоменклатуры);
	ПараметрыДействия.ПараметрыУчетаНоменклатуры.ИспользоватьПартии = Ложь;
	
	ОбработатьШтрихкодыНаСервере(ПараметрыДействия, КэшированныеЗначения);
	
	Если ПараметрыДействия.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.СообщитьОНеизвестныхШтрихкодах(ПараметрыДействия);
	
	Если ПараметрыДействия.ТекущаяСтрока <> Неопределено Тогда
		Элементы.Товары.ТекущаяСтрока = ПараметрыДействия.ТекущаяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыНаСервере(ПараметрыДействия, КэшированныеЗначения)
	
	ОбработкаТабличнойЧастиСервер.ОбработатьШтрихкоды(ЭтотОбъект, Объект, ПараметрыДействия, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтрокиНенайденныхШтрихКодов(ЗарегистрированныеШтрихкоды = Неопределено)
	
	Если Не ОбработкаТабличнойЧастиКлиент.ЕстьНенайденныеШтрихкоды(Объект.Товары) Тогда
		Возврат;
	КонецЕсли;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	ДействияСИзмененнымиСтроками = Новый Структура;
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	
	ПараметрыДействия = ОбработкаТабличнойЧастиКлиент.ПолучитьПараметрыОбработкиНенайденныхШтрихкодов();
	ПараметрыДействия.ДействияСИзмененнымиСтроками = ДействияСИзмененнымиСтроками;
	Если ЗарегистрированныеШтрихкоды <> Неопределено Тогда
		ПараметрыДействия.ЗарегистрированныеШтрихкоды = ЗарегистрированныеШтрихкоды;
	КонецЕсли;
	
	ОбновитьДанныеНенайденныхШтрихКодовНаСервере(ПараметрыДействия, КэшированныеЗначения);
	
	Если ПараметрыДействия.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.СообщитьОНеизвестныхШтрихкодах(ПараметрыДействия);
	ОбработкаТабличнойЧастиКлиент.СообщитьОРезультатеОбновленияДанныхПоШтрихкодам(ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеНенайденныхШтрихКодовНаСервере(ПараметрыДействия, КэшированныеЗначения)
	
	ОбработкаТабличнойЧастиСервер.ОбновитьДанныеНенайденныхШтрихКодов(Объект, ПараметрыДействия, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти // ОбработкаШтрихкодов

////////////////////////////////////////////////////////////////////////////////
// Обработка подбора
#Область ОбработкаПодбора

&НаСервере
Процедура ОбработатьПодбор(Знач АдресТоваровВХранилище, КэшированныеЗначения)
	
	СписокТоваров = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	
	Для Каждого ВыбранныйТовар Из СписокТоваров Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыбранныйТовар);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТабличнойЧасти(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ОбработкаПодбора

////////////////////////////////////////////////////////////////////////////////
// Обработка изменения реквизитов
#Область ОбработкаИзмененияРеквизитов

&НаСервере
Процедура ОбработатьИзменениеХозяйственнойОперации()
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастройкаФормПоддержкаПроектов.ИзменитьЗаголовокПоХозяйственнойОперации(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОрганизации()
	
	Подразделение = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьПодразделениеПоУмолчанию(Объект.ПодразделениеОрганизации, Объект.Организация);
	Если Объект.ПодразделениеОрганизации <> Подразделение Тогда
		Объект.ПодразделениеОрганизации = Подразделение;
		ОбработатьИзменениеПодразделения();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПодразделения()
	
	ОбщегоНазначенияПоддержкаПроектов.ИзменитьСкладПриНеобходимости(Объект.ПодразделениеОрганизации, Объект.Склад, ОсновнойСклад);
	ОбработатьИзменениеСклада();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеСклада()
	
	Если Склад = Объект.Склад Тогда
		Возврат;
	КонецЕсли;
	
	Склад = Объект.Склад;
	
	ПараметрыУчетаНоменклатуры = Новый ФиксированнаяСтруктура(ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(Объект));
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(Объект, ПараметрыУчетаНоменклатуры);
	
	УстановитьДоступностьЭлементовПоТипуСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРазбиенияСтроки(НоваяСтрока, ТекущаяСтрока) Экспорт
	
	ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока);
	ПриИзмененииКоличестваВСтрокеСпискаТовары(НоваяСтрока);
	
	Элементы.Товары.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеСтатьиРасходов(КэшированныеЗначения)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	ПланыВидовХарактеристик.СтатьиРасходов.ОбработатьИзменениеСтатьиРасходов(Объект, ТекущаяСтрока);
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьСлужебныеРеквизитыСтатьиРасходов());
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти // ОбработкаИзмененияРеквизитов

////////////////////////////////////////////////////////////////////////////////
// Буфер обмена товарами
#Область БуферОбменаТоварами

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	ТаблицаТовары = Элементы.Товары;
	Если ОбработкаТабличнойЧастиКлиент.ВозможноКопированиеСтрок(ТаблицаТовары.ТекущаяСтрока) Тогда
		СкопироватьСтрокиВБуферОбмена(ТаблицаТовары.Имя);
		ОбработкаТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(ТаблицаТовары.ВыделенныеСтроки.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	ВставитьТоварыИзБуфераОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБуфераОбмена(Команда)
	
	ОбработкаТабличнойЧастиКлиент.ОткрытьБуферОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтрокиВБуферОбмена(Знач ИмяТабличнойЧасти)
	
	ОбработкаТабличнойЧастиСервер.СкопироватьВыделенныеСтрокиВБуферОбмена(Объект, Объект[ИмяТабличнойЧасти], Элементы[ИмяТабличнойЧасти].ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьТоварыИзБуфераОбмена(ВыбранныеТовары = Неопределено)
	
	ТаблицаТовары = Объект.Товары;
	КоличествоТоваровДоВставки = ТаблицаТовары.Количество();
	
	ВставитьТоварыИзБуфераОбменаСервер(ВыбранныеТовары);
	
	КоличествоВставленных = ТаблицаТовары.Количество() - КоличествоТоваровДоВставки;
	ОбработкаТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьТоварыИзБуфераОбменаСервер(Знач ВыбранныеТовары = Неопределено)
	
	ТабличнаяЧасть = Объект.Товары;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоэффициент());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьСумму());
	
	ДанныеВставлены = ОбработкаТабличнойЧастиСервер.ВставитьТоварыИзБуфераОбмена(ВыбранныеТовары, ТабличнаяЧасть, СтруктураДействий);
	Если ДанныеВставлены Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандБуфераОбмена(Форма, ЕстьДанныеВБуфереОбмена)
	
	Элементы = Форма.Элементы;
	Элементы.ТоварыБуферОбменаВставить.Доступность = ЕстьДанныеВБуфереОбмена;
	Элементы.ТоварыКонтекстноеМенюБуферОбменаВставить.Доступность = ЕстьДанныеВБуфереОбмена;
	Элементы.ТоварыБуферОбмена.Доступность = ЕстьДанныеВБуфереОбмена;
	
КонецПроцедуры

#КонецОбласти // БуферОбменаТоварами

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти // СтандартныеПодсистемы

&НаКлиенте
Процедура СоздатьСерии(Команда)
	НайтиСоздатьСерииНоменклатурыДоПроведения();
КонецПроцедуры

&НаСервере
Процедура НайтиСоздатьСерииНоменклатурыДоПроведения()
	СтруктураОтбора = Новый Структура("СтатусУказанияСерий", 6);
	СтрокиССериями = Объект.Товары.НайтиСтроки(СтруктураОтбора);
	Если Объект.Ссылка.Пустая() Тогда
		Для Каждого Строка Из СтрокиССериями Цикл
			Серия = Справочники.СерииНоменклатуры.СоздатьЭлемент();
			Серия.КодГода = "00";
			Серия.КодЦентра = "0";
			Серия.КодДО = "0";
			Серия.КодГрифа = "0";
			Серия.Владелец = Строка.Номенклатура;
			Серия.Записать();
			
			Строка.СерияНоменклатуры = Серия.Ссылка;
		КонецЦикла;
	Иначе
		Таблица = Объект.Товары.Выгрузить(СтрокиССериями);
		Таблица.Свернуть("Номенклатура", "Количество");
		Для Каждого Строка Из Таблица Цикл
			Запрос = Новый Запрос();
			Запрос.Текст = "ВЫБРАТЬ
			               |	СУММА(1) КАК КоличествоСерий
			               |ИЗ
			               |	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
			               |ГДЕ
			               |	СерииНоменклатуры.Владелец = &Владелец
			               |	И СерииНоменклатуры.Поставка = &Поставка
			               |
			               |СГРУППИРОВАТЬ ПО
			               |	СерииНоменклатуры.Владелец,
			               |	СерииНоменклатуры.Поставка";
			Запрос.УстановитьПараметр("Владелец", Строка.Номенклатура);
			Запрос.УстановитьПараметр("Поставка", Объект.Ссылка);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Если Выборка.Количество() < Строка.Количество Тогда
					СтруктураОтбора = Новый Структура("Номенклатура", Строка.Номенклатура);
					СтрокиПоНоменклатуре = Объект.Товары.НайтиСтроки(СтруктураОтбора);
					МассивСерий = Новый Массив();
					Для Каждого Строка Из СтрокиПоНоменклатуре Цикл
						Если ЗначениеЗаполнено(Строка.СерияНоменклатуры) И МассивСерий.Найти(Строка.СерияНоменклатуры) = Неопределено Тогда
							МассивСерий.Добавить(Строка.СерияНоменклатуры);
							Продолжить;
						КонецЕсли;
						Серия = Справочники.СерииНоменклатуры.СоздатьЭлемент();
						Серия.КодГода = "00";
						Серия.КодЦентра = "0";
						Серия.КодДО = "0";
						Серия.КодГрифа = "0";
						Серия.Владелец = Строка.Номенклатура;
						Серия.Поставка = Объект.Ссылка;
						Серия.Записать();
						
						Строка.СерияНоменклатуры = Серия.Ссылка;	
					КонецЦикла;
				КонецЕсли;
			Иначе
				СтруктураОтбора = Новый Структура("Номенклатура", Строка.Номенклатура);
				СтрокиПоНоменклатуре = Объект.Товары.НайтиСтроки(СтруктураОтбора);
				Для Каждого Строка Из СтрокиПоНоменклатуре Цикл
					Если ЗначениеЗаполнено(Строка.СерияНоменклатуры) Тогда
						Продолжить;
					КонецЕсли;
					Серия = Справочники.СерииНоменклатуры.СоздатьЭлемент();
					Серия.КодГода = "00";
					Серия.КодЦентра = "0";
					Серия.КодДО = "0";
					Серия.КодГрифа = "0";
					Серия.Владелец = Строка.Номенклатура;
					Серия.Поставка = Объект.Ссылка;
					Серия.Записать();
					
					Строка.СерияНоменклатуры = Серия.Ссылка;	
				КонецЦикла;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНомера(Команда)
	Если Объект.Ссылка.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для заполнения учетных и заводских номеров документ должен быть записан!");
		Возврат;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьПослеВводаНомеров", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ДокументПоступления", Объект.Ссылка);
	ОткрытьФорму("Документ.ПоступлениеТоваров.Форма.ВвестиДанныеПоНомерам", ПараметрыФормы, ЭтаФорма,,,,ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПослеВводаНомеров(Значение, Параметры) Экспорт
	ОповеститьОбИзменении(Тип("СправочникСсылка.СерииНоменклатуры"));
	ЭтаФорма.Прочитать();
КонецПроцедуры