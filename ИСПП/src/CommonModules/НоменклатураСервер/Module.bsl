
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает описание номенклатуры
//
// Параметры
//	Номенклатура - СправочникСсылка.Номенклатура
//
Функция ОписаниеНоменклатуры(Номенклатура) Экспорт
	
	ЗапрашиваемыеРеквизиты = Новый Структура;
	ЗапрашиваемыеРеквизиты.Вставить("ВидНоменклатуры");
	ЗапрашиваемыеРеквизиты.Вставить("ТипНоменклатурыРасширенный");
	ЗапрашиваемыеРеквизиты.Вставить("ТипНоменклатуры");
	ЗапрашиваемыеРеквизиты.Вставить("ЕдиницаИзмерения");
	
	Описание = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, ЗапрашиваемыеРеквизиты);
	
	Возврат Описание;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с единицами измерения номенклатуры
#Область ЕдиницыИзмерения

// Функция получает все упаковки номенклатуры
//
// Параметры
//  Номенклатура - СправочникСсылка.Номенклатура
//  ЭлементКАТ - СправочникСсылка.РегистрЛекарственныхСредств
//
// Возвращаемое значение
//  Массив - список упаковок номенклатуры
//
Функция ПолучитьУпаковкиНоменклатуры(Знач Номенклатура, Знач Упаковка = Неопределено) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр(
		"Упаковка",
		?(Упаковка = Неопределено, ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "Упаковка"), Упаковка));
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Упаковки.Ссылка       КАК Упаковка,
	|	Упаковки.Коэффициент  КАК Коэффициент,
	|	4                     КАК НомерУпаковки
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК Упаковки
	|ГДЕ
	|	Упаковки.Номенклатура = &Номенклатура
	|	И Упаковки.ТипЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыЕдиницИзмерения.Упаковка)
	|	И Упаковки.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Упаковки.Ссылка       КАК Упаковка,
	|	Упаковки.Коэффициент  КАК Коэффициент,
	|	3                     КАК НомерУпаковки
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК Упаковки
	|ГДЕ
	|	Упаковки.Ссылка = &Упаковка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Упаковки.Ссылка       КАК Упаковка,
	|	Упаковки.Коэффициент  КАК Коэффициент,
	|	2                     КАК НомерУпаковки
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК Упаковки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ЕдиницыИзмерения КАК ВнешняяУпаковка
	|	ПО
	|		ВнешняяУпаковка.Ссылка = &Упаковка
	|		И ВнешняяУпаковка.Родитель = Упаковки.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Упаковки.Ссылка       КАК Упаковка,
	|	Упаковки.Коэффициент  КАК Коэффициент,
	|	1                     КАК НомерУпаковки
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК Упаковки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ЕдиницыИзмерения КАК ВнешняяУпаковка
	|	ПО
	|		ВнешняяУпаковка.Ссылка = &Упаковка
	|		И ВнешняяУпаковка.Родитель.Родитель = Упаковки.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерУпаковки УБЫВ,
	|	Коэффициент УБЫВ
	|";
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Упаковка");
	
	Возврат Результат;
	
КонецФункции

