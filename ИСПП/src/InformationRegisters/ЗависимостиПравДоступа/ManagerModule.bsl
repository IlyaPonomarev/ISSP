#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обновляет данные регистра, если прикладной разработчик
// изменил зависимости в переопределяемом модуле.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ЕстьИзменения = Неопределено) Экспорт
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	УстановитьПривилегированныйРежим(Истина);
	
	ЗависимостиПравДоступа = СоздатьНаборЗаписей();
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ПодчиненнаяТаблица", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ВедущаяТаблица",     Новый ОписаниеТипов("Строка"));
	
	ИнтеграцияПодсистемБСП.ПриЗаполненииЗависимостейПравДоступа(Таблица);
	УправлениеДоступомПереопределяемый.ПриЗаполненииЗависимостейПравДоступа(Таблица);
	
	ЗависимостиПравДоступа = СоздатьНаборЗаписей().Выгрузить();
	Для каждого Строка Из Таблица Цикл
		НоваяСтрока = ЗависимостиПравДоступа.Добавить();
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(Строка.ПодчиненнаяТаблица);
		Если ОбъектМетаданных = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка в процедуре ПриЗаполненииЗависимостейПравДоступа
				           |общего модуля УправлениеДоступомПереопределяемый.
				           |
				           |Не найдена подчиненная таблица ""%1"".'"),
				Строка.ПодчиненнаяТаблица);
		КонецЕсли;
		НоваяСтрока.ПодчиненнаяТаблица = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Строка.ПодчиненнаяТаблица);
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(Строка.ВедущаяТаблица);
		Если ОбъектМетаданных = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка в процедуре ПриЗаполненииЗависимостейПравДоступа
				           |общего модуля УправлениеДоступомПереопределяемый.
				           |
				           |Не найдена ведущая таблица ""%1"".'"),
				Строка.ВедущаяТаблица);
		КонецЕсли;
		НоваяСтрока.ТипВедущейТаблицы = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			Строка.ВедущаяТаблица).ПустаяСсылка();
	КонецЦикла;
	
	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	НовыеДанные.ПодчиненнаяТаблица,
	|	НовыеДанные.ТипВедущейТаблицы
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	&ЗависимостиПравДоступа КАК НовыеДанные";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.ПодчиненнаяТаблица,
	|	НовыеДанные.ТипВедущейТаблицы,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив;
	Поля.Добавить(Новый Структура("ПодчиненнаяТаблица"));
	Поля.Добавить(Новый Структура("ТипВедущейТаблицы"));
	
	Запрос = Новый Запрос;
	ЗависимостиПравДоступа.Свернуть("ПодчиненнаяТаблица, ТипВедущейТаблицы");
	Запрос.УстановитьПараметр("ЗависимостиПравДоступа", ЗависимостиПравДоступа);
	
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ЗависимостиПравДоступа", ТекстЗапросовВременныхТаблиц);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗависимостиПравДоступа");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Данные = Новый Структура;
		Данные.Вставить("МенеджерРегистра",      РегистрыСведений.ЗависимостиПравДоступа);
		Данные.Вставить("ИзмененияСоставаСтрок", Запрос.Выполнить().Выгрузить());
		
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(Данные, ЕстьИзменения);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли