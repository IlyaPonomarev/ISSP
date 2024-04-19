#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Механизм расширенных ключей аналитики

// Формирует наименование ключа аналитики
//
// Параметры:
//  ПараметрыАналитики - значения полей создаваемого ключа аналитики
//
Функция ПолучитьНаименованиеКлючаАналитики(ПараметрыАналитики) Экспорт
	
	Возврат СокрЛП(ПараметрыАналитики.Номенклатура)
		+ ?(ЗначениеЗаполнено(ПараметрыАналитики.СерияНоменклатуры), "; " + СокрЛП(ПараметрыАналитики.СерияНоменклатуры), "")
		+ ?(ЗначениеЗаполнено(ПараметрыАналитики.Партия), "; "+ СокрЛП(ПараметрыАналитики.Партия), "");
	
КонецФункции

// Заполняет наименование ключа аналитики
//
// Параметры:
//  КлючАналитики      - ссылка ключа аналитики, у которого заполняется наименование
//  ПараметрыАналитики - значения полей создаваемого ключа аналитики
//
Процедура ЗаполнитьНаименованиеКлючаАналитики(КлючАналитики, ПараметрыАналитики) Экспорт
	
	КлючАналитики.Наименование = ПолучитьНаименованиеКлючаАналитики(ПараметрыАналитики);
	
КонецПроцедуры

// Возвращает существующий или новый ключ аналитики
//
// Параметры:
//  ПараметрыАналитики - значения полей создаваемого ключа аналитики
//
Функция ЗначениеКлючаАналитики(ПараметрыАналитики) Экспорт
	
	Возврат РасширеннаяАналитикаУчета.ЗначениеКлючаАналитики(Справочники.КлючиАналитикиУчетаНоменклатуры, ПараметрыАналитики);
	
КонецФункции

// Возвращает новый ключ аналитики
//
// Параметры:
//  ПараметрыАналитики - значения полей создаваемого ключа аналитики
//
Функция СоздатьКлючАналитики(ПараметрыАналитики) Экспорт
	
	Возврат РасширеннаяАналитикаУчета.СоздатьКлючАналитики(Справочники.КлючиАналитикиУчетаНоменклатуры, ПараметрыАналитики);
	
КонецФункции

// Заполняет дополнительные поля ключа аналитики при необходимости
//
// Параметры:
//  КлючАналитики      - ссылка ключа аналитики, у которого заполняются дополнительные поля
//  ПараметрыАналитики - значения полей создаваемого ключа аналитики
//
Процедура ЗаполнитьДополнительныеПоляКлючаАналитики(КлючАналитики, ПараметрыАналитики) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Проверяет наличие необходимых ключей аналитики и если не находит их, то создает новые
//
// Параметры:
//  МенеджерВременныхТаблиц - должен содержать временную таблицу "втТаблицаАналитики" со
//                            значениями полей аналитики.
Процедура ИнициализироватьКлючиАналитики(МенеджерВременныхТаблиц) Экспорт
	
	РасширеннаяАналитикаУчета.ИнициализироватьКлючиАналитики(Справочники.КлючиАналитикиУчетаНоменклатуры, МенеджерВременныхТаблиц);
	
КонецПроцедуры

// Возвращает массив имен полей соответствующие ключу аналитики
//
Функция ИменаПолейАналитики() Экспорт
	
	Возврат ОбщегоНазначенияПоддержкаПроектов.ИменаИзмеренийРегистраСведений(ИмяРегистраАналитики());
	
КонецФункции

// Возвращает имя регистра сведений ключа аналитики
//
Функция ИмяРегистраАналитики() Экспорт
	
	Возврат "АналитикаУчетаНоменклатуры";
	
КонецФункции

// Устанавливает пометку удаления у ключей, соответствующих отбору
//
Процедура УстановитьПометкуУдаления(Отбор, ПометкаУдаления) Экспорт
	
	РасширеннаяАналитикаУчета.УстановитьПометкуУдаленияКлючейАналитики(Справочники.КлючиАналитикиУчетаНоменклатуры, Отбор, ПометкаУдаления);
	
КонецПроцедуры

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#КонецЕсли