// Возвращает основную единицу измерения номенклатуры.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура
//  ВидЕдиницы - Строка -
//      "ПотребительскаяУпаковка" - последняя упаковка препарата.
//      "МинимальнаяЕдиница" - для штучных - базовая единица,
//                             для весовых, объемных - первичная упаковка или основная единица учета.
//
// Возвращаемое значение:
//  СправочникСсылка.ЕдиницыИзмерения
//
Функция ОсновнаяЕдиницаИзмерения(Знач Номенклатура, Знач ВидЕдиницы = "") Экспорт
	
	ЗапрашиваемыеПараметры = Новый Структура;
	ЗапрашиваемыеПараметры.Вставить("ЕдиницаИзмерения");
	ЗапрашиваемыеПараметры.Вставить("ШтучныйТовар", "ВЫБОР КОГДА ЕдиницаИзмерения.ТипЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыЕдиницИзмерения.КоличествоШтук) ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ");
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, ЗапрашиваемыеПараметры);
	ЕдиницаИзмерения = Неопределено;
	
	Если ВРег(ВидЕдиницы) = НоменклатураКлиентСервер.ВидЕдиницы_МинимальнаяЕдиница() Тогда
		
		Если Реквизиты.ШтучныйТовар Тогда
			ЕдиницаИзмерения = Реквизиты.ЕдиницаИзмерения;
		КонецЕсли;
		
	КонецЕсли;
	
	// если нет ни упаковок, ни основной единицы, то возьмем базовую единицу измерения
	Если Не ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		ЕдиницаИзмерения = Реквизиты.ЕдиницаИзмерения;
	КонецЕсли;
	
	Возврат ЕдиницаИзмерения;
	
КонецФункции

