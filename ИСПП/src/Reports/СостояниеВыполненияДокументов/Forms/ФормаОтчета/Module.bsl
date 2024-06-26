
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ПараметрКоманды) Тогда
		ВходящиеДокументы.ЗагрузитьЗначения(Параметры.ПараметрКоманды);
	Иначе
		ВызватьИсключение НСтр("ru='Отчет не предназначен для интерактивного открытия.'");
	КонецЕсли;
	
	МетаданныеДокумента = ВходящиеДокументы[0].Значение.Метаданные();
	
	ПредставлениеОбъекта = МетаданныеДокумента.ПредставлениеОбъекта;
	Если ПустаяСтрока(ПредставлениеОбъекта) Тогда
		ПредставлениеОбъекта = МетаданныеДокумента.Представление();
	КонецЕсли;
	
	АвтоЗаголовок = Ложь;
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Состояние выполнения (%1)'"), ПредставлениеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьОтчетНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНДЫ ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьОтчетНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьОтчетНаКлиенте()
	
	Задание = СформироватьОтчетНаСервере();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТаблицаОтчета, "ФормированиеОтчета");
	
	ОбработчикРезультата = Новый ОписаниеОповещения("ОбработатьРезультатФормированияОтчета", ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, ОбработчикРезультата, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если ИдентификаторЗадания <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВходящиеДокументы", ВходящиеДокументы.ВыгрузитьЗначения());
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Формирование отчета: %1'"), Заголовок);
	
	Задание = ДлительныеОперации.ВыполнитьВФоне(
		"Отчеты.СостояниеВыполненияДокументов.СформироватьОтчетСостояниеВыполненияДокументов",
		ПараметрыОтчета,
		ПараметрыВыполнения);
	
	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	
	Возврат Задание;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатФормированияОтчета(РезультатЗадания, ДополнительныеПараметры) Экспорт
	
	Если ИдентификаторЗадания <> Неопределено Тогда
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТаблицаОтчета, "НеИспользовать");
	
	Если РезультатЗадания = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ТаблицаОтчета, "НеАктуальность");
		
	ИначеЕсли РезультатЗадания.Статус = "Выполнено" Тогда
		
		РезультатВыполнения = ПолучитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
		ТаблицаОтчета = РезультатВыполнения.ТаблицаОтчета;
		
	ИначеЕсли РезультатЗадания.Статус = "Ошибка" Тогда
		
		ПоказатьОшибкиФормирования(РезультатЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкиФормирования(РезультатЗадания)
	
	КраткоеПредставлениеОшибки = Неопределено;
	Если РезультатЗадания.Свойство("КраткоеПредставлениеОшибки", КраткоеПредставлениеОшибки)
	   И ЗначениеЗаполнено(КраткоеПредставлениеОшибки) Тогда
		
		ОтображениеСостояния = Элементы.ТаблицаОтчета.ОтображениеСостояния;
		ОтображениеСостояния.Видимость                      = Истина;
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
		ОтображениеСостояния.Картинка                       = Новый Картинка;
		ОтображениеСостояния.Текст                          = КраткоеПредставлениеОшибки;
		
	КонецЕсли;
	
	ПодробноеПредставлениеОшибки = Неопределено;
	Если РезультатЗадания.Свойство("ПодробноеПредставлениеОшибки", ПодробноеПредставлениеОшибки)
	   И ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Варианты отчетов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Отчеты.СостояниеВыполненияДокументов,
			,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при формировании: %1'"), РезультатЗадания.ПодробноеПредставлениеОшибки));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
