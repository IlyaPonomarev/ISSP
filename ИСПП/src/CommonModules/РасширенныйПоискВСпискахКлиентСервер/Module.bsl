
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Снимает отбор в списке механизма расширенного поиска.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, где снимается отбор по строке поиска.
//
Процедура СнятьОтборПоСтрокеПоиска(Форма) Экспорт
	
	Форма[Префикс() + "ПоискНеУдачный"] = Ложь;
	Форма[Префикс() + "КодОшибкиПоиска"] = "";
	Форма[Префикс() + "СтрокаПоиска"] = "";
	
	УстановитьОтборСпискаПоСтрокеПоиска(Форма,, Ложь);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

// Добавляет или заменяет существующий элемент отбора динамического списка.
//
// Параметры:
//  Форма               - УправляемаяФорма - форма, где устанавливается отбор.
//  ЗначениеОтбора      - значение отбора.
//  ИспользованиеОтбора - Булево - признак использования отбора.
//
Процедура УстановитьОтборСпискаПоСтрокеПоиска(Форма, ЗначениеОтбора, ИспользованиеОтбора) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ФильтруемыйСписок(Форма),
		Форма[Префикс() + "ИмяФильтруемогоРеквизита"],
		ЗначениеОтбора,
		ВидСравненияКомпоновкиДанных.ВСписке,
		Префикс() + "ПоискПоПодстроке",
		ИспользованиеОтбора);
	
КонецПроцедуры

// Возвращает список на форме, где происходит поиск элемента.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, где выполняется поиск.
//
// Возвращаемое значение:
//  ДинамическийСписок - список в котором происходит расширенный поиск.
//
Функция ФильтруемыйСписок(Форма) Экспорт
	
	Возврат Форма[ИмяФильтруемогоСписка(Форма)];
	
КонецФункции

// Возвращает элемент формы, где будет выведен результат поиска.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, где выполняется расширенный поиск.
//
// Возвращаемое значение:
//  ТаблицаФормы - элемент формы, в котором будет выведен результат поиска.
//
Функция ФильтруемыйСписокЭлементФормы(Форма) Экспорт
	
	Возврат Форма.Элементы[ИмяФильтруемогоСписка(Форма) + "РасширенныйПоиск"];
	
КонецФункции

// Возвращает строку, по которой выполняется поиск.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, где выполняется расширенный поиск.
//
// Возвращаемое значение:
//  Строка - строка поиска в списке.
//
Функция СтрокаПоиска(Форма) Экспорт
	
	Возврат Форма[ИмяСтрокиПоиска(Форма)];
	
КонецФункции

// Возвращает элемент формы, в котором находится искомое значение.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, где выполняется расширенный поиск.
//
// Возвращаемое значение:
//  ПолеФормы - элемент формы, в котором находится искомое значение.
//
Функция СтрокаПоискаЭлементФормы(Форма) Экспорт
	
	Возврат Форма.Элементы[ИмяСтрокиПоиска(Форма)];
	
КонецФункции

// Возвращает ключ настроек, используемый при сохранении и получении настроек из хранилища настроек.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, для которой получается ключ настроек.
//
// Возвращаемое значение:
//  Строка - ключ настроек.
//
Функция КлючНастройки(Форма) Экспорт
	
	Префикс = Префикс();
	ТипРеквизитаПоиска = Форма[Префикс + "ТипФильтруемогоРеквизита"];
	Возврат Префикс + "ИсторияПоиска" + СтрЗаменить(ТРег(ТипРеквизитаПоиска), " ", "")
	
КонецФункции

// Возвращает префикс имени элементов формы механизма расширенного поиска в списках.
//
// Возвращаемое значение:
//  Строка - префикс имени элементов формы расширенного поиска в списках.
//
Функция Префикс() Экспорт
	
	Возврат "РасширенныйПоискВСписках";
	
КонецФункции

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ИмяФильтруемогоСписка(Форма)
	
	Возврат Форма[Префикс() + "ИмяФильтруемогоСписка"];
	
КонецФункции

Функция ИмяСтрокиПоиска(Форма)
	
	Возврат Префикс() + "СтрокаПоиска";
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
