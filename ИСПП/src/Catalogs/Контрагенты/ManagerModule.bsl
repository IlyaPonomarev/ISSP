
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		Если Параметры.Свойство("Ключ") И Параметры.Ключ = Справочники.Контрагенты.ДляПереходаНаДоговорыБезВладельца Тогда
			ВызватьИсключение НСтр("ru = 'Редактирование предопределенного элемента запрещено.'");
		КонецЕсли;
	ИначеЕсли ВидФормы = "ФормаСписка" Или ВидФормы = "ФормаВыбора" Тогда
		СтандартнаяОбработка = Ложь;
		Если Не Параметры.Свойство("Отбор") Тогда
			Параметры.Вставить("Отбор", Новый Структура);
		КонецЕсли;
		Параметры.Отбор.Вставить("Предопределенный", Ложь);
		ВыбраннаяФорма = ВидФормы;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Параметры.Отбор.Вставить("Предопределенный", Ложь);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Функция определяет значения реквизитов выбранного контрагента.
//
// Параметры:
//  Контрагент - СправочникСсылка.Контрагенты - Ссылка на контрагента
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного контрагента
//
Функция ПолучитьРеквизитыКонтрагента(Контрагент) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Контрагенты.Наименование        КАК Наименование,
	|	Контрагенты.НаименованиеПолное  КАК НаименованиеПолное,
	|	Контрагенты.ИНН                 КАК ИНН,
	|	Контрагенты.КПП                 КАК КПП,
	|	Контрагенты.КодПоОКПО           КАК КодПоОКПО,
	|	Контрагенты.ЮрФизЛицо           КАК ЮрФизЛицо
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &Контрагент
	|");
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Представление = ?(Не ПустаяСтрока(Выборка.НаименованиеПолное), Выборка.НаименованиеПолное, Выборка.Наименование);
		Наименование  = ?(Не ПустаяСтрока(Выборка.НаименованиеПолное), Выборка.НаименованиеПолное, Выборка.Наименование);
		ИНН           = Выборка.ИНН;
		КПП           = Выборка.КПП;
		КодПоОКПО     = Выборка.КодПоОКПО;
		ЮрФизЛицо     = Выборка.ЮрФизЛицо;
	Иначе
		Представление = "";
		Наименование  = "";
		ИНН           = "";
		КПП           = "";
		КодПоОКПО     = "";
		ЮрФизЛицо     = Перечисления.ЮрФизЛицо.ПустаяСсылка();
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Представление", Представление);
	СтруктураРеквизитов.Вставить("Наименование" , Наименование);
	СтруктураРеквизитов.Вставить("ИНН"          , ИНН);
	СтруктураРеквизитов.Вставить("КПП"          , КПП);
	СтруктураРеквизитов.Вставить("КодПоОКПО"    , КодПоОКПО);
	СтруктураРеквизитов.Вставить("ЮрФизЛицо"    , ЮрФизЛицо);
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Определяет доступен ли для пользователя упрощенный ввод контрагентов.
//
// Возвращаемое значение:
//   Булево   - Истина, если упрощенный ввод доступен, и ложь в обратном случае.
//
Функция УпрощенныйВводДоступен() Экспорт
	
	Возврат Пользователи.РолиДоступны("ВводИнформацииПоКонтрагентуБезКонтроля",, Ложь);
	
КонецФункции

// Определяет, есть ли в базе контрагент с таким же набором ИНН/КПП.
//
Функция ИННКППУжеИспользуетсяВИнформационнойБазе(ИНН, КПП, ИсключаяСсылку = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ИНН = &ИНН
	|	И Контрагенты.КПП = &КПП
	|	И Контрагенты.Ссылка <> &Ссылка
	|";
	
	Запрос.УстановитьПараметр("ИНН"   , ИНН);
	Запрос.УстановитьПараметр("КПП"   , КПП);
	Запрос.УстановитьПараметр("Ссылка", ИсключаяСсылку);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Контрагент;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Определяет, есть ли в базе контрагент с таким же набором РегистрационныйНомер/СтранаРегистрации
//
Функция СтранаРегистрационныйНомерУжеИспользуетсяВИнформационнойБазе(РегистрационныйНомер, СтранаРегистрации, ИсключаяСсылку = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.РегистрационныйНомер = &РегистрационныйНомер
	|	И Контрагенты.СтранаРегистрации = &СтранаРегистрации
	|	И Контрагенты.Ссылка <> &Ссылка
	|";
	
	Запрос.УстановитьПараметр("РегистрационныйНомер", РегистрационныйНомер);
	Запрос.УстановитьПараметр("СтранаРегистрации"   , СтранаРегистрации);
	Запрос.УстановитьПараметр("Ссылка"              , ИсключаяСсылку);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Контрагент;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Печать
#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	УправлениеПечатьюПоддержкаПроектов.ДобавитьКомандыПечати(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыПечати);
	
КонецПроцедуры

// Возвращает список доступных печатных форм документа
//
Функция ДоступныеПечатныеФормы() Экспорт
	
	ПечатныеФормы = УправлениеПечатьюПоддержкаПроектов.СоздатьКоллекциюДоступныхПечатныхФорм();
	
	Возврат ПечатныеФормы;
	
КонецФункции

#КонецОбласти // Печать

////////////////////////////////////////////////////////////////////////////////
// Команды формы
#Область КомандыФормы

// Заполняет список команд ввода на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Процедура ДобавитьКомандыСоздатьНаОсновании(КомандыСоздатьНаОсновании, НастройкиФормы) Экспорт
	
	ВводНаОснованииПоддержкаПроектов.ДобавитьКомандыСоздатьНаОсновании(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыСоздатьНаОсновании, НастройкиФормы);
	
КонецПроцедуры

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, НастройкиФормы) Экспорт
	
	МенюОтчетыПоддержкаПроектов.ДобавитьОбщиеКоманды(ПустаяСсылка().Метаданные().ПолноеИмя(), КомандыОтчетов, НастройкиФормы);
	
КонецПроцедуры

#КонецОбласти // КомандыФормы

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов.
//
// Возвращаемое значение:
//  Массив - массив имен реквизитов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ЮридическоеФизическоеЛицо");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти // СтандартныеПодсистемы

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ
#Область ОбновлениеИнформационнойБазы

// Обработчик обновления информационной базы, предназначенный для первоначального заполнения
// и обновления значения реквизитов, предопределенных видов КИ.
//
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформации() Экспорт
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагенты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагенты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагенты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 3;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагенты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 4;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Факс");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ФаксКонтрагенты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 5;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтрагенты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 6;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Другое");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтрагенты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 7;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Справочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Справочник
	|ГДЕ
	|	ЮрФизЛицо <> ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент)
	|	И СтранаРегистрации <> ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	КонтрагентОперативногоМониторинга = Константы.КонтрагентДляПроектаОперативныйМониторингЛС.Получить();
	
	МетаданныеКонтрагента = ПустаяСсылка().Метаданные();
	ПолноеИмяОбъекта = МетаданныеКонтрагента.ПолноеИмя();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	Россия = Справочники.СтраныМира.Россия;
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			ОбщегоНазначенияПоддержкаПроектов.ЗаблокироватьСсылку(Выборка.Ссылка);
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если Объект = Неопределено Или Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Или Объект.СтранаРегистрации = Россия Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Объект.СтранаРегистрации = Россия;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать: %Объект% по причине: %Причина%'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеКонтрагента,
				Выборка.Ссылка,
				ТекстСообщения);
				
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти // ОбновлениеИнформационнойБазы

#КонецЕсли