// Возвращает единицы измерения элемента Номенклатуры
//
// Параметры
//	Номенклатура - ссылка на элемент справочника Номенклатура
//
// Возвращаемое значение
//	Массив - массив единиц измерения элемента справочника Номенклатура
//
Функция ЕдиницыИзмерения(Знач Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаВыбораЕдиницНоменклатуры();
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
	
КонецФункции

// Функция получает текст запроса для формы выбора единицы измерения номенклатуры
//
// Возвращаемое значение
//	Текст - текст запроса
//
Функция ТекстЗапросаВыбораЕдиницНоменклатуры(ИмяВременнойТаблицы = Неопределено) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЕдиницыИзмеренияНоменклатуры.Порядок           КАК Порядок,
	|	ЕдиницыИзмеренияНоменклатуры.ЕдиницаИзмерения  КАК Ссылка,
	|	ЕдиницыИзмерения.Наименование                  КАК Наименование,
	|	ЕдиницыИзмерения.НаименованиеПолное            КАК НаименованиеПолное,
	|	ЕдиницыИзмеренияНоменклатуры.Коэффициент       КАК Коэффициент
	|ИЗ
	|	РегистрСведений.ЕдиницыИзмеренияНоменклатуры КАК ЕдиницыИзмеренияНоменклатуры
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|	ПО
	|		ЕдиницыИзмеренияНоменклатуры.ЕдиницаИзмерения = ЕдиницыИзмерения.Ссылка
	|ГДЕ
	|	ЕдиницыИзмеренияНоменклатуры.Номенклатура = &Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	Коэффициент УБЫВ,
	|	НаименованиеПолное УБЫВ
	|";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
		ПоследнийЗапрос = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
		ПоследнийЗапрос.Порядок.Очистить();
		ПоследнийЗапрос.ТаблицаДляПомещения = ИмяВременнойТаблицы;
		ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает коэффициент единицы измерения номенклатуры
//
// Параметры
//  Номенклатура - СправочникСсылка.Номенклатура
//  ЕдиницаИзмерения - СправочникСсылка.ЕдиницыИзмерения
//  КоэффициентПоУмолчанию - Число - если не получится рассчитать коэффициент, то будет возвращено это значение
//
// Возвращаемое значение
//  Число
//
Функция КоэффициентЕдиницыИзмерения(Номенклатура, ЕдиницаИзмерения, КоэффициентПоУмолчанию = 1) Экспорт
	
	Если Не ЗначениеЗаполнено(Номенклатура) Или Не ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		Возврат КоэффициентПоУмолчанию;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Коэффициент
	|ИЗ
	|	РегистрСведений.ЕдиницыИзмеренияНоменклатуры
	|ГДЕ
	|	Номенклатура = &Номенклатура
	|	И ЕдиницаИзмерения = &ЕдиницаИзмерения
	|");
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", ЕдиницаИзмерения);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Если Выборка.Коэффициент = 0 Тогда
			Коэффициент = КоэффициентПоУмолчанию;
		Иначе
			Коэффициент = Выборка.Коэффициент;
		КонецЕсли;
	Иначе
		Коэффициент = РассчитатьКоэффициентЕдиницыИзмерения(Номенклатура, ЕдиницаИзмерения, КоэффициентПоУмолчанию);
	КонецЕсли;
	
	Возврат Коэффициент;
	
КонецФункции

// Возвращает коэффициент единицы измерения номенклатуры
//
// Параметры
//  Номенклатура - СправочникСсылка.Номенклатура
//  ЕдиницаИзмерения - СправочникСсылка.ЕдиницыИзмерения
//  КоэффициентПоУмолчанию - Число - если не получится рассчитать коэффициент, то будет возвращено это значение
//
// Возвращаемое значение
//  Число
//
Функция РассчитатьКоэффициентЕдиницыИзмерения(Номенклатура, ЕдиницаИзмерения, КоэффициентПоУмолчанию = 1) Экспорт
	
	Если Не ЗначениеЗаполнено(Номенклатура) Или Не ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		Возврат КоэффициентПоУмолчанию;
	КонецЕсли;
	
	ЗапрашиваемыеПоля = Новый Структура;
	ЗапрашиваемыеПоля.Вставить("ЕдиницаИзмерения");
	ЗапрашиваемыеПоля.Вставить("ТипБазовойЕдиницыИзмерения", "ЕдиницаИзмерения.ТипЕдиницы");
	ЗапрашиваемыеПоля.Вставить("Коэффициент", "ЕдиницаИзмерения.Коэффициент");
	ПараметрыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, ЗапрашиваемыеПоля);
	
	Коэффициент = 1;
	Если ПараметрыНоменклатуры.ЕдиницаИзмерения <> ЕдиницаИзмерения Тогда
		
		ТекстОшибки = НСтр("ru='Не удалось определить коэффициент единицы измерения ""%2"" номенклатуры ""%1""'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Номенклатура, ЕдиницаИзмерения);
		
		ПараметрыЕдиницыИзмерения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЕдиницаИзмерения, "Ссылка, Коэффициент, ТипЕдиницы, БазоваяЕдиницаИзмерения");
		Если ПараметрыЕдиницыИзмерения.ТипЕдиницы = Перечисления.ТипыЕдиницИзмерения.Упаковка Тогда
			Коэффициент = ПараметрыЕдиницыИзмерения.Коэффициент;
			ПараметрыЕдиницыИзмерения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрыЕдиницыИзмерения.БазоваяЕдиницаИзмерения, "Ссылка, Коэффициент, ТипЕдиницы");
		КонецЕсли;
		
		ТипЕдиницы = ПараметрыЕдиницыИзмерения.ТипЕдиницы;
		Если ПараметрыНоменклатуры.ЕдиницаИзмерения = ПараметрыЕдиницыИзмерения.Ссылка Тогда // Дальнейший пересчет не требуется
			
		// единица меры (вес, объем,...)
		ИначеЕсли ТипЕдиницы = Перечисления.ТипыЕдиницИзмерения.Вес Тогда
			Если ПараметрыНоменклатуры.ВесИспользовать Тогда
				Коэффициент = Коэффициент * ПараметрыЕдиницыИзмерения.Коэффициент / ПараметрыНоменклатуры.ВесКоэффициент * ПараметрыНоменклатуры.ВесЗнаменатель / ПараметрыНоменклатуры.ВесЧислитель;
			Иначе
				ВызватьИсключение ТекстОшибки + Символы.ПС + НСтр("ru = 'Использование весовых единиц для номенклатуры отключено.'");
			КонецЕсли;
		ИначеЕсли ТипЕдиницы = Перечисления.ТипыЕдиницИзмерения.Объем Тогда
			Если ПараметрыНоменклатуры.ОбъемИспользовать Тогда
				Коэффициент = Коэффициент * ПараметрыЕдиницыИзмерения.Коэффициент / ПараметрыНоменклатуры.ОбъемКоэффициент * ПараметрыНоменклатуры.ОбъемЗнаменатель / ПараметрыНоменклатуры.ОбъемЧислитель;
			Иначе
				ВызватьИсключение ТекстОшибки + Символы.ПС + НСтр("ru = 'Использование объемных единиц для номенклатуры отключено.'");
			КонецЕсли;
		ИначеЕсли ТипЕдиницы = Перечисления.ТипыЕдиницИзмерения.Длина Тогда
			Если ПараметрыНоменклатуры.ДлинаИспользовать Тогда
				Коэффициент = Коэффициент * ПараметрыЕдиницыИзмерения.Коэффициент / ПараметрыНоменклатуры.ДлинаКоэффициент * ПараметрыНоменклатуры.ДлинаЗнаменатель / ПараметрыНоменклатуры.ДлинаЧислитель;
			Иначе
				ВызватьИсключение ТекстОшибки + Символы.ПС + НСтр("ru = 'Использование единиц длины для номенклатуры отключено.'");
			КонецЕсли;
		ИначеЕсли ТипЕдиницы = Перечисления.ТипыЕдиницИзмерения.Площадь Тогда
			Если ПараметрыНоменклатуры.ПлощадьИспользовать Тогда
				Коэффициент = Коэффициент * ПараметрыЕдиницыИзмерения.Коэффициент / ПараметрыНоменклатуры.ПлощадьКоэффициент * ПараметрыНоменклатуры.ПлощадьЗнаменатель / ПараметрыНоменклатуры.ПлощадьЧислитель;
			Иначе
				ВызватьИсключение ТекстОшибки + Символы.ПС + НСтр("ru = 'Использование единиц площади для номенклатуры отключено.'");
			КонецЕсли;
		Иначе
			// Если попали сюда, то значит единица не совместима с номенклатурой
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Коэффициент;
	
