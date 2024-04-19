#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеПоддержкаПроектов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу "ДвиженияПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = ПроведениеПоддержкаПроектов.ПолучитьМенеджерВременныхТаблицДляКонтроляПроведения(ДополнительныеСвойства);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ДокументОснование                       КАК ДокументОснование,
	|	Таблица.Организация                             КАК Организация,
	|	Таблица.Номенклатура                            КАК Номенклатура,
	|	Таблица.СерияНоменклатуры                       КАК СерияНоменклатуры,
	|	Таблица.Партия                                  КАК Партия,
	|	Таблица.Склад                                   КАК Склад,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.КОформлениюОприходования
	|		ИНАЧЕ
	|			-Таблица.КОформлениюОприходования
	|	КОНЕЦ                                           КАК КОформлениюОприходованияПередЗаписью,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			Таблица.КОформлениюСписания
	|		ИНАЧЕ
	|			-Таблица.КОформлениюСписания
	|	КОНЕЦ                                           КАК КОформлениюСписанияПередЗаписью
	|ПОМЕСТИТЬ ТоварыКОформлениюИзлишковНедостачПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеПоддержкаПроектов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ПроведениеПоддержкаПроектов.ПолучитьМенеджерВременныхТаблицДляКонтроляПроведения(ДополнительныеСвойства);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ДокументОснование                     КАК ДокументОснование,
	|	Таблица.Организация                           КАК Организация,
	|	Таблица.Номенклатура                          КАК Номенклатура,
	|	Таблица.СерияНоменклатуры                     КАК СерияНоменклатуры,
	|	Таблица.Партия                                КАК Партия,
	|	Таблица.Склад                                 КАК Склад,
	|	Таблица.КОформлениюОприходованияПередЗаписью  КАК КОформлениюОприходованияИзменение,
	|	Таблица.КОформлениюСписанияПередЗаписью       КАК КОформлениюСписанияИзменение
	|ПОМЕСТИТЬ ТаблицаИзменений
	|ИЗ
	|	ТоварыКОформлениюИзлишковНедостачПередЗаписью КАК Таблица
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	Таблица.ДокументОснование               КАК ДокументОснование,
	|	Таблица.Организация                     КАК Организация,
	|	Таблица.Номенклатура                    КАК Номенклатура,
	|	Таблица.СерияНоменклатуры               КАК СерияНоменклатуры,
	|	Таблица.Партия                          КАК Партия,
	|	Таблица.Склад                           КАК Склад,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			-Таблица.КОформлениюОприходования
	|		ИНАЧЕ
	|			Таблица.КОформлениюОприходования
	|	КОНЕЦ                                   КАК КОформлениюОприходованияИзменение,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			-Таблица.КОформлениюСписания
	|		ИНАЧЕ
	|			Таблица.КОформлениюСписания
	|	КОНЕЦ                                   КАК КОформлениюСписанияИзменение
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаИзменений.ДокументОснование                         КАК ДокументОснование,
	|	ТаблицаИзменений.Организация                               КАК Организация,
	|	ТаблицаИзменений.Номенклатура                              КАК Номенклатура,
	|	ТаблицаИзменений.СерияНоменклатуры                         КАК СерияНоменклатуры,
	|	ТаблицаИзменений.Партия                                    КАК Партия,
	|	ТаблицаИзменений.Склад                                     КАК Склад,
	|	СУММА(ТаблицаИзменений.КОформлениюОприходованияИзменение)  КАК КОформлениюОприходованияИзменение,
	|	СУММА(ТаблицаИзменений.КОформлениюСписанияИзменение)       КАК КОформлениюСписанияИзменение
	|ПОМЕСТИТЬ ДвиженияТоварыКОформлениюИзлишковНедостачИзменение
	|ИЗ
	|	ТаблицаИзменений КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.ДокументОснование,
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.СерияНоменклатуры,
	|	ТаблицаИзменений.Партия,
	|	ТаблицаИзменений.Склад
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КОформлениюОприходованияИзменение) > 0
	|	ИЛИ СУММА(ТаблицаИзменений.КОформлениюСписанияИзменение) > 0
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТоварыКОформлениюИзлишковНедостачПередЗаписью
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаИзменений
	|";
	
	Выборка = Запрос.ВыполнитьПакет()[1].Выбрать();
	Выборка.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияТоварыКОформлениюИзлишковНедостачИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	Если Выборка.Количество > 0 Тогда
		ПроведениеПоддержкаПроектов.ДобавитьПараметрыКонтроля(
			ДополнительныеСвойства,
			ТекстЗапросаПроверки(),
			РегистрыНакопления.ТоварыКОформлениюИзлишковНедостач);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаПроверки()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаОстатков.ДокументОснование                                       КАК ДокументОснование,
	|	ТаблицаОстатков.Организация                                             КАК Организация,
	|	ТаблицаОстатков.Номенклатура                                            КАК Номенклатура,
	|	ТаблицаОстатков.Номенклатура.ЕдиницаИзмерения                           КАК Упаковка,
	|	ТаблицаОстатков.СерияНоменклатуры                                       КАК СерияНоменклатуры,
	|	ТаблицаОстатков.Партия                                                  КАК Партия,
	|	ТаблицаОстатков.Склад                                                   КАК Склад,
	|	ТаблицаОстатков.КОформлениюОприходованияОстаток / Упаковки.Коэффициент  КАК КОформлениюОприходования,
	|	ТаблицаОстатков.КОформлениюСписанияОстаток / Упаковки.Коэффициент       КАК КОформлениюСписания
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(,
	|			(ДокументОснование, Организация, Номенклатура, СерияНоменклатуры, Партия, Склад) В
	|				(ВЫБРАТЬ
	|					Таблица.ДокументОснование,
	|					Таблица.Организация,
	|					Таблица.Номенклатура,
	|					Таблица.СерияНоменклатуры,
	|					Таблица.Партия,
	|					Таблица.Склад
	|				ИЗ
	|					ДвиженияТоварыКОформлениюИзлишковНедостачИзменение КАК Таблица)
	|	) КАК ТаблицаОстатков
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ЕдиницыИзмеренияНоменклатуры КАК Упаковки
	|	ПО
	|		ТаблицаОстатков.Номенклатура = Упаковки.Номенклатура
	|		И ТаблицаОстатков.Номенклатура.ЕдиницаИзмерения = Упаковки.ЕдиницаИзмерения
	|
	|ГДЕ
	|	ТаблицаОстатков.КОформлениюОприходованияОстаток < 0
	|	ИЛИ ТаблицаОстатков.КОформлениюСписанияОстаток < 0
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли
