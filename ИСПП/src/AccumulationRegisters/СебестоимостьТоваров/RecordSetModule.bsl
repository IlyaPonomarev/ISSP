#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 Или Не ПроведениеПоддержкаПроектов.ЭтоПроведениеДокумента(ДополнительныеСвойства)Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПроведениеПоддержкаПроектов.РассчитыватьИзменения(ДополнительныеСвойства)
	   И Не Константы.ОтключитьКонтрольОстатковТоваровПоРегиструСебестоимости.Получить() Тогда
		
		БлокироватьДляИзменения = Истина;
		
		// Текущее состояние набора помещается во временную таблицу "ДвиженияПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("ЭтоНовый", ДополнительныеСвойства.ЭтоНовый);
		Запрос.МенеджерВременныхТаблиц = ПроведениеПоддержкаПроектов.ПолучитьМенеджерВременныхТаблицДляКонтроляПроведения(ДополнительныеСвойства);
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	Таблица.Период                      КАК Период,
		|	Таблица.АналитикаВидаУчета          КАК АналитикаВидаУчета,
		|	Таблица.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
		|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Таблица.Количество > 0
		|				ИЛИ Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Таблица.Количество < 0 ТОГДА
		|		ИСТИНА
		|	ИНАЧЕ
		|		ЛОЖЬ
		|	КОНЕЦ                               КАК КонтрольПоступлений,
		|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Таблица.Количество > 0
		|				ИЛИ Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Таблица.Количество < 0 ТОГДА
		|			ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|				Таблица.Количество
		|			ИНАЧЕ
		|				- Таблица.Количество
		|			КОНЕЦ
		|		ИНАЧЕ
		|			-Таблица.Количество
		|	КОНЕЦ                               КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ СебестоимостьТоваровПередЗаписью
		|ИЗ
		|	РегистрНакопления.СебестоимостьТоваров КАК Таблица
		|ГДЕ
		|	Таблица.Регистратор = &Регистратор
		|	И НЕ &ЭтоНовый
		|";
		Запрос.Выполнить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 Или Не ПроведениеПоддержкаПроектов.ЭтоПроведениеДокумента(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроведениеПоддержкаПроектов.РассчитыватьИзменения(ДополнительныеСвойства)
	   И Не Константы.ОтключитьКонтрольОстатковТоваровПоРегиструСебестоимости.Получить() Тогда
		
		// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
		// и помещается во временную таблицу.
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("ЭтоНовый", ДополнительныеСвойства.ЭтоНовый);
		Запрос.МенеджерВременныхТаблиц = ПроведениеПоддержкаПроектов.ПолучитьМенеджерВременныхТаблицДляКонтроляПроведения(ДополнительныеСвойства);
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	КОНЕЦПЕРИОДА(Таблица.Период, МЕСЯЦ)   КАК ПериодПередЗаписью,
		|	NULL                                  КАК ПериодПриЗаписи,
		|	Таблица.КонтрольПоступлений           КАК КонтрольПоступлений,
		|	Таблица.АналитикаВидаУчета            КАК АналитикаВидаУчета,
		|	Таблица.АналитикаУчетаНоменклатуры    КАК АналитикаУчетаНоменклатуры,
		|	Таблица.КоличествоПередЗаписью        КАК КоличествоИзменение
		|ПОМЕСТИТЬ ТаблицаИзменений
		|ИЗ
		|	СебестоимостьТоваровПередЗаписью КАК Таблица
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL                                  КАК ПериодПередЗаписью,
		|	КОНЕЦПЕРИОДА(Таблица.Период, МЕСЯЦ)   КАК ПериодПриЗаписи,
		|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Таблица.Количество > 0
		|				ИЛИ Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Таблица.Количество < 0 ТОГДА
		|		ИСТИНА
		|	ИНАЧЕ
		|		ЛОЖЬ
		|	КОНЕЦ                                 КАК КонтрольПоступлений,
		|	Таблица.АналитикаВидаУчета            КАК АналитикаВидаУчета,
		|	Таблица.АналитикаУчетаНоменклатуры    КАК АналитикаУчетаНоменклатуры,
		|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Таблица.Количество > 0
		|				ИЛИ Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Таблица.Количество < 0 ТОГДА
		|			ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|				-Таблица.Количество
		|			ИНАЧЕ
		|				Таблица.Количество
		|			КОНЕЦ
		|		ИНАЧЕ
		|			Таблица.Количество
		|	КОНЕЦ                                 КАК КоличествоИзменение
		|ИЗ
		|	РегистрНакопления.СебестоимостьТоваров КАК Таблица
		|ГДЕ
		|	Таблица.Регистратор = &Регистратор
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(ТаблицаИзменений.ПериодПередЗаписью) КАК ПериодПроверки,
		|	ТаблицаИзменений.АналитикаВидаУчета          КАК АналитикаВидаУчета,
		|	ТаблицаИзменений.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
		|	ТаблицаИзменений.КонтрольПоступлений         КАК КонтрольПоступлений,
		|	СУММА(ТаблицаИзменений.КоличествоИзменение)  КАК КоличествоИзменение
		|ПОМЕСТИТЬ ДвиженияСебестоимостьТоваровИзменение
		|ИЗ
		|	ТаблицаИзменений КАК ТаблицаИзменений
		|ГДЕ
		|	ТаблицаИзменений.КонтрольПоступлений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.АналитикаВидаУчета,
		|	ТаблицаИзменений.АналитикаУчетаНоменклатуры,
		|	ТаблицаИзменений.КонтрольПоступлений
		|
		|ИМЕЮЩИЕ
		|	СУММА(ТаблицаИзменений.КоличествоИзменение) > 0
		|	ИЛИ МИНИМУМ(ТаблицаИзменений.ПериодПередЗаписью) < МАКСИМУМ(ТаблицаИзменений.ПериодПриЗаписи)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	МИНИМУМ(ТаблицаИзменений.ПериодПриЗаписи)    КАК ПериодПроверки,
		|	ТаблицаИзменений.АналитикаВидаУчета          КАК АналитикаВидаУчета,
		|	ТаблицаИзменений.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
		|	ТаблицаИзменений.КонтрольПоступлений         КАК КонтрольПоступлений,
		|	СУММА(ТаблицаИзменений.КоличествоИзменение)  КАК КоличествоИзменение
		|ИЗ
		|	ТаблицаИзменений КАК ТаблицаИзменений
		|ГДЕ
		|	НЕ ТаблицаИзменений.КонтрольПоступлений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.АналитикаВидаУчета,
		|	ТаблицаИзменений.АналитикаУчетаНоменклатуры,
		|	ТаблицаИзменений.КонтрольПоступлений
		|
		|ИМЕЮЩИЕ
		|	СУММА(ТаблицаИзменений.КоличествоИзменение) > 0
		|	ИЛИ МАКСИМУМ(ТаблицаИзменений.ПериодПередЗаписью) > МИНИМУМ(ТаблицаИзменений.ПериодПриЗаписи)
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ СебестоимостьТоваровПередЗаписью
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ТаблицаИзменений
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(Изменения.ПериодПроверки) КАК Дата
		|ИЗ
		|	ДвиженияСебестоимостьТоваровИзменение КАК Изменения
		|ГДЕ
		|	Изменения.КонтрольПоступлений
		|;
		|ВЫБРАТЬ
		|	МИНИМУМ(Изменения.ПериодПроверки) КАК Дата
		|ИЗ
		|	ДвиженияСебестоимостьТоваровИзменение КАК Изменения
		|ГДЕ
		|	НЕ Изменения.КонтрольПоступлений
		|//////////////////////////////////////////////////////////////////////////////
		|";
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Выборка = РезультатЗапроса[1].Выбрать();
		Выборка.Следующий();
		
		// Новые изменения были помещены во временную таблицу "ДвиженияСебестоимостьТоваровИзменение".
		// Добавляется информация о ее существовании и наличии в ней записей об изменении.
		Если Выборка.Количество > 0 Тогда
			
			ДатаПоследнегоДвижения = ДатаПоследнегоДвижения();
			Если ЗначениеЗаполнено(ДатаПоследнегоДвижения) Тогда
				ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отбор.Регистратор.Значение, "Дата");
				
				ВыборкаДат = РезультатЗапроса[РезультатЗапроса.ВГраница() - 1].Выбрать();
				ВыборкаДат.Следующий();
				МинимальныйПериодПрихода = ВыборкаДат.Дата;
				
				ВыборкаДат = РезультатЗапроса[РезультатЗапроса.ВГраница()].Выбрать();
				ВыборкаДат.Следующий();
				МинимальныйПериодРасхода = ВыборкаДат.Дата;
				
				ПараметрыПроверки = ПолучитьПараметрыКонтроляОстатков(МинимальныйПериодРасхода, МинимальныйПериодПрихода, ДатаПоследнегоДвижения);
				
				ПроведениеПоддержкаПроектов.ДобавитьПараметрыКонтроля(
					ДополнительныеСвойства,
					ПараметрыПроверки.ТекстЗапроса,
					РегистрыНакопления.СебестоимостьТоваров,
					ПараметрыПроверки.ПараметрыЗапроса);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыКонтроляОстатков(МинимальныйПериодРасхода, МинимальныйПериодПрихода, ДатаПоследнегоДвижения)
	
	ПараметрыКонтроля = Новый Структура;
	
	ОбъединениеЗапросов = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	ПакетЗапросов = Новый Массив;
	ПараметрыЗапроса = Новый Структура;
	
	НуженКонтрольРасхода = ЗначениеЗаполнено(МинимальныйПериодРасхода);
	Если НуженКонтрольРасхода Тогда
		ТекстЗапросаКонтроляРасхода = ТекстЗапросаКонтроля(МинимальныйПериодРасхода, Ложь, ДатаПоследнегоДвижения, ПараметрыЗапроса);
		ПакетЗапросов.Добавить(ТекстЗапросаКонтроляРасхода);
	КонецЕсли;
	НуженКонтрольПрихода = ЗначениеЗаполнено(МинимальныйПериодПрихода);
	Если НуженКонтрольПрихода Тогда
		ТекстЗапросаКонтроляПрихода = ТекстЗапросаКонтроля(МинимальныйПериодПрихода, Истина, ДатаПоследнегоДвижения, ПараметрыЗапроса);
		ПакетЗапросов.Добавить(ТекстЗапросаКонтроляПрихода);
	КонецЕсли;
	
	ИтоговыйЗапрос = Новый Массив;
	ШаблонЗапроса = "
	|ВЫБРАТЬ
	|	Остатки.ТипКонтроля                                           КАК ТипКонтроля,
	|	Остатки.ДатаОстатка                                           КАК ДатаОстатка,
	|	Остатки.АналитикаВидаУчета                                    КАК АналитикаВидаУчета,
	|	Остатки.АналитикаУчетаНоменклатуры                            КАК АналитикаУчетаНоменклатуры,
	|	АналитикиВидаУчета.Организация                                КАК Организация,
	|	АналитикиУчетаНоменклатуры.Номенклатура                       КАК Номенклатура,
	|	АналитикиУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения      КАК Упаковка,
	|	АналитикиУчетаНоменклатуры.СерияНоменклатуры                  КАК СерияНоменклатуры,
	|	АналитикиУчетаНоменклатуры.Партия                             КАК Партия,
	|	АналитикиВидаУчета.Склад                                      КАК Склад,
	|	Остатки.Количество / КоэффициентыУпаковок.Коэффициент         КАК Количество
	|ИЗ
	|	СебестоимостьТоваровОтрицательныеОстатки КАК Остатки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаВидаУчета КАК АналитикиВидаУчета
	|	ПО
	|		Остатки.АналитикаВидаУчета = АналитикиВидаУчета.КлючАналитики
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикиУчетаНоменклатуры
	|	ПО
	|		Остатки.АналитикаУчетаНоменклатуры = АналитикиУчетаНоменклатуры.КлючАналитики
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ЕдиницыИзмеренияНоменклатуры КАК КоэффициентыУпаковок
	|	ПО
	|		АналитикиУчетаНоменклатуры.Номенклатура = КоэффициентыУпаковок.Номенклатура
	|		И АналитикиУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения = КоэффициентыУпаковок.ЕдиницаИзмерения
	|";
	Если НуженКонтрольРасхода Тогда
		ИтоговыйЗапрос.Добавить(СтрЗаменить(ШаблонЗапроса, "СебестоимостьТоваровОтрицательныеОстатки", "СебестоимостьТоваровОтрицательныеОстаткиРасхода"));
	КонецЕсли;
	Если НуженКонтрольПрихода Тогда
		ИтоговыйЗапрос.Добавить(СтрЗаменить(ШаблонЗапроса, "СебестоимостьТоваровОтрицательныеОстатки", "СебестоимостьТоваровОтрицательныеОстаткиПрихода"));
	КонецЕсли;
	
	ПакетЗапросов.Добавить(СтрСоединить(ИтоговыйЗапрос, ОбъединениеЗапросов) + "
	|УПОРЯДОЧИТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	АналитикаВидаУчета,
	|	ДатаОстатка
	|");
	
	Результат = Новый Структура;
	Результат.Вставить("ТекстЗапроса", СтрСоединить(ПакетЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов()));
	Результат.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаКонтроля(Период, ЭтоКонтрольПоступлений, ДатаПоследнегоДвижения, ПараметрыЗапроса)
	
	ШаблонЗапроса = "
	|ВЫБРАТЬ
	|	&ТипКонтроля                                КАК ТипКонтроля,
	|	&ДатаКонтроля                               КАК ДатаОстатка,
	|	ТаблицаОстатков.АналитикаВидаУчета          КАК АналитикаВидаУчета,
	|	ТаблицаОстатков.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаОстатков.КоличествоОстаток           КАК Количество
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров.Остатки(
	|			&ГраницаКонтроля,
	|			(АналитикаВидаУчета, АналитикаУчетаНоменклатуры) В
	|				(ВЫБРАТЬ
	|					Таблица.АналитикаВидаУчета,
	|					Таблица.АналитикаУчетаНоменклатуры
	|				ИЗ
	|					ДвиженияСебестоимостьТоваровИзменение КАК Таблица
	|				ГДЕ
	|					Таблица.КонтрольПоступлений = &ЭтоКонтрольПоступлений)
	|		) КАК ТаблицаОстатков
	|ГДЕ
	|	ТаблицаОстатков.КоличествоОстаток < 0
	|";
	
	КонецТекущегоМесяца = КонецМесяца(ДатаПоследнегоДвижения);
	ТриГодаНазад = КонецМесяца(ДобавитьМесяц(КонецТекущегоМесяца, -36));
	ОбъединениеЗапросов = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	ДатаКонтроляКонецМесяца = КонецМесяца(Период);
	
	// Больше трех лет не контролируем, чтобы не превысить количество таблиц в запросе.
	Если ДатаКонтроляКонецМесяца < ТриГодаНазад Тогда
		МинимальныйПериод = ТриГодаНазад;
	ИначеЕсли ДатаКонтроляКонецМесяца > КонецТекущегоМесяца Тогда
		МинимальныйПериод = КонецТекущегоМесяца;
	Иначе
		МинимальныйПериод = ДатаКонтроляКонецМесяца;
	КонецЕсли;
	
	ОбрабатываемыйМесяц = КонецМесяца(ДобавитьМесяц(ДатаПоследнегоДвижения, -1));
	
	Суффикс = ?(ЭтоКонтрольПоступлений, "Прихода", "Расхода");
	ШаблонЗапроса = СтрЗаменить(ШаблонЗапроса, "&ТипКонтроля", СтрШаблон("""Контроль%1""", Суффикс));
	ШаблонЗапроса = СтрЗаменить(ШаблонЗапроса, "&ЭтоКонтрольПоступлений", ?(ЭтоКонтрольПоступлений, "ИСТИНА", "ЛОЖЬ"));
	
	Счетчик = 0;
	
	КонтрольРасхода = Новый Массив;
	Пока ОбрабатываемыйМесяц >= МинимальныйПериод Цикл
		
		ТекстЗапросаОстаткаМесяца = СтрЗаменить(ШаблонЗапроса            , "&ДатаКонтроля"   , "&ДатаКонтроля" + Суффикс + Строка(Счетчик));
		ТекстЗапросаОстаткаМесяца = СтрЗаменить(ТекстЗапросаОстаткаМесяца, "&ГраницаКонтроля", "&ГраницаКонтроля" + Суффикс + Строка(Счетчик));
		КонтрольРасхода.Добавить(ТекстЗапросаОстаткаМесяца);
		
		ПараметрыЗапроса.Вставить("ДатаКонтроля" + Суффикс + Строка(Счетчик)   , ОбрабатываемыйМесяц);
		ПараметрыЗапроса.Вставить("ГраницаКонтроля" + Суффикс + Строка(Счетчик), Новый Граница(ОбрабатываемыйМесяц, ВидГраницы.Включая));
		
		Счетчик = Счетчик + 1;
		
		Если ОбрабатываемыйМесяц = КонецМесяца(ДобавитьМесяц(ОбрабатываемыйМесяц, -1)) Тогда
			Прервать;
		КонецЕсли;
		
		ОбрабатываемыйМесяц = КонецМесяца(ДобавитьМесяц(ОбрабатываемыйМесяц, -1));
		
	КонецЦикла;
	
	Если ДатаКонтроляКонецМесяца < МинимальныйПериод И ДатаКонтроляКонецМесяца < ДатаПоследнегоДвижения Тогда
		
		ТекстЗапросаОстаткаМесяца = СтрЗаменить(ШаблонЗапроса            , "&ДатаКонтроля"   , "&ДатаКонтроля" + Суффикс + Строка(Счетчик));
		ТекстЗапросаОстаткаМесяца = СтрЗаменить(ТекстЗапросаОстаткаМесяца, "&ГраницаКонтроля", "&ГраницаКонтроля" + Суффикс + Строка(Счетчик));
		КонтрольРасхода.Добавить(ТекстЗапросаОстаткаМесяца);
		
		ПараметрыЗапроса.Вставить("ДатаКонтроля" + Суффикс + Строка(Счетчик), ДатаКонтроляКонецМесяца);
		ПараметрыЗапроса.Вставить("ГраницаКонтроля" + Суффикс + Строка(Счетчик), Новый Граница(ДатаКонтроляКонецМесяца, ВидГраницы.Включая));
		
		Счетчик = Счетчик + 1;
		
	КонецЕсли;
	
	ТекстЗапросаОстаткаМесяца = СтрЗаменить(ШаблонЗапроса            , "&ДатаКонтроля"   , "&ДатаКонтроля" + Суффикс + Строка(Счетчик));
	ТекстЗапросаОстаткаМесяца = СтрЗаменить(ТекстЗапросаОстаткаМесяца, "&ГраницаКонтроля", "");
	КонтрольРасхода.Добавить(ТекстЗапросаОстаткаМесяца);
	
	ПараметрыЗапроса.Вставить("ДатаКонтроля" + Суффикс + Строка(Счетчик), ПроведениеПоддержкаПроектов.ДатаАктуальныхОстатков());
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(СтрСоединить(КонтрольРасхода, ОбъединениеЗапросов));
	СхемаЗапроса.ПакетЗапросов[0].ТаблицаДляПомещения = "СебестоимостьТоваровОтрицательныеОстатки" + Суффикс;
	Возврат СхемаЗапроса.ПолучитьТекстЗапроса();
	
КонецФункции

Функция ДатаПоследнегоДвижения()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СебестоимостьТоваров.Период КАК Период
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|");
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Дата('00010101');
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Период;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли