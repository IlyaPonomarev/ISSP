#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Получает вид номенклатуры, если он один в справочнике.
//
// Параметры:
//  Тип - ПеречислениеСсылка.ТипыНоменклатуры, СправочникСсылка.ТипыНоменклатурыРасширенные - отбор вида номенклатуры.
//
// Возвращаемое значение:
//  СправочникСсылка.ВидыНоменклатуры - найденный вид номенклатуры.
//
Функция ВидНоменклатурыПоУмолчанию(Тип = Неопределено) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	ВидНоменклатуры.Ссылка КАК ВидНоменклатуры
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидНоменклатуры
	|ГДЕ
	|	НЕ ВидНоменклатуры.ПометкаУдаления
	|	И НЕ ВидНоменклатуры.ЭтоГруппа
	|");
	
	Если Тип <> Неопределено Тогда
		ТипЗначения = ТипЗнч(Тип);
		Если ТипЗначения = Тип("СправочникСсылка.ТипыНоменклатурыРасширенные") Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И ВидНоменклатуры.ТипНоменклатурыРасширенный = &Тип
			|";
		ИначеЕсли ТипЗначения = Тип("ПеречислениеСсылка.ТипыНоменклатуры") Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И ВидНоменклатуры.ТипНоменклатуры = &Тип
			|";
		КонецЕсли;
		Запрос.УстановитьПараметр("Тип", Тип);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.ВидыНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ВидНоменклатуры = Выборка.ВидНоменклатуры;
	Иначе
		ВидНоменклатуры = Справочники.ВидыНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВидНоменклатуры;
	
КонецФункции

// Функция возвращает структуру с параметрами шаблона серий номенклатуры
// Параметры:
//  ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - вид номенклатуры, параметры серий которых нужно получить
// Возвращаемое значение:
//  Структура:
//     ИспользоватьСерии - если для вида номенклатуры серии не ведутся, то в этом параметре возвращается ЛОЖЬ,
//                         а остальные заполняются значениями по умолчанию
//     ВидНоменклатуры
//     ИспользоватьНомерСерии
//     ИспользоватьСрокГодностиСерии
//     УказыватьСрокГодностиСерииСТочностьюДоЧасов
//     ФорматнаяСтрокаСрокаГодности
//
Функция ПараметрыСерийНоменклатуры(ВидНоменклатуры) Экспорт
	
	ПараметрыСерий = Новый Структура;
	ПараметрыСерий.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	ПараметрыСерий.Вставить("ИспользоватьСерии", Ложь);
	ПараметрыСерий.Вставить("ИспользоватьКоличествоСерии", Ложь);
	ПараметрыСерий.Вставить("ИспользоватьНомерСерии", Ложь);
	ПараметрыСерий.Вставить("ШаблонРабочегоНаименованияСерии", "");
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		
		ЗапрашиваемыеПоля = Новый Структура;
		ЗапрашиваемыеПоля.Вставить("ИспользоватьСерии");
		ЗапрашиваемыеПоля.Вставить("ИспользоватьКоличествоСерии");
		ЗапрашиваемыеПоля.Вставить("ИспользоватьНомерСерии");
		ЗапрашиваемыеПоля.Вставить("ШаблонРабочегоНаименованияСерии");
		
		ЗаполнитьЗначенияСвойств(ПараметрыСерий, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидНоменклатуры, ЗапрашиваемыеПоля));
		
	КонецЕсли;
	
	Возврат ПараметрыСерий;
	
КонецФункции

Функция ПолучитьПредустановленныеВидыНоменклатуры(ВключатьУслуги = Ложь) Экспорт
	
	ПредустановленныеВиды = Новый Массив;
	
	ПредустановленныеВиды.Добавить(ПредустановленныйВидНоменклатуры(Справочники.ТипыНоменклатурыРасширенные.Товар));
	
	Возврат ПредустановленныеВиды;
	
КонецФункции

Функция ПредустановленныйВидНоменклатуры(Тип) Экспорт
	
	ВидНоменклатуры = ВидНоменклатурыПоУмолчанию(Тип);
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Возврат ВидНоменклатуры;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НовыйВид = Справочники.ВидыНоменклатуры.СоздатьЭлемент();
	НовыйВид.Наименование = Строка(Тип);
	НовыйВид.ТипНоменклатурыРасширенный = Тип;
	НовыйВид.ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Тип, "ТипНоменклатуры");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаНоменклатуры") Тогда
		НовыйВид.ГруппаДоступа = Справочники.ГруппыДоступаНоменклатуры.ПолучитьГруппуДоступаПоУмолчанию(НовыйВид);
	КонецЕсли;
	
	НовыйВид.Записать();
	
	Возврат НовыйВид.Ссылка;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеНастройкиИспользованияСерий(ПараметрыСерийНоменклатуры) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрыСерийНоменклатуры, "НастройкаИспользованияСерий") Тогда
		НастройкаИспользованияСерий = ПараметрыСерийНоменклатуры.НастройкаИспользованияСерий;
	ИначеЕсли Не ПараметрыСерийНоменклатуры.ИспользоватьСерии Тогда
		НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.НеИспользовать;
	ИначеЕсли ПараметрыСерийНоменклатуры.ИспользоватьКоличествоСерии Тогда
		НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ПартияТоваров;
	Иначе
		НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара;
	КонецЕсли;
	
	ЧастиПредставления = Новый Массив;
	
	Если Не ЗначениеЗаполнено(НастройкаИспользованияСерий)
	 Или НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.НеИспользовать Тогда
		ЧастиПредставления.Добавить(НСтр("ru = 'Не используются'"));
	Иначе
		
		ЧастиПредставления.Добавить(Новый ФорматированнаяСтрока(Строка(НастройкаИспользованияСерий), Новый Шрифт(,,Истина)));
		ЧастиПредставления.Добавить(" (");
		
		ОписаниеРеквизитов = Новый Массив;
		
		Если ПараметрыСерийНоменклатуры.ИспользоватьНомерСерии Тогда
			ОписаниеРеквизитов.Добавить(НСтр("ru = 'Номер 1'"));
			ОписаниеРеквизитов.Добавить(НСтр("ru = 'Номер 2'"));
		КонецЕсли;
		
		ЧастиПредставления.Добавить(СтрСоединить(ОписаниеРеквизитов, ", "));
		ЧастиПредставления.Добавить(") ");
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(ЧастиПредставления)
	
КонецФункции

Функция ИменаРеквизитовДляФормыНастройкаИспользованияСерий() Экспорт
	
	ИменаРеквизитов = Новый Массив;
	ИменаРеквизитов.Добавить("НастройкаИспользованияСерий");
	ИменаРеквизитов.Добавить("ИспользоватьНомерСерии");
	
	Возврат СтрСоединить(ИменаРеквизитов, ",");
	
КонецФункции

Функция ИспользуетсяНесколькоВидовНоменклатуры() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТипыНоменклатуры.Ссылка КАК Тип
	|ИЗ
	|	Справочник.ТипыНоменклатурыРасширенные КАК ТипыНоменклатуры
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ВидыНоменклатуры КАК Виды
	|	ПО
	|		Виды.ТипНоменклатурыРасширенный = ТипыНоменклатуры.Ссылка
	|		И НЕ Виды.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	ТипыНоменклатуры.Ссылка
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(Виды.Ссылка) > 1
	|");
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМ
#Область СтандартныеПодсистемы

// Возвращает описание блокируемых реквизитов
//
// Возвращаемое значение:
//  Массив - имена блокируемых реквизитов
//   Элемент массива - Строка в формате:
//     ИмяРеквизита[;ИмяЭлементаФормы,...]
//      где
//       ИмяРеквизита     - имя реквизита объекта
//       ИмяЭлементаФормы - имя элемента формы, связанного с реквизитом
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("ТипНоменклатурыРасширенный");
	БлокируемыеРеквизиты.Добавить("ИспользоватьСерии;ВариантЗаданияНастроекСерий");
	БлокируемыеРеквизиты.Добавить("НастройкаИспользованияСерий");
	БлокируемыеРеквизиты.Добавить("ПолитикаУчетаСерий");
	БлокируемыеРеквизиты.Добавить("ИспользоватьПартии;ВариантЗаданияНастроекПартий");
	БлокируемыеРеквизиты.Добавить("ПолитикаУчетаПартий");
	
	Возврат БлокируемыеРеквизиты;
	
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

#КонецЕсли