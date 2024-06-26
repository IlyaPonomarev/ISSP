
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает структуру, содержащую информацию об ответственном лице организации.
//
// Параметры:
//  Организация       - СправочникСсылка.Организации - отбор по организации
//  Дата              - Дата - отбор по дате
//  ОтветственноеЛицо - Перечисления.ОтветственныеЛицаОрганизаций - "вид" ответственного лица.
//
// Возвращаемое значение:
//  Структура
//    * СтруктурнаяЕдиница
//    * ОтветственноеЛицо
//    * ФизическоеЛицо
//    * Должность
//
Функция ПолучитьДанныеОтветственногоЛица(Организация, Дата = Неопределено, ОтветственноеЛицо) Экспорт
	
	СтруктураОтветственных = ПолучитьОтветственныеЛицаОрганизации(Организация, Дата);
	Результат = Новый Структура;
	Результат.Вставить("СтруктурнаяЕдиница" , Организация);
	Результат.Вставить("ОтветственноеЛицо", ОтветственноеЛицо);
	Результат.Вставить("ФизическоеЛицо", "");
	Результат.Вставить("Должность", "");
	
	Для Каждого МетаВидОтветственного Из Метаданные.Перечисления.ОтветственныеЛицаОрганизаций.ЗначенияПеречисления Цикл
		
		Ключ = МетаВидОтветственного.Имя;
		Если ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций[Ключ] Тогда
			Результат.Вставить("ФизическоеЛицо", СтруктураОтветственных[Ключ]);
			Результат.Вставить("Должность",      СтруктураОтветственных[Ключ + "Должность"]);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру, содержащую информацию об ответственных лицах организации.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - отбор по организации
//  Дата        - Дата - отбор по дате
//
// Возвращаемое значение:
//  Структура
//    %ВидОтветственного%          - СправочникСсылка.ФизическиеЛица - физическое лицо, соответствующее ответственному лицу
//    %ВидОтветственного%Должность - Строка - должность ответственного лица
//  Для полей, начинающихся с %ВидОтветственного%
//    - вместо %ВидОтветственного% подставляется имя значения перечисления ОтветственныеЛицаОрганизаций как оно задано в конфигураторе
//    - количество каждого из этих ключей соответствует количеству значений перечисления ОтветственныеЛицаОрганизаций
//
Функция ПолучитьОтветственныеЛицаОрганизации(Организация, Дата = Неопределено) Экспорт
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	СтруктураОтветственных = Новый Структура;
	
	СтруктураОтбора      = Новый Структура("Дата, Владелец", Дата, Организация);
	ТаблицаОтветственных = ПолучитьТаблицуОтветственныхЛицПоОтбору(СтруктураОтбора);
	ТаблицаОтветственных.Индексы.Добавить("ОтветственноеЛицо, ПравоПодписиПоДоверенности");
	
	Для Каждого МетаВидОтветственного Из Метаданные.Перечисления.ОтветственныеЛицаОрганизаций.ЗначенияПеречисления Цикл
		
		Ключ              = МетаВидОтветственного.Имя;
		ВидОтветственного = Перечисления.ОтветственныеЛицаОрганизаций[Ключ];
		СтрокаТаблицы     = Неопределено; // ответственный пока не определен
		
		// Попытаемся найти подходящее ответственное лицо
		СтруктураОтбора = Новый Структура("ОтветственноеЛицо", ВидОтветственного);
		СтрокиТаблицы = ТаблицаОтветственных.НайтиСтроки(СтруктураОтбора);
		
		Если СтрокиТаблицы.Количество() = 1 Тогда
			
			// Если есть только один ответственный данного вида - вернем его
			СтрокаТаблицы = СтрокиТаблицы[0];
			
		ИначеЕсли СтрокиТаблицы.Количество() > 1 Тогда
			
			СтруктураОтбора.Вставить("ПравоПодписиПоДоверенности", Ложь);
			
			СтрокиТаблицы = ТаблицаОтветственных.НайтиСтроки(СтруктураОтбора);
			Если СтрокиТаблицы.Количество() = 1 Тогда
				// Если есть основной ответственный данного вида - вернем его
				СтрокаТаблицы = СтрокиТаблицы[0];
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтрокаТаблицы = Неопределено Тогда
			
			// Ответственное лицо этого вида не удалось определить
			СтруктураОтветственных.Вставить(Ключ,                        Справочники.ФизическиеЛица.ПустаяСсылка());
			СтруктураОтветственных.Вставить(Ключ + "Должность",          "");
			СтруктураОтветственных.Вставить(Ключ + "ДолжностьСсылка",    Неопределено);
			СтруктураОтветственных.Вставить(Ключ + "Наименование",       "");
			СтруктураОтветственных.Вставить(Ключ + "Ссылка",             Справочники.ОтветственныеЛицаОрганизаций.ПустаяСсылка());
		Иначе
			
			// Основное ответственное лицо этого вида найдено
			СтруктураОтветственных.Вставить(Ключ,                        СтрокаТаблицы.ФизическоеЛицо);
			СтруктураОтветственных.Вставить(Ключ + "Должность",          СтрокаТаблицы.Должность);
			СтруктураОтветственных.Вставить(Ключ + "ДолжностьСсылка",    СтрокаТаблицы.ДолжностьСсылка);
			СтруктураОтветственных.Вставить(Ключ + "Наименование",       СтрокаТаблицы.Наименование);
			СтруктураОтветственных.Вставить(Ключ + "Ссылка",             СтрокаТаблицы.Ссылка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураОтветственных;
	
КонецФункции

// Возвращает таблицу ответственных лиц, сформированную в соответствии с произвольным отбором.
//
// Параметры:
//  Отбор - Структура - структура, содержащая параметры отбора данных справочника ОтветственныеЛицаОрганизаций.
//    * Ключ     - имя реквизита справочника. Возможны дополнительные ключи:
//      ** Дата        - для отбора по периоду ДатаНачала - ДатаОкончания
//      ** Организация - синоним ключа Владелец
//    * Значение - значение для отбора по ключу
//  ДопустимыПомеченныеНаУдаление - Булево - выводить в результирующую таблицу помеченные на удаление элементы.
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица, содержащая данные справочника ОтветственныеЛицаОрганизаций.
//                     Имена колонок таблицы совпадают с именами реквизитов справочника.
//
Функция ПолучитьТаблицуОтветственныхЛицПоОтбору(Знач Отбор, ДопустимыПомеченныеНаУдаление = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	
	ТекстВыбираемыеПоля = "";
	ТекстОтбора = "";
	НомерОтбора = 0;
	
	ПоляОтбора = Новый Структура;
	ОписаниеРеквизитов = ОбщегоНазначения.ОписаниеСвойствОбъекта(Метаданные.Справочники.ОтветственныеЛицаОрганизаций, "Имя, Синоним");
	Для Каждого Описание Из ОписаниеРеквизитов Цикл
		ПоляОтбора.Вставить(Описание.Имя, Описание.Синоним);
	КонецЦикла;
	
	Если Отбор.Свойство("Дата") Тогда
		
		// Отбор по периоду действия записи об ответственном лице
		ТекстОтбора =
			ТекстОтбора
			+ ?(ТекстОтбора = "", "", " И ") + "ОтветственныеЛицаОрганизаций.ДатаНачала <= &ОтборПоДате
			| И (ОтветственныеЛицаОрганизаций.ДатаОкончания >= &ОтборПоДате 
			|	 ИЛИ ОтветственныеЛицаОрганизаций.ДатаОкончания = ДАТАВРЕМЯ(1,1,1,0,0,0))
			|";
		Запрос.УстановитьПараметр("ОтборПоДате", НачалоДня(Отбор.Дата));
		
		Отбор.Удалить("Дата");
		
	КонецЕсли;
	
	Если Отбор.Свойство("Организация") Тогда
		Отбор.Вставить("Владелец", Отбор.Организация);
		Отбор.Удалить("Организация");
	КонецЕсли;
	
	Если НЕ ДопустимыПомеченныеНаУдаление Тогда
		Отбор.Вставить("ПометкаУдаление", Ложь);
	КонецЕсли;
	
	// Формируем секцию запроса "ГДЕ", устанавливаем параметры запроса
	Для Каждого ТекущийОтбор Из Отбор Цикл
		
		Если НЕ ПоляОтбора.Свойство(ТекущийОтбор.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		
		НомерОтбора = НомерОтбора + 1;
		
		ТекстОтбора =
			ТекстОтбора
			+ ?(ТекстОтбора = "", "", " И ") + "ОтветственныеЛицаОрганизаций." + ТекущийОтбор.Ключ 
				+ ?(ТипЗнч(ТекущийОтбор.Значение) = Тип("Массив"), " В ", " = ") + "&ЗначениеОтбора" + СокрЛП(НомерОтбора) + "
			|";
		
		Запрос.УстановитьПараметр("ЗначениеОтбора" + СокрЛП(НомерОтбора), ТекущийОтбор.Значение);
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстОтбора) Тогда
		ТекстОтбора =
			"ГДЕ
			| " + ТекстОтбора;
	КонецЕсли;
	
	Для Каждого Поле Из ПоляОтбора Цикл
		ТекстВыбираемыеПоля = ТекстВыбираемыеПоля
			+ ?(ТекстВыбираемыеПоля = "", "", ",") + "
			|ОтветственныеЛицаОрганизаций." + Поле.Ключ + " КАК " + Поле.Ключ;
	КонецЦикла;
	
	// Формируем запрос, получаем данные
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	%ТекстВыбираемыеПоля%
	|ИЗ
	|	Справочник.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|%ТекстОтбора%
	|УПОРЯДОЧИТЬ ПО
	|	Владелец,
	|	ОтветственноеЛицо,
	|	ПравоПодписиПоДоверенности,
	|	ДатаНачала,
	|	ДатаОкончания,
	|	ФизическоеЛицо";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстВыбираемыеПоля%", ТекстВыбираемыеПоля);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстОтбора%",         ТекстОтбора);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Формирует временную таблицу, содержащую информацию об ответственных лицах в разрезе документов.
// Используется для формирования печатных форм документов подсистемой печати
//  - перед выборкой данных из шапки документа вызвать эту процедуру
//  - при выборке данных создать левое соединение таблицы документов с временной таблицей ТаблицаОтветственныеЛица по полю Ссылка.
//
// Параметры:
//  ОтборДокументы - Массив, ДокументСсылка - ссылки на документы, по которым необходимо получить ответственных лиц.
//                                            Важно: если передан массив, то все его элементы должны иметь одинаковый тип.
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - в него помещается сформированная временная таблица ТаблицаОтветственныеЛица.
//  ИмяРеквизитаОрганизация - имя поля документа для получения организации-владельца ответственного лица.
//  РеквизитыОтветственныеЛица - Структура, Соответствие
//    * Ключ - Строка - имя поля в запросе для получения значения ответственного лица.
//    * Значение - ПеречислениеСсылка.ОтветственныеЛицаОрганизаций - "вид" ответственного лица.
// Количество строк в таблице "ТаблицаОтветственныеЛица" соответствует количеству элементов в ОтборДокументы.
//
// Структура временной таблицы "ТаблицаОтветственныеЛица"
//    Ссылка                          - ссылка на документ из ОтборДокументы
//    %Реквизит%                      - СправочникСсылка.ОтветственныеЛицаОрганизаций - значение реквизита ответственного лица из документа
//    %Реквизит%ФизическоеЛицо        - СправочникСсылка.ФизическиеЛица - физическое лицо, соответствующее ответственному лицу
//    %Реквизит%Наименование          - Строка - наименование для печати ответственного лица
//    %Реквизит%Должность             - Строка - должность ответственного лица
//    %Реквизит%ОснованиеПраваПодписи - Строка - основание права подписи для неосновного ответственного лица
// Для полей, начинающихся с %Реквизит%
//  - вместо %Реквизит% подставляется имя реквизита ответственного лица как оно задано в конфигураторе
//  - количество каждого из этих полей соответствует количеству реквизитов ответственных лиц документа
//
// Например, если в метаданных документа есть два реквизита ответственных лиц - Руководитель и Бухгалтер,
// то таблица ТаблицаОтветственныеЛица будет иметь следующую структуру:
//  Ссылка
//  Руководитель
//  РуководительФизическоеЛицо
//  РуководительНаименование
//  РуководительДолжность
//  РуководительОснованиеПраваПодписи
//  Бухгалтер
//  БухгалтерФизическоеЛицо
//  БухгалтерНаименование
//  БухгалтерДолжность
//  БухгалтерОснованиеПраваПодписи
//
Процедура СформироватьВременнуюТаблицуОтветственныхЛицДокументов(ОтборДокументы,
																МенеджерВременныхТаблиц,
																ИмяРеквизитаОрганизация = "Организация",
																РеквизитыОтветственныеЛица = Неопределено) Экспорт
	
	Если ТипЗнч(ОтборДокументы) = Тип("Массив") И ОтборДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ОтборДокументы) <> Тип("Массив") Тогда // это ссылка на документ
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(ОтборДокументы);
	Иначе // это массив ссылок на документы
		МассивОбъектов = ОтборДокументы;
	КонецЕсли;
	
	МетаданныеДокумента = МассивОбъектов[0].Метаданные();
	
	ИменаПолейПереданыВПараметрах = (РеквизитыОтветственныеЛица <> Неопределено);
	Если НЕ ИменаПолейПереданыВПараметрах Тогда
		РеквизитыОтветственныеЛица = ОтветственныеЛицаПовтИсп.РеквизитыОтветственныхЛицДокумента(МетаданныеДокумента.Имя);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РеквизитыОтветственныеЛица) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаОрганизация = "ДокументДляПечати." + ИмяРеквизитаОрганизация;
	
	Если МенеджерВременныхТаблиц = Неопределено Тогда
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	// Получим данные из документов
	ШаблонЗапроса = 
	"ВЫБРАТЬ
	|	ДокументДляПечати.Ссылка 					КАК Ссылка,
	|	НАЧАЛОПЕРИОДА(ДокументДляПечати.Дата, ДЕНЬ) КАК Дата,
	|	%Организация%								КАК Организация,
	|	%ИмяРеквизита% 								КАК ВыбранноеОтветственноеЛицо,
	|	ЗНАЧЕНИЕ(%ОтветственноеЛицо%) 				КАК ОтветственноеЛицо
	|%СозданиеВременнойТаблицы%
	|ИЗ
	|	Документ." + МетаданныеДокумента.Имя + " КАК ДокументДляПечати
	|ГДЕ
	|	ДокументДляПечати.Ссылка В(&МассивОбъектов)";
	
	Индекс = 0;
	Для Каждого КлючИЗначение Из РеквизитыОтветственныеЛица Цикл
		
		Индекс 		 = Индекс + 1;
		ТекстЗапроса = ШаблонЗапроса;
		
		Если Индекс > 1 Тогда
			ТекстЗапроса = "
			|ОБЪЕДИНИТЬ ВСЕ
			|" + ТекстЗапроса;
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса , "%Организация%", 			 	ИмяРеквизитаОрганизация);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса , "%ИмяРеквизита%", 			
			?(ИменаПолейПереданыВПараметрах, 
				"ЗНАЧЕНИЕ(Справочник.ОтветственныеЛицаОрганизаций.ПустаяСсылка)", // будут выбраны значения по умолчанию
				"ДокументДляПечати." + КлючИЗначение.Ключ));
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса , "%ОтветственноеЛицо%", 		ПолучитьПолноеИмяПредопределенногоЗначения(КлючИЗначение.Значение));
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса , "%СозданиеВременнойТаблицы%", ?(Индекс = 1, "ПОМЕСТИТЬ ВТДанныеДокументов", ""));
		
		Запрос.Текст = Запрос.Текст + ТекстЗапроса;
		
	КонецЦикла;
	
	Запрос.Текст = Запрос.Текст + "
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОтветственноеЛицо,
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	// Заполним пустые поля ответственных лиц значениями по умолчанию
	Запрос.Текст = Запрос.Текст + "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТДанныеДокументов.Организация КАК Организация,
	|	ВТДанныеДокументов.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	ВТДанныеДокументов.Дата КАК Дата
	|ПОМЕСТИТЬ ВТНезаполненныеОтветственные
	|ИЗ
	|	ВТДанныеДокументов КАК ВТДанныеДокументов
	|ГДЕ
	|	ВТДанныеДокументов.ВыбранноеОтветственноеЛицо = ЗНАЧЕНИЕ(Справочник.ОтветственныеЛицаОрганизаций.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОтветственноеЛицо,
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТНезаполненныеОтветственные.Организация КАК Организация,
	|	ВТНезаполненныеОтветственные.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	ВТНезаполненныеОтветственные.Дата КАК Дата,
	|	ОтветственныеЛицаОрганизаций.Ссылка КАК Ответственный,
	|	ОтветственныеЛицаОрганизаций.ПравоПодписиПоДоверенности КАК ПравоПодписиПоДоверенности
	|ПОМЕСТИТЬ ВТКандидатыВОтветственныеПоУмолчанию
	|ИЗ
	|	ВТНезаполненныеОтветственные КАК ВТНезаполненныеОтветственные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|		ПО ВТНезаполненныеОтветственные.Организация = ОтветственныеЛицаОрганизаций.Владелец
	|			И ВТНезаполненныеОтветственные.ОтветственноеЛицо = ОтветственныеЛицаОрганизаций.ОтветственноеЛицо
	|			И ВТНезаполненныеОтветственные.Дата >= ОтветственныеЛицаОрганизаций.ДатаНачала
	|			И (ВТНезаполненныеОтветственные.Дата <= ОтветственныеЛицаОрганизаций.ДатаОкончания
	|				ИЛИ ОтветственныеЛицаОрганизаций.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТКандидатыВОтветственныеПоУмолчанию.Организация КАК Организация,
	|	ВТКандидатыВОтветственныеПоУмолчанию.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	ВТКандидатыВОтветственныеПоУмолчанию.Дата КАК Дата,
	|	ВТКандидатыВОтветственныеПоУмолчанию.Ответственный КАК ОтветственноеЛицоПоУмолчанию
	|ПОМЕСТИТЬ ВТОтветственныеПоУмолчанию
	|ИЗ
	|	ВТКандидатыВОтветственныеПоУмолчанию КАК ВТКандидатыВОтветственныеПоУмолчанию
	|ГДЕ
	|	НЕ ВТКандидатыВОтветственныеПоУмолчанию.ПравоПодписиПоДоверенности
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВТКандидатыВОтветственныеПоУмолчанию.Организация,
	|	ВТКандидатыВОтветственныеПоУмолчанию.ОтветственноеЛицо,
	|	ВТКандидатыВОтветственныеПоУмолчанию.Дата,
	|	МИНИМУМ(ВТКандидатыВОтветственныеПоУмолчанию.Ответственный)
	|ИЗ
	|	ВТКандидатыВОтветственныеПоУмолчанию КАК ВТКандидатыВОтветственныеПоУмолчанию
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТКандидатыВОтветственныеПоУмолчанию.Организация,
	|	ВТКандидатыВОтветственныеПоУмолчанию.ОтветственноеЛицо,
	|	ВТКандидатыВОтветственныеПоУмолчанию.Дата
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТКандидатыВОтветственныеПоУмолчанию.Ответственный) = 1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОтветственноеЛицо,
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДанныеДокументов.Ссылка,
	|	ВТДанныеДокументов.ОтветственноеЛицо,
	|	ВЫБОР
	|		КОГДА ВТДанныеДокументов.ВыбранноеОтветственноеЛицо = ЗНАЧЕНИЕ(Справочник.ОтветственныеЛицаОрганизаций.ПустаяСсылка)
	|			ТОГДА ЕСТЬNULL(ВТОтветственныеПоУмолчанию.ОтветственноеЛицоПоУмолчанию, ЗНАЧЕНИЕ(Справочник.ОтветственныеЛицаОрганизаций.ПустаяСсылка))
	|		ИНАЧЕ ВТДанныеДокументов.ВыбранноеОтветственноеЛицо
	|	КОНЕЦ КАК ОтветственноеЛицоПоУмолчанию
	|ПОМЕСТИТЬ ВТДокументыСОтветственными
	|ИЗ
	|	ВТДанныеДокументов КАК ВТДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОтветственныеПоУмолчанию КАК ВТОтветственныеПоУмолчанию
	|		ПО ВТДанныеДокументов.Организация = ВТОтветственныеПоУмолчанию.Организация
	|			И ВТДанныеДокументов.ОтветственноеЛицо = ВТОтветственныеПоУмолчанию.ОтветственноеЛицо
	|			И ВТДанныеДокументов.Дата = ВТОтветственныеПоУмолчанию.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТДокументыСОтветственными.ОтветственноеЛицоПоУмолчанию.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА (1000)) КАК ФИО
	|ИЗ
	|	ВТДокументыСОтветственными КАК ВТДокументыСОтветственными
	|ГДЕ
	|	ВТДокументыСОтветственными.ОтветственноеЛицоПоУмолчанию.ФизическоеЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|";
	
	// Для всех выбранных физ. лиц получим временную таблицу с их ФИО
	ТаблицаФизЛиц = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекСтр Из ТаблицаФизЛиц Цикл
		ТекСтр.ФИО = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СокрЛП(ТекСтр.ФизическоеЛицо));
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаФизЛиц", ТаблицаФизЛиц);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаФизЛиц.ФизическоеЛицо,
	|	ТаблицаФизЛиц.ФИО
	|ПОМЕСТИТЬ ВТФИОФизЛиц
	|ИЗ
	|	&ТаблицаФизЛиц КАК ТаблицаФизЛиц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДокументыСОтветственными.Ссылка,
	|	ВТДокументыСОтветственными.ОтветственноеЛицо,
	|	ВТДокументыСОтветственными.ОтветственноеЛицоПоУмолчанию,
	|	ЕСТЬNULL(ВТФИОФизЛиц.ФИО, """") КАК ФИО
	|ПОМЕСТИТЬ ВТДокументыСФИООтветственных
	|ИЗ
	|	ВТДокументыСОтветственными КАК ВТДокументыСОтветственными
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИОФизЛиц КАК ВТФИОФизЛиц
	|		ПО ВТДокументыСОтветственными.ОтветственноеЛицоПоУмолчанию.ФизическоеЛицо = ВТФИОФизЛиц.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	// Свернем результат - поместим всех ответственных в одну запись выборки запроса
	ШаблонЗапроса = "
	|ВЫБРАТЬ
	|	ВТДокументыСФИООтветственных.Ссылка%СтрокаВыборкаЗапроса%
	|ПОМЕСТИТЬ ВТДокументыСФИООтветственныхСвернутая
	|ИЗ
	|(%ВложенныйЗапрос%) КАК ВТДокументыСФИООтветственных
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТДокументыСФИООтветственных.Ссылка
	|";
	
	ШаблонВложенногоЗапроса = "
	|ВЫБРАТЬ
	|	ВТДокументыСФИООтветственных.Ссылка%СтрокаВыборкаВложенногоЗапроса%
	|ИЗ
	|	ВТДокументыСФИООтветственных КАК ВТДокументыСФИООтветственных
	|ГДЕ
	|	ВТДокументыСФИООтветственных.ОтветственноеЛицо = ЗНАЧЕНИЕ(%ОтветственноеЛицо%)
	|";
	
	Индекс = 0;
	СтрокаВыборкаЗапроса = "";
	ТекстВложенногоЗапроса = "";
	
	Для Каждого КлючИЗначение Из РеквизитыОтветственныеЛица Цикл
		
		Индекс = Индекс + 1;
		
		СтрокаВыборкаВложенногоЗапроса = "";
		Для Каждого КлючИЗначение2 Из РеквизитыОтветственныеЛица Цикл
			
			Если КлючИЗначение.Ключ = КлючИЗначение2.Ключ Тогда
				СтрокаВыборкаВложенногоЗапроса = СтрокаВыборкаВложенногоЗапроса + ",
				|	ВТДокументыСФИООтветственных.ОтветственноеЛицоПоУмолчанию КАК " + КлючИЗначение2.Ключ + ",
				|	ВТДокументыСФИООтветственных.ФИО КАК " + КлючИЗначение2.Ключ + "ФИО";
			Иначе
				СтрокаВыборкаВложенногоЗапроса = СтрокаВыборкаВложенногоЗапроса + ",
				|	ЗНАЧЕНИЕ(Справочник.ОтветственныеЛицаОрганизаций.ПустаяСсылка) КАК " + КлючИЗначение2.Ключ + ",
				|	"""" КАК " + КлючИЗначение2.Ключ + "ФИО";
			КонецЕсли;
			
		КонецЦикла;
		
		Если Индекс > 1 Тогда
			ТекстВложенногоЗапроса = ТекстВложенногоЗапроса + "
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
		ТекстВложенногоЗапроса = ТекстВложенногоЗапроса + ШаблонВложенногоЗапроса;
		
		ТекстВложенногоЗапроса = СтрЗаменить(ТекстВложенногоЗапроса , "%СтрокаВыборкаВложенногоЗапроса%", СтрокаВыборкаВложенногоЗапроса);
		ТекстВложенногоЗапроса = СтрЗаменить(ТекстВложенногоЗапроса , "%ОтветственноеЛицо%", 			  ПолучитьПолноеИмяПредопределенногоЗначения(КлючИЗначение.Значение));
		
		СтрокаВыборкаЗапроса = СтрокаВыборкаЗапроса + ",
		|	МАКСИМУМ(ВТДокументыСФИООтветственных." + КлючИЗначение.Ключ + ") КАК " + КлючИЗначение.Ключ + ",
		|	МАКСИМУМ(ВТДокументыСФИООтветственных." + КлючИЗначение.Ключ + "ФИО) КАК " + КлючИЗначение.Ключ + "ФИО";

	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ШаблонЗапроса , "%СтрокаВыборкаЗапроса%", СтрокаВыборкаЗапроса);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса ,  "%ВложенныйЗапрос%", 	 ТекстВложенногоЗапроса);
	
	Запрос.Текст = Запрос.Текст + ТекстЗапроса;
	
	// Расшифруем данные - выберем нужные реквизиты ответственных лиц в отдельные поля
	ШаблонЗапроса = "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСвернутая.Ссылка КАК Ссылка%СтрокаВыборка%
	|ПОМЕСТИТЬ ТаблицаОтветственныеЛица
	|ИЗ
	|	ВТДокументыСФИООтветственныхСвернутая КАК ВТСвернутая
	|";
	
	ШаблонСтрокиВыборки = ",
	|	ВТСвернутая.%Реквизит% КАК %Реквизит%,
	|	ЕСТЬNULL(ВТСвернутая.%Реквизит%.ФизическоеЛицо, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК %Реквизит%ФизическоеЛицо,
	|	ВТСвернутая.%Реквизит%ФИО 
	|		+ ВЫБОР
	|			КОГДА ВТСвернутая.%Реквизит%.ОснованиеПраваПодписи ЕСТь NULL
	|				ИЛИ ВТСвернутая.%Реквизит%.ОснованиеПраваПодписи = """"
	|			ТОГДА """"
	|			ИНАЧЕ "", "" + ВТСвернутая.%Реквизит%.ОснованиеПраваПодписи
	|		  КОНЕЦ КАК %Реквизит%Наименование,
	|	ЕСТЬNULL(ВТСвернутая.%Реквизит%.Должность, """") КАК %Реквизит%Должность,
	|	ЕСТЬNULL(ВТСвернутая.%Реквизит%.ОснованиеПраваПодписи, """") КАК %Реквизит%ОснованиеПраваПодписи";

	СтрокаВыборка = "";
	Для Каждого КлючИЗначение Из РеквизитыОтветственныеЛица Цикл
		СтрокаВыборка = СтрокаВыборка + СтрЗаменить(ШаблонСтрокиВыборки , "%Реквизит%", КлючИЗначение.Ключ);
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ШаблонЗапроса , "%СтрокаВыборка%", СтрокаВыборка);
	
	// Удалим ненужные временные таблицы
	Запрос.Текст = Запрос.Текст + ТекстЗапроса + "
	|;
	|УНИЧТОЖИТЬ ВТДанныеДокументов
	|;
	|УНИЧТОЖИТЬ ВТНезаполненныеОтветственные
	|;
	|УНИЧТОЖИТЬ ВТОтветственныеПоУмолчанию
	|;
	|УНИЧТОЖИТЬ ВТКандидатыВОтветственныеПоУмолчанию
	|;
	|УНИЧТОЖИТЬ ВТДокументыСОтветственными
	|;
	|УНИЧТОЖИТЬ ВТДокументыСФИООтветственных
	|;
	|УНИЧТОЖИТЬ ВТДокументыСФИООтветственныхСвернутая
	|";
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти
