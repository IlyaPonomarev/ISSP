#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Заполняет служебные реквизиты статьи доходов в табличной части
//
// Параметры:
//  ТабличнаяЧасть - табличная часть в которой нужно заполнить служебные реквизиты статей доходов
//
Процедура ЗаполнитьСлужебныеРеквизиты(ТабличнаяЧасть, Реквизиты = "") Экспорт
	
	ДоходыРасходыСервер.ЗаполнитьСлужебныеРеквизитыСтатей(
		ПустаяСсылка().Метаданные(), ТабличнаяЧасть, Реквизиты, РеквизитыПоУмолчанию(), ЗначенияПоУмолчанию());
	
КонецПроцедуры

// Заполняет служебные реквизиты статьи доходов в строке табличной части
//
// Параметры:
//  ТекущаяСтрока - 
//
Процедура ЗаполнитьСлужебныеРеквизитыВСтроке(ТекущаяСтрока, КэшированныеЗначения, Реквизиты = "") Экспорт
	
	ДоходыРасходыСервер.ЗаполнитьСлужебныеРеквизитыВСтроке(
		ТекущаяСтрока, КэшированныеЗначения, Реквизиты, РеквизитыПоУмолчанию(), ЗначенияПоУмолчанию());
	
КонецПроцедуры

// Обрабатывает изменение статьи доходов
//
// Параметры:
//  Объект - 
//  ТекущаяСтрока - 
//
Процедура ОбработатьИзменениеСтатьиДоходов(Объект, ТекущаяСтрока, Реквизиты = "") Экспорт
	
	ДоходыРасходыСервер.ОбработатьИзменениеСтатьи(Объект, ТекущаяСтрока, Реквизиты, РеквизитыПоУмолчанию());
	
КонецПроцедуры

// Производит заполнение условного оформления формы
//
// Параметры:
//  Форма - УправляемаяФорма - формы объекта
//  Реквизиты - Строка, Структура, Массив - Реквизиты статей Доходов и их аналитик для оформления
//              <Строка> Перечисление пар реквизитов в формате "СтатьяДоходов1, АналитикаДоходов1, СтатьяДоходов2, АналитикаДоходов2, ..."
//                       Пустая строка трактуется как "СтатьяДоходов, АналитикаДоходов"
//              <Структура> Ключ: Строка с именем табличной части; Значение - Строка в нотации как у параметра типа <Строка>
//              <Массив> Массив, элементы которого либо структуры в нотации как у параметра с типа <Структура>, либо строки в нотации <Строка>
//
Процедура УстановитьУсловноеОформлениеАналитик(Форма, Реквизиты = "") Экспорт
	
	ДоходыРасходыСервер.УстановитьУсловноеОформлениеАналитик(Форма, Реквизиты, РеквизитыПоУмолчанию(), НСтр("ru = 'Не указана статья доходов'"));
	
КонецПроцедуры

// Производит проверку заполнения реквизитов аналитик статей доходов в переданном объекте
//
// Параметры:
//  Объект - СправочникОбъект, ДокументОбъект, ДанныеФормыСтруктура - Объект ИБ предназначенный для проверки
//  Реквизиты - Строка, Структура, Массив - Реквизиты статей доходов для проверки
//      <Строка> Перечисление пар реквизитов для проверки в формате "СтатьяДоходов1, АналитикаДоходов1, СтатьяДоходов2, АналитикаДоходов2, ..."
//               Пустая строка трактуется как "СтатьяДоходов, АналитикаДоходов"
//      <Структура> Ключ: Строка с именем табличной части; Значение - Строка в нотации как у параметра типа <Строка>
//      <Массив> Массив, элементы которого либо структуры в нотации как у параметра с типа <Структура>, либо строки в нотации <Строка>
//  НепроверяемыеРеквизиты - Массив - Массив для накопления не проверяемых реквизитов переданного объекта
//  Отказ - Булево - Признак наличия ошибок заполнения аналитик доходов переданного объекта
//  ДополнительныеПараметры - Структура - При наличии свойства "ПрограммнаяПроверка", ошибки записываются в эту структуру, пользователю не выводятся
//
Процедура ПроверитьЗаполнениеАналитик(Объект, Реквизиты = "", НепроверяемыеРеквизиты = Неопределено, Отказ = Ложь, ДополнительныеПараметры = Неопределено) Экспорт
	
	ДоходыРасходыСервер.ПроверитьЗаполнениеАналитик(
		Объект, РеквизитыПоУмолчанию(), НСтр("ru='Не заполнена аналитика доходов'"), Реквизиты, НепроверяемыеРеквизиты, Отказ, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция РеквизитыПоУмолчанию()
	
	Возврат "СтатьяДоходов, АналитикаДоходов";
	
КонецФункции

Функция ЗначенияПоУмолчанию()
	
	ЗначенияПоУмолчанию = Новый Структура;
	ЗначенияПоУмолчанию.Вставить("КонтролироватьЗаполнениеАналитики", Ложь);
	
	Возврат ЗначенияПоУмолчанию;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы
#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьПредопределенныеСтатьиДоходов() Экспорт
	
	СтатьяДоходов = ПланыВидовХарактеристик.СтатьиДоходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров.ПолучитьОбъект();
	СтатьяДоходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СтатьяДоходов);
	
КонецПроцедуры

#КонецОбласти // ОбновлениеИнформационнойБазы

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ТипАналитики; ТипАналитики");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти // СтандартныеПодсистемы

#КонецЕсли