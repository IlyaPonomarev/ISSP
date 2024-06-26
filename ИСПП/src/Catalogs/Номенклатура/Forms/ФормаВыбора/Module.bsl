
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.ПрефиксГрупп = "СтандартныйПоиск";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельСписокТоваровСтандартныйПоиск;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.ПрефиксГрупп = "РасширенныйПоиск";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельСписокТоваровРасширенныйПоиск;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрыФормы = Новый ФиксированнаяСтруктура;
	
	КодФормы = "Справочник_Номенклатура_ФормаВыбора";
	ПодборТоваровСервер.ПриСозданииФормыСпискаНаСервере(ЭтотОбъект);
	
	Параметры.Свойство("ТекущаяСтрока", НоменклатураЭлементПриОткрытии);
	Если ЗначениеЗаполнено(НоменклатураЭлементПриОткрытии) Тогда
		Если ФильтрыСписковКлиентСервер.ИспользоватьФильтры(ЭтотОбъект) Тогда
			Если ФильтрыСписковКлиентСервер.ТекущийФильтр(ЭтотОбъект) = ФильтрНоменклатурыПоИерархииКлиентСервер.Идентификатор() Тогда
				НоменклатураРодительПриОткрытии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоменклатураЭлементПриОткрытии, "Родитель");
			Иначе
				ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтотОбъект, НоменклатураЭлементПриОткрытии);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ФильтрыСписковКлиентСервер.ИспользоватьФильтры(ЭтотОбъект) Тогда
		Если ФильтрыСписковКлиентСервер.ТекущийФильтр(ЭтотОбъект) = ФильтрНоменклатурыПоИерархииКлиентСервер.Идентификатор() Тогда
			ФильтрНоменклатурыПоИерархииКлиентСервер.ИерархияНоменклатуры(ЭтотОбъект).ТекущаяСтрока = НоменклатураРодительПриОткрытии;
			ФильтрНоменклатурыПоИерархииКлиент.ПриАктивизацииСтрокиИерархииНоменклатуры(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока = НоменклатураЭлементПриОткрытии;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВведенШтрихкод" И Источник = УникальныйИдентификатор Тогда
		ОбработатьШтрихкоды(ОбщегоНазначенияПоддержкаПроектовКлиентСервер.ПолучитьДанныеШтрихкода(Параметр, 1));
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Номенклатура" Тогда
		Если ЗначениеЗаполнено(Источник) Тогда
			ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока = Источник;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройкиФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьЗначениеНоменклатуры(Команда)
	
	ТекущаяСтрока = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ОповеститьОВыборе(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПоиск(Команда)
	
	ПодборТоваровКлиент.НастроитьПоиск(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить()
	
	ОчиститьСообщения();
	ОбработкаТабличнойЧастиКлиент.ПоказатьВводШтрихкода(УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// ФильтрНоменклатурыПоИерархии
	ФильтрНоменклатурыПоИерархииКлиент.ПриАктивизацииСтрокиСпискаНоменклатуры(ЭтотОбъект);
	// Конец ФильтрНоменклатурыПоИерархии
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОповеститьОВыборе(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкода)
	
	Штрихкод = ДанныеШтрихкода.Штрихкод;
	
	Номенклатура = ПолучитьНоменклатуруПоШтрихкоду(ДанныеШтрихкода);
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		ФильтрыСписковКлиентСервер.ФильтруемыйСписокЭлементФормы(ЭтотОбъект).ТекущаяСтрока = Номенклатура;
		ПоказатьЗначение(, Номенклатура);
	Иначе
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Номенклатура со штрихкодом %1 не найдена'"), Штрихкод);
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНоменклатуруПоШтрихкоду(ДанныеШтрихкода)
	
	Штрихкод = ДанныеШтрихкода.Штрихкод;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Штрихкод = &Штрихкод";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Номенклатура;
	КонецЕсли;
	
	Возврат Справочники.Номенклатура.ПустаяСсылка();
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ПодборТоваровСервер.СохранитьНастройкиФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Расширенный поиск в списке номенклатуры
#Область СтрокаПоиска

&НаКлиенте
Процедура Подключаемый_РасширенныйПоискВСписках_СтрокаПоискаПриИзменении(Элемент)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РасширенныйПоискВСписках_СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РасширенныйПоискВСпискахКлиентСервер.СнятьОтборПоСтрокеПоиска(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РасширенныйПоискВСписках_НайтиПоТочномуСоответствиюПриИзменении(Элемент)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	ВыполнитьПоискНаСервере();
	
	РасширенныйПоискВСпискахКлиент.ПослеВыполненияПоиска(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНаСервере()
	
	РасширенныйПоискВСписках.ВыполнитьПоиск(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // СтрокаПоиска

////////////////////////////////////////////////////////////////////////////////
// Фильтры списка номенклатуры
#Область ФильтрыСписков

&НаКлиенте
Процедура Подключаемый_ПодборТоваров_ОтфильтроватьПоАналогичнымСвойствам(Команда)
	
	ТекущаяСтрока = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект).ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОтфильтроватьПоАналогичнымСвойствам(ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ОтфильтроватьПоАналогичнымСвойствам(Знач Номенклатура)
	
	ПодборТоваровСервер.ОтфильтроватьПоАналогичнымСвойствам(ЭтотОбъект, Номенклатура);
	ФильтрыСписковКлиентСервер.ФильтруемыйСписокЭлементФормы(ЭтотОбъект).ТекущаяСтрока = Номенклатура;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрыСписков_ИспользоватьФильтрыПриИзменении(Элемент)
	
	ФильтрыСписков_ИспользоватьФильтрыПриИзменении();
	
КонецПроцедуры

&НаСервере
Процедура ФильтрыСписков_ИспользоватьФильтрыПриИзменении()
	
	ФильтрыСписков.ИспользоватьФильтрыПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрыСписков_ВариантФильтраПриИзменении(Элемент)
	
	Если ФильтрыСписковКлиент.НуженСерверныйВызовПриИзмененииВариантаФильтра(ЭтотОбъект) Тогда
		ФильтрыСписков_ВариантФильтраПриИзменении();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ФильтрыСписков_ВариантФильтраПриИзменении()
	
	ФильтрыСписков.ВариантФильтраПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрыСписков_ВариантФильтраОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Фильтр номенклатуры по иерархии
#Область ИерархияНоменклатуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_СоздатьГруппуНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.СоздатьГруппуНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ИзменитьГруппуНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.ИзменитьГруппуНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_СкопироватьГруппуНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.СкопироватьГруппуНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_УстановитьПометкуУдаленияГруппыНоменклатуры(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.УстановитьПометкуУдаленияГруппыНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ИзменитьВыделенныеГруппы(Команда)
	
	ФильтрНоменклатурыПоИерархииКлиент.ИзменитьВыделенныеГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_УстановитьТекущуюСтрокуИерархииНоменклатуры()
	
	ФильтрНоменклатурыПоИерархииКлиент.УстановитьТекущуюСтрокуИерархииНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ИерархияНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ФильтрНоменклатурыПоИерархииКлиент.ПриАктивизацииСтрокиИерархииНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФильтрНоменклатурыПоИерархии_ОбработатьАктивациюСтрокиИерархииНоменклатуры()
	
	ФильтрНоменклатурыПоИерархииКлиент.ОбработатьАктивациюСтрокиИерархииНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ИерархияНоменклатуры

&НаКлиенте
Процедура Подключаемый_ПанельОтборов_СвернутьРазвернутьОтбор(Элемент)
	
	ПанельОтборовКлиентСервер.СкрытьПоказатьПанельОтборов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ФильтрыСписков

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Список = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект);
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	Список = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект);
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Список = ПодборТоваровКлиентСервер.ТекущийСписокТоваров(ЭтотОбъект);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти // СтандартныеПодсистемы
