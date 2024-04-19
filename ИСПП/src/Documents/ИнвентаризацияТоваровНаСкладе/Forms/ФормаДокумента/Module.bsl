
////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ПЕРЕМЕННЫХ
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

&НаКлиенте
Перем ВыполняетсяЗапись;

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
	
	// БуферОбменаТоварами
	ДоступностьБуфераОбмена = Не ОбработкаТабличнойЧастиСервер.БуферОбменаПустой()
		И (Не Объект.Проведен Или Объект.Статус = Перечисления.СтатусыИнвентаризацииТоваров.ВРаботе);
	УстановитьДоступностьКомандБуфераОбмена(ЭтотОбъект, ДоступностьБуфераОбмена);
	// Конец БуферОбменаТоварами
	
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
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	// БуферОбменаТоварами
	Если ОбработкаТабличнойЧастиКлиент.НужноОбработатьВставкуИзБуфераОбмена(ЭтотОбъект, ИсточникВыбора) Тогда
		ВставитьТоварыИзБуфераОбмена(ВыбранноеЗначение);
	КонецЕсли;
	// Конец БуферОбменаТоварами
	
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
		ДоступностьБуфераОбмена = ОбработкаТабличнойЧастиКлиент.ОпределитьДоступностьВставкиИзБуфераОбменаПоСобытию(ИмяСобытия)
			И (Не Объект.Проведен Или Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыИнвентаризацииТоваров.ВРаботе"));
		УстановитьДоступностьКомандБуфераОбмена(ЭтотОбъект, ДоступностьБуфераОбмена);
	КонецЕсли;
	// Конец БуферОбменаТоварами
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение
	   И Не Объект.УчетныеДанныеЗаполнены
	   И Объект.Товары.Количество() > 0
	   И ВыполняетсяЗапись <> Истина Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru='При проведении будет перезаполнено учетное количество во всех строках табличной части. Продолжить?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса,РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.ОК);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ОтборИнвентаризации = Новый ХранилищеЗначения(ОтборИнвентаризации.Настройки, Новый СжатиеДанных(9));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	ЗаполнитьСлужебныеРеквизиты();
	
	НастройкаФормПоддержкаПроектов.ФормаДокумента_ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// Шапка
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Объект.УчетныеДанныеЗаполнены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.УчетныеДанныеЗаполнены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	Если Склад <> Объект.Склад Тогда
		ОбработатьИзменениеСклада();
		Объект.УчетныеДанныеЗаполнены = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоРасхожденияПриИзменении(Элемент)
	
	Если ТолькоРасхождения Тогда
		Элементы.Товары.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьРасхождения", Истина);
	Иначе
		Элементы.Товары.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // Шапка


////////////////////////////////////////////////////////////////////////////////
// Список "Товары"
#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если Копирование Тогда
		ТекущаяСтрока.Количество = 0;
		ТекущаяСтрока.КоличествоПоДаннымУчета = 0;
		ТекущаяСтрока.ЕстьРасхождения = Ложь;
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Не ОтменаРедактирования И НоваяСтрока Тогда
		Объект.УчетныеДанныеЗаполнены = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьСериюНоменклатурыПоВладельцу(), ТекущаяСтрока.СерияНоменклатуры);
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьУпаковкуПоВладельцу(), ТекущаяСтрока.ЕдиницаИзмерения);
	СтруктураДействий.Вставить(Действия.Действие_ПроверитьПартиюПоВладельцу(), ТекущаяСтрока.Партия);
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоПоДаннымУчета());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Объект.УчетныеДанныеЗаполнены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНоменклатурыПриИзменении(Элемент)
	
	Объект.УчетныеДанныеЗаполнены = Ложь;
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
		
	СтруктураДействий = Новый Структура;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоПоДаннымУчета());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Объект.УчетныеДанныеЗаполнены = Ложь;
	
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
	ПараметрыВыбораПартии.МожноСоздаватьПартию = Истина;
	
	ОбработкаТабличнойЧастиКлиент.ВыбратьПартиюНоменклатуры(ЭтотОбъект, Элемент, ПараметрыВыбораПартии, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияПриИзменении(Элемент)
	
	Объект.УчетныеДанныеЗаполнены = Ложь;
	
КонецПроцедуры


#КонецОбласти // Товары

////////////////////////////////////////////////////////////////////////////////
// Список "Инвентаризационная комиссия"
#Область ОбработчикиСобытийЭлементовТаблицыФормыИнвентаризационнаяКомиссия

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьПодборЧленовКомиссии(
		Объект.ИнвентаризационнаяКомиссия, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьНачалоРедактированияСоставаКомиссии(
		Объект.ИнвентаризационнаяКомиссия, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПослеУдаления(Элемент)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьУдалениеЧленаКомиссии(Объект.ИнвентаризационнаяКомиссия);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПредседательПриИзменении(Элемент)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьИзменениеПредседателяКомиссии(Объект.ИнвентаризационнаяКомиссия, Элемент.Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияЧленКомиссииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьВыборЧленаКомиссии(
		Объект.ИнвентаризационнаяКомиссия, Элемент.Родитель, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти // ИнвентаризационнаяКомиссия


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

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

&НаКлиенте
Процедура ПодборКомиссии(Команда)
	
	ВзаимодействиеСПользователемКлиент.ОткрытьПодборЧленовКомиссии(Элементы.ИнвентаризационнаяКомиссия);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзПостоянноДействующихКомиссий(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьВыборКомиссии", ЭтотОбъект);
	ВзаимодействиеСПользователемКлиент.ВыбратьПостоянноДействующуюКомиссию(ЭтотОбъект, Объект.Организация, Оповещение);
	
КонецПроцедуры

#Область Товары

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("ПослеРазбиенияСтроки", ЭтотОбъект, ТекущаяСтрока);
	ОбработкаТабличнойЧастиКлиент.РазбитьСтрокуТЧ(Объект.Товары, ТекущаяСтрока, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОтбору(Команда)
	
	Если Не КлючевыеПараметрыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Товары.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоОтборуЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед заполнением список товаров будет очищен. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьПоОтборуСервер();
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Процедура ЗаполнитьФактПоУчету(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьФактПоУчетуЗавершение", ЭтотОбъект);
	Если КоличествоФактЗаполнено() Тогда
		ТекстВопроса = НСтр("ru='В табличной части уже есть строки с заполненным фактическим количеством.
		                        |При заполнении эта информация будет утеряна. Продолжить?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Иначе
		ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить()
	
	ОбработкаТабличнойЧастиКлиент.ПоказатьВводШтрихкода(УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНенайденныеШтрихкоды(Команда)
	
	ОбновитьСтрокиНенайденныхШтрихКодов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНенайденныеШтрихкоды(Команда)
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьНенайденныеШтрихкоды(Объект.Товары, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // Товары

#КонецОбласти // ОбработчикиКомандФормы


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

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

&НаКлиенте
Процедура ЗаполнитьФактПоУчетуЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Действия = ОбработкаТабличнойЧастиКлиентСервер;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
		СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьРасхождения());
		
		Для Каждого СтрокаТовара Из Объект.Товары Цикл
			СтрокаТовара.Количество = СтрокаТовара.КоличествоПоДаннымУчета;
			ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(СтрокаТовара, СтруктураДействий, КэшированныеЗначения);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОтборуЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ЗаполнитьПоОтборуСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняетсяЗапись = Истина;
	Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	ВыполняетсяЗапись = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНовогоПриЧтенииНаСервере()
	
	ИнициализироватьОтборИнвентаризации();
	
	Склад = Объект.Склад;
	
	ПараметрыУчетаНоменклатуры = Новый ФиксированнаяСтруктура(ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(Объект));
	
	ЗаполнитьСлужебныеРеквизиты();
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьОтборИнвентаризации()
	
	СхемаКомпоновкиДанных = Документы.ИнвентаризацияТоваровНаСкладе.ПолучитьМакет("ОтборИнвентаризации");
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	
	ОтборИнвентаризации.Инициализировать(ИсточникНастроек);
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекНастройки = ТекОбъект.ОтборИнвентаризации.Получить();
	Если ТекНастройки = Неопределено Тогда
		ОтборИнвентаризации.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Иначе
		ОтборИнвентаризации.ЗагрузитьНастройки(ТекНастройки);
	КонецЕсли;
	
	ОтборИнвентаризации.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	УстановитьЗначениеПараметраНастроек(ОтборИнвентаризации.Настройки, "Склад", Объект.Склад);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьРасхождения());
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТабличнуюЧасть(Объект.Товары, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоСтатусуСервер()
	
	ПолноеРедактирование = Ложь;
	ОграниченноеРедактирование = Ложь;
	
	Если Объект.Проведен Тогда
		
		Если Объект.Статус = Перечисления.СтатусыИнвентаризацииТоваров.Выполнено Тогда
			
		ИначеЕсли Объект.Статус = Перечисления.СтатусыИнвентаризацииТоваров.ВРаботе Тогда
			ОграниченноеРедактирование = Истина;
		КонецЕсли;
		
	Иначе
		ПолноеРедактирование = Истина;
	КонецЕсли;
	
	Элементы.Дата.ТолькоПросмотр        = Не ПолноеРедактирование;
	Элементы.Организация.ТолькоПросмотр = Не ПолноеРедактирование;
	Элементы.Склад.ТолькоПросмотр       = Не ПолноеРедактирование;
	
	Элементы.ТоварыЗаполнитьПоДаннымУчета.Доступность = ПолноеРедактирование Или ОграниченноеРедактирование;
	Элементы.ТоварыЗаполнитьФактПоУчету.Доступность   = ПолноеРедактирование Или ОграниченноеРедактирование;
	
	Элементы.ТоварыРазбитьСтроку.Доступность = ПолноеРедактирование Или ОграниченноеРедактирование;
	
	Элементы.Товары.ИзменятьСоставСтрок  = ПолноеРедактирование Или ОграниченноеРедактирование;
	Элементы.Товары.ИзменятьПорядокСтрок = ПолноеРедактирование Или ОграниченноеРедактирование;
	
	// БуферОбменаТоварами
	Элементы.ТоварыБуферОбменаВставить.Доступность                = ПолноеРедактирование Или ОграниченноеРедактирование;
	Элементы.ТоварыКонтекстноеМенюБуферОбменаВставить.Доступность = ПолноеРедактирование Или ОграниченноеРедактирование;
	Элементы.ТоварыБуферОбмена.Доступность                        = ПолноеРедактирование Или ОграниченноеРедактирование;
	// Конец БуферОбменаТоварами
	
КонецПроцедуры

&НаКлиенте
Функция КоличествоФактЗаполнено()
	
	НайденныеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Количество", 0));
	Возврат НайденныеСтроки.Количество() <> Объект.Товары.Количество();
	
КонецФункции

&НаКлиенте
Функция КлючевыеПараметрыЗаполнены()
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" не заполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "Объект.Организация",, Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Склад"" не заполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "Объект.Склад",, Отказ);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборКомиссии(ВыбранноеЗначение, НеИспользуется) Экспорт
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьВыборКомиссииСервер(ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьВыборКомиссииСервер(Комиссия)
	
	ОбработкаТабличнойЧастиСервер.ЗаполнитьДанныеКомиссииИзПостоянноДействующейКомиссии(Комиссия, Объект, Объект.ИнвентаризационнаяКомиссия);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Заполнение по отбору
#Область ЗаполнениеПоОтбору

&НаСервере
Процедура ЗаполнитьПоОтборуСервер()
		
	УстановитьЗначениеПараметраНастроек(ОтборИнвентаризации.Настройки, "Организация", Объект.Организация);
	УстановитьЗначениеПараметраНастроек(ОтборИнвентаризации.Настройки, "Склад", Объект.Склад);
	УстановитьЗначениеПараметраНастроек(ОтборИнвентаризации.Настройки, "ДатаОстатков", ПолучитьДатуОстатков());
	
	СхемаКомпоновкиДанных = Документы.ИнвентаризацияТоваровНаСкладе.ПолучитьМакет("ОтборИнвентаризации");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		ОтборИнвентаризации.ПолучитьНастройки(),
		,
		,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Объект.Товары.Загрузить(ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных));
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьРасхождения());
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТабличнуюЧасть(Объект.Товары, СтруктураДействий, Неопределено);
	
	Объект.УчетныеДанныеЗаполнены = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДатуОстатков()
	
	ДатаОстатков = ТекущаяДатаСеанса();
	Если ЗначениеЗаполнено(Объект.Дата) И НачалоДня(Объект.Дата) <> НачалоДня(ДатаОстатков) Тогда
		
		Если Объект.Ссылка.Пустая() Тогда
			ДатаОстатков = КонецДня(Объект.Дата);
		Иначе
			ДатаОстатков = Объект.Дата;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДатаОстатков;
	
КонецФункции

&НаСервере
Процедура УстановитьЗначениеПараметраНастроек(Настройки, ИмяПараметра, Значение)
	
	Параметр = Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Значение;
		Параметр.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ЗаполнениеПоОтбору

////////////////////////////////////////////////////////////////////////////////
// Обработка штрихкодов
#Область ОбработкаШтрихкодов

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	ДействияСДобавленнымиСтроками = Новый Структура;
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьЕдиницуИзмерения());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьПараметрыУчета(), ПараметрыУчетаНоменклатуры);
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	ДействияСДобавленнымиСтроками.Вставить(Действия.Действие_ЗаполнитьРасхождения());
	
	ДействияСИзмененнымиСтроками = Новый Структура;
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ЗаполнитьРасхождения());
	
	ИзменятьКоличество =
		Не ТолькоПросмотр
		И (Не Объект.Проведен
			Или Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыИнвентаризацииТоваров.ВРаботе"));
	ПараметрыДействия = ОбработкаТабличнойЧастиКлиент.ПолучитьПараметрыОбработкиШтрихкодов(ДанныеШтрихкодов, ДействияСДобавленнымиСтроками, ДействияСИзмененнымиСтроками);
	ПараметрыДействия.ИзменятьКоличество = ИзменятьКоличество;
	ПараметрыДействия.ПараметрыУчетаНоменклатуры = ПараметрыУчетаНоменклатуры;
	
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
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ПересчитатьКоличествоПоДаннымУчета());
	ДействияСИзмененнымиСтроками.Вставить(Действия.Действие_ЗаполнитьРасхождения());
	
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
// Обработка изменения реквизитов
#Область ОбработкаИзмененияРеквизитов

&НаСервере
Процедура ОбработатьИзменениеСклада()
	
	Если Склад = Объект.Склад Тогда
		Возврат;
	КонецЕсли;
	
	Склад = Объект.Склад;
	
	ПараметрыУчетаНоменклатуры = Новый ФиксированнаяСтруктура(ЗапасыСервер.ПолучитьПараметрыУчетаНоменклатуры(Объект));
	ЗапасыСервер.ЗаполнитьСтатусыУчетаНоменклатуры(Объект, ПараметрыУчетаНоменклатуры);
	
	Объект.УчетныеДанныеЗаполнены = Ложь;
	
	УстановитьЗначениеПараметраНастроек(ОтборИнвентаризации.Настройки, "Склад", Объект.Склад);
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ОтборИнвентаризации.Настройки.Отбор, "МестоХранения");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока)
	
	Действия = ОбработкаТабличнойЧастиКлиентСервер;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьРасхождения());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТабличнойЧасти(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеРазбиенияСтроки(НоваяСтрока, ТекущаяСтрока) Экспорт
	
	НоваяСтрока.КоличествоПоДаннымУчета = 0;
	
	ПриИзмененииКоличестваВСтрокеСпискаТовары(ТекущаяСтрока);
	ПриИзмененииКоличестваВСтрокеСпискаТовары(НоваяСтрока);
	
	Элементы.Товары.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
КонецПроцедуры

#КонецОбласти // ОбработкаИзмененияРеквизитов

////////////////////////////////////////////////////////////////////////////////
// Условное оформление
#Область УсловноеОформление

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеСерийНоменклатуры(ЭтотОбъект);
	ОбработкаТабличнойЧастиСервер.УстановитьОформлениеПартий(ЭтотОбъект);
	
	УстановитьОформлениеИнвентаризацияВыполнена();
	УстановитьОформлениеЕстьРасхождения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеИнвентаризацияВыполнена()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ДобавитьПоляВКоллекциюОформляемыхПолей(Элемент, Элементы.Товары.ПодчиненныеЭлементы);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Проведен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыИнвентаризацииТоваров.Выполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаФормы);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПоляВКоллекциюОформляемыхПолей(ЭлементУсловногоОформления, ЭлементыФормы)
	
	Для Каждого ЭлементФормы Из ЭлементыФормы Цикл
		
		Если ТипЗнч(ЭлементФормы) <> Тип("ГруппаФормы") Тогда
			ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементФормы.Имя);
		Иначе
			ПодчиненныеЭлементыГруппы = ЭлементФормы.ПодчиненныеЭлементы;
			ДобавитьПоляВКоллекциюОформляемыхПолей(ЭлементУсловногоОформления, ПодчиненныеЭлементыГруппы);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеЕстьРасхождения()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы["ТоварыКоличество"].Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ЕстьРасхождения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ПолеСОшибкойФон);
	
КонецПроцедуры

#КонецОбласти // УсловноеОформление

////////////////////////////////////////////////////////////////////////////////
// Буфер обмена товарами
#Область БуферОбменаТоварами



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
	СтруктураДействий.Вставить(Действия.Действие_ПересчитатьКоличествоЕдиниц());
	СтруктураДействий.Вставить(Действия.Действие_ЗаполнитьРасхождения());
	
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