КонецФункции

Функция ПересчитатьКоличествоВБазовыхЕдиницах(Знач Номенклатура, Знач Количество, Знач ЕдиницаИзмерения) Экспорт
	
	Если Количество = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Количество * КоэффициентЕдиницыИзмерения(Номенклатура, ЕдиницаИзмерения);
	
КонецФункции

Функция ПересчитатьКоличествоВЕдиницахИзмерения(Знач Номенклатура, Знач Количество, Знач ЕдиницаИзмерения) Экспорт
	
	Если Количество = 0 Тогда
		Возврат 0;
	КонецЕсли;

	Возврат Количество / КоэффициентЕдиницыИзмерения(Номенклатура, ЕдиницаИзмерения);
	
КонецФункции

// Возвращает значение константы.
//
// Параметры:
//  ТипИзмеряемойВеличины - ПеречислениеСсылка.ТипыЕдиницИзмерения - тип измеряемой величины.
// 
// Возвращаемое значение:
//   СправочникСсылка.ЕдиницыИзмерения
//
Функция ЕдиницаМерыПоУмолчанию(ТипИзмеряемойВеличины) Экспорт
	
	Если ТипИзмеряемойВеличины = Перечисления.ТипыЕдиницИзмерения.Вес Тогда
		Значение = Константы.ЕдиницаИзмеренияВеса.Получить();
	ИначеЕсли ТипИзмеряемойВеличины = Перечисления.ТипыЕдиницИзмерения.Объем Тогда
		Значение = Константы.ЕдиницаИзмеренияОбъема.Получить();
	ИначеЕсли ТипИзмеряемойВеличины = Перечисления.ТипыЕдиницИзмерения.Длина Тогда
		Значение = Константы.ЕдиницаИзмеренияДлины.Получить();
	ИначеЕсли ТипИзмеряемойВеличины = Перечисления.ТипыЕдиницИзмерения.Площадь Тогда
		Значение = Константы.ЕдиницаИзмеренияПлощади.Получить();
	Иначе
		Значение = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти // ЕдиницыИзмерения

#КонецОбласти // ПрограммныйИнтерфейс
