
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Устанавливает отбор по реквизиту примитивного типа при выборе элемента фильтра.
//
// Параметры:
//  Форма                - УправляемаяФорма - форма, где устанавливается фильтр.
//  Элемент              - ТаблицаФормы - элемент формы - фильтр.
//  ВыбраннаяСтрока      - Число - строка таблицы, данные которой необходимо получить.
//  Поле                 - ПолеФормы - поле отображения представления фильтра по свойствам номенклатуры.
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ФильтрПоСвойствамВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	Если Не ФильтрыСписковКлиентСервер.ИспользоватьФильтры(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Префикс = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.Идентификатор();
	ТекущиеДанные = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	Если Не ТекущиеДанные.ОтборДоступен Тогда
		
		ТекущаяСтрока   = Элемент.ТекущаяСтрока;
		Если Поле = Форма.Элементы[Префикс + "ФильтрПоСвойствамПредставление"] Тогда
			Если Элемент.Развернут(ТекущаяСтрока) Тогда
				Элемент.Свернуть(ТекущаяСтрока);
			Иначе
				Элемент.Развернуть(ТекущаяСтрока);
			КонецЕсли;
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ФиксированноеЗначение
	   //И Поле = Форма.Элементы[Префикс + "ФильтрПоСвойствамПредставлениеОтбора"]
	   И Не ТекущиеДанные.ТипРеквизита.СодержитТип(Тип("Булево")) Тогда
		СтандартнаяОбработка = Ложь;
		УстановитьФиксированныйОтбор(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает изменение настроек фильтра по свойствам номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, где изменяются настройки.
//
Процедура ФильтрПоСвойствамОтборПриИзменении(Форма) Экспорт
	
	УстанавливатьОтборСписка = Истина;
	
	Префикс = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.Идентификатор();
	ТекущиеДанные = Форма.Элементы[Префикс + "ФильтрПоСвойствам"].ТекущиеДанные;
	Если ТекущиеДанные.ФиксированноеЗначение Тогда
		Если ТекущиеДанные.Отбор Тогда
			Если ТекущиеДанные.ТипРеквизита.СодержитТип(Тип("Строка")) И Не ЗначениеЗаполнено(ТекущиеДанные.ЗначениеОтбора) Тогда
				УстановитьФиксированныйОтбор(Форма);
				УстанавливатьОтборСписка = Ложь;
			ИначеЕсли (ТекущиеДанные.ТипРеквизита.СодержитТип(Тип("Число")) Или ТекущиеДанные.ТипРеквизита.СодержитТип(Тип("Дата")))
					И Не (ЗначениеЗаполнено(ТекущиеДанные.ИнтервалОт) Или ЗначениеЗаполнено(ТекущиеДанные.ИнтервалДо)) Тогда
				УстановитьФиксированныйОтбор(Форма);
				УстанавливатьОтборСписка = Ложь;
			ИначеЕсли ТипЗнч(ТекущиеДанные.ЗначениеОтбора) = Тип("СписокЗначений") И ТекущиеДанные.ЗначениеОтбора.Количество() = 0 Тогда
				УстановитьФиксированныйОтбор(Форма);
				УстанавливатьОтборСписка = Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Родитель = ТекущиеДанные.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			
			// Установить/снять значение флажка отбора для всех подчиненных строк.
			ПодчиненныеЭлементыДерева = ТекущиеДанные.ПолучитьЭлементы();
			Для Каждого ЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
				ЭлементДерева.Отбор = ТекущиеДанные.Отбор;
			КонецЦикла;
			
		Иначе
			// Выбрана подчиненная строка.
			Родитель.Отбор = Ложь;
			
			ПодчиненныеЭлементыДерева = Родитель.ПолучитьЭлементы();
			Для Каждого ЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
				Если ЭлементДерева.Отбор Тогда
					Родитель.Отбор = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	Если УстанавливатьОтборСписка Тогда
		ОбработатьИзменениеФильтра(Форма);
		Форма.ФильтрНоменклатурыПоВидуИСвойствам_ФильтрПоСвойствамПриИзмененииОтбора();
	КонецЕсли;
	
КонецПроцедуры

// Инвертирует флаг ПоказыватьВидыНоменклатуры и настраивает форму в соответствии со значением данного флага.
//
// Параметры:
//  Форма - УправляемаяФорма
//
Процедура ПоказатьСкрытьВидыНоменклатуры(Форма) Экспорт
	
	Префикс = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.Идентификатор();
	Форма[Префикс + "ПоказыватьВидыНоменклатуры"] = Не Форма.Элементы[Префикс + "ВидыНоменклатуры"].Видимость;
	ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.ПоказатьСкрытьВидыНоменклатуры(Форма);
	
КонецПроцедуры

// Обрабатывает активацию строки списка видов номенклатуры
//
// Параметры:
//  Форма - УправляемаяФорма
//
Процедура ПриАктивизацииСтрокиВидаНоменклатуры(Форма) Экспорт
	
	Префикс = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.Идентификатор();
	ТекущиеДанные = Форма.Элементы[Префикс + "ВидыНоменклатуры"].ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
	 Или ТекущиеДанные.ЭтоГруппа
	 Или ТекущиеДанные.Ссылка = Форма[Префикс + "ВидНоменклатуры"] Тогда
		Возврат;
	КонецЕсли;
	
	Форма[Префикс + "ВидНоменклатуры"] = ТекущиеДанные.Ссылка;
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ФильтрНоменклатурыПоИерархии_ОбработатьАктивациюСтрокиВидаНоменклатуры", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Процедура УстановитьФиксированныйОтбор(Форма)
	
	Префикс = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.Идентификатор();
	ТекущиеДанные = Форма.Элементы[Префикс + "ФильтрПоСвойствам"].ТекущиеДанные;
	Если Не ТекущиеДанные.ФиксированноеЗначение Тогда
		Возврат;
	КонецЕсли;
	
	ВидНоменклатуры = Форма[Префикс + "ВидНоменклатуры"];
	Оповещение = Новый ОписаниеОповещения("УстановитьФиксированныйОтборЗавершение", ЭтотОбъект, Форма);
	
	Если ТекущиеДанные.ТипРеквизита.СодержитТип(Тип("Строка")) Тогда
		
		ЗначениеОтбора  = СокрЛП(ТекущиеДанные.ЗначениеОтбора);
		СписокВыбора = ФильтрНоменклатурыПоВидуИСвойствамВызовСервера.СформироватьСписокВыбораСтроковыхЗначений(
			ВидНоменклатуры,
			ТекущиеДанные.ИмяРеквизита,
			ТекущиеДанные.ЭтоДопРеквизит);
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИмяРеквизита", ТекущиеДанные.Представление);
		Параметры.Вставить("Значение"    , Новый Структура("Строка, СписокВыбора", ЗначениеОтбора, СписокВыбора));
		Параметры.Вставить("ТипЗначения" , ТекущиеДанные.ТипРеквизита);
		
		ОткрытьФорму("ОбщаяФорма.УстановкаЗначенийПримитивногоТипа", Параметры, Форма,,,, Оповещение);
		
	ИначеЕсли ТипЗнч(ТекущиеДанные.ЗначениеОтбора) = Тип("СписокЗначений") Тогда
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИмяРеквизита"  , ТекущиеДанные.Представление);
		Параметры.Вставить("Значение"      , ТекущиеДанные.ЗначениеОтбора);
		Параметры.Вставить("ТипЗначения"   , ТекущиеДанные.ТипРеквизита);
		Параметры.Вставить("ЭтоДопРеквизит", ТекущиеДанные.ЭтоДопРеквизит);
		Параметры.Вставить("Свойство"      , ТекущиеДанные.Свойство);
		
		ОткрытьФорму("ОбщаяФорма.УстановкаЗначенийПримитивногоТипа", Параметры, Форма,,,, Оповещение);
		
	Иначе
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИмяРеквизита", ТекущиеДанные.Представление);
		Параметры.Вставить("Значение"    , Новый Структура("ИнтервалОт, ИнтервалДо, Формат", ТекущиеДанные.ИнтервалОт, ТекущиеДанные.ИнтервалДо, ТекущиеДанные.ФорматРеквизита));
		Параметры.Вставить("ТипЗначения" , ТекущиеДанные.ТипРеквизита);
		
		ОткрытьФорму("ОбщаяФорма.УстановкаЗначенийПримитивногоТипа", Параметры, Форма,,,, Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьФиксированныйОтборЗавершение(ЗначениеВыбора, Форма) Экспорт
	
	УстанавливатьОтборСписка = Ложь;
	
	Если ЗначениеВыбора <> Неопределено Тогда
		
		Префикс = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.Идентификатор();
		ТекущиеДанные = Форма.Элементы[Префикс + "ФильтрПоСвойствам"].ТекущиеДанные;
		
		Если ТекущиеДанные.ТипРеквизита.СодержитТип(Тип("Строка")) Тогда
			
			ЗначениеОтбора = ЗначениеВыбора.ЗначениеОтбора;
			Если ТекущиеДанные.ЗначениеОтбора <> ЗначениеОтбора Тогда
				ТекущиеДанные.ЗначениеОтбора = ЗначениеОтбора;
				ТекущиеДанные.ПредставлениеОтбора = ?(ЗначениеЗаполнено(ЗначениеОтбора), ЗначениеОтбора, НСтр("ru = '<не задано>'"));
				УстанавливатьОтборСписка = Истина;
			КонецЕсли;
			
			ТекущиеДанные.Отбор = ЗначениеЗаполнено(ЗначениеОтбора);
			
		ИначеЕсли ТипЗнч(ТекущиеДанные.ЗначениеОтбора) = Тип("СписокЗначений") Тогда
			
			ЗначениеОтбора = ЗначениеВыбора.ЗначениеОтбора;
			
			ТекущиеДанные.Отбор               = ЗначениеЗаполнено(ЗначениеОтбора);
			ТекущиеДанные.ЗначениеОтбора      = ЗначениеОтбора;
			ТекущиеДанные.ПредставлениеОтбора = ?(ЗначениеЗаполнено(ЗначениеОтбора), ЗначениеОтбора, НСтр("ru = '<не задано>'"));
			
			УстанавливатьОтборСписка = Истина;
			
		Иначе
			
			Если ЗначениеВыбора.ИнтервалОт <> ТекущиеДанные.ИнтервалОт
			 Или ЗначениеВыбора.ИнтервалДо <> ТекущиеДанные.ИнтервалДо Тогда
				
				ТекущиеДанные.ИнтервалОт = ЗначениеВыбора.ИнтервалОт;
				ТекущиеДанные.ИнтервалДо = ЗначениеВыбора.ИнтервалДо;
				ТекущиеДанные.ПредставлениеОтбора = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.ПредставлениеИнтервалаОтбора(
					ТекущиеДанные.ИнтервалОт, ТекущиеДанные.ИнтервалДо, ТекущиеДанные.ФорматРеквизита);
				УстанавливатьОтборСписка = Истина;
				
			КонецЕсли;
			
			ТекущиеДанные.Отбор = ЗначениеЗаполнено(ЗначениеВыбора.ИнтервалОт) Или ЗначениеЗаполнено(ЗначениеВыбора.ИнтервалДо);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если УстанавливатьОтборСписка Тогда
		ОбработатьИзменениеФильтра(Форма);
		Форма.ФильтрНоменклатурыПоВидуИСвойствам_ФильтрПоСвойствамПриИзмененииОтбора();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьИзменениеФильтра(Форма)
	
	Префикс = ФильтрНоменклатурыПоВидуИСвойствамКлиентСервер.Идентификатор();
	ТекущиеДанные = Форма.Элементы[Префикс + "ФильтрПоСвойствам"].ТекущиеДанные;
	УстановленныеОтборы = Форма[Префикс + "УстановленныеОтборы"];
	
	Если ТекущиеДанные.ФиксированноеЗначение Тогда
		
		ОтобранныеСтроки = УстановленныеОтборы.НайтиСтроки(Новый Структура("ИмяРеквизита", ТекущиеДанные.ИмяРеквизита));
		Если ТекущиеДанные.Отбор Тогда
			
			Если ОтобранныеСтроки.Количество() > 0 Тогда
				ЗаполнитьЗначенияСвойств(ОтобранныеСтроки[0], ТекущиеДанные);
			Иначе
				ЗаполнитьЗначенияСвойств(УстановленныеОтборы.Добавить(), ТекущиеДанные);
			КонецЕсли;
			
		Иначе
			
			Для Каждого СтрокаДляУдаления Из ОтобранныеСтроки Цикл
				УстановленныеОтборы.Удалить(СтрокаДляУдаления);
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		Родитель = ТекущиеДанные.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда // выбрана строка-родитель
			
			ПодчиненныеЭлементыДерева = ТекущиеДанные.ПолучитьЭлементы();
			
			Если ТекущиеДанные.Отбор Тогда
				Для Каждого ЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
					ЗаполнитьЗначенияСвойств(УстановленныеОтборы.Добавить(), ЭлементДерева);
				КонецЦикла;
			Иначе
				ОтобранныеСтроки = УстановленныеОтборы.НайтиСтроки(Новый Структура("ИмяРеквизита", ТекущиеДанные.ИмяРеквизита));
				Для Каждого СтрокаДляУдаления Из ОтобранныеСтроки Цикл
					УстановленныеОтборы.Удалить(СтрокаДляУдаления);
				КонецЦикла;
			КонецЕсли;
			
		Иначе
			
			Если ТекущиеДанные.Отбор Тогда
				НоваяСтрока = УстановленныеОтборы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекущиеДанные);
			Иначе
				Отбор = Новый Структура();
				Отбор.Вставить("ИмяРеквизита"  ,ТекущиеДанные.ИмяРеквизита);
				Отбор.Вставить("ЗначениеОтбора",ТекущиеДанные.ЗначениеОтбора);
				ОтобранныеСтроки = УстановленныеОтборы.НайтиСтроки(Отбор);
				Для Каждого СтрокаДляУдаления Из ОтобранныеСтроки Цикл
					УстановленныеОтборы.Удалить(СтрокаДляУдаления);
